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
cd "/Users/User/Library/CloudStorage/OneDrive-Universidaddelosandes/2024-2 Evaluación de Políticas Públicas/Talleres"

*log using "taller5_grupo4.log", replace /*Empezar el log file*/

use "/Base_Taller_5_RD.dta", clear

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
       legend(position(9) ring(0) cols(1) row(1) order(1 2)) ///
       xtitle("Intervalo de Sisbén") ytitle("Proporción de hogares con alcantarillado") ///
       title("Acceso a alcantarillado por intervalo de Sisbén")
graph save "graph3.1.gph", replace
egen prop_Nevera = mean(Tiene_Nevera), by(intervalo)
label var prop_Nevera "Proporción de hogares con nevera"

scatter prop_Nevera intervalo, msymbol(oh) mlcolor(gs1) ///
    || lowess prop_Nevera sisben if sisben<=11, bw(.6) lcolor(gs6) clwidth(medthick) ///
    || lowess prop_Nevera sisben if sisben>11 & sisben<=21, bw(.6) lcolor(gs6) clwidth(medthick) ///
    ||, xline(11) xlabel(0(1)21) ylabel(, glcolor(gs14) glwidth(thin)) ///
    legend(position(9) ring(0) cols(1) row(1) order(1 2)) ///
    xtitle("Intervalo de Sisbén") ytitle("Proporción de hogares con nevera") ///
    title("Propiedad de nevera por intervalo de Sisbén")
graph save "graph3.2.gph", replace

egen prop_Secundaria = mean(Jefe_Secundaria_Completa), by(intervalo)
label var prop_Secundaria "Proporción de jefes con secundaria completa"

scatter prop_Secundaria intervalo, msymbol(oh) mlcolor(gs1) ///
    || lowess prop_Secundaria sisben if sisben<=11, bw(.6) lcolor(gs6) clwidth(medthick) ///
    || lowess prop_Secundaria sisben if sisben>11 & sisben<=21, bw(.6) lcolor(gs6) clwidth(medthick) ///
    ||, xline(11) xlabel(0(1)21) ylabel(, glcolor(gs14) glwidth(thin)) ///
    legend(position(9) ring(0) cols(1) row(1) order(1 2)) ///
    xtitle("Intervalo de Sisbén") ytitle("Proporción de jefes con secundaria completa") ///
    title("Nivel educativo del jefe de hogar por intervalo de Sisbén")
graph save "graph3.3.gph", replace

egen prop_Asistencia = mean(asistencia), by(intervalo)
label var prop_Asistencia "Proporción de niños que asisten al colegio"

scatter prop_Asistencia intervalo, msymbol(oh) mlcolor(gs1) ///
    || lowess prop_Asistencia sisben if sisben<=11, bw(.6) lcolor(gs6) clwidth(medthick) ///
    || lowess prop_Asistencia sisben if sisben>11 & sisben<=21, bw(.6) lcolor(gs6) clwidth(medthick) ///
    ||, xline(11) xlabel(0(1)21) ylabel(, glcolor(gs14) glwidth(thin)) ///
    legend(position(9) ring(0) cols(1) row(1) order(1 2)) ///
    xtitle("Intervalo de Sisbén") ytitle("Proporción de niños que asisten al colegio") ///
    title("Asistencia escolar de niños por intervalo de Sisbén")
graph save "graph3.4.gph",replace

graph combine graph3.1.gph graph3.2.gph graph3.3.gph graph3.4.gph, ///
    cols(2) ///
    title("Gráficas combinadas: Acceso a servicios y educación por intervalo de Sisbén") ///
    ysize(6) xsize(12)
graph save "graph3.gph",replace

* Punto 4- Estimación de las diferencias observadas en las gráficas para las características de balance ----------------------------------------------------
*Configurar el punto de corte como 0
gen sisben_std = sisben - 11

*Característica de balance: Acceso a alcantarillado

reg prop_Alcantarillado beneficiario sisben_std if abs(sisben_std)<5, r
eststo: quietly reg prop_Alcantarillado beneficiario sisben_std if abs(sisben_std)<5, r

*Característica de balance: Propietario de nevera
reg prop_Nevera beneficiario sisben_std if abs(sisben_std)<5, r
eststo: quietly reg prop_Nevera beneficiario sisben_std if abs(sisben_std)<5, r

*Característica de balance: Nivel educativo jefes de familia
reg prop_Secundaria beneficiario sisben_std if abs(sisben_std)<5, r
eststo: quietly reg prop_Secundaria beneficiario sisben_std if abs(sisben_std)<5, r

*Característica de balance: Asistencia a clases
reg prop_Asistencia beneficiario sisben_std if abs(sisben_std)<5, r
eststo: quietly reg prop_Asistencia beneficiario sisben_std if abs(sisben_std)<5, r

outreg2 [est1 est2 est3 est4] using resultados_punto4.doc, replace

*Forma de Julian - CONSULTAR CON LA PROFESORA - REUNIÓN MARTES 3:30 PM
{
	
*ssc install rdrobust,replace
*ssc install rddensity, replace
*ssc install lpdensity, replace

*Característica de balance: Acceso a alcantarillado
rdrobust prop_Alcantarillado sisben_std, fuzzy(beneficiario) covs(prop_Asistencia  prop_Nevera prop_Secundaria) c(0) h(5)

*Característica de balance: Propietario de nevera
rdrobust prop_Nevera sisben_std, fuzzy(beneficiario) covs(prop_Alcantarillado prop_Asistencia prop_Secundaria) c(0) h(5)

*Característica de balance: Nivel educativo jefes de familia
rdrobust prop_Secundaria sisben_std, fuzzy(beneficiario) covs(prop_Alcantarillado prop_Asistencia prop_Nevera ) c(0) h(5)

*Característica de balance: Asistencia a clases
rdrobust prop_Asistencia sisben_std, fuzzy(beneficiario) covs(prop_Nevera prop_Secundaria prop_Alcantarillado) c(0) h(5)

}

*Punto 6 - Estime el impacto en las dos variables de resultado para anchos de banda de h=5 y h=10

*jefe de hogar
rdrobust empleojefe sisben_std,  covs(prop_Alcantarillado prop_Asistencia  prop_Nevera prop_Secundaria) c(0) h(5)

rdrobust empleojefe sisben_std,  covs(prop_Alcantarillado prop_Asistencia  prop_Nevera prop_Secundaria) c(0) h(10)

*Trabajo infantil
rdrobust tinfantil sisben_std, fuzzy(beneficiario) covs(prop_Alcantarillado prop_Asistencia  prop_Nevera prop_Secundaria) c(0) h(5)

rdrobust tinfantil sisben_std, fuzzy(beneficiario) covs(prop_Alcantarillado prop_Asistencia  prop_Nevera prop_Secundaria) c(0) h(10)

*Punto 7 -Escriba la ecuación (o ecuaciones) para estimar el efecto local promedio de recibir FeA 
*jefe de hogar
rdrobust empleojefe sisben_std, fuzzy(beneficiario) covs(prop_Alcantarillado prop_Asistencia  prop_Nevera prop_Secundaria) c(0) h(5)

rdrobust empleojefe sisben_std, fuzzy(beneficiario) covs(prop_Alcantarillado prop_Asistencia  prop_Nevera prop_Secundaria) c(0) h(10)

*Trabajo infantil
rdrobust tinfantil sisben_std, fuzzy(beneficiario) covs(prop_Alcantarillado prop_Asistencia  prop_Nevera prop_Secundaria) c(0) h(5)

rdrobust tinfantil sisben_std, fuzzy(beneficiario) covs(prop_Alcantarillado prop_Asistencia  prop_Nevera prop_Secundaria) c(0) h(10)
