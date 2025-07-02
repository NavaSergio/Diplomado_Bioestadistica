***************************************************
** Análisis de supervivencia
** Riesgo de muerte por COVID 19 en dias desde la
** aparición de sintomas hasta la fecha de corte
** 21/05/2020, por sexo, edad y comorbilidades
** (sujetos confirmados).
** Datos nacionales por  al 21 de mayo del 2020
** (Datos de la secretaría de salud)
***************************************************

clear
set more off

cd "G:\Mi unidad\CIMAT\Cursos Actual\Análisis de supervivencia\datos"
use "covid19_21052020.dta"

** Definición de la estructura de la serie
stset tiempo2, failure(muerto)

** Descripción inicial
stdes
stsum

** Función de supervivencia de Kaplan-Meier (no paramétrica)
sts list
sts

** Función de supervivencia S(t) de Kaplan-Meier por sexo
sts list, by(SEXO)
sts list, by(SEXO) c
sts, by(SEXO)

** Función de muerte h(t) de Kaplan-Meier por tratamiento
sts list, by(SEXO) f
sts list, by(SEXO) f c
sts, by(SEXO) f

** Prueba Log-rank de igualdad de funciones de supervivencia
sts test SEXO

** Regresión Cox de riesgos proporcionales
stcox i.SEXO EDAD
margins i.SEXO, at(EDAD=(20(10)80)) nopvalues
marginsplot, title("") ytitle(Tasa de riesgo h(t) estimada) graphregion(fcolor(white))

** Prueba de proporcionalidad
estat phtest, detail

** Gráfica de riesgos proporcionales, si las lineas son paralelas
** no se viola el supuesto de riesgos proporcionales
stphplot, by(SEXO) 

*** Función de supervivencia
stcurve, survival at1(SEXO=1) at2(SEXO=2)

*** Función de riesgo suavizada por tratamiento
stcurve, hazard at1(SEXO=1) at2(SEXO=2) kernel(gauss) 

*** Función de riesgo suavizada por tratamiento con escala logarítmica
stcurve, hazard at1(SEXO=1) at2(SEXO=2) kernel(gauss) yscale(log)

*** Estimación de la función de riesgo individual
predict pi, xb
gen di=1-0.9984^exp(pi)

*** Supervivencia Kaplan-Meier observada vs curvas de predicción por modelo Cox
stcoxkm, by(SEXO)


** Regresión Cox de riesgos proporcionales con múltiples factores
stcox i.SEXO EDAD i.DIABETES i.EPOC i.INMUSUPR i.HIPERTENSION i.OBESIDAD i.RENAL_CRONICA
margins i.DIABETES, at(EDAD=(20(10)70)) nopvalues
marginsplot, title("") ytitle(Tasa de riesgo h(t) estimada) graphregion(fcolor(white))

** Regresión Cox de riesgos proporcionales con interacción HTA y obesidad
stcox i.SEXO EDAD i.OBESIDAD##i.HIPERTENSION
margins i.OBESIDAD#i.HIPERTENSION, at(EDAD=(20(10)70)) nopvalues
marginsplot, by(OBESIDAD) title("") ytitle(Tasa de riesgo h(t) estimada) graphregion(fcolor(white))

