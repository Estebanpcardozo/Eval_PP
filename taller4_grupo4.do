
*==============================================================================*
*				 		EVALUACION POLITICA PUBICA   2024-2					   *
*							TALLER 4 DO file								   *
* 	POR: Laura Pardo, José E González, Julián Pulido  Luis Castellanos   	   *
* 							21 de Octubre DE 2024			 				   *
* 							 	STATA 18.0									   *  
*==============================================================================*

cls
clear all
cap log close
set more off
*________________________________________________________________________________
*Establecemos un directorio de trabajo

*CD Laura
cd "C:\Users\Heitz\Documents\Taller 4\Eval_PP"

*CD Julian
*cd"/Users/User/Library/CloudStorage/OneDrive-Universidaddelosandes/2024-2 Evaluación de Políticas Públicas/Talleres/Taller 3-Evaluación Experimental/"

*Rellenar directorio de trabajo para revisión
*cd ""

log using "Taller4_grupo4.log", replace /*Empezar el log file*/

use "taller_3_base - Copy", clear


*_______________________________________________________________________________

*Punto 2 -----------------------------------------------------------------------
*2.	Corra la regresión anterior, usando la variable de active_account que indica si una persona tiene BKash, y mire las mismas dos variables de resultado del taller anterior: suficiencia calórica (normal_calorie_sufficiency) y asistencia escolar (attendance). Presente los resultados e interprete el coeficiente principal (tenga cuidado con el uso de lenguaje causal). 


*Regresión básica - Suficiencia Calorica
reg normal_calorie_sufficiency active_account, r
est sto r1 

*Regresión básica - Asistencia escolar
reg attendance active_account,r
est sto r2

*Exportacion de resultados
esttab r* , b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) stats(N r2) drop(_cons), using "resultados.doc", rtf replace

*Interpretaciones en el documento
*_______________________________________________________________________________

*Puntos 6,7,8
global controles hohh_female hohh_age hohh_completed_primary household_size_b

*Punto 6
*Primera Etapa - No controles
reg active_account treatment,r
est sto r1 

*Primera Etapa controles
reg active_account treatment ${controles},r
est sto r4 


*IV
ivreg2 normal_calorie_sufficiency (active_account=treatment), r
ivreg2 normal_calorie_sufficiency (active_account=treatment) ${controles}, r

ivreg2 attendance (active_account=treatment), r
ivreg2 attendance (active_account=treatment) ${controles}, r

*Forma Reducida

reg normal_calorie_sufficiency treatment,r
reg normal_calorie_sufficiency treatment ${controles},r

reg attendance treatment,r
reg attendance treatment ${controles},r