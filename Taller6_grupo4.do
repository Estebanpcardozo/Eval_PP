
*==============================================================================*
*				 		EVALUACION POLITICA PUBICA   2024-2					   *
*							TALLER 6 Do file								   *
* 	POR: Laura Pardo, José E González, Julián Pulido  Luis Castellanos   	   *
* 							22 de Noviembre  DE 2024						   *
* 							 	STATA 18.0									   *  
*==============================================================================*

cls
clear all
cap log close
set more off
*________________________________________________________________________________
*Establecemos un directorio de trabajo

*CD Laura
cd "C:\Users\Heitz\Desktop\Evaluación de Impacto  EGOB\Taller 6"

*CD Julian


*CD Luis


*CD José


log using "taller6_grupo4.log", replace /*Empezar el log file*/

use "Base_Taller_DD", clear

sort llavefin
br
sum tratamiento,d
sum seguimiento,d
tab tratamiento
tab seguimiento

* Punto 1.b --------------------------------------------------------------------
/* b)	Estime el efecto de FeA utilizando el método de Diferencias en Diferencias 
sobre el trabajo infantil utilizando dos variables de resultado: 1) (10%) el tiempo
 que dedican los niños a trabajar por fuera del hogar, y 2) (10%) en el tiempo que
dedican los niños a ayudar en las labores del hogar. Presente e interprete los 
resultados de cada estimación. 

*/


gen interaccion = tratamiento*seguimiento

eststo:reg ttrabajo tratamiento seguimiento interaccion, r
est sto r1 
eststo: reg tayuda tratamiento seguimiento interaccion, r
est sto r2

*Exportacion de resultados
esttab r1 r2 , b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) stats(N r2), using "Punto1b.doc", rtf replace


* Punto 1.c --------------------------------------------------------------------
/* c)	(10%) Estime de nuevo el modelo para cada variable de resultado incluyendo
 también como variables de control los activos netos y el número de bienes durables
 del hogar. Observe si cambió el coeficiente que mide el efecto del programa. 
 Comente por qué cambió o no cambió.
*/

eststo: reg ttrabajo tratamiento seguimiento interaccion activos durables
est sto r3
eststo: reg tayuda tratamiento seguimiento interaccion activos durables
est sto r4


*Exportacion de resultados
esttab r3 r4 , b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) stats(N r2), using "Punto1b.doc", rtf replace





* Crear variables para promedios por grupo y período
gen mean_ttrabajo = .
gen mean_tayuda = .

* Calcular promedios por período y grupo
foreach var in ttrabajo tayuda {
    qui sum `var' if seguimiento == 0 & tratamiento == 1
    replace mean_`var' = r(mean) if seguimiento == 0 & tratamiento == 1
    
    qui sum `var' if seguimiento == 1 & tratamiento == 1
    replace mean_`var' = r(mean) if seguimiento == 1 & tratamiento == 1

    qui sum `var' if seguimiento == 0 & tratamiento == 0
    replace mean_`var' = r(mean) if seguimiento == 0 & tratamiento == 0

    qui sum `var' if seguimiento == 1 & tratamiento == 0
    replace mean_`var' = r(mean) if seguimiento == 1 & tratamiento == 0
}


twoway (line mean_ttrabajo seguimiento if tratamiento == 0, ///
        lcolor(blue) lpattern(solid) legend(label(1 "No Tratado"))) ///
       (line mean_ttrabajo seguimiento if tratamiento == 1, ///
        lcolor(red) lpattern(dash) legend(label(2 "Tratado"))), ///
       graphregion(color(white)) ///
       ytitle("Tiempo Promedio Trabajando Fuera del Hogar") ///
       xlabel(0 1, valuelabel) ///
       title("Impacto de FeA en Trabajo Infantil")


twoway (line mean_tayuda seguimiento if tratamiento == 0, ///
        lcolor(blue) lpattern(solid) legend(label(1 "No Tratado"))) ///
       (line mean_tayuda seguimiento if tratamiento == 1, ///
        lcolor(red) lpattern(dash) legend(label(2 "Tratado"))), ///
       graphregion(color(white)) ///
       ytitle("Tiempo Promedio Ayudando en el Hogar") ///
       xlabel(0 1, valuelabel) ///
       title("Impacto de FeA en Ayuda en el Hogar")



	   
	   
	   