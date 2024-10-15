
*==============================================================================*
*				 		EVALUACION POLITICA PUBICA   2024-2					   *
*							TALLER 3 DO file								   *
* 	POR: Laura Pardo, José E González, Julián Pulido  Luis Castellanos   	   *
* 							22 de Septiembre  DE 2024						   *
* 							 	STATA 18.0									   *  
*==============================================================================*

cls
clear all
cap log close
set more off
*________________________________________________________________________________
*Establecemos un directorio de trabajo

*CD Laura
cd "C:\Users\Heitz\Desktop\Evaluación de Impacto  EGOB\Taller 3"

*CD Julian
cd"/Users/User/Library/CloudStorage/OneDrive-Universidaddelosandes/2024-2 Evaluación de Políticas Públicas/Talleres/Taller 3-Evaluación Experimental/"

*Rellenar directorio de trabajo para revisión
*cd ""

log using "taller3_grupo4.log", replace /*Empezar el log file*/

use "taller_3_base - Copy.dta", clear

*ssc install outreg, replace

*_______________________________________________________________________________

*Puntos 6,7,8

*Primera Etapa - No controles
reg active_account treatment,r
est sto r1 

*Primera Etapa controles
reg active_account treatment ${controles},r
est sto r4 


*IV
ivreg2 normal_calorie_sufficiency (treatment=active_account)

ivreg2 attendance (treatment=active_account ) ${controles}, r

