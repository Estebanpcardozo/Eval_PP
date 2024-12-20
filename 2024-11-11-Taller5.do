*==============================================================================*
*				 		EVALUACION POLITICA PUBICA   2024-2					   *
*							TALLER 5 Do file								   *
* 	POR: Laura Pardo, José E González, Julián Pulido  Luis Castellanos   	   *
* 							10 de Noviembre de 2024						   *
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

*cd "/Users/User/Library/CloudStorage/OneDrive-Universidaddelosandes/2024-2 Evaluación de Políticas Públicas/Talleres"


*cd "C:\Users\User\OneDrive\OneDrive - Universidad de los andes\EPP\Talleres\Taller 5"

*log using "taller5_grupo4.log", replace /*Empezar el log file*/
*_________________________________________________________________________________
*Directorio de Jose
cd "C:\Users\Heitz\Desktop\Evaluación de Impacto  EGOB\Taller 5"


use "Base_Taller_5_RD.dta", clear

*para Mac
*use "./Base_Taller_5_RD.dta",clear 


describe

summarize

* Punto 3- Gráfica de covariables del hogar medidas en linea de base alrededor del punto de corte ----------------------------------------------------

egen prop_Alcantarillado = mean(Tiene_Alcantarillado), by(intervalo)
label var prop_Alcantarillado "Proporción de hogares con alcantarillado"

scatter prop_Alcantarillado intervalo, msymbol(oh) mlcolor(gs1) ///
       || lowess prop_Alcantarillado sisben if sisben<=11, bw(.6) lcolor(gs6) clwidth(medthick) ///
       || lowess prop_Alcantarillado sisben if sisben>11 & sisben<=21, bw(.6) lcolor(gs6) clwidth(medthick) ///
       ||, xline(11) xlabel(0(1)21) ylabel(, glcolor(gs14) glwidth(thin)) ///
       legend(position(8) ring(0) cols(1) row(1) order(1 2)) ///
       xtitle("Intervalo de Sisbén") ytitle("Proporción de hogares con alcantarillado") ///
       title("Acceso a alcantarillado por intervalo de Sisbén")
graph save "graph3.1.gph", replace
egen prop_Nevera = mean(Tiene_Nevera), by(intervalo)
label var prop_Nevera "Proporción de hogares con nevera"

scatter prop_Nevera intervalo, msymbol(oh) mlcolor(gs1) ///
    || lowess prop_Nevera sisben if sisben<=11, bw(.6) lcolor(gs6) clwidth(medthick) ///
    || lowess prop_Nevera sisben if sisben>11 & sisben<=21, bw(.6) lcolor(gs6) clwidth(medthick) ///
    ||, xline(11) xlabel(0(1)21) ylabel(, glcolor(gs14) glwidth(thin)) ///
    legend(position(8) ring(0) cols(1) row(1) order(1 2)) ///
    xtitle("Intervalo de Sisbén") ytitle("Proporción de hogares con nevera") ///
    title("Propiedad de nevera por intervalo de Sisbén")
graph save "graph3.2.gph", replace

egen prop_Secundaria = mean(Jefe_Secundaria_Completa), by(intervalo)
label var prop_Secundaria "Proporción de jefes con secundaria completa"

scatter prop_Secundaria intervalo, msymbol(oh) mlcolor(gs1) ///
    || lowess prop_Secundaria sisben if sisben<=11, bw(.6) lcolor(gs6) clwidth(medthick) ///
    || lowess prop_Secundaria sisben if sisben>11 & sisben<=21, bw(.6) lcolor(gs6) clwidth(medthick) ///
    ||, xline(11) xlabel(0(1)21) ylabel(, glcolor(gs14) glwidth(thin)) ///
    legend(position(8) ring(0) cols(1) row(1) order(1 2)) ///
    xtitle("Intervalo de Sisbén") ytitle("Proporción de jefes con secundaria completa") ///
    title("Nivel educativo del jefe de hogar por intervalo de Sisbén")
graph save "graph3.3.gph", replace

egen prop_Recoleccion = mean(Tiene_Recoleccion_Basura), by(intervalo)
label var prop_Recoleccion "Proporción de recolección de basura"

scatter prop_Recoleccion intervalo, msymbol(oh) mlcolor(gs1) ///
    || lowess prop_Recoleccion sisben if sisben<=11, bw(.6) lcolor(gs6) clwidth(medthick) ///
    || lowess prop_Recoleccion sisben if sisben>11 & sisben<=21, bw(.6) lcolor(gs6) clwidth(medthick) ///
    ||, xline(11) xlabel(0(1)21) ylabel(, glcolor(gs14) glwidth(thin)) ///
    legend(position(8) ring(0) cols(1) row(1) order(1 2)) ///
    xtitle("Intervalo de Sisbén") ytitle("Proporción de recolección de basura") ///
    title("Recolección de basura por intervalo de Sisbén")
graph save "graph3.4.gph",replace

/*egen prop_Asistencia = mean(asistencia), by(intervalo)
label var prop_Asistencia "Proporción de niños que asisten al colegio"

scatter prop_Asistencia intervalo, msymbol(oh) mlcolor(gs1) ///
    || lowess prop_Asistencia sisben if sisben<=11, bw(.6) lcolor(gs6) clwidth(medthick) ///
    || lowess prop_Asistencia sisben if sisben>11 & sisben<=21, bw(.6) lcolor(gs6) clwidth(medthick) ///
    ||, xline(11) xlabel(0(1)21) ylabel(, glcolor(gs14) glwidth(thin)) ///
    legend(position(8) ring(0) cols(1) row(1) order(1 2)) ///
    xtitle("Intervalo de Sisbén") ytitle("Proporción de niños que asisten al colegio") ///
    title("Asistencia escolar de niños por intervalo de Sisbén")
graph save "graph3.4.gph",replace*/

graph combine graph3.1.gph graph3.2.gph graph3.3.gph graph3.4.gph, ///
    cols(2) ///
    title("Gráficas combinadas: Acceso a servicios y educación por intervalo de Sisbén") ///
    ysize(6) xsize(12)
graph save "graph3.gph",replace

* Punto 4- Estimación de las diferencias observadas en las gráficas para las características de balance ----------------------------------------------------
*Configurar el punto de corte como 0
gen sisben_std = sisben - 11

*Característica de balance: Acceso a alcantarillado

eststo: reg Tiene_Alcantarillado sisben_std if abs(sisben_std)<5, r
est sto r11 
*Característica de balance: Propietario de nevera

eststo: reg Tiene_Nevera sisben_std if abs(sisben_std)<5, r
est sto r22
*Característica de balance: Nivel educativo jefes de familia

eststo: reg Jefe_Secundaria_Completa sisben_std if abs(sisben_std)<5, r
est sto r33
*Característica de balance: Recolección

eststo: reg Tiene_Recoleccion_Basura sisben_std if abs(sisben_std)<5, r
est sto r144

esttab r*, b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) stats(N r2) drop(_cons), using "Punto4.doc", rtf replace


*Forma de Julian - CONSULTAR CON LA PROFESORA - REUNIÓN MARTES 3:30 PM
{
	
*ssc install rdrobust,replace
*ssc install rddensity, replace
*ssc install lpdensity, replace

*Característica de balance: Acceso a alcantarillado
*Sin Fuzzy, sin controles -sin covariables mas adelante y fuzzy
eststo: rdrobust Tiene_Alcantarillado sisben_std,  c(0) h(5) 
est sto r1 

*rdrobust Tiene_Alcantarillado sisben_std, fuzzy(beneficiario) covs(Tiene_Recoleccion_Basura  Tiene_Nevera Jefe_Secundaria_Completa) c(0) h(5) all//no sig


*Característica de balance: Propietario de nevera
eststo: rdrobust Tiene_Nevera sisben_std, c(0) h(5) 
est sto r2
*rdrobust Tiene_Nevera sisben_std, fuzzy(beneficiario) covs(Tiene_Alcantarillado Tiene_Recoleccion_Basura Jefe_Secundaria_Completa) c(0) h(5) all //no sig.


*Característica de balance: Nivel educativo jefes de familia
eststo: rdrobust Jefe_Secundaria_Completa sisben_std,  c(0) h(5) //7% más sig al 99%
est sto r3

*rdrobust Jefe_Secundaria_Completa sisben_std, fuzzy(beneficiario) covs(Tiene_Alcantarillado Tiene_Recoleccion_Basura Tiene_Nevera ) c(0) h(5) all //7% más sig al 99%


*Característica de balance: Asistencia a clases
eststo: rdrobust Tiene_Recoleccion_Basura sisben_std, c(0) h(5) 
est sto r4

*rdrobust Tiene_Recoleccion_Basura sisben_std, fuzzy(beneficiario) covs(Tiene_Nevera Jefe_Secundaria_Completa Tiene_Alcantarillado) c(0) h(5) all //1.4% al 95%

*Exportacion de resultados
esttab r* , b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) stats(N r2) drop(_cons), using "Punto4.doc", rtf replace

}

* Punto 5- Gráfica de las variables de resultado contra el puntaje Sisbén ----------------------------------------------------

egen prop_Empleojefe = mean(empleojefe), by(intervalo)
label var prop_Empleojefe "Proporción de hogares cuyo jefe de hogar tiene empleo"

scatter prop_Empleojefe intervalo, msymbol(oh) mlcolor(gs1) ///
       || lowess prop_Empleojefe sisben if sisben<=11, bw(.6) lcolor(gs6) clwidth(medthick) ///
       || lowess prop_Empleojefe sisben if sisben>11 & sisben<=21, bw(.6) lcolor(gs6) clwidth(medthick) ///
       ||, xline(11) xlabel(0(1)21) ylabel(, glcolor(gs14) glwidth(thin)) ///
       legend(position(8) ring(0) cols(1) row(1) order(1 2)) ///
       xtitle("Intervalo de Sisbén") ytitle("Proporción de hogares cuyo jefe de hogar tiene empleo") ///
       title("Empleo de jefes de hogar por intervalo de Sisbén")
graph save "graph5.1.gph", replace

egen prop_tinfantil = mean(tinfantil), by(intervalo)
label var prop_tinfantil "Proporción de hogares en los que algún niño o niña trabaja"

scatter prop_tinfantil intervalo, msymbol(oh) mlcolor(gs1) ///
       || lowess prop_tinfantil sisben if sisben<=11, bw(.6) lcolor(gs6) clwidth(medthick) ///
       || lowess prop_tinfantil sisben if sisben>11 & sisben<=21, bw(.6) lcolor(gs6) clwidth(medthick) ///
       ||, xline(11) xlabel(0(1)21) ylabel(, glcolor(gs14) glwidth(thin)) ///
       legend(position(8) ring(0) cols(1) row(1) order(1 2)) ///
       xtitle("Intervalo de Sisbén") ytitle("Proporción de hogares en los que algún niño o niña trabaja") ///
       title("Empleo de niños y niñas en el hogar por intervalo de Sisbén")
graph save "graph5.2.gph", replace

graph combine graph5.1.gph graph5.2.gph, ///
    cols(2) ///
    title("Gráficas combinadas: Empleo de jefes de hogar y Empleo de niños y niñas en el hogar, por intervalo de Sisbén") ///
    ysize(6) xsize(12)
graph save "graph5.gph"


*Punto 6 - Estime el impacto en las dos variables de resultado para anchos de banda de h=5 y h=10
cls
 
*jefe de hogar
rdrobust empleojefe sisben_std, covs(Tiene_Alcantarillado Tiene_Nevera Jefe_Secundaria_Completa) c(0) h(5)

rdplot empleojefe sisben_std,  fuzzy(beneficiario) covs(Tiene_Alcantarillado Tiene_Nevera Jefe_Secundaria_Completa) c(0) h(5)

rdrobust empleojefe sisben_std, covs(Tiene_Alcantarillado Tiene_Nevera Jefe_Secundaria_Completa) c(0) h(10)

rdplot empleojefe sisben_std, fuzzy(beneficiario) covs(Tiene_Alcantarillado Tiene_Nevera Jefe_Secundaria_Completa) c(0) h(10)

*Trabajo infantil
rdrobust tinfantil sisben_std, covs(Tiene_Alcantarillado Tiene_Nevera Jefe_Secundaria_Completa) c(0) h(5)

*Trabajo infantil
rdrobust tinfantil sisben_std, covs(Tiene_Alcantarillado Tiene_Nevera Jefe_Secundaria_Completa) c(0) h(10)

*Punto 7 -Escriba la ecuación (o ecuaciones) para estimar el efecto local promedio de recibir FeA 
*jefe de hogar
rdrobust empleojefe sisben_std, fuzzy(beneficiario) covs(Tiene_Alcantarillado Tiene_Nevera Jefe_Secundaria_Completa) c(0) h(5)

rdrobust empleojefe sisben_std, fuzzy(beneficiario) covs(Tiene_Alcantarillado Tiene_Nevera Jefe_Secundaria_Completa) c(0) h(10)

*Trabajo infantil
rdrobust tinfantil sisben_std, fuzzy(beneficiario) covs(Tiene_Alcantarillado Tiene_Nevera Jefe_Secundaria_Completa) c(0) h(5)

rdrobust tinfantil sisben_std, fuzzy(beneficiario) covs(Tiene_Alcantarillado Tiene_Nevera Jefe_Secundaria_Completa) c(0) h(10)



*Bono - NO manipulación
*1er métdodo
kdensity sisben_std, xline(0,lcol(red) lp("--")) lcol(black)	

*Segundo mètodo
	rddensity sisben_std
	rddensity sisben_std, plot  graph_opt(title("Test de manipulación") 					///
		xtitle("Clasificación de SISBEN 1")   					///
		ytitle("Densidad de la variable de focalización")  						///
		scheme(s1mono) legend(off) graphregion(fcolor(white))) 
	
