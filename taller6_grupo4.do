*==============================================================================*
*				 		EVALUACION POLITICA PUBICA   2024-2					   *
*							TALLER 6 Do file								   *
* 	POR: Laura Pardo, José E González, Julián Pulido  Luis Castellanos   	   *
* 							17 de Noviembre de 2024						   *
* 							 	STATA 18.0									   *  
*==============================================================================*

cls
clear all
cap log close
set more off
*________________________________________________________________________________
*Establecemos un directorio de trabajo

*CD José Eduardo
*cd "C:\Users\jedog\OneDrive\Desktop\SEMESTRE 2024-2\EVALUACIÓN DE POLÍTICAS PÚBLICAS\TALLERES\TALLER 5"

cd "/Users/User/Library/CloudStorage/OneDrive-Universidaddelosandes/2024-2 Evaluación de Políticas Públicas/Talleres"


*cd "C:\Users\User\OneDrive\OneDrive - Universidad de los andes\EPP\Talleres\Taller 5"

*log using "taller6_grupo4.log", replace /*Empezar el log file*/
*_________________________________________________________________________________
*Directorio de Jose
*cd "C:\Users\Heitz\Desktop\Evaluación de Impacto  EGOB\Taller 5"


use "Base_Taller_DD.dta", clear

*para Mac
*use "./Base_Taller_5_RD.dta",clear 

*Checking base
sort llavefin
order llavefin tratamiento seguimiento
br
describe llavefin



* Diferencias entre el número de controles y tratados:
ttest tayuda, by(tratamiento)

*No significativo para tiempo dedicado a ayudar en el hogar

*Diferencias entre el número de controles y tratado:

ttest ttrabajo, by(tratamiento)

*Existen diferencias significativas para la variables el tiempo dedicado a trabaj

* Semana 11 Evaluación de Impacto 
* Profesora: Stephanie Majerrowicz 	
*==============================================================================*
*				 		EVALUACION POLITICA PUBICA   2024-2					   *
*					 Do File Para Ejercicio DD en Clase						   *
* 							POR: Laura Pardo y Julián Pulido   	 							   *
* 							6 de Nov DE 2024			 					   *
* 							 	STATA 18.0									   *  
*==============================================================================*

cls
clear all
cap log close
set more off 
*________________________________________________________________________________
*Establecemos un directorio de trabajo

*Directorio de trabajo
cd "C:\Users\Heitz\Desktop\Evaluación de Impacto  EGOB\Semana 13"


log using "ActividadDeClase.log", replace /*Empezar el log file*/


use "base_dd_peru_clase.dta", clear


* Va a trabajar esto en parejas. Ponga el nombre de las dos personas que trabajaron. 

* Deben subir el do file con las respuestas. 

/********************************************************************************
								PARTE 1						
******************************************************************************/

								
* Entendamos la base: 

* (1) Cuantos colegios controles y tratados tenemos? 
describe
unique id 
*Tenemos 16132 colegios diferentes en la muestra

*El numero de colegios varía en los años (no es un panel balanceado)¨
*En 2007 hay 10.792 colegios que no han sido tratados y 3.088, mientras que en 2014 hay 11.086 tratados y 3.259 no tratados. 
tab trat_ap year, col 

* (2) En qué departamentos están? 
tab dpto trat_ap if year==2012

* (3) Hay una diferencia entre los tratados y controles en número de alumnos o número de profesores? 

reg tot_alum trat_ap, r

ttest tot_alum, by(trat_ap)

reg tot_doc trat_ap, r
ttest tot_doc, by(trat_ap)


summ tot_alum if trat_ap == 1 & year==2012
summ tot_alum if trat_ap == 0 & year==2012



/****************** 		R E S P U E S T A 		***************************
Los resultado indican que el grupo de tratamiento tiene, en promedio, 0.654 alumnos 
más que el grupo de control. Esta diferencia es significativa al 1%, pues el p-valor 
es 0 y el intervalo de confianza no contiene el cero.

Esto indica que el grupo de tratamiento tiene, en promedio, 0.052 profesores menos 
que el grupo de control. Esta diferencia es significativa al 1%, pues el p-valor
es 0 y el intervalo de confianza no contiene el cero. 

*/******************************************************************************

* (4) La base está en versión wide o long? 


******************** 		R E S P U E S T A 		***************************
/* Los datos estan en formato de datos tipo long, cada observación (por ejemplo,
 una escuela) aparece en varias filas según el número de tiempos o unidades de 
medida asociados a ella. En este caso, en este caso tengo observaciones 
para cada escuela (unidad de analiss* en distintos momentos en el tiempo (años)
Cada fila representaría un único valor para una combinación de escuela y tiempo.

*/
br 
/********************************************************************************
								PARTE 2							
******************************************************************************/
	
* Vamos a hacer la gráfica de las tendencias paralelas: 

gen mean_matz=.
gen mean_lengz=.
forvalues i = 2007/2014 { 
	qui sum mat_z if year == `i' & trat_ap==1 
	replace mean_matz = r(mean) if year == `i' & trat_ap==1 
	qui sum leng_z if year== `i' & trat_ap==1  
	replace mean_lengz = r(mean) if year == `i' & trat_ap==1 
	
	qui sum mat_z  if year == `i' & trat_ap==0 
	replace mean_matz = r(mean) if year == `i' & trat_ap==0 
	qui sum leng_z if year== `i' & trat_ap==0  
	replace mean_lengz = r(mean) if year == `i' & trat_ap==0 
} 
xtset id year
set scheme s2mono

* Gráfica para Matematicas
twoway (tsline mean_matz if trat_ap==0, legend(label(1 "No Tratado")) tline(2012)) ///
		(tsline mean_matz if trat_ap==1, legend(label(2 "Tratado")) tline(2012)), ///
		graphregion(color(white)) ytitle("Puntaje Promedio Matemáticas") xtitle("Año")

* Gráfica para Lenguaje 		
twoway (tsline mean_lengz if trat_ap==0, legend(label(1 "No Tratado")) tline(2012)) ///
		(tsline mean_lengz if trat_ap==1, legend(label(2 "Tratado")) tline(2012)), ///
		graphregion(color(white)) ytitle("Puntaje Promedio Lectura") xtitle("Año")	

		
* (5) Cuál es el supuesto principal de diferencias en diferencias? Cree que se 
*cumple dada las gráficas anteriores?  

/*
Tendencias paralelas:

		E[Yi,t(0) − Yi,t−1(0)|Di = 1] = E[Yi,t(0) − Yi,t−1(0)|Di = 0]


* En ausencia del tratamiento, el cambio esperado en la variable dependiente del 
grupo de tratamiento es igual alcambio observado en esa variable para el grupo 
de control 

*Tener tendencias paralelas es clave, pues al hacer las diferencias en el tiempo
 se eliminan el componente sistemático  (elefecto fijo de grupo)
 
 
 
*/	
		
/********************************************************************************
								PARTE 3							
******************************************************************************/
	

**** Regresion Dif in Dif 2x2 *****

* Primero vamos a estimar la ecuación de diferencias en diferencias de 2x2. 

* (6) Cuál es la regresión que necesita correr? Escriba la formula.

/*Corremos dos regresiones, una con la variable dependiente de resultados en
 matematicas y otra para los resultados en la prueba de lenguaje.

****************** 		R E S P U E S T A 		***************************

* mat_z= alpha+ B_1trat_ap + B_2 Despues+ B_3 trat_ap*Despues + e_ts

* leng_z= alpha+ B_1trat_ap + B_2 Despues+ B_3 trat_ap*Despues + e_ts

*/


* (7) Cree las varibles que necesita. 


gen despues=(year>2012)

gen interaccion= trat_ap*despues

* (8) Corra la regresión e interprete los coeficientes para matemáticas y lenguaje.  


reg mat_z trat_ap despues interaccion, r 
reg leng_z trat_ap despues interaccion, r 

/* El coeficiente de interes es de 17.55 y es estadisticamente significativo al 
95% lo que indica que el desempeño de los estudiantes de los colegios tratados
 aumentó en 17.55 puntos en promedio.
El coeficiente de interes es de 25.95 y es estadisticamente significativo al 95% 
lo que indica que el desempeño de los estudiantes de los colegios tratados aumentó 
en 25.95 puntos en promedio.*/



*** TWFE ***** 
*  Ahora vamos a correr la misma regresión pero con efectos fijos en dos
* direcciones (Two Way Fixed Effects).

* (9) Cuales son los dos efectos fijos que necesita? Qué otras variables necesita? 

*Necesito efectos fijos de tiempo (años) y de individuo (escuela), seria 
*entonces las variables  year y id respectivamente. 

* (10) Escriba la ecuación y cree las variables que le faltan. 

****************** 		R E S P U E S T A 		***************************

* mat_z= id + year+ B1D_it + e_it

gen Dit= trat_ap*despues




* (11) Corra la regresión para matemáticas y lenguaje. Qué encuentra? Cómo 
*compara con la regresión anterior?

* Efectos fijos 
*Pude haber usado areg
* Regresión TWFE para matemáticas con efectos fijos
xtset id year
xtreg mat_z interaccion i.year, fe r

* Regresión TWFE para lenguaje con efectos fijos
xtreg leng_z interaccion i.year, fe r

*Entonces nos da mas precision respecto a la anterior porque nos ayuda a controlar por 
*efecto fijo 

/********************************************************************************
								PARTE 4						
********************************************************************************/
	
* Finalmente vamos a hacer el estudio de evento:

* (12a) Primero cree una variable para cada año. 
*(Tip: Puede usar tab, generate() para crear una dummy por cada valor de la variable)

// Crear dummies para cada año con nombres descriptivos
foreach y in 2007 2008 2009 2010 2011 2012 2013 2014 {
    gen year_`y' = (year == `y')
}



* (12b) Después cree una variable que interactue si fue tratado con cada año. Llamelos int1 int2, etc. 

// Crear interacciones de tratamiento para los años 2007 a 2015
foreach y in 2007 2008 2009 2010 2011 2012 2013 2014 {
    gen int_`y' = trat_ap * year_`y'
}


* (12c) Ahora corra la regresión omitiendo la interacción del 2012 (año previo al tratamiento) 
xtset id year
eststo mat_event:xtreg mat_z int_2007 int_2008 int_2009 int_2010 int_2011 int_2013 int_2014 i.year, fe  cluster(id)

eststo leng_event: xtreg leng_z int_2007 int_2008 int_2009 int_2010 int_2011 int_2013 int_2014 i.year, fe cluster(id)




* (13) Interprete los coeficientes. Ve evidencia de tendencias paralelas? Cuál es el efecto del programa por año? 

/*

****************** 		R E S P U E S T A 		***************************

Estos coeficientes sugieren que NO hay variaciones significativas en los resultados
 de mat_z entre el grupo de tratamiento y el de control en los años antes del 
 tratamiento, lo cual indica que se cumplen las tendencias paralelas en este caso excepto en 2011. 
 
Esto permite dar la interpretación causal de los efectos estimados del tratamiento,
 Validando la metodología a empleada. 
 
Despues del tratamiento en promedio hay un aumento de 19.25 puntos en los resultados 
de la prueba de matematicas, significativos al 1% para 2013. Este efecto positivo aumenta
a 32.81 para 2015, tambien significativo al 1%. Manteniendo lo demas constante. 


Para puntaje de lenguaje:
Despues del tratamiento en promedio hay un aumento de 12.57 puntos en los resultados 
de la prueba de matematicas, significativos al 1% para 2013. Este efecto positivo aumenta
a 19.36 para 2014, tambien significativo al 1%. Manteniendo lo demas constante. 


*/

*** Grafica de coeficientes ****
* Debe guardar el resultado de su regresión bajo el nombre mat_event y leng_event. Sus interacciones se deben llamar int*. Este codigo le debe funcionar. 

*ssc install coefplot 

coefplot (mat_event, keep(int*)), vertical yline(0) xline(5.5) xlabel(1 "2007" 2 "2008" 3 "2009" 4 "2010" 5 "2011" 6 "2013" 7 "2014")

coefplot (leng_event, keep(int*)), vertical yline(0) xline(5.5) xlabel(1 "2007" 2 "2008" 3 "2009" 4 "2010" 5 "2011" 6 "2013" 7 "2014")
