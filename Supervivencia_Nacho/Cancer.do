***********************************************
** Análisis de supervivencia
***********************************************

clear
set more off

cd "G:\Mi unidad\CIMAT\Cursos Actual\Análisis de supervivencia\datos"
use "cancer.dta"

** Definición de la estructura de la serie
stset tiempo, failure(muerte)

** Descripción inicial
stdes
stsum

** Función de supervivencia de Kaplan-Meier (no paramétrica)
sts list
sts

** Función de supervivencia S(t) de Kaplan-Meier por tratamiento
sts list, by(trat)
sts list, by(trat) c
sts, by(trat)

** Función de muerte h(t) de Kaplan-Meier por tratamiento
sts list, by(trat) f
sts list, by(trat) f c
sts, by(trat) f

** Prueba Log-rank de igualdad de funciones de supervivencia
sts test trat

** Regresión Cox de riesgos proporcionales
stcox i.trat edad
margins i.trat, at(edad=(48(2)66))
marginsplot

replace edad = edad/5
stcox i.trat edad, nolog

** Prueba de proporcionalidad
estat phtest, detail

** Gráfica de riesgos proporcionales, si las lineas son paralelas
** no se viola el supuesto de riesgos proporcionales
stphplot, by(trat) 

*** Función de supervivencia
stcurve, survival at1(trat=0) at2(trat=1)

*** Función de riesgo suavizada por tratamiento
stcurve, hazard at1(trat=0) at2(trat=1)  kernel(gauss) 

*** Función de riesgo suavizada por tratamiento con escala logarítmica
stcurve, hazard at1(trat=0) at2(trat=1) kernel(gauss) yscale(log)

*** Estimación de la función de riesgo individual
predict pi, xb
gen di=1-0.988^exp(pi)

*** Supervivencia Kaplan-Meier observada vs curvas de predicción por modelo Cox
stcoxkm, by(trat)



