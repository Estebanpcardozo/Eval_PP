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

*cd "/Users/User/Library/CloudStorage/OneDrive-Universidaddelosandes/2024-2 Evaluación de Políticas Públicas/Talleres/Taller 2"

cd "C:\Users\Heitz\Desktop\Evaluación de Impacto  EGOB\Taller 3"

*Rellenar directorio de trabajo para revisión
*cd ""

log using "taller3_grupo4.log", replace /*Empezar el log file*/

use "taller_3_base - Copy.dta", clear



*ssc install outreg, replace



*_______________________________________________________________________________



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



*________________________________________________________________________________

*Tabla de Balance Intento 1						

* Se puede hacer con ttest pero en este caso los errores estandar están mal


* Crear la tabla de balance y guardarla
sort treatment

by treatment: eststo: estpost summarize anymobile_b num_self_employed_b daily_wage_b mean_annual_wage_inc_b num_wage_laborers_b num_migrants_b migrant_annual_wage_inc_b annual_business_inc_b self_employed_b saved_past_year_b savings_amt_b lent_money_outstanding_b household_size_b_b num_children_b ln_total_annual_wage_inc_b total_annual_wage_inc_1_b outstanding_loanfrac_b tot_loanvalue_1_b log_tot_loanvalue_1_b productivity_b below_upoverty_line_b below_ipoverty_line_b below_ipoverty_line2_b tot_hh_income_b daily_hh_income_b daily_pc_income_b below_upoverty_line2_b tot_savings_b log_tot_savings_1_b any_savings_b medical_fee_pc_b wage_labor_b poverty_gap_b poverty_gap_sq_b child_laborer_b migration_for_work_b household_size_b, listwise

* Exportar la tabla a Word
esttab using "tabla_balance.doc", cells("mean sd") label nodepvar replace 


*_______________________________________________________________________________
*Otro metodo 
* 1. Balance muestral
* -------------------------------------------------------------------------------
global covs "anymobile_b num_self_employed_b daily_wage_b mean_annual_wage_inc_b num_wage_laborers_b num_migrants_b migrant_annual_wage_inc_b annual_business_inc_b self_employed_b saved_past_year_b savings_amt_b lent_money_outstanding_b household_size_b_b num_children_b ln_total_annual_wage_inc_b total_annual_wage_inc_1_b outstanding_loanfrac_b tot_loanvalue_1_b log_tot_loanvalue_1_b productivity_b below_upoverty_line_b below_ipoverty_line_b below_ipoverty_line2_b tot_hh_income_b daily_hh_income_b daily_pc_income_b below_upoverty_line2_b tot_savings_b log_tot_savings_1_b any_savings_b medical_fee_pc_b wage_labor_b poverty_gap_b poverty_gap_sq_b child_laborer_b migration_for_work_b household_size_b"

di "${covs}"

*) Enfoque 1: Diferencia de medias
	
	* t-test
	foreach var in $covs {
		display ""
		display "******* `var' *******"
		ttest `var', by(treatment) 
	}
	

	
*Falta la exportacion aqui
	
*Ultimo metodo 	
	mat balance=J(37,10,.)
	mat significancia=J(37,20,0)
	
	tokenize ${covs}
	forvalues j=1/37{

		qui sum ``j''
		matrix balance[`j',1]=r(mean)
		matrix balance[`j',2]=r(sd)
		ttest ``j'', by(treatment) 
		matrix balance [`j',3]=r(mu_2) // tratados
		matrix balance [`j',4]=r(sd_2)
		matrix balance [`j',5]=r(mu_1) // no tratados
		matrix balance [`j',6]=r(sd_1)
		matrix balance[`j',7]=r(mu_2)-r(mu_1)
		matrix balance[`j',8]=r(se)
		matrix balance[`j',9]=r(p) 
		matrix significancia[`j',7]=(r(p)<0.1)+(r(p)<0.05)+(r(p)<0.01)

		matlist balance
		matlist significancia
	}

	frmttable using "Tabla_1_Balance_Muestral.doc", replace sdec(3)				/// 
		statmat(balance) substat(1) annotate(significancia) asymbol(*,**,***)	///
		title("Tabla 1. Balance muestral")										///
		ctitles("Media Tratados", "Desviacion Estandar Tratados", "Media Controles", "Desviacion Estandar Control", "Diferencia",	///
			"p-valor")															///
		rtitles("Cognicion, BL"\ "" \"Sexo"\ "" \ "Asistencia centro, BL")	
	
*) Enfoque 2: Análisis de regresión		
reg treatment ${covs}, r
test ${covs}
	/*  Se rechaza la H0, por lo que las características observadas
			sí explican la asignación el tratamiento. 
		Note que las pruebas t de esta regresión son distintas a las 
			de la diferencia de medias											*/
		




