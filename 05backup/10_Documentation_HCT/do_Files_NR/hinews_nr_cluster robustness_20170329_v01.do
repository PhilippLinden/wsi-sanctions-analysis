/*==============================================================================
File name:    hinews_nr_cluster_ana_20170327.do
Task:         Conducts cluster analysis                                                   
Project:      Health system typology
Author(s):    Nadine Reibling, Mareike Ariaans                                            
Last update:  2017-03-27                                                                             
==============================================================================*/

/*------------------------------------------------------------------------------ 
Content:

#1 Load data
#2 Hierarchical cluster analysis (Wards)
#3 Hierarchical cluster analysis (Average)
#4 Hierarchical cluster analysis (Complete)
#5 K-Means cluster analysis

------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------
Notes:

------------------------------------------------------------------------------*/

version 13.1   // Stata version control

/*------------------------------------------------------------------------------
#1 Load data
------------------------------------------------------------------------------*/

clear

cd "C:\Users\Reibling\Documents\A01_current_projects\2015_HINEWS\2015_healthtyp\10_Data"

sysuse hinews_nr_cluster_rec.dta

cd "C:\Users\Reibling\Documents\A01_current_projects\2015_HINEWS\2015_healthtyp\2_Results"


**Test 1: Alle Indikatoren mit Gower
local list1 "zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol access_d1 access_d2 access_d3 access_d4 costshare_d1 costshare_d2 costshare_d3 choice bb_poslist quality_sum"
local list3 "zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol quality_sum"
local list5 "access_d1 access_d2 access_d3 access_d4 costshare_d1 costshare_d2 costshare_d3 choice bb_poslist rem_sp"
local list7 "zexp_hc_cap zprof_gp zexp_gov_share"
local list9 "costshare_d1 costshare_d2 costshare_d3 choice bb_poslist"
local list11 "zexp_hc_cap zprof_gp choice bb_poslist"
local list13 "zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol quality_sum"
local list15 "zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol quality_sum choice bb_poslist rem_sp"
local list17 "zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol access_sum  costshare_d2 costshare_d3 choice quality_sum"
local list19 "zexp_hc_cap zexp_gov_share rem_sp zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol access_sum  costshare_d2 costshare_d3 choice quality_sum"
local list21 "zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol access_sum  choice quality_sum"
local list23 "zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol access_sum  choice costsharesect quality_sum"
local list25 "zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol access_sum  choice costshare_gp quality_sum"
local list27 "zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol access_sum  choice costshare_gp primary_asthma_hosp acute_30_infarc"
local list29 "zexp_hc_cap  zexp_oop_share rem_sp  zgpsprat zprev_tobacco zprev_alcohol access_sum  costshare_gp quality_sum"
local list29 " zprof_gp zexp_gov_share zexp_oop_share rem_sp zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol access_sum  choice costsharesect quality_sum"
local list29 "zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol access_sum  choice quality_sum costshare_gp bb_poslist"


forvalues i = 1(1)20 {
cluster kmeans `list29', measure (Gower) k(`i') start(random(123)) name(cs`i')
cluster stop

}

*WSS matrix
matrix WSS = J(20,5,.)
matrix colnames WSS = i WSS log(WSS) eta-squared PRE

*WSS for each clustering
forvalues i = 1(1)20 {
scalar ws`i' = 0
foreach v of varlist `list29' {
quietly anova `v' cs`i'
scalar ws`i' = ws`i'+e(rss)
}
matrix WSS[`i', 1] = `i'
matrix WSS[`i', 2] = ws`i'
matrix WSS[`i', 3] = log(ws`i')
matrix WSS[`i', 4] = 1 - ws`i'/WSS[1,2]
matrix WSS[`i', 5] = (WSS[`i'-1,2] - ws`i')/WSS[`i'-1,2]
}


matrix list WSS

_matplot WSS, columns(2 1) connect(l) xlabel(#10) name(plot1, replace) noname nodraw
_matplot WSS, columns(3 1) connect(l) xlabel(#10) name(plot2, replace) noname nodraw
_matplot WSS, columns(4 1) connect(l) xlabel(#10) name(plot3, replace) noname nodraw
_matplot WSS, columns(5 1) connect(l) xlabel(#10) name(plot4, replace) noname nodraw

graph combine plot1 plot2 plot3 plot4, title("Indicator Mix, Gower")
graph export screeplot_list29.tif, replace



**Test 2: Alle Indikatoren mit Euclidean
local list2 "zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol access_d1 access_d2 access_d3 access_d4 costshare_d1 costshare_d2 costshare_d3 choice bb_poslist quality_sum"
local list4 "zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol quality_sum"
local list6 "access_d1 access_d2 access_d3 access_d4 costshare_d1 costshare_d2 costshare_d3 choice bb_poslist"
local list8 "zexp_hc_cap zprof_gp zexp_gov_share"
local list10 "costshare_d1 costshare_d2 costshare_d3 choice bb_poslist"
local list12 "zexp_hc_cap zprof_gp choice bb_poslist"
local list14 "zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol quality_sum"

forvalues i = 1(1)20 {
cluster kmeans `list14', measure (Euclidean) k(`i') start(random(123)) name(cs`i')
cluster stop

}

*WSS matrix
matrix WSS = J(20,5,.)
matrix colnames WSS = i WSS log(WSS) eta-squared PRE

*WSS for each clustering
forvalues i = 1(1)20 {
scalar ws`i' = 0
foreach v of varlist `list14' {
quietly anova `v' cs`i'
scalar ws`i' = ws`i'+e(rss)
}
matrix WSS[`i', 1] = `i'
matrix WSS[`i', 2] = ws`i'
matrix WSS[`i', 3] = log(ws`i')
matrix WSS[`i', 4] = 1 - ws`i'/WSS[1,2]
matrix WSS[`i', 5] = (WSS[`i'-1,2] - ws`i')/WSS[`i'-1,2]
}


matrix list WSS

_matplot WSS, columns(2 1) connect(l) xlabel(#10) name(plot1, replace) noname nodraw
_matplot WSS, columns(3 1) connect(l) xlabel(#10) name(plot2, replace) noname nodraw
_matplot WSS, columns(4 1) connect(l) xlabel(#10) name(plot3, replace) noname nodraw
_matplot WSS, columns(5 1) connect(l) xlabel(#10) name(plot4, replace) noname nodraw

graph combine plot1 plot2 plot3 plot4, title("5 metric indicators, Euclidean")
graph export screeplot_list23.tif, replace


///////////////////////////////////////////////////////////////////////////

tab access_d1 choice,m row
tab access_d2 choice,m row
tab access_d3 choice,m row
tab access_d4 choice,m row

tab rem_sp bb_poslist,m chi2
tab rem_sp choice,m chi2
tab choice bb_poslist, chi2
**high overlap between choice and benefit baskets 

tab rem_sp costshare_d1,m chi2
tab rem_sp costshare_d2,m chi2
tab rem_sp costshare_d3,m chi2

tab access_d1 rem_sp,m row
tab access_d2 rem_sp,m row
tab access_d3 rem_sp,m row
tab access_d4 rem_sp,m row

tab1 access_d*
tab1 costshare_d*

tab access_sum costsharesect,m
tab access_sum costshare_gp,m

tab choice costsharesect,m
tab choice costshare_gp,m

tab rem_sp costsharesect,m
tab rem_sp costshare_gp,m
