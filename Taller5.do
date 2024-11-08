*==============================================================================*
*				 		EVALUACION POLITICA PUBICA   2024-2					   *
*							TALLER 4 Do file								   *
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

log using "taller5_grupo4.log", replace /*Empezar el log file*/

use "Base_Taller_5_RD.dta", clear

describe

summarize

* Punto 3- Gráfica de covariables del hogar medidas en linea de base alrededor del punto de corte ----------------------------------------------------

egen prop_Alcantarillado = mean(Tiene_Alcantarillado), by(intervalo)
label var prop_Alcantarillado "Proporción de hogares con alcantarillado"

scatter prop_Alcantarillado intervalo, msymbol(oh) mlcolor(gs1) ///
       || lowess prop_Alcantarillado sisben if sisben<=11, bw(.6) lcolor(gs6) clwidth(medthick) ///
       || lowess prop_Alcantarillado sisben if sisben>11 & sisben<=21, bw(.6) lcolor(gs6) clwidth(medthick) ///
       ||, xline(11) xlabel(0(1)21) ylabel(, glcolor(gs14) glwidth(thin)) ///
       legend(position(9) ring(0) cols(1) row(1) order(1 2)) ///
       xtitle("Intervalo de Sisbén") ytitle("Proporción de hogares con alcantarillado") ///
       title("Acceso a alcantarillado por intervalo de Sisbén")
graph save "graph3.1.gph"
  	   
egen prop_Nevera = mean(Tiene_Nevera), by(intervalo)
label var prop_Nevera "Proporción de hogares con nevera"

scatter prop_Nevera intervalo, msymbol(oh) mlcolor(gs1) ///
    || lowess prop_Nevera sisben if sisben<=11, bw(.6) lcolor(gs6) clwidth(medthick) ///
    || lowess prop_Nevera sisben if sisben>11 & sisben<=21, bw(.6) lcolor(gs6) clwidth(medthick) ///
    ||, xline(11) xlabel(0(1)21) ylabel(, glcolor(gs14) glwidth(thin)) ///
    legend(position(9) ring(0) cols(1) row(1) order(1 2)) ///
    xtitle("Intervalo de Sisbén") ytitle("Proporción de hogares con nevera") ///
    title("Propiedad de nevera por intervalo de Sisbén")
graph save "graph3.2.gph"

egen prop_Secundaria = mean(Jefe_Secundaria_Completa), by(intervalo)
label var prop_Secundaria "Proporción de jefes con secundaria completa"

scatter prop_Secundaria intervalo, msymbol(oh) mlcolor(gs1) ///
    || lowess prop_Secundaria sisben if sisben<=11, bw(.6) lcolor(gs6) clwidth(medthick) ///
    || lowess prop_Secundaria sisben if sisben>11 & sisben<=21, bw(.6) lcolor(gs6) clwidth(medthick) ///
    ||, xline(11) xlabel(0(1)21) ylabel(, glcolor(gs14) glwidth(thin)) ///
    legend(position(9) ring(0) cols(1) row(1) order(1 2)) ///
    xtitle("Intervalo de Sisbén") ytitle("Proporción de jefes con secundaria completa") ///
    title("Nivel educativo del jefe de hogar por intervalo de Sisbén")
graph save "graph3.3.gph"

egen prop_Asistencia = mean(asistencia), by(intervalo)
label var prop_Asistencia "Proporción de niños que asisten al colegio"

scatter prop_Asistencia intervalo, msymbol(oh) mlcolor(gs1) ///
    || lowess prop_Asistencia sisben if sisben<=11, bw(.6) lcolor(gs6) clwidth(medthick) ///
    || lowess prop_Asistencia sisben if sisben>11 & sisben<=21, bw(.6) lcolor(gs6) clwidth(medthick) ///
    ||, xline(11) xlabel(0(1)21) ylabel(, glcolor(gs14) glwidth(thin)) ///
    legend(position(9) ring(0) cols(1) row(1) order(1 2)) ///
    xtitle("Intervalo de Sisbén") ytitle("Proporción de niños que asisten al colegio") ///
    title("Asistencia escolar de niños por intervalo de Sisbén")
graph save "graph3.4.gph"

graph combine graph3.1.gph graph3.2.gph graph3.3.gph graph3.4.gph, ///
    cols(2) ///
    title("Gráficas combinadas: Acceso a servicios y educación por intervalo de Sisbén") ///
    ysize(6) xsize(12)
graph save "graph3.gph"
