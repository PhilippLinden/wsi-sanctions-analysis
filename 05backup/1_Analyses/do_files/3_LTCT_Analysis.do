/*******************************************************************************

File name: 		3_LTCT_Analysis.do
Task:			Cluster Analysis - Analysis
Project:		Long-term-care Typology
Version:		Stata 15
Author:			Philipp Linden/Mareike Ariaans
Last update:	2019-06-01

********************************************************************************

Content:
# 1. Describe data
# 2. Variable transformation

*******************************************************************************/

clear all
use "$data\LTCT_Prep.dta"

********************************************************************************
****							1. Describe data							****
********************************************************************************	

order id country ///
		LTC_he LTC_beds LTC_inst ///
		priv_he cash_avail ///
		life_exp perc_he ///
		home_care inst_care cash_vs_inkind ///
		means_any

desc

*Tabulate vars in Dimensional order

tab1 LTC_he LTC_beds LTC_inst ///
		priv_he cash_avail ///
		life_exp perc_he ///
		home_care inst_care cash_vs_inkind ///
		means_any		
		  
*Descriptive tables

*Metric

vardesc LTC_he priv_he LTC_inst LTC_beds life_exp perc_he, optimize

*Categorical		
		
tab1 cash_avail home_care inst_care cash_vs_inkind means_any

********************************************************************************
****					2. Variable transformation							****
********************************************************************************		
	
*Varibles colinear? VIF?

collin 	LTC_he LTC_beds LTC_inst ///
		priv_he cash_avail ///
		life_exp perc_he ///
		home_care inst_care cash_vs_inkind ///
		means_any
/*

  Collinearity Diagnostics

                        SQRT                   R-
  Variable      VIF     VIF    Tolerance    Squared
----------------------------------------------------
    LTC_he      4.11    2.03    0.2431      0.7569
  LTC_beds      7.35    2.71    0.1360      0.8640
  LTC_inst      4.25    2.06    0.2350      0.7650
   priv_he      1.34    1.16    0.7473      0.2527
cash_avail      3.50    1.87    0.2857      0.7143
  life_exp      1.76    1.33    0.5676      0.4324
   perc_he      1.93    1.39    0.5190      0.4810
 home_care      1.86    1.36    0.5382      0.4618
 inst_care      1.95    1.40    0.5126      0.4874
cash_vs_inkind      4.01    2.00    0.2492      0.7508
 means_any      2.57    1.60    0.3885      0.6115
----------------------------------------------------
  Mean VIF      3.15

Result: No high collinearity in variables, transformation not necces
*/	

********************************************************************************
****						3. Building indices								****
********************************************************************************	

*I: Building choice index

gen choice_index = home_care + inst_care + cash_vs_inkind
tab choice_index

*Ib) Turnaround of public-private Mix and choice index

global output	"C:\Users\Anima\sciebo\LTCT_Mareike_Ariaans\1_Analyses\output\alternate"
global graphs	"C:\Users\Anima\sciebo\LTCT_Mareike_Ariaans\1_Analyses\graphs_tables\alternate"	

replace priv_he = 100-priv_he
	
*II: Standardization

*a) by Range (Ranges are more similar)

foreach var of varlist ///
		LTC_he LTC_beds LTC_inst ///
		priv_he cash_avail ///
		life_exp perc_he ///
		choice_index ///
		means_any {
	
		sum `var', meanonly
		gen zr_`var' = (`var' / (r(max) - r(min)))
		lab var zr_`var' "`var' (Range-std.)"
}

*0,1 scaling (differing means/deviations but equal ranges)

foreach var of varlist ///
		LTC_he LTC_beds LTC_inst ///
		priv_he cash_avail ///
		life_exp perc_he ///
		choice_index ///
		means_any {
	
		sum `var'
		gen s_`var' = (`var' - `r(min)') / (`r(max)'-`r(min)')
		lab var s_`var' "`var' (0,1 scaled.)"
}

*z-Scores (Mean = 0, Std.dev. = 1 but different ranges)

foreach var of varlist ///
		LTC_he LTC_beds LTC_inst ///
		priv_he cash_avail ///
		life_exp perc_he ///
		choice_index ///
		means_any {
	
		sum `var'
		egen z_`var' = std(`var')
		lab var z_`var' "`var' (z-std.)"
}

*log transformation

foreach var of varlist ///
		LTC_he LTC_beds LTC_inst ///
		priv_he cash_avail ///
		life_exp perc_he ///
		choice_index ///
		means_any {
	
		gen l_`var' = ln(`var'+1)
		lab var l_`var' "`var' (Log.)"
}

eststo sumstats: estpost summarize ///
		LTC_he LTC_beds LTC_inst ///
		priv_he cash_avail ///
		life_exp perc_he ///
		zr_choice_index ///
		means_any
	esttab sumstats using "$graphs\20200506_LTCT_PL_Descriptive_Statistics.rtf", replace cell("mean sd min max") mtitle("Descriptives") label

********************************************************************************
****						4. Factor Analysis								****
********************************************************************************

factor 	LTC_he LTC_beds LTC_inst ///
		priv_he cash_avail ///
		life_exp perc_he ///
		choice_index ///
		means_any 
		
estat kmo		

	rotate, oblique oblimin blanks(.5)

********************************************************************************

save "$data\LTCT_aux.dta", replace

********************************************************************************

********************************************************************************
****							5. Clustering								****
********************************************************************************

clear all
use "$data\LTCT_aux.dta", replace

********************************************************************************

********************************************************************************
****					5.1: Hierarchical -> 8 Models						****
********************************************************************************

/*
Distinct clustering is characterized by large Calinski–Harabasz pseudo-F values, large Duda–Hart
Je(2)/Je(1) values, and small Duda–Hart pseudo-T-squared values.

The conventional wisdom for deciding the number of groups based on the Duda–Hart stopping-rule
table is to find one of the largest Je(2)/Je(1) values that corresponds to a low pseudo-T-squared value
that has much larger T-squared values next to it. This strategy, combined with the results from
the Calinski–Harabasz results, indicates that the ???-group solution is the most distinct from this ´
hierarchical cluster analysis.
*/

********************************************************************************

*M1: Standardization: Range / Measure: Gower / Linkage: Average / Type: Hierarchical

cluster averagelinkage ///
		zr_LTC_he zr_LTC_beds zr_LTC_inst ///
		zr_priv_he zr_cash_avail ///
		zr_life_exp zr_perc_he ///
		zr_choice_index ///
		zr_means_any, measure (Gower)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M1_a = groups(4)
tab country M1_a,m
cluster generate M1_b = groups(7)
tab country M1_b,m

********************************************************************************

*M2: Standardization: z-Values / Measure: Gower / Linkage: Average / Type: Hierarchical

cluster averagelinkage ///
		z_LTC_he z_LTC_beds z_LTC_inst ///
		z_priv_he z_cash_avail ///
		z_life_exp z_perc_he ///
		z_choice_index ///
		z_means_any, measure (Gower)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M2_a = groups(4)
tab country M2_a,m
cluster generate M2_b = groups(7)
tab country M2_b,m

********************************************************************************

*M3: Standardization: Range / Measure: Euclidian / Linkage: Average / Type: Hierarchical

cluster averagelinkage ///
		zr_LTC_he zr_LTC_beds zr_LTC_inst ///
		zr_priv_he zr_cash_avail ///
		zr_life_exp zr_perc_he ///
		zr_choice_index ///
		zr_means_any, measure (L2squared)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M3_a = groups(2)
tab country M3_a,m
cluster generate M3_b = groups(6)
tab country M3_b,m

********************************************************************************

*M4: Standardization: z-Values / Measure: Euclidian / Linkage: Average / Type: Hierarchical

cluster averagelinkage ///
		z_LTC_he z_LTC_beds z_LTC_inst ///
		z_priv_he z_cash_avail ///
		z_life_exp z_perc_he ///
		z_choice_index ///
		z_means_any, measure (L2squared)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M4_a = groups(4)
tab country M4_a,m
cluster generate M4_b = groups(6)
tab country M4_b,m

********************************************************************************

*M5: Standardization: Range / Measure: Gower / Linkage: Ward / Type: Hierarchical

cluster wardslinkage ///
		zr_LTC_he zr_LTC_beds zr_LTC_inst ///
		zr_priv_he zr_cash_avail ///
		zr_life_exp zr_perc_he ///
		zr_choice_index ///
		zr_means_any, measure (Gower)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M5_a = groups(2)
tab country M5_a,m
cluster generate M5_b = groups(4)
tab country M5_b,m

********************************************************************************

*M6: Standardization: z-Values / Measure: Gower / Linkage: Ward / Type: Hierarchical

cluster wardslinkage ///
		z_LTC_he z_LTC_beds z_LTC_inst ///
		z_priv_he z_cash_avail ///
		z_life_exp z_perc_he ///
		z_choice_index ///
		z_means_any, measure (Gower)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M6_a = groups(2)
tab country M6_a,m
cluster generate M6_b = groups(4)
tab country M6_b,m

********************************************************************************

*M7: Standardization: Range / Measure: Euclidian / Linkage: Ward / Type: Hierarchical

cluster wardslinkage ///
		zr_LTC_he zr_LTC_beds zr_LTC_inst ///
		zr_priv_he zr_cash_avail ///
		zr_life_exp zr_perc_he ///
		zr_choice_index ///
		zr_means_any, measure (L2squared)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M7_a = groups(2)
tab country M7_a,m
cluster generate M7_b = groups(4)
tab country M7_b,m

********************************************************************************

*M8: Standardization: z-Values / Measure: Euclidian / Linkage: Ward / Type: Hierarchical

cluster wardslinkage ///
		z_LTC_he z_LTC_beds z_LTC_inst ///
		z_priv_he z_cash_avail ///
		z_life_exp z_perc_he ///
		z_choice_index ///
		z_means_any, measure (L2squared)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M8_a = groups(4)
tab country M8_a,m
cluster generate M8_b = groups(6)
tab country M8_b,m

********************************************************************************

save "$data\LTCT_aux_single.dta", replace

********************************************************************************

********************************************************************************	
****			5.2: K-Means -> No Linkage possible, 4 Models				****
********************************************************************************

/*
From Makles 2012: Stata tip 110: How to get the optimal k-means cluster solution

The k-means cluster algorithm is a well-known partitional clustering method but is
also widely used as an iterative or exploratory clustering method within unsupervised
learning procedures (Hastie, Tibshirani, and Friedman 2009, chap. 14). 
When the number of clusters is unknown, several k-means solutions with different numbers of groups k
(k = 1,...,K) are computed and compared. To detect the clustering with the optimal
number of groups k from the set of K solutions, we typically use a scree plot and search
for a kink in the curve generated from the within sum of squares (WSS) or its logarithm
[log(WSS)] for all cluster solutions. Another criterion for detecting the optimal number
of clusters is the η2 coefficient, which is quite similar to the R2, or the proportional
reduction of error (PRE) coefficient (Schwarz 2008, 72):
*/

********************************************************************************

clear all
use "$data\LTCT_aux.dta"

*M9: Standardization: Range / Measure: Gower / Type: K-Means

local list1 "zr_LTC_he zr_LTC_beds zr_LTC_inst zr_priv_he zr_cash_avail zr_life_exp zr_perc_he zr_choice_index zr_means_any"

forvalues i = 1(1)15 {
cluster kmeans `list1', measure (Gower) k(`i') start(random(123)) name(M9_`i')
cluster stop
}

*WSS matrix
matrix WSS = J(15,5,.)
matrix colnames WSS = i WSS log(WSS) eta-squared PRE

*WSS for each clustering
forvalues i = 1(1)15 {
scalar ws`i' = 0
foreach v of varlist `list1' {
quietly anova `v' M9_`i'
scalar ws`i' = ws`i'+e(rss)
}
matrix WSS[`i', 1] = `i'
matrix WSS[`i', 2] = ws`i'
matrix WSS[`i', 3] = log(ws`i')
matrix WSS[`i', 4] = 1 - (ws`i'/ WSS[1,2])
matrix WSS[`i', 5] = (WSS[`i'-1,2] - (ws`i'/ WSS[`i'-1,2]))
}

matrix list WSS

_matplot WSS, columns(2 1) connect(l) xlabel(#10) name(plot1, replace) noname nodraw
_matplot WSS, columns(3 1) connect(l) xlabel(#10) name(plot2, replace) noname nodraw
_matplot WSS, columns(4 1) connect(l) xlabel(#10) name(plot3, replace) noname nodraw
_matplot WSS, columns(5 1) connect(l) xlabel(#10) name(plot4, replace) noname nodraw

graph combine plot1 plot2 plot3 plot4, title("Standardization: Range, Measure: Gower")
graph export "$graphs\screeplots_R_G.tif", replace

save "$data\LTCT_aux_k_9.dta", replace

*Result: 5, 7

********************************************************************************

clear all
use "$data\LTCT_aux.dta"

*M10: Standardization: z-Values / Measure: Gower / Type: K-Means

local list1 "z_LTC_he z_LTC_beds z_LTC_inst z_priv_he z_cash_avail z_life_exp z_perc_he z_choice_index z_means_any"

forvalues i = 1(1)15 {
cluster kmeans `list1', measure (Gower) k(`i') start(random(123)) name(M10_`i')
cluster stop
}

*WSS matrix
matrix WSS = J(15,5,.)
matrix colnames WSS = i WSS log(WSS) eta-squared PRE

*WSS for each clustering
forvalues i = 1(1)15 {
scalar ws`i' = 0
foreach v of varlist `list1' {
quietly anova `v' M10_`i'
scalar ws`i' = ws`i'+e(rss)
}
matrix WSS[`i', 1] = `i'
matrix WSS[`i', 2] = ws`i'
matrix WSS[`i', 3] = log(ws`i')
matrix WSS[`i', 4] = 1 - (ws`i'/ WSS[1,2])
matrix WSS[`i', 5] = (WSS[`i'-1,2] - (ws`i'/ WSS[`i'-1,2]))
}

matrix list WSS

_matplot WSS, columns(2 1) connect(l) xlabel(#10) name(plot1, replace) noname nodraw
_matplot WSS, columns(3 1) connect(l) xlabel(#10) name(plot2, replace) noname nodraw
_matplot WSS, columns(4 1) connect(l) xlabel(#10) name(plot3, replace) noname nodraw
_matplot WSS, columns(5 1) connect(l) xlabel(#10) name(plot4, replace) noname nodraw

graph combine plot1 plot2 plot3 plot4, title("Standardization: z-Values, Measure: Gower")
graph export "$graphs\screeplots_Z_G.tif", replace

save "$data\LTCT_aux_k_10.dta", replace

*Result: 2, 4

********************************************************************************

clear all
use "$data\LTCT_aux.dta"

*M11: Standardization: Range / Measure: Euclidian / Type: K-Means

local list1 "zr_LTC_he zr_LTC_beds zr_LTC_inst zr_priv_he zr_cash_avail zr_life_exp zr_perc_he zr_choice_index zr_means_any"

forvalues i = 1(1)15 {
cluster kmeans `list1', measure (L2squared) k(`i') start(random(123)) name(M11_`i')
cluster stop
}

*WSS matrix
matrix WSS = J(15,5,.)
matrix colnames WSS = i WSS log(WSS) eta-squared PRE

*WSS for each clustering
forvalues i = 1(1)15 {
scalar ws`i' = 0
foreach v of varlist `list1' {
quietly anova `v' M11_`i'
scalar ws`i' = ws`i'+e(rss)
}
matrix WSS[`i', 1] = `i'
matrix WSS[`i', 2] = ws`i'
matrix WSS[`i', 3] = log(ws`i')
matrix WSS[`i', 4] = 1 - ((ws`i')/WSS[1,2])
matrix WSS[`i', 5] = (WSS[`i'-1,2] - ((ws`i')/WSS[`i'-1,2]))
}

matrix list WSS

_matplot WSS, columns(2 1) connect(l) xlabel(#10) name(plot1, replace) noname nodraw
_matplot WSS, columns(3 1) connect(l) xlabel(#10) name(plot2, replace) noname nodraw
_matplot WSS, columns(4 1) connect(l) xlabel(#10) name(plot3, replace) noname nodraw
_matplot WSS, columns(5 1) connect(l) xlabel(#10) name(plot4, replace) noname nodraw

graph combine plot1 plot2 plot3 plot4, title("Standardization: Range, Measure: Euclidian^2")
graph export "$graphs\screeplots_R_E2.tif", replace

save "$data\LTCT_aux_k_11.dta", replace

*Result: 2, 4

********************************************************************************

clear all
use "$data\LTCT_aux.dta"

*M12: Standardization: z-Values / Measure: Euclidian / Type: K-Means

local list1 "z_LTC_he z_LTC_beds z_LTC_inst z_priv_he z_cash_avail z_life_exp z_perc_he z_choice_index z_means_any"

forvalues i = 1(1)15 {
cluster kmeans `list1', measure (L2squared) k(`i') start(random(123)) name(M12_`i')
cluster stop
}

*WSS matrix
matrix WSS = J(15,5,.)
matrix colnames WSS = i WSS log(WSS) eta-squared PRE

*WSS for each clustering
forvalues i = 1(1)15 {
scalar ws`i' = 0
foreach v of varlist `list1' {
quietly anova `v' M12_`i'
scalar ws`i' = ws`i'+e(rss)
}
matrix WSS[`i', 1] = `i'
matrix WSS[`i', 2] = ws`i'
matrix WSS[`i', 3] = log(ws`i')
matrix WSS[`i', 4] = 1 - (ws`i'/ WSS[1,2])
matrix WSS[`i', 5] = (WSS[`i'-1,2] - (ws`i'/ WSS[`i'-1,2]))
}

matrix list WSS

_matplot WSS, columns(2 1) connect(l) xlabel(#10) name(plot1, replace) noname nodraw
_matplot WSS, columns(3 1) connect(l) xlabel(#10) name(plot2, replace) noname nodraw
_matplot WSS, columns(4 1) connect(l) xlabel(#10) name(plot3, replace) noname nodraw
_matplot WSS, columns(5 1) connect(l) xlabel(#10) name(plot4, replace) noname nodraw

graph combine plot1 plot2 plot3 plot4, title("Standardization: z-Values, Measure: Euclidian^2")
graph export "$graphs\screeplots_Z_E2.tif", replace

save "$data\LTCT_aux_k_12.dta", replace

*Result: 3, 6

********************************************************************************
****						5.3 Merge & Clean Up								****
********************************************************************************

***Merge of single datasets

clear all
use "$data\LTCT_aux_single.dta"
	merge 1:1 id using "$data\LTCT_aux_k_9.dta"
		drop _merge
	merge 1:1 id using "$data\LTCT_aux_k_10.dta"
		drop _merge
	merge 1:1 id using "$data\LTCT_aux_k_11.dta"
		drop _merge
	merge 1:1 id using "$data\LTCT_aux_k_12.dta"
		drop _merge

********************************************************************************		
		
*Clean up

compress
save "$data\LTCT_Final.dta", replace
lab data "Long-term-care Typology_Final"
		
erase "$data\LTCT_aux_k_9.dta"
erase "$data\LTCT_aux_k_10.dta"
erase "$data\LTCT_aux_k_11.dta"
erase "$data\LTCT_aux_k_12.dta"
erase "$data\LTCT_aux_single.dta"

********************************************************************************
****							6. Analysis									****
********************************************************************************

clear all
use "$data\LTCT_Final.dta"

********************************************************************************
****			6.1. Distributions with clusters Analysis					****
********************************************************************************

*Log of clusters to export in excel

log using "$output\20200507_LTCT_PL_Cluster_Country.log", replace

foreach var of varlist M* {

	tab country `var'
}

tab country M9_5
tab country M9_7
tab country M10_2
tab country M10_4
tab country M11_2
tab country M11_4
tab country M12_3
tab country M12_6

log close

********************************************************************************
****						6.2. Denodrogramms								****
********************************************************************************

set scheme s1mono, perm

decode id, gen(id_leaf)

********************************************************************************

cluster dend _clus_1, lab(id_leaf) ///
	xlabel(, angle(90)) title("Standardization: Range, Measure: Gower, Linkage: Average", size(medsmall)) name("Dendrogramm_R_G_A", replace)
	
	graph export "$graphs\01_Dendrogramm_R_G_A.tif", replace	

cluster dend _clus_2, lab(id_leaf) ///
	xlabel(, angle(90)) title("Standardization: z-Values, Measure: Gower, Linkage: Average", size(medsmall)) name("Dendrogramm_Z_G_A", replace)
	
	graph export "$graphs\02_Dendrogramm_Z_G_A.tif", replace
	
cluster dend _clus_3, lab(id_leaf) ///
	xlabel(, angle(90)) title("Standardization: Range, Measure: Euclidian^2, Linkage: Average", size(medsmall)) name("Dendrogramm_R_E2_A", replace)
	
	graph export "$graphs\03_Dendrogramm_R_E2_A.tif", replace	

cluster dend _clus_4, lab(id_leaf) ///
	xlabel(, angle(90)) title("Standardization: z-Values, Measure: Euclidian^2, Linkage: Average", size(medsmall)) name("Dendrogramm_Z_E2_A", replace)
	
	graph export "$graphs\04_Dendrogramm_Z_E2_A.tif", replace
	
cluster dend _clus_5, lab(id_leaf) ///
	xlabel(, angle(90)) title("Standardization: Range, Measure: Gower, Linkage: Ward", size(medsmall)) name("Dendrogramm_R_G_W", replace)
	
	graph export "$graphs\05_Dendrogramm_R_G_W.tif", replace	

cluster dend _clus_6, lab(id_leaf) ///
	xlabel(, angle(90)) title("Standardization: z-Values, Measure: Gower, Linkage: Ward", size(medsmall)) name("Dendrogramm_Z_G_W", replace)
	
	graph export "$graphs\06_Dendrogramm_Z_G_W.tif", replace
	
cluster dend _clus_7, lab(id_leaf) ///
	xlabel(, angle(90)) title("Standardization: Range, Measure: Euclidian^2, Linkage: Ward", size(medsmall)) name("Dendrogramm_R_E2_W", replace)
	
	graph export "$graphs\07_Dendrogramm_R_E2_W.tif", replace	

cluster dend _clus_8, lab(id_leaf) ///
	xlabel(, angle(90)) title("Standardization: z-Values, Measure: Euclidian^2, Linkage: Ward", size(medsmall)) name("Dendrogramm_Z_E2_W", replace)
	
	graph export "$graphs\08_Dendrogramm_Z_E2_W.tif", replace
	
********************************************************************************
****						6.2. Mean tables								****
********************************************************************************

************************************
*****	Descriptive Table		****
************************************

tabstat LTC_he LTC_beds LTC_inst priv_he life_exp perc_he cash_avail home_care inst_care cash_vs_inkind choice_index means_any, stats(mean sd min max)

************************************
*****	Without clustering		****
************************************

tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any, by(id)

********************************************************
****	With 9 clusters (methodological solution)	****
********************************************************

*CL1

tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if id == 1 | id == 2 | id == 14 | id == 15 | id == 23, by(id)
	
*CL2
		
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if  id == 3 | id == 13 | id == 18, by(id)
	
*CL3	
	
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if  id == 4 | id == 9 | id == 17 | id == 22, by(id)
	
*CL4	
	
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if  id == 5, by(id)

*CL5	
	
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///	
		if  id == 6 | id == 8, by(id)
	
*CL6

tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if id == 7 | id == 10 | id == 21 | id == 24 | id == 25, by(id)

*CL7
		
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if  id == 11 | id == 12, by(id)

*CL8	
	
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if  id == 16, by(id)

*CL9	
	
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if id == 19 | id == 20, by(id)
		
****************************************************		
****	With 8 clusters (Without SK, SE)		****
****************************************************

*CL1

tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if 	id == 1 | id == 2 | id == 14 | id == 15 | id == 19 | id == 20 | id == 23, by(id) 

*CL2
		
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if  id == 3 | id == 13 | id == 18, by(id)

*CL3	
	
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if  id == 4 | id == 9 | id == 17 | id == 22, by(id)

*CL4	
	
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if  id == 5, by(id)

*CL5	
	
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///	
		if  id == 6 | id == 8, by(id)
	
*CL6

tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if id == 7 | id == 10 | id == 21 | id == 24 | id == 25, by(id) 

*CL7
		
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if  id == 11 | id == 12, by(id)

*CL8	
	
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if id == 19 | id == 20, by(id)		
		
********************************************************
****	With 5 clusters (theory-based solution)		****
********************************************************

*CL1

tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if 	id == 1 | id == 2 | id == 7 | id == 10 | id == 14 | id == 15 | id == 16 | ///
			id == 21 | id == 23 | id == 24 | id == 25, by(id)

*CL2
		
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if id == 3 | id == 13 | id == 18, by(id)

*CL3	
	
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if id == 4 | id == 9 | id == 11 | id == 12 | id == 17 | id == 22, by(id)

*CL4	
	
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if id == 5, by(id)

*CL5	
	
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///	
		if id == 6 | id == 8, by(id)
		
****************************************************************************************
****	With 6+2 clusters (4 Base + Split of 2 in 2 subclusters - graphic solution	****
****************************************************************************************

*CL1

tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if id == 3 | id == 13 | id == 18, by(id)

*CL2
		
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///	
		if id == 6 | id == 8, by(id)

*CL3	
	
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if id == 4 | id == 9 | id == 11 | id == 12 | id == 17 | id == 22, by(id)

*CL3a	(Core)
	
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if id == 4 | id == 9 | id == 17 | id == 22, by(id)

*CL3b (Peripheral)	
	
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///	
		if id == 11 | id == 12, by(id)
		
*CL4	

tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if 	id == 1 | id == 2 | id == 5 | id == 7 | id == 10 | id == 14 | id == 15 | id == 16 | ///
			id == 19 | id == 20 | id == 21 | id == 23 | id == 24 | id == 25, by(id)
		
*CL4a	(Upper + SK/SI)
	
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///
		if 	id == 1 | id == 2 | id == 14| id == 15 | id == 19 | id == 20 | id == 23, by(id)
		
*CL4b	(Lower + EE/NZ)
	
tabstat LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he choice_index means_any ///	
		if 	id == 5 | id == 7 | id == 10 | id == 16 | id == 21 | id == 24 | id == 25, by(id)			

********************************************************************************

*A simple scatterplot of expenditures * Life expectancy

scatter LTC_he life_exp, msymbol(circle_hollow) mlabel(id) || lfit LTC_he life_exp, ///
		ytitle("LTC expenditure (health) per capita" "in US$ of purchasing power parities", size(medium) margin(medium)) ///
		xtitle("Life expectancy of people 65+", margin(medium))
		
********************************************************************************







********************************************************************************


