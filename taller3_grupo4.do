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

{

tab anymobile_b, m


tab num_self_employed_b, m


tab daily_wage_b, m


tab mean_annual_wage_inc_b, m

tab num_wage_laborers_b, m


tab num_migrants_b, m


tab migrant_annual_wage_inc_b, m


tab annual_business_inc_b, m

tab self_employed_b, m

tab saved_past_year_b, m


tab savings_amt_b, m


tab lent_money_outstanding_b, m

tab household_size_b_b, m


tab num_children_b, m


tab ln_total_annual_wage_inc_b, m


tab total_annual_wage_inc_1_b, m


tab outstanding_loanfrac_b, m


tab tot_loanvalue_1_b, m


tab log_tot_loanvalue_1_b, m


tab productivity_b, m

tab below_upoverty_line_b, m


tab below_ipoverty_line_b, m


tab below_ipoverty_line2_b, m

tab tot_hh_income_b, m


tab daily_hh_income_b, m


tab daily_pc_income_b, m


tab below_upoverty_line2_b, m


tab tot_savings_b, m


tab log_tot_savings_1_b, m


tab any_savings_b, m


tab medical_fee_pc_b, m


tab wage_labor_b, m


tab poverty_gap_b, m


tab poverty_gap_sq_b, m


tab child_laborer_b, m


tab migration_for_work_b, m

}

*________________________________________________________________________________

*Tabla de Balance Intento 1						

* Se puede hacer con ttest pero en este caso los errores estandar están mal

*_______________________________________________________________________________
*Otro metodo 
* 1. Balance muestral
* -------------------------------------------------------------------------------
{
* Definición de las variables a usar en el análisis

table (command) (result), ///
command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
  Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest daily_wage_b, by(treatment)) ///
command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
  Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest mean_annual_wage_inc_b, by(treatment)) ///
command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
  Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest num_migrants_b, by(treatment)) ///
command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
  Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest migrant_annual_wage_inc_b, by(treatment)) ///
command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
  Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest num_migrants_b, by(treatment)) ///
command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
  Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest saved_past_year_b, by(treatment)) ///
command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
  Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest num_children_b, by(treatment)) ///
command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
  Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest ln_total_annual_wage_inc_b, by(treatment)) ///
command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
  Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest total_annual_wage_inc_1_b, by(treatment)) ///
command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
  Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest log_tot_loanvalue_1_b, by(treatment)) ///
command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
  Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest productivity_b, by(treatment)) ///
command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
  Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest below_ipoverty_line_b, by(treatment)) ///
command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
  Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest household_size_b, by(treatment)) ///
nformat(%3.2f) stars(p_value 0.1 "*" 0.05 "**" 0.01 "***", shownote) name(t_test1) replace

// Ajusta la tabla después de correr los comandos
collect set t_test1
collect label levels command 1 "Salario Diario" 2 "Media del Salario Anual" 3 "Numero de migrantes" 4 "Salario Anual del Migrante" 5 "Numero de Migrantes" 6 "Ahorrado en el pasado año" 7 "Numero de Niños en hogar" 8 "Logaritmo salario anual" 9 "Salario total Anual" 10 "Logaritmo total Prestamo" 11 "Productividad" 12 "Debajo de la linea de Pobreza" 13 "Tamaño del hogar", modify
collect title "Tabla. T-tests comparación tratados vs control"
collect preview
collect style cell command[2 4]#result[media_tratado de_tratado media_control de_control Difference p_value stars]
collect export t_test1.docx, replace





	
*) Enfoque 2: Análisis de regresión		
// Ejecutar regresiones y guardar los resultados en M1, M2, M3, etc.
// Ejemplo de regresiones:

reg treatment daily_wage_b
eststo M1

reg treatment mean_annual_wage_inc_b
eststo M2

reg treatment num_migrants_b
eststo M3


// Exportar la tabla con el título
outreg2 [M1 M2 M3] using 1.doc, title("Tabla 2. Tabla de balance") replace



*Punto 5 
*Calcule el impacto del programa sobre si el hogar tenía una cuenta activa de bKash (active_account) y dos resultados de interés: suficiencia calórica  (normal_calorie_sufficiency), y asistencia escolar (attendance).  Para cada variable de resultado, estimen primero los resultados sin controles (primera columna), y después controlando por las siguientes variables: sexo, edad, si el jefe de hogar completó primaria, y el tamaño del hogar  (segunda columna de cada resultado).
{
global controles hohh_female hohh_age hohh_completed_primary household_size_b

*Regresión básica - Cuenta activa
reg active_account treatment,r
est sto r1 

*Regresión con controles - Cuenta activa 
reg active_account treatment ${controles},r
est sto r4 

*Regresión básica - Suficiencia Calorica
reg normal_calorie_sufficiency treatment,r
est sto r2

*Regresión con controles - Suficiencia Calorica
reg normal_calorie_sufficiency treatment ${controles},r
est sto r5


*Regresión básica - Asistencia escolar
reg attendance treatment, r
est sto r3

*Regresión con controles - Asistencia escolar
reg attendance treatment ${controles},r
est sto r6 


esttab r* , b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) stats(N r2) drop(_cons ${controles}), using "resultados.doc",rtf replace

}

