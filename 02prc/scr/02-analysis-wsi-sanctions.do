/*==============================================================================
File name: 		02-analysis-wsi-sanctions.do
Task:			WSI Sanctions - Analysis
Project:		MEPYSO
Version:		Stata 16.1
Author:			Philipp Linden
Last update:	2022-10-11
==============================================================================*/

/*------------------------------------------------------------------------------
Content:


------------------------------------------------------------------------------*/

********************************************************************************

*==============================================================================*
****							II) Analysis - WSI							****
*==============================================================================*

********************************************************************************

/*Content:
#	1. Preparation & Labeling vignettess
#	2. Weighting and representativeness
#	3. DVs: Sanction levels
# 	4. Handling of missings
#		4.1 Imputation of respondent characteristics
# 	5. Sensitivity checks
# 	6. Descriptives
#		6.1 Table of vignette characteristics
#		6.2 Table of respondent characteristics
#		6.3 Sanctions deconstructed
#		6.4 Mean differences accross vignette name & motivation
#		6.5 Proportions of evaluated vignettes over sanction levels and reason for unemployment
# 	7. Robustness checks
#	8. Interactions
#		8.1 Interaction models vig x reason	
#		8.2 Interaction models vig x vig
#	9. Final regression models
#	10. Graphing estimation results
#	11. Clean up & Save

*******************************************************************************/

clear all
use $pdta\prep-wsi-sanctions.dta

********************************************************************************
****					2. Weighting and representativeness					****
********************************************************************************

fre r_gender r_educ r_state		

estpost sum r_age

********************************************************************************
****						3. DV: Sanction levels							****
********************************************************************************

*Sanction levels (10 steps)

gen al_sanction_cat10 = al_sanction
recode al_sanction_cat10 (0 = 0) (1/10 = 1) (11/20 = 2) (21/30 = 3) (31/40 = 4) (41/50 = 5) (51/60 = 6) (61/70 = 7) (71/80 = 8) (81/90 = 9) (91/100 = 10)
lab def al_sanction_cat10 0 "0" 1 "1-10" 2 "11-20" 3 "21-30" 4 "31-40" 5 "41-50" 6 "51-60" 7 "61-70" 8 "71-80" 9 "81-90" 10 "91-100", replace
lab val al_sanction_cat10 al_sanction_cat10
lab var al_sanction_cat10 "Kürzung der Grundsicherungsleistung in % (kategorial)"

*Sanction levels (Dummy)

gen al_sanction_d = al_sanction
recode al_sanction_d (1/100 = 1)
lab def al_sanction_d 0 "Nein" 1 "Ja", replace
lab val al_sanction_d
lab var al_sanction_d "Kürzung der Grundsicherungsleistung in % (Dummy)"
	
********************************************************************************
****						4. Handling of missings							****
********************************************************************************

*General missings

misstable sum _all		

*Missing patterns		

misstable patterns r_party r_mig r_famstat r_health r_unempl ///
			r_emplstat r_left_right r_inc
			
*Result:	67% Complete cases, Missings: 10% Income, + 8% Left_Right, + 3% Both
		
*Auxiliary variables = correlated with a missing variable (r > 0.4)?
			
pwcorr  ///
		al_sanction ///
		al_vig_name al_vig_reason al_vig_age al_vig_motivation al_vig_children al_vig_appointment ///
		r_gender r_age r_age_cat r_educ r_state r_ost ///
		r_mig r_emplstat ///
		r_unempl r_inc r_famstat ///
		r_party r_left_right r_health, star(0.05)
		
********************************************************************************
****		4.1 Imputation of missing respondent characteristics			****
********************************************************************************

*Recode reason for unemployment

clonevar al_vig_reason_raw = al_vig_reason											
recode al_vig_reason (1=2) (2=1)
lab def al_vig_reason_de 1 "Zahlungsunfähigkeit des Arbeitgebers" 2 "Persönliches Fehlverhalten" 3 "Chronische Rückenschmerzen" 4 "Depression", replace
lab val al_vig_reason al_vig_reason_de

clonevar r_famstat_raw = r_famstat											
recode r_famstat (4 5 6 = 0) (1 2 3 = 1)
lab def r_famstat 0 "Alleinstehend" 1 "Mit Partner", replace
lab val r_famstat r_famstat

clonevar r_inc_raw = r_inc
recode r_inc (1 = 0) (2 = 1) (3 4 = 2)
lab def r_inc 0 "Unter 1.000" 1 "1.000-2.000" 2 "Über 2.000", replace
lab val r_inc r_inc	

clonevar r_emplstat_raw = r_emplstat
recode r_emplstat (3=2) (4 5 6 7 8 = 3)
lab def r_emplstat 0 "Erwerbstätig" 1 "Rente" 2 "ALG I/II Bezug" 3 "Andere", replace
lab val r_emplstat r_emplstat

*Generate interaction terms

gen ia_vname_vmot = al_vig_name * al_vig_motivation
label var ia_vname_vmot "IA Vig Name x Vig Motivation"

gen ia_vname_vapp = al_vig_name * al_vig_appointment
label var ia_vname_vapp "IA Vig Name x Vig Appointment"

*Classification of variables for Imputation

fre	al_vig_name al_vig_reason al_vig_age ///
	al_vig_motivation al_vig_children al_vig_appointment ///							//	-> Model variable (Vignette) and non-missing -> Regular & Base for imputation
	r_gender r_age_cat_vig r_educ r_state r_ost ///							//	-> Model variable (Respondent) and non-missing -> Regular & Base for imputation
	r_mig r_unempl r_inc r_left_right r_health  ///						//	-> Model variable (Respondent) and missing -> Imputed
	r_party r_emplstat r_famstat ///			//	-> Not in Model, missing values -> Not need for imputation, Regular
	al_sanction																			// 	-> Dependent variables -> Regular & Base for imputation
	
*Setting up data for imputation

mi set mlong																			// Tell Stata the format of data for imputation
mi svyset _n [pw=weight]																// Tell Stata that survey weights exist																
mi register imputed r_mig r_unempl ///
					r_famstat r_emplstat ///
					r_inc r_party r_left_right r_health /// 							// Register imputed variables

mi register regular r_gender r_age_cat_vig r_educ r_ost ///
					al_vig_name al_vig_reason al_vig_age al_vig_motivation al_vig_children al_vig_appointment ///
					al_sanction	ia_vname_vmot ia_vname_vapp								// Register regular variables

*Impute missing data for respondent characteristics
					
mi impute chained ///
	(logit)	 	r_mig r_unempl ///
	(ologit) 	r_famstat r_emplstat ///
				r_inc r_party r_left_right r_health ///
				= 	al_sanction ///
					i.al_vig_name ib(1).al_vig_reason ib(2).al_vig_age ib(2).al_vig_motivation i.al_vig_children i.al_vig_appointment ///
					i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
					ia_vname_vmot ia_vname_vapp ///
						[pw=weight] ///
							, add(20) replace dots noisily rseed(2402)
						
********************************************************************************			
	
*Checks for correct specification	
	
list r_inc r_left_right r_gender r_age _mi_miss _mi_m id if id == 1

mi xeq 0 1 20: mean al_alg1 al_alg2 al_sanction r_left_right r_health r_inc
mi xeq 0 1 20: tab r_unempl
mi xeq 0 1 20: tab r_mig

graph box r_inc, over(_mi_m)
graph box r_health, over(_mi_m)
graph box r_left_right, over(_mi_m)
graph box r_party, over(_mi_m)

*Result: No indication for systematic bias
	
mi convert wide, clear

*Missingness before and after imputation

misstable sum 		r_mig r_unempl ///
					r_famstat r_emplstat ///
					r_inc r_party r_left_right r_health 
				
sum 				r_mig r_unempl ///
					r_famstat r_emplstat ///
					r_inc r_party r_left_right r_health
					
mean				r_mig r_unempl ///
					r_famstat r_emplstat ///
					r_inc r_party r_left_right r_health 					
		
mi est: svy: mean 	r_mig r_unempl ///
					r_famstat r_emplstat ///
					r_inc r_party r_left_right r_health

********************************************************************************

compress
save $pdta\prep-wsi-sanctions.dta, replace

********************************************************************************

********************************************************************************
****						5. Sensitivity checks							****
********************************************************************************

clear all
use $pdta\prep-wsi-sanctions.dta, replace

*Frequencies of vignette characteristics - Assumption of approximate distribution over respondents met?

fre al_vig_name al_vig_age al_vig_reason al_vig_motivation al_vig_children al_vig_appointment

*Result: 	- No systematic differences

*Correlations

*Do vignette vars correlate among each other? -> Ideally they do not

pwcorr al_vig_name al_vig_age al_vig_reason al_vig_motivation al_vig_children al_vig_appointment, star(.05)

/*
             | al_vi~me al_vi~ge al_v~son al_v~ion al_vi~en al_vig~t
-------------+------------------------------------------------------
 al_vig_name |   1.0000 
  al_vig_age |   0.0100   1.0000 
al_vig_rea~n |  -0.0012   0.0008   1.0000 
al_vig_mot~n |  -0.0007   0.0129  -0.0061   1.0000 
al_vig_chi~n |   0.0030  -0.0062  -0.0043   0.0039   1.0000 
al_vig_app~t |  -0.0041  -0.0121   0.0051   0.0119  -0.0075   1.0000 
*/

*Result: No correlation

*Do vignette variables correlate with respondent characteristics?

pwcorr al_vig_name al_vig_age al_vig_reason al_vig_motivation al_vig_children al_vig_appointment ///
			r_gender r_educ r_state r_age_cat_vig ///
			r_mig r_unempl ///
			r_famstat r_emplstat ///
			r_inc r_party r_left_right r_health ///
				, star(.05)
		
*Result: No correlation

********************************************************************************
****						6. Descriptives									****
********************************************************************************

*Generate mean of imputed values

gen m_mig_imp = ///
	(_1_r_mig + _2_r_mig + _3_r_mig + _4_r_mig + _5_r_mig + ///
	_6_r_mig + _7_r_mig + _8_r_mig + _9_r_mig + _10_r_mig + ///
	_11_r_mig + _12_r_mig + _13_r_mig + _14_r_mig + _15_r_mig + ///
	_16_r_mig + _17_r_mig + _18_r_mig + _19_r_mig + _20_r_mig)/20
				 
	recode m_mig_imp (0.01/1 = 1)
	lab val m_mig_imp r_mig
	lab var m_mig_imp "R: Migrationshintergrund (Mittelwert-imputiert)"
		
gen m_emplstat_imp = ///
	(_1_r_emplstat + _2_r_emplstat + _3_r_emplstat + _4_r_emplstat + _5_r_emplstat + ///
	_6_r_emplstat + _7_r_emplstat + _8_r_emplstat + _9_r_emplstat + _10_r_emplstat + ///
	_11_r_emplstat + _12_r_emplstat + _13_r_emplstat + _14_r_emplstat + _15_r_emplstat + ///
	_16_r_emplstat + _17_r_emplstat + _18_r_emplstat + _19_r_emplstat + _20_r_emplstat)/20
				 
	recode m_emplstat_imp (0.01/1 = 1) (1.01/2 = 2) (2.01/3 = 3)
	lab val m_emplstat_imp r_emplstat
	lab var m_emplstat_imp "R: Erwerbsstatus (Mittelwert-imputiert)"
	
gen m_unempl_imp = ///
	(_1_r_unempl + _2_r_unempl + _3_r_unempl + _4_r_unempl + _5_r_unempl + ///
	_6_r_unempl + _7_r_unempl + _8_r_unempl + _9_r_unempl + _10_r_unempl + ///
	_11_r_unempl + _12_r_unempl + _13_r_unempl + _14_r_unempl + _15_r_unempl + ///
	_16_r_unempl + _17_r_unempl + _18_r_unempl + _19_r_unempl + _20_r_unempl)/20
				 
	recode m_unempl_imp (0.01/1 = 1)
	lab val m_unempl_imp r_unempl
	lab var m_unempl_imp "R: Erfahrung mit Arbeitslosigkeit (Mittelwert-imputiert)"
	
gen m_inc_imp = ///
	(_1_r_inc + _2_r_inc + _3_r_inc + _4_r_inc + _5_r_inc + ///
	_6_r_inc + _7_r_inc + _8_r_inc + _9_r_inc + _10_r_inc + ///
	_11_r_inc + _12_r_inc + _13_r_inc + _14_r_inc + _15_r_inc + ///
	_16_r_inc + _17_r_inc + _18_r_inc + _19_r_inc + _20_r_inc)/20
				 
	recode m_inc_imp (0.01/1 = 1) (1.01/1.99 = 2) (2.01/2.99 = 3) (3.01/3.99 = 4) (4.01/max = 5)
	lab val m_inc_imp r_inc
	lab var m_inc_imp "R: Einkommen in Euro (Mittelwert-imputiert)"
	
gen m_famstat_imp = ///
	(_1_r_famstat + _2_r_famstat + _3_r_famstat + _4_r_famstat + _5_r_famstat + ///
	_6_r_famstat + _7_r_famstat + _8_r_famstat + _9_r_famstat + _10_r_famstat + ///
	_11_r_famstat + _12_r_famstat + _13_r_famstat + _14_r_famstat + _15_r_famstat + ///
	_16_r_famstat + _17_r_famstat + _18_r_famstat + _19_r_famstat + _20_r_famstat)/20
				 
	recode m_famstat_imp (0.01/1 = 1) (1.01/1.99 = 2) (2.01/2.99 = 3) (3.01/3.99 = 4)
	lab val m_famstat_imp r_famstat
	lab var m_famstat_imp "R: Familienstatus (Mittelwert-imputiert)"	
				 
gen m_health_imp = ///
	(_1_r_health + _2_r_health + _3_r_health + _4_r_health + _5_r_health + ///
	_6_r_health + _7_r_health + _8_r_health + _9_r_health + _10_r_health + ///
	_11_r_health + _12_r_health + _13_r_health + _14_r_health + _15_r_health + ///
	_16_r_health + _17_r_health + _18_r_health + _19_r_health + _20_r_health)/20
				 
	recode m_health_imp (0.01/1 = 1) (1.01/1.99 = 2) (2.01/2.99 = 3) (3.01/3.99 = 4)
	lab val m_health_imp r_health
	lab var m_health_imp "R: Selbsteingeschätzte Gesundheit (0 = Sehr schlecht – 4 = Sehr gut, Mittelwert-imputiert)"	

gen m_party_imp = ///
	(_1_r_party + _2_r_party + _3_r_party + _4_r_party + _5_r_party + ///
	_6_r_party + _7_r_party + _8_r_party + _9_r_party + _10_r_party + ///
	_11_r_party + _12_r_party + _13_r_party + _14_r_party + _15_r_party + ///
	_16_r_party + _17_r_party + _18_r_party + _19_r_party + _20_r_party)/20
						
	recode m_party_imp (0.01/1 = 1) (1.01/1.99 = 2) (2.01/2.99 = 3) ///
							(3.01/3.99 = 4) (4.01/4.99 = 5) (5.01/5.99 = 6) ///
							(6.01/6.99 = 7) (7.01/7.99 = 8)	(8.01/8.99 = 9) (9.01/9.99 = 10)
	lab val m_party_imp r_party
	lab var m_party_imp "R: Zugehörigkeit zu politischer Partei (Mittelwert-imputiert)"

gen m_left_right_imp = ///
	(_1_r_left_right + _2_r_left_right + _3_r_left_right + _4_r_left_right + _5_r_left_right + ///
	_6_r_left_right + _7_r_left_right + _8_r_left_right + _9_r_left_right + _10_r_left_right + ///
	_11_r_left_right + _12_r_left_right + _13_r_left_right + _14_r_left_right + _15_r_left_right + ///
	_16_r_left_right + _17_r_left_right + _18_r_left_right + _19_r_left_right + _20_r_left_right)/20
						
	recode m_left_right_imp (0.01/1 = 1) (1.01/1.99 = 2) (2.01/2.99 = 3) ///
							(3.01/3.99 = 4) (4.01/4.99 = 5) (5.01/5.99 = 6) ///
							(6.01/6.99 = 7) (7.01/7.99 = 8)	(8.01/8.99 = 9) (9.01/9.99 = 10)
	lab val m_left_right_imp r_left_right
	lab var m_left_right_imp "R: Pol. Selbsteinschätzung (0 = Links - 10 = Rechts, Mittelwert-imputiert)"

********************************************************************************
****				6.1 Table of vignette characteristics					****
********************************************************************************

fre al_vig_name al_vig_age al_vig_reason al_vig_motivation al_vig_children al_vig_appointment			

********************************************************************************
****				6.2 Table of respondent characteristics					****
********************************************************************************

fre r_gender r_educ r_ost r_age_cat_vig  ///
	m_mig_imp m_famstat_imp m_emplstat_imp ///
	m_inc_imp m_unempl_imp m_health_imp m_party_imp	

mi est: svy: mean r_age r_left_right r_health

sum r_age m_health_imp m_left_right_imp

********************************************************************************
****					6.3 Sanctions deconstructed							****
********************************************************************************

*Median of sanctions by deck (vignette levels)

egen median_sanction_deck = median(al_sanction), by(deck)
lab var median_sanction_deck "Kürzung der Grundsicherungsleistung in % über Decks (Median)"

*Overall mean of sanctions

mean al_sanction

*Mean of sanctions by deck (vignette levels)

egen mean_sanction_deck = mean(al_sanction), by(deck)
lab var mean_sanction_deck "{&empty} Kürzung der Grundsicherungsleistung in % über Decks"

*Proportions of evaluated vignettes over sanction levels (10 steps)

histogram al_sanction_cat10, discrete percent width(0.5) addlabels addlabopts(mlabsize(vsmall) mlabformat(%9.2f)) ///
	xtitle("Sanktionshöhe in %", size(medsmall) margin(medsmall)) xlabel(0(1)10, labsize(small) valuelabel nogrid) ///
	ytitle("Anteil beurteilter Vignetten in %", size(medsmall) margin(medsmall)) ///
	subtitle(, size(medsmall)) ///
	yscale(range(0 35)) ylabel(0(10)35, labsize(small) nogrid) ///
	scheme(plotplain)
	
graph export $plot\prop_vig.png, replace
 
********************************************************************************
****		6.4 Mean differences accross vignette name & motivation			****
********************************************************************************

*Descriptives

tab al_sanction_d

/*
   Level of |
sanctioning |
    (Dummy) |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        590       22.51       22.51
          1 |      2,031       77.49      100.00
------------+-----------------------------------
      Total |      2,621      100.00
*/

sum al_sanction, detail

/*
          Kürzung der Grundsicherungsleistung in %
-------------------------------------------------------------
      Percentiles      Smallest
 1%            0              0
 5%            0              0
10%            0              0       Obs               2,621
25%            5              0       Sum of Wgt.       2,621

50%           10                      Mean           23.24533
                        Largest       Std. Dev.      26.26088
75%           30            100
90%           50            100       Variance       689.6341
95%           90            100       Skewness       1.491102
99%          100            100       Kurtosis       4.627685
*/

sum al_sanction if al_sanction_d == 1, detail

/*
          Kürzung der Grundsicherungsleistung in %
-------------------------------------------------------------
      Percentiles      Smallest
 1%            2              1
 5%            5              1
10%           10              1       Obs               2,031
25%           10              1       Sum of Wgt.       2,031

50%           20                      Mean           29.99803
                        Largest       Std. Dev.      26.21835
75%           50            100
90%           70            100       Variance        687.402
95%          100            100       Skewness       1.346614
99%          100            100       Kurtosis       4.042248
*/

********************************************************************************

*Two sample t-Test for mean differences sanction vs. non-sanction

ttest al_sanction, by(al_sanction_d) reverse

/*
Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
       1 |   2,031    29.99803    .5817688    26.21835     28.8571    31.13896
       0 |     590           0           0           0           0           0
---------+--------------------------------------------------------------------
combined |   2,621    23.24533     .512951    26.26088     22.2395    24.25116
---------+--------------------------------------------------------------------
    diff |            29.99803    1.079539                 27.8812    32.11487
------------------------------------------------------------------------------
    diff = mean(1) - mean(0)                                      t =  27.7878
Ho: diff = 0                                     degrees of freedom =     2619

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 1.0000         Pr(|T| > |t|) = 0.0000          Pr(T > t) = 0.0000
*/

********************************************************************************

*Two sample t-Test for mean differences within vignette names (Bergmann vs. Yildirim)

ttest al_sanction if al_vig_name == 1 | al_vig_name == 2, by(al_vig_name)

/*
Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
Hr. Berg |   1,284    20.86994    .6795412    24.34996     19.5368    22.20307
Hr. Yild |   1,337    25.52655    .7600713    27.79202    24.03549    27.01762
---------+--------------------------------------------------------------------
combined |   2,621    23.24533     .512951    26.26088     22.2395    24.25116
---------+--------------------------------------------------------------------
    diff |           -4.656614    1.022266               -6.661145   -2.652083
------------------------------------------------------------------------------
    diff = mean(Hr. Berg) - mean(Hr. Yild)                        t =  -4.5552
Ho: diff = 0                                     degrees of freedom =     2619

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.0000         Pr(|T| > |t|) = 0.0000          Pr(T > t) = 1.0000
*/

********************************************************************************

*Two sample t-Test for mean differences within vignette age (20 vs. 40 vs. 60)

ttest al_sanction if al_vig_age == 1 | al_vig_age == 2, by(al_vig_age) reverse

/*
Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
      20 |     860    24.36628    .9070029    26.59855    22.58608    26.14648
      40 |     871    24.23881    .9197775    27.14513    22.43356    26.04405
---------+--------------------------------------------------------------------
combined |   1,731    24.30214    .6457658    26.86727    23.03557     25.5687
---------+--------------------------------------------------------------------
    diff |            .1274731    1.291927               -2.406432    2.661378
------------------------------------------------------------------------------
    diff = mean(20) - mean(40)                                    t =   0.0987
Ho: diff = 0                                     degrees of freedom =     1729

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.5393         Pr(|T| > |t|) = 0.9214          Pr(T > t) = 0.4607
*/

ttest al_sanction if al_vig_age == 2 | al_vig_age == 3, by(al_vig_age)

/*
Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
      40 |     871    24.23881    .9197775    27.14513    22.43356    26.04405
      60 |     890    21.18989    .8355262    24.92614    19.55005    22.82972
---------+--------------------------------------------------------------------
combined |   1,761     22.6979    .6215881    26.08449    21.47877    23.91703
---------+--------------------------------------------------------------------
    diff |            3.048918    1.241475                .6139959    5.483841
------------------------------------------------------------------------------
    diff = mean(40) - mean(60)                                    t =   2.4559
Ho: diff = 0                                     degrees of freedom =     1759

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.9929         Pr(|T| > |t|) = 0.0141          Pr(T > t) = 0.0071
*/

********************************************************************************

*Two sample t-Test for mean differences within vignette reason for unemployment (Bankruptcy vs. Personal vs. Back pain vs. Depression)

*Bankruptcy vs. Personal

ttest al_sanction if al_vig_reason == 1 | al_vig_reason == 2, by(al_vig_reason)

/*
Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
Zahlungs |     660    25.43333    1.086254    27.90636     23.3004    27.56627
Persönli |     618    25.97735    1.079092     26.8258    23.85821    28.09648
---------+--------------------------------------------------------------------
combined |   1,278     25.6964    .7658876    27.37981    24.19386    27.19894
---------+--------------------------------------------------------------------
    diff |           -.5440129    1.533128               -3.551741    2.463715
------------------------------------------------------------------------------
    diff = mean(Zahlungs) - mean(Persönli)                        t =  -0.3548
Ho: diff = 0                                     degrees of freedom =     1276

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.3614         Pr(|T| > |t|) = 0.7228          Pr(T > t) = 0.6386
*/

*Bankruptcy vs. Chronic back pain

ttest al_sanction if al_vig_reason == 1 | al_vig_reason == 3, by(al_vig_reason)

/*
Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
Zahlungs |     660    25.43333    1.086254    27.90636     23.3004    27.56627
Chronisc |     663    21.09955    .9836689    25.32828    19.16806    23.03103
---------+--------------------------------------------------------------------
combined |   1,323    23.26153    .7347077    26.72357    21.82021    24.70285
---------+--------------------------------------------------------------------
    diff |            4.333786    1.465131                1.459548    7.208024
------------------------------------------------------------------------------
    diff = mean(Zahlungs) - mean(Chronisc)                        t =   2.9580
Ho: diff = 0                                     degrees of freedom =     1321

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.9984         Pr(|T| > |t|) = 0.0032          Pr(T > t) = 0.0016
*/

*Bankruptcy vs. Depression

ttest al_sanction if al_vig_reason == 1 | al_vig_reason == 4, by(al_vig_reason)

/*
Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
Zahlungs |     660    25.43333    1.086254    27.90636     23.3004    27.56627
Depressi |     680    20.73088    .9421173    24.56741    18.88107     22.5807
---------+--------------------------------------------------------------------
combined |   1,340    23.04701    .7201098    26.36035    21.63435    24.45968
---------+--------------------------------------------------------------------
    diff |            4.702451    1.435172                1.887019    7.517883
------------------------------------------------------------------------------
    diff = mean(Zahlungs) - mean(Depressi)                        t =   3.2766
Ho: diff = 0                                     degrees of freedom =     1338

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.9995         Pr(|T| > |t|) = 0.0011          Pr(T > t) = 0.0005
*/

*Personal vs. Chronic back pain

ttest al_sanction if al_vig_reason == 2 | al_vig_reason == 3, by(al_vig_reason)

/*
Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
Persönli |     618    25.97735    1.079092     26.8258    23.85821    28.09648
Chronisc |     663    21.09955    .9836689    25.32828    19.16806    23.03103
---------+--------------------------------------------------------------------
combined |   1,281    23.45277    .7310519    26.16512    22.01858    24.88696
---------+--------------------------------------------------------------------
    diff |            4.877799    1.457209                2.019015    7.736582
------------------------------------------------------------------------------
    diff = mean(Persönli) - mean(Chronisc)                        t =   3.3474
Ho: diff = 0                                     degrees of freedom =     1279

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.9996         Pr(|T| > |t|) = 0.0008          Pr(T > t) = 0.0004
*/

*Personal vs. Depression

ttest al_sanction if al_vig_reason == 2 | al_vig_reason == 4, by(al_vig_reason)

/*
Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
Persönli |     618    25.97735    1.079092     26.8258    23.85821    28.09648
Depressi |     680    20.73088    .9421173    24.56741    18.88107     22.5807
---------+--------------------------------------------------------------------
combined |   1,298    23.22881    .7158654    25.79103    21.82443    24.63319
---------+--------------------------------------------------------------------
    diff |            5.246464    1.426495                2.447972    8.044956
------------------------------------------------------------------------------
    diff = mean(Persönli) - mean(Depressi)                        t =   3.6779
Ho: diff = 0                                     degrees of freedom =     1296

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.9999         Pr(|T| > |t|) = 0.0002          Pr(T > t) = 0.0001
*/

*Chronic back pain vs. Depression

ttest al_sanction if al_vig_reason == 3 | al_vig_reason == 4, by(al_vig_reason)

/*
Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
 Chronic |     663    21.09955    .9836689    25.32828    19.16806    23.03103
Depressi |     680    20.73088    .9421173    24.56741    18.88107     22.5807
---------+--------------------------------------------------------------------
combined |   1,343    20.91288    .6804741    24.93731    19.57797    22.24779
---------+--------------------------------------------------------------------
    diff |            .3686652    1.361527                -2.30229    3.039621
------------------------------------------------------------------------------
    diff = mean(Chronic) - mean(Depressi)                         t =   0.2708
Ho: diff = 0                                     degrees of freedom =     1341

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.6067         Pr(|T| > |t|) = 0.7866          Pr(T > t) = 0.3933
*/

********************************************************************************

*Two sample t-Test for mean differences within vignette children (Single vs. Married vs. Married, 3yo child)

ttest al_sanction if al_vig_children == 1 | al_vig_children == 2, by(al_vig_children)

/*
Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
 Single, |     887    23.58286    .8785678    26.16598    21.85855    25.30718
Verheira |     865    23.23699    .9037097     26.5789    21.46327    25.01072
---------+--------------------------------------------------------------------
combined |   1,752     23.4121     .629853    26.36369    22.17676    24.64744
---------+--------------------------------------------------------------------
    diff |            .3458694    1.260138               -2.125665    2.817404
------------------------------------------------------------------------------
    diff = mean(Single,) - mean(Verheira)                         t =   0.2745
Ho: diff = 0                                     degrees of freedom =     1750

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.6081         Pr(|T| > |t|) = 0.7838          Pr(T > t) = 0.3919
*/

ttest al_sanction if al_vig_children == 1 | al_vig_children == 3, by(al_vig_children)

/*
Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
 Single, |     887    23.58286    .8785678    26.16598    21.85855    25.30718
Verheira |     869    22.90909    .8841693    26.06426    21.17373    24.64445
---------+--------------------------------------------------------------------
combined |   1,756    23.24943    .6230913    26.11042    22.02735    24.47151
---------+--------------------------------------------------------------------
    diff |            .6737727    1.246499               -1.771008    3.118554
------------------------------------------------------------------------------
    diff = mean(Single,) - mean(Verheira)                         t =   0.5405
Ho: diff = 0                                     degrees of freedom =     1754

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.7056         Pr(|T| > |t|) = 0.5889          Pr(T > t) = 0.2944
*/

********************************************************************************

*Motivation: High vs. Low

ttest al_sanction if al_vig_motivation == 1 | al_vig_motivation == 2, by(al_vig_motivation)

/*
Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
  Gering |   1,291    24.87684    .7631405    27.42001    23.37971    26.37397
    Hoch |   1,330    21.66165    .6853244    24.99321    20.31722    23.00609
---------+--------------------------------------------------------------------
combined |   2,621    23.24533     .512951    26.26088     22.2395    24.25116
---------+--------------------------------------------------------------------
    diff |            3.215186    1.024286                1.206693    5.223678
------------------------------------------------------------------------------
    diff = mean(Gering) - mean(Hoch)                              t =   3.1390
Ho: diff = 0                                     degrees of freedom =     2619

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.9991         Pr(|T| > |t|) = 0.0017          Pr(T > t) = 0.0009
*/

********************************************************************************

*Appointments: 1st vs. 2nd

ttest al_sanction if al_vig_appointment == 1 | al_vig_appointment == 2, by(al_vig_appointment)

/*
Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
  1. Mal |   1,316    17.42629    .6380353    23.14582    16.17461    18.67797
  2. Mal |   1,305    29.11341    .7714903    27.86992    27.59991    30.62691
---------+--------------------------------------------------------------------
combined |   2,621    23.24533     .512951    26.26088     22.2395    24.25116
---------+--------------------------------------------------------------------
    diff |           -11.68712    1.000371               -13.64872   -9.725521
------------------------------------------------------------------------------
    diff = mean(1. Mal) - mean(2. Mal)                            t = -11.6828
Ho: diff = 0                                     degrees of freedom =     2619

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.0000         Pr(|T| > |t|) = 0.0000          Pr(T > t) = 1.0000
*/

********************************************************************************
****				6.5 Proportions of evaluated vignettes 					****
****			over sanction levels and reason for unemployment			****
********************************************************************************

gen al_vig_name_wsi = al_vig_name
lab def al_vig_name_wsi 1 "Deutscher Name: Hr. Bergmann" 2 "Ausländischer Name: Hr. Yildirim", replace
lab val al_vig_name_wsi al_vig_name_wsi
lab var al_vig_name_wsi "V: Name der Person, die arbeitslos ist (WSI)"

histogram al_sanction_cat10, ///
	discrete percent width(0.5) addlabels addlabopts(mlabsize(vsmall) mlabformat(%9.2f)) ///
	xtitle("Sanktionshöhe in %", size(small)) xlabel(0(1)10, labsize(vsmall) valuelabel nogrid) ///
	ytitle("Anteil beurteilter Vignetten in %", size(vsmall)) ///
	yscale(range(0 35)) ylabel(0(10)35, labsize(small) angle(0) nogrid) ///
	subtitle(, size(medsmall) justification(center) margin(vsmall)) ///
	by(al_vig_name_wsi, note("") legend(off) col(2)) ///
	scheme(plotplain)
	
	graph save $plot\name.gph, replace
	
histogram al_sanction_cat10, ///
	discrete percent width(0.5) addlabels addlabopts(mlabsize(vsmall) mlabformat(%9.2f)) ///
	xtitle("Sanktionshöhe in %", size(small)) xlabel(0(1)10, labsize(vsmall) valuelabel nogrid) ///
	ytitle("Anteil beurteilter Vignetten in %", size(small)) ///
	yscale(range(0 35)) ylabel(0(15)45, labsize(small) nogrid) ///
	subtitle(, size(medsmall) justification(center) margin(vsmall)) ///
	by(al_vig_age, note("") legend(off) col(1)) ///
	scheme(plotplain)
	
	graph save $plot\age.gph, replace
	
histogram al_sanction_cat10, ///
	discrete percent width(0.5) addlabels addlabopts(mlabsize(vsmall) mlabformat(%9.2f)) ///
	xtitle("Sanktionshöhe in %", size(small)) xlabel(0(1)10, labsize(vsmall) valuelabel nogrid) ///
	ytitle("Anteil beurteilter Vignetten in %", size(small)) ///
	yscale(range(0 35)) ylabel(0(15)45, labsize(small) nogrid) ///
	subtitle(, size(medsmall) justification(center) margin(vsmall)) ///
	by(al_vig_reason, note("") legend(off) col(2)) ///
	scheme(plotplain)
	
	graph save $plot\rea.gph, replace
	
histogram al_sanction_cat10, ///
	discrete percent width(0.5) addlabels addlabopts(mlabsize(vsmall) mlabformat(%9.2f)) ///
	xtitle("Sanktionshöhe in %", size(small)) xlabel(0(1)10, labsize(vsmall) valuelabel nogrid) ///
	ytitle("Anteil beurteilter Vignetten in %", size(small)) ///
	yscale(range(0 35)) ylabel(0(15)45, labsize(small) nogrid) ///
	subtitle(, size(medsmall) justification(center) margin(vsmall)) ///
	by(al_vig_children, note("") legend(off) col(1)) ///
	scheme(plotplain)
	
	graph save $plot\chi.gph, replace
	
gen al_vig_motivation_wsi = al_vig_motivation
lab def al_vig_motivation_wsi 1 "Motivation: Gering" 2 "Motivation: Hoch", replace
lab val al_vig_motivation_wsi al_vig_motivation_wsi
lab var al_vig_motivation_wsi "V: Motivation (WSI)"	
	
histogram al_sanction_cat10, ///
	discrete percent width(0.5) addlabels addlabopts(mlabsize(vsmall) mlabformat(%9.2f)) ///
	xtitle("Sanktionshöhe in %", size(small)) xlabel(0(1)10, labsize(vsmall) valuelabel nogrid) ///
	ytitle("Anteil beurteilter Vignetten in %", size(vsmall)) ///
	yscale(range(0 35)) ylabel(0(10)35, labsize(small) angle(0) nogrid) ///
	subtitle(, size(medsmall) justification(center) margin(vsmall)) ///
	by(al_vig_motivation_wsi, note("") legend(off) col(2)) ///
	scheme(plotplain)
	
	graph save $plot\mot.gph, replace
	
gen al_vig_appointment_wsi = al_vig_appointment
lab def al_vig_appointment_wsi 1 "Verpasste Termine: 1. Mal" 2 "Verpasste Termine: 2. Mal", replace
lab val al_vig_appointment_wsi al_vig_appointment_wsi
lab var al_vig_appointment_wsi "V: Appointment (WSI)"		
	
histogram al_sanction_cat10, ///
	discrete percent width(0.5) addlabels addlabopts(mlabsize(vsmall) mlabformat(%9.2f)) ///
	xtitle("Sanktionshöhe in %", size(small)) xlabel(0(1)10, labsize(vsmall) valuelabel nogrid) ///
	ytitle("Anteil beurteilter Vignetten in %", size(vsmall)) ///
	yscale(range(0 35)) ylabel(0(10)35, labsize(small) angle(0) nogrid) ///
	subtitle(, size(medsmall) justification(center) margin(vsmall)) ///
	by(al_vig_appointment_wsi, note("") legend(off) col(2)) ///
	scheme(plotplain)
	
	graph save $plot\app.gph, replace
	
********************************************************************************

graph combine 	$plot\name.gph ///
				$plot\mot.gph ///
				$plotFinal\Unemployment\WSI\app.gph ///
				, col(1) graphregion(color(white))
					
graph export 	$plot\prop_over_vig.png, replace
graph export 	$plot\prop_over_vig.pdf, replace

	erase $plot\name.gph
	erase $plot\mot.gph
	erase $plot\app.gph	

********************************************************************************

graph combine	$plot\age.gph ///
				$plot\rea.gph ///
				$plot\chi.gph ///
				, col(1)
				
graph export 	$plot\prop_over_vig2.png, replace
graph export 	$plot\prop_over_vig2.svg, replace

********************************************************************************
****						7. Robustness checks							****
********************************************************************************

*T1: Without controls

reg al_sanction i.al_vig_reason i.al_vig_name ib(2).al_vig_age i.al_vig_children ib(2).al_vig_motivation i.al_vig_appointment ///
		if r_gender != . & 		///
		r_educ != . & 			///
		r_ost != . &			///
		r_age_cat_vig != . &  	///
		r_mig != . &  			///
		r_citship != . &  		///
		r_famstat != . &  		///
		r_emplstat != . &  		///
		r_inc != . &  			///
		r_unempl != . &  		///
		r_party != . &  		///
		r_left_right != . &  	///
		r_health != .
	est store T1

*T2: Complete model

reg al_sanction i.al_vig_reason i.al_vig_name ib(2).al_vig_age i.al_vig_children ib(2).al_vig_motivation i.al_vig_appointment ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_citship i.r_famstat  i.r_emplstat ///
		ib(2).r_inc i.r_unempl i.r_party r_left_right ib(2).r_health
			est store T2
			lrtest T1
			vif
			
/*

Likelihood-ratio test                                 LR chi2(28) =     123.29
(Assumption: T1 nested in T2)                         Prob > chi2 =    0.0000

VIF: No problematic variance inflation by any of the variables

*/	
			
*T3: Without controls and "unwilling" to sanction

reg al_sanction i.al_vig_reason i.al_vig_name ib(2).al_vig_age i.al_vig_children ib(2).al_vig_motivation i.al_vig_appointment ///
		if r_gender != . & 		///
		r_educ != . & 			///
		r_ost != . &			///
		r_age_cat_vig != . &  	///
		r_mig != . &  			///
		r_citship != . &  		///
		r_famstat != . &  		///
		r_emplstat != . &  		///
		r_inc != . &  			///
		r_unempl != . &  		///
		r_party != . &  		///
		r_left_right != . &  	///
		r_health != . &			///
		al_sanction > 0
	est store T3			
			
*T4: Without "unwilling" to sanction			
			
reg al_sanction i.al_vig_reason i.al_vig_name ib(2).al_vig_age i.al_vig_children ib(2).al_vig_motivation i.al_vig_appointment ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_citship i.r_famstat  i.r_emplstat ///
		ib(2).r_inc i.r_unempl i.r_party r_left_right ib(2).r_health ///
		if al_sanction > 0
			est store T4
			lrtest T3
			vif

/*

Likelihood-ratio test                                 LR chi2(28) =     77.61
(Assumption: T3 nested in T4)                         Prob > chi2 =    0.0000

VIF: No problematic variance inflation by any of the variables

*/	
			
*T5: Without controls & parsimonious model

reg al_sanction i.al_vig_reason i.al_vig_name ib(2).al_vig_age i.al_vig_children ib(2).al_vig_motivation i.al_vig_appointment ///
		if r_gender != . & 		///
		r_educ != . & 			///
		r_ost != . &			///
		r_age_cat_vig != . &  	///
		r_mig != . &  			///
		r_famstat != . &  		///
		r_emplstat != . &  		///
		r_inc != . &  			///
		r_unempl != . &  		///
		r_party != . &  		///
		r_left_right != . &  	///
		r_health != .
	est store T5
	
*T6: Complete parsimonious model

reg al_sanction i.al_vig_reason i.al_vig_name ib(2).al_vig_age i.al_vig_children ib(2).al_vig_motivation i.al_vig_appointment ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right ib(2).r_health
			est store T6
			lrtest T5
			vif
			
/*

Likelihood-ratio test                                 LR chi2(26) =    123.61
(Assumption: T5 nested in T6)                         Prob > chi2 =    0.0000

VIF: No problematic variance inflation by any of the variables

*/

*T7: Complete parsimonious model with deck variable

reg al_sanction i.al_vig_reason i.al_vig_name ib(2).al_vig_age i.al_vig_children ib(2).al_vig_motivation i.al_vig_appointment ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right ib(2).r_health ///
			deck
			est store T7
			lrtest T6
			vif

/*

Likelihood-ratio test                                 LR chi2(26) =    0,01
(Assumption: T3 nested in T4)                         Prob > chi2 =    0.9168

VIF: No problematic variance inflation by any of the variables

********************************************************************************	
	
esttab T1 T2 T3 T4 T5 T6 ///
	using $output\Robust.rtf, replace label se obslast aic bic ///
	nonumbers mti("W/o controls" "Full model" "W/o controls & unwilling" "Full model & w/o unwilling" "W/o controls (parsimonious)" "Full model (parsimonious)") ///
	addnote("Anmerkung: Erster Eintrag: Koeffizient. Zweiter Eintrag: Standardfehler, zweiseitig.") ///
	varwidth(20) brackets nogaps nobaselevels compress b(3) equations(1) interaction(" X ")
	
*/

********************************************************************************
****								8. Interactions						****
********************************************************************************

********************************************************************************
****					8.1 Interaction models vig x reason					****
********************************************************************************

*I0: Complete model w/o IA

mi est, vartable ufmitest saving($pdta\Final\WSI_estI0.ster, replace) post: ///
	svy: reg al_sanction i.al_vig_reason i.al_vig_name ib(2).al_vig_age i.al_vig_children ib(2).al_vig_motivation i.al_vig_appointment ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store I0

*I1: Interaction with Vig Name

mi est, vartable ufmitest saving($pdta\Final\WSI_estI1.ster, replace) post: ///
	svy: reg al_sanction i.al_vig_reason##i.al_vig_name ib(2).al_vig_age i.al_vig_children ib(2).al_vig_motivation i.al_vig_appointment ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store I1
			
*I2: Interaction with Vig Age

mi est, vartable ufmitest saving($pdta\Final\WSI_estI2.ster, replace) post: ///
	svy: reg al_sanction i.al_vig_reason##ib(2).al_vig_age i.al_vig_name i.al_vig_children ib(2).al_vig_motivation i.al_vig_appointment ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store I2
			
*I3: Interaction with Vig Children

mi est, vartable ufmitest saving($pdta\Final\WSI_estI3.ster, replace) post: ///
	svy: reg al_sanction i.al_vig_reason##i.al_vig_children i.al_vig_name ib(2).al_vig_age ib(2).al_vig_motivation i.al_vig_appointment ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store I3		
			
*I4: Interaction with Vig Motivation

mi est, vartable ufmitest saving($pdta\Final\WSI_estI4.ster, replace) post: ///
	svy: reg al_sanction i.al_vig_reason##ib(2).al_vig_motivation i.al_vig_name ib(2).al_vig_age i.al_vig_children i.al_vig_appointment ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store I4
			
*I5: Interaction with Vig Appointment

mi est, vartable ufmitest saving($pdta\Final\WSI_estI5.ster, replace) post: ///
	svy: reg al_sanction i.al_vig_reason##i.al_vig_appointment i.al_vig_name ib(2).al_vig_age i.al_vig_children ib(2).al_vig_motivation ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store I5
			
/*	
				
esttab I0 I1 I2 I3 I4 I5 ///
	using $output\Final\Unemployment\Vig_WSI\IA_ReasonXVig.rtf, replace label se obslast aic bic ///
	nonumbers mti("W/o IA" "IA: Name" "IA: Age" "IA: Children" "IA: Motivation" "IA: Appointment") ///
	addnote("Anmerkung: Erster Eintrag: Koeffizient. Zweiter Eintrag: Standardfehler, zweiseitig.") ///
	varwidth(20) brackets nogaps nobaselevels compress b(3) equations(1) interaction(" X ")
	
*/

********************************************************************************
****					8.2 Interaction models vig x vig					****
********************************************************************************

*I6: Interaction Name * Age

mi est, vartable ufmitest saving($pdta\Final\WSI_estI6.ster, replace) post: ///
	svy: reg al_sanction i.al_vig_reason i.al_vig_name##ib(2).al_vig_age i.al_vig_children ib(2).al_vig_motivation i.al_vig_appointment ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store I6
			
*I7: Interaction Name * Children

mi est, vartable ufmitest saving($pdta\Final\WSI_estI7.ster, replace) post: ///
	svy: reg al_sanction i.al_vig_reason i.al_vig_name##i.al_vig_children ib(2).al_vig_age ib(2).al_vig_motivation i.al_vig_appointment ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store I7
			
*I8: Interaction Name * Motivation

mi est, vartable ufmitest saving($pdta\Final\WSI_estI8.ster, replace) post: ///
	svy: reg al_sanction i.al_vig_reason i.al_vig_name##ib(2).al_vig_motivation_wsi ib(2).al_vig_age i.al_vig_children i.al_vig_appointment ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store I8
			
*-> Yildirim X Motivation (4.202; SE = 2.010; t = 2.09; p = 0.036)
	
*PRM = Predictive margins (Bar)	

mimrgns i.al_vig_name#i.al_vig_motivation_wsi, cmdmargins
marginsplot, ///
		by(al_vig_motivation_wsi) ///
		recast(bar) ///
		byopts(title("")) ///
		ytitle("{&empty} Sanktionshöhe (%)", margin(medsmall)) ///
		ylabel(0(5)35, nogrid) ///
		xtitle("Name der Person, die arbeitslos ist", size(medsmall) margin(medsmall)) ///
		xlabel(, nogrid) ///
		plotopt(barwidth(0.75) fcolor(*.25)) ///
		scheme(plotplain)	
		
	graph export $plot\IA_mot_name_prm.png, replace
	graph save $plot\IA_mot_name_prm.gph, replace
	
test _b[1.al_vig_name#1.al_vig_motivation]=_b[2.al_vig_name#1.al_vig_motivation]	
			
*I9: Interaction Name * Appointment

mi est, vartable ufmitest saving($pdta\Final\WSI_estI9.ster, replace) post: ///
	svy: reg al_sanction i.al_vig_reason i.al_vig_name##i.al_vig_appointment_wsi ib(2).al_vig_age i.al_vig_children ib(2).al_vig_motivation ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store I9

*-> Yildirim X 2nd missed appointment (6.88; SE = 1.986; t = 3.47; p = 0.001)
	
*PRM = Predictive margins (Bar)	

mimrgns i.al_vig_name#i.al_vig_appointment_wsi, cmdmargins
marginsplot, ///
		by(al_vig_appointment_wsi) ///
		recast(bar) ///
		byopts(title("")) ///
		ytitle("{&empty} Sanktionshöhe (%)", margin(medsmall)) ///
		ylabel(0(5)35, nogrid) ///
		xtitle("Name der Person, die arbeitslos ist", size(medsmall) margin(medsmall)) ///
		xlabel(, nogrid) ///
		plotopt(barwidth(0.75) fcolor(*.25)) ///
		scheme(plotplain)
		
test _b[2.al_vig_name#1.al_vig_appointment]=_b[2.al_vig_name#2.al_vig_appointment]
		
	graph export $plot\IA_app_name_prm.png, replace
	graph save $plot\IA_app_name_prm.gph, replace
	
********************************************************************************

*Graph combine

graph combine 	$plot\IA_mot_name_prm.gph ///
				$plot\IA_app_name_prm.gph ///
				, row(1) altshrink graphregion(color(white))
				
	graph export $plot\IA_name_appmot_prm.png, replace
	graph export $plot\IA_name_appmot_prm.pdf, replace
			
********************************************************************************		
			
*I10: Interaction Age * Children

mi est, vartable ufmitest saving($pdta\Final\WSI_estI10.ster, replace) post: ///
	svy: reg al_sanction i.al_vig_reason i.al_vig_name ib(2).al_vig_age##i.al_vig_children ib(2).al_vig_motivation i.al_vig_appointment ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store I10
			
*I11: Interaction Age * Motivation

mi est, vartable ufmitest saving($pdta\Final\WSI_estI11.ster, replace) post: ///
	svy: reg al_sanction i.al_vig_reason i.al_vig_name ib(2).al_vig_age##ib(2).al_vig_motivation i.al_vig_children i.al_vig_appointment ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store I11
			
*I12: Interaction Age * Appointment

mi est, vartable ufmitest saving($pdta\Final\WSI_estI12.ster, replace) post: ///
	svy: reg al_sanction i.al_vig_reason i.al_vig_name ib(2).al_vig_age##i.al_vig_appointment i.al_vig_children ib(2).al_vig_motivation ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store I12
			
********************************************************************************

*I13: Interaction Children * Motivation

mi est, vartable ufmitest saving($pdta\Final\WSI_estI13.ster, replace) post: ///
	svy: reg al_sanction i.al_vig_reason i.al_vig_name ib(2).al_vig_age i.al_vig_children##ib(2).al_vig_motivation i.al_vig_appointment ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store I13
			
*I14: Interaction Children * Appointment

mi est, vartable ufmitest saving($pdta\Final\WSI_estI14.ster, replace) post: ///
	svy: reg al_sanction i.al_vig_reason i.al_vig_name ib(2).al_vig_age i.al_vig_children##i.al_vig_appointment ib(2).al_vig_motivation ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store I14
			
********************************************************************************

*I15: Interaction Motivation * Appointment

mi est, vartable ufmitest saving($pdta\Final\WSI_estI15.ster, replace) post: ///
	svy: reg al_sanction i.al_vig_reason i.al_vig_name ib(2).al_vig_age i.al_vig_children ib(2).al_vig_motivation##i.al_vig_appointment  ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store I15

********************************************************************************

/*
				
esttab I0 I6 I7 I8 I9 I10 I11 I12 I13 I14 I15 ///
	using $output\Final\Unemployment\Vig_WSI_IA_VigXVig.rtf, replace label se obslast aic bic ///
	nonumbers mti("W/o IA" "IA: Nam*Age" "IA: Nam*Chi" "IA: Nam*Mot" "IA: Nam*App" "IA: Age*Chi" "IA: Age*Mot" "IA: Age*App" "IA: Chi*Mot" "IA: Chi*App" "IA: Mot*App") ///
	addnote("Anmerkung: Erster Eintrag: Koeffizient. Zweiter Eintrag: Standardfehler, zweiseitig.") ///
	varwidth(20) brackets nogaps nobaselevels compress b(3) equations(1) interaction(" X ")	
	
*/

********************************************************************************
****					9. Final regression models							****
********************************************************************************

*T1: Sanctioning Dummy (0/1) coded

mi est, vartable ufmitest saving($pdta\Final\WSI_estF1.ster, replace) post: ///
	svy: reg al_sanction_d i.al_vig_reason i.al_vig_name ib(2).al_vig_age i.al_vig_children ib(2).al_vig_motivation i.al_vig_appointment ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store F1

*T2: Complete model

mi est, vartable ufmitest saving($pdta\Final\WSI_estF2.ster, replace) post: ///
	svy: reg al_sanction i.al_vig_reason i.al_vig_name ib(2).al_vig_age i.al_vig_children ib(2).al_vig_motivation i.al_vig_appointment ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store F2		
			
*T3: Deviations from Comparison vignette (Deck Nr. 252 = Z/B/40/H/Vk/1)

sum mean_sanction_deck if deck == 252
gen mean_sanction_deck_252 = r(mean)
gen mean_sanction_com = mean_sanction_deck - mean_sanction_deck_252

mi est, vartable ufmitest saving($pdta\Final\WSI_estF3.ster, replace) post: ///
	svy: reg mean_sanction_com i.al_vig_reason i.al_vig_name ib(2).al_vig_age i.al_vig_children ib(2).al_vig_motivation i.al_vig_appointment ///
		i.r_gender ib(1).r_educ i.r_ost ib(1).r_age_cat_vig ///
		i.r_mig i.r_famstat i.r_emplstat ///
		ib(1).r_inc i.r_unempl i.r_party r_left_right r_health
			est store F3		

/*
			
esttab F1 F2 I8 I9 ///
	using $output\Final\Unemployment\Vig_WSI\Final.rtf, replace label se obslast aic bic ///
	nonumbers mti("Sanctioning 0/1 coded" "Full model" "IA: Name x Motivation" "IA: Name x Appointment") ///
	addnote("Anmerkung: Erster Eintrag: Koeffizient. Zweiter Eintrag: Standardfehler, zweiseitig.") ///
	varwidth(20) brackets nogaps nobaselevels compress b(3) equations(1) interaction(" X ")
	
*/
			
********************************************************************************
****					10. Graphing estimation results						****
********************************************************************************

*Sanctions

coefplot	(T1, keep (*.al_vig_name *.al_vig_age *.al_vig_reason *. al_vig_children *.al_vig_motivation *.al_vig_appointment) ///
						base xline(0) ylabel(, angle(0))) || ///
			(T2, keep (*.al_vig_name *.al_vig_age *.al_vig_reason *. al_vig_children *.al_vig_motivation *.al_vig_appointment) ///
						base xline(0) ylabel(, angle(0))), ///
						byopts(row(1))  ///
					xlabel(, angle(0) labsize(small)) ///
					recast(bar) cirecast(rcap) citop ///
					barwidth(0.5) fcolor(*.5)  ///
					order(1.al_vig_reason 2.al_vig_reason 3.al_vig_reason 4.al_vig_reason *.al_vig_name *.al_vig_age *.al_vig_children 2.al_vig_motivation 1.al_vig_motivation) ///
					grid(none) ///
					coeflabels(, labsize(3) notick labgap(-1)) ///
					headings (2.al_vig_reason = "{bf:Begründung}" ///
								1.al_vig_name = "{bf:Name}" ///
								1.al_vig_age = "{bf:Alter}" ///
								1.al_vig_children = "{bf:Familienstatus}" ///
								2.al_vig_motivation = "{bf:Motivation}" ///
								1.al_vig_appointment = "{bf:Verpasste Termine}" ///
								, labcolor(black)) ///
					name(al_alg1_sanction, replace)
					
graph export $plot\coefplot_1.png, replace

********************************************************************************

coefplot	(T3, keep (*.al_vig_name *.al_vig_age *.al_vig_reason *. al_vig_children *.al_vig_motivation *.al_vig_appointment) ///
						base xline(0) ylabel(, angle(0)) rescale(100)) || ///
			(T4, keep (*.al_vig_name *.al_vig_age *.al_vig_reason *. al_vig_children *.al_vig_motivation *.al_vig_appointment) ///
						base xline(0) ylabel(, angle(0))), ///
						byopts(row(1)) subtitle("", size(small)) ///
					xlabel(, angle(0) labsize(small)) ///
					recast(bar) cirecast(rcap) citop ///
					barwidth(0.5) fcolor(*.5)  ///
					order(1.al_vig_reason 2.al_vig_reason 3.al_vig_reason 4.al_vig_reason *.al_vig_name *.al_vig_age *.al_vig_children 2.al_vig_motivation 1.al_vig_motivation) ///
					grid(none) ///
					coeflabels(, labsize(3) notick labgap(-1)) ///
					headings (2.al_vig_reason = "{bf:Begründung}" ///
								1.al_vig_name = "{bf:Name}" ///
								1.al_vig_age = "{bf:Alter}" ///
								1.al_vig_children = "{bf:Familienstatus}" ///
								2.al_vig_motivation = "{bf:Motivation}" ///
								1.al_vig_appointment = "{bf:Verpasste Termine}" ///
								, labcolor(black)) ///
					name(al_alg1_sanction, replace)
					
graph export $plot\coefplot_2.png, replace

********************************************************************************
****						11. Clean up & Save								****
********************************************************************************

erase $plot\IA_mot_name_prm.gph
erase $plot\IA_app_name_prm.gph
erase $plot\age.gph
erase $plot\rea.gph
erase $plot\chi.gph

erase $pdta\Final\WSI_estI0.ster
erase $pdta\Final\WSI_estI1.ster
erase $pdta\Final\WSI_estI2.ster
erase $pdta\Final\WSI_estI3.ster
erase $pdta\Final\WSI_estI4.ster
erase $pdta\Final\WSI_estI5.ster
erase $pdta\Final\WSI_estI6.ster
erase $pdta\Final\WSI_estI7.ster
erase $pdta\Final\WSI_estI8.ster
erase $pdta\Final\WSI_estI9.ster
erase $pdta\Final\WSI_estI10.ster
erase $pdta\Final\WSI_estI11.ster
erase $pdta\Final\WSI_estI12.ster
erase $pdta\Final\WSI_estI13.ster
erase $pdta\Final\WSI_estI14.ster
erase $pdta\Final\WSI_estI15.ster

erase $pdta\Final\WSI_estF1.ster
erase $pdta\Final\WSI_estF2.ster
erase $pdta\Final\WSI_estF3.ster

compress
lab data "MEPYSO Factorial survey data - WSI Sanctions"
save $pdta\final-wsi-sanctions.dta, replace

********************************************************************************