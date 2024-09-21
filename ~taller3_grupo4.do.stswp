
*==============================================================================*
*				 		EVALUACION POLITICA PUBICA   2024-2					   *
*							TALLER 3 Do file								   *
* 	POR: Laura Pardo, José E González, Julián Pulido  Luis Castellanos   	   *
* 							23 de Septiembre  DE 2024						   *
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
*cd"/Users/User/Library/CloudStorage/OneDrive-Universidaddelosandes/2024-2 Evaluación de Políticas Públicas/Talleres/Taller 3-Evaluación Experimental/"

*CD Luis
*cd "D:\OneDrive - Universidad de los andes\EPP\Talleres\Do\Eval_PP"

log using "taller3_grupo4.log", replace /*Empezar el log file*/

use "taller_3_base - Copy.dta", clear

*________________________________________________________________________________

* Punto 4- Balance muestral ----------------------------------------------------
{
// Ejecuta los T-tests solo con las variables seleccionadas
table (command) (result), ///
    command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
    Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest mean_annual_wage_inc_b, by(treatment)) ///
    command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
    Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest num_migrants_b, by(treatment)) ///
    command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
    Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest saved_past_year_b, by(treatment)) ///
    command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
    Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest num_children_b, by(treatment)) ///
    command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
    Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest log_tot_loanvalue_1_b, by(treatment)) ///
    command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
    Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest productivity_b, by(treatment)) ///
    command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
    Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest below_ipoverty_line_b, by(treatment)) ///
    command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
    Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest household_size_b, by(treatment)) ///
    command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
    Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest anymobile, by(treatment)) ///
    command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
    Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest normal_meals_b, by(treatment)) ///
    command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
    Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest normal_calories_b, by(treatment)) ///
    command(media_tratado=r(mu_2) de_tratado=r(sd_2) media_control=r(mu_1) de_control=r(sd_1) ///
    Difference=(r(mu_2) - r(mu_1)) p_value=r(p): ttest consumption_value_b, by(treatment)) ///
    nformat(%3.2f) stars(p_value 0.1 "*" 0.05 "**" 0.01 "***", shownote) name(t_test1) replace

// Ajusta la tabla después de correr los comandos
collect set t_test1
collect label levels command ///
    1 "Media del Salario Anual" ///
    2 "Numero de migrantes" ///
    3 "Ahorrado en el pasado año" ///
    4 "Numero de Niños en hogar" ///
    5 "Logaritmo total Prestamo" ///
    6 "Productividad" ///
    7 "Debajo de la linea de Pobreza" ///
    8 "Tamaño del hogar" ///
    9 "Cualquier Móvil" ///
    10 "Comidas Normales" ///
    11 "Calorías Normales" ///
    12 "Valor de Consumo", modify

collect title "Tabla. T-tests comparación tratados vs control"
collect preview
collect style cell command[2 4]#result[media_tratado de_tratado media_control de_control Difference p_value stars]
collect export t_test1.docx, replace


	
*) Enfoque 2: Análisis de regresión		

reg treatment mean_annual_wage_inc_b num_migrants_b saved_past_year_b num_children_b log_tot_loanvalue_1_b productivity_b below_ipoverty_line_b household_size_b anymobile normal_calories_b consumption_value_b

outreg2 using regressionUnica.doc, title("Tabla 2. Tabla de balance") replace

}

*Punto 5 -----------------------------------------------------------------------
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

**# 7. Efectos heterogeneos:
/*
Calcule los efectos heterogéneos del programa sobre las horas de estudio (study_hour) por el género del jefe de hogar (hohh_female; =1 si el jefe de hogar es mujer, 0 si hombre). Interprete los tres coeficientes de su regresión, y su intercepto. ¿Hay un efecto del programa diferenciado para hogares liderados por hombres versus mujeres?  
*/

{
* Crear la variable de interacción:
label variable hohh_female "Jefe del hogar es mujer"
gen treatment_female_study = treatment * hohh_female
label variable treatment_female "Capacitación * Jefe mujer"

reg study_hour treatment hohh_female treatment_female, r
eststo heterogeneity
esttab heterogeneity, b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) stats(N r2), using "resultados_heterogeneos.doc",rtf replace label
*reg active_account treatment hohh_female treatment_female, r
*reg normal_calorie_sufficiency treatment hohh_female treatment_female, r
*reg attendance treatment hohh_female treatment_female, r


	
}

