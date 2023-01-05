/*==============================================================================
File name:    hinews_nr_cluster_ana_02_20170515.do
Task:         Conducts cluster analysis, outlier check                                                 
Project:      Health system typology
Author(s):    Nadine Reibling, Mareike Ariaans                                            
Last update:  2017-05-22                                                                             
==============================================================================*/

/*------------------------------------------------------------------------------ 
Content:

#1 Load data
#2 Hierarchical cluster analysis (
#3 K-Means cluster analysis

------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------
Notes:
**This is the same as 02_hinews_nr_cluster_ana01 except that US, KO, and CH are dropped

------------------------------------------------------------------------------*/

version 13.1   // Stata version control

/*------------------------------------------------------------------------------
#1 Load data
------------------------------------------------------------------------------*/

clear

cd "C:\Users\Reibling\Documents\A01_current_projects\2015_HINEWS\2015_healthtyp\10_Data"

sysuse hinews_nr_cluster_rec03.dta

drop if country=="USA"
drop if country=="Korea"
drop if country=="Switzerland"

tab country,m

/*------------------------------------------------------------------------------
#2 Hierarchical cluster analysis
------------------------------------------------------------------------------*/

**2.1 Z-standardized variables
**2.1.1 Gower
**2.1.1.1 Gower + Single Linkage

cluster singlelinkage  zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp ///
	zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol ///
	access_sum  choice costshare_gp quality_sum, measure (Gower) 
cluster stop
**4 or 6 
cluster stop, rule(duda)
**2 or 6

cluster dendrogram, labels(cntry2) horizontal


cluster generate single1 = groups(5)
tab cntry single1,m

**Outlier countries: US, CH, KO, IE, AU

**2.1.1.1 Gower + Average Linkage

cluster averagelinkage  zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp ///
	zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol ///
	access_sum  choice costshare_gp quality_sum, measure (Gower) 

cluster stop
**3
cluster stop, rule(duda)
** 5 or 6cluster

cluster dendrogram, labels(cntry2) horizontal

cluster generate average1 = groups(6)
tab cntry average1,m
list cntry average1

**2.1.1.1 Gower + Centroid Linkage

cluster centroidlinkage  zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp ///
	zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol ///
	access_sum  choice costshare_gp quality_sum, measure (Gower) 

cluster stop
**3,6, or 7

cluster stop, rule(duda)
** 4 or 7


cluster generate centroid1 = groups(7)
tab cntry centroid1,m
list cntry centroid1

**2.1.1.1 Gower + Wards

cluster wardslinkage  zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp ///
	zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol ///
	access_sum  choice costshare_gp quality_sum, measure (Gower) 

cluster stop
**3

cluster stop, rule(duda)
** 3 or 5

cluster dendrogram, labels(cntry2) horizontal

cluster generate wards1 = groups(3)
cluster generate wards2 = groups(5)
tab cntry wards1,m
tab cntry wards2,m
list cntry wards1
list cntry wards2


**2.1.1 Euclidean squared
**2.1.1.1 Euclidean squared + Single Linkage

cluster singlelinkage  zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp ///
	zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol ///
	access_sum  choice costshare_gp quality_sum, measure (L2squared) 
cluster stop
**5
cluster stop, rule(duda)
**6
cluster dendrogram, labels(cntry2) horizontal

cluster generate single3 = groups(5)
tab cntry single3,m
list cntry single3

**2.1.1.1 Euclidean swaured + Average Linkage

cluster averagelinkage  zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp ///
	zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol ///
	access_sum  choice costshare_gp quality_sum, measure (L2squared) 

cluster stop
**4

cluster stop, rule(duda)
** 6


cluster generate average3 = groups(6)
tab cntry average3,m
list cntry average3

**2.1.1.1 Euclidean sqaured + Centroid Linkage

cluster centroidlinkage  zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp ///
	zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol ///
	access_sum  choice costshare_gp quality_sum, measure (L2squared) 

cluster stop
**5 oder 7

cluster stop, rule(duda)
** 3 oder 5


cluster generate centroid3 = groups(5)
tab cntry centroid3,m
list cntry centroid3


**2.1.1.1  Euclidean + Wards

cluster wardslinkage  zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp ///
	zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol ///
	access_sum  choice costshare_gp quality_sum, measure (L2squared) 

cluster stop
**3

cluster stop, rule(duda)
** 3

cluster dendrogram, labels(cntry2) horizontal
*3 sieht gut aus


cluster generate wards3 = groups(3)
tab cntry wards3,m
list cntry wards3

**********************************************************************
**2.2 Range-standardized variables
**2.2.1 Gower
**2.2.1.1 Gower + Single Linkage

cluster singlelinkage  rexp_hc_cap rprof_gp rexp_gov_share rexp_oop_share rem_sp ///
	rexp_outp_cur_share rgpsprat rprev_tobacco rprev_alcohol ///
	raccess_sum  choice costshare_gp rquality_sum, measure (Gower) 

cluster stop
** 4 or 6
cluster stop, rule(duda)
**2 or 4

cluster dendrogram, labels(cntry2) horizontal

cluster generate single4 = groups(4)
tab cntry single4, m
list cntry single4

**2.2.1.1 Gower + Average Linkage

cluster averagelinkage  rexp_hc_cap rprof_gp rexp_gov_share rexp_oop_share rem_sp ///
	rexp_outp_cur_share rgpsprat rprev_tobacco rprev_alcohol ///
	raccess_sum  choice costshare_gp rquality_sum, measure (Gower) 

cluster stop
**3

cluster stop, rule(duda)
** 3

cluster dendrogram, labels(cntry2) horizontal

cluster generate average5 = groups(3)
tab cntry average5,m
list cntry average5

**2.2.1.1 Gower + Centroid Linkage

cluster centroidlinkage  rexp_hc_cap rprof_gp rexp_gov_share rexp_oop_share rem_sp ///
	rexp_outp_cur_share rgpsprat rprev_tobacco rprev_alcohol ///
	raccess_sum  choice costshare_gp rquality_sum, measure (Gower) 

cluster stop
**7 

cluster stop, rule(duda)
** 4 or 7


cluster generate centroid5 = groups(7)
tab cntry centroid5,m
list cntry centroid5

**2.2.1.1 Gower + Wards

cluster wardslinkage  rexp_hc_cap rprof_gp rexp_gov_share rexp_oop_share rem_sp ///
	rexp_outp_cur_share rgpsprat rprev_tobacco rprev_alcohol ///
	raccess_sum  choice costshare_gp rquality_sum, measure (Gower) 

cluster stop
**3 

cluster stop, rule(duda)
** 3 or 7

cluster dendrogram, labels(cntry2) horizontal

cluster generate wards5 = groups(3)
tab cntry wards5,m
list cntry wards5


**2.2.1 Euclidean squared
**2.2.1.1 Euclidean squared + Single Linkage

cluster singlelinkage  rexp_hc_cap rprof_gp rexp_gov_share rexp_oop_share rem_sp ///
	rexp_outp_cur_share rgpsprat rprev_tobacco rprev_alcohol ///
	raccess_sum  choice costshare_gp rquality_sum, measure (L2squared) 
cluster stop
**3 or 4
cluster stop, rule(duda)
**4

cluster dendrogram, labels(cntry2) horizontal

cluster generate single7 = groups(4)
tab cntry single7,m
list cntry single7


**2.1.1.1 Euclidean swaured + Average Linkage

cluster averagelinkage  rexp_hc_cap rprof_gp rexp_gov_share rexp_oop_share rem_sp ///
	rexp_outp_cur_share rgpsprat rprev_tobacco rprev_alcohol ///
	raccess_sum  choice costshare_gp rquality_sum, measure (L2squared) 

cluster stop
**3 or 5

cluster stop, rule(duda)
** 3


cluster generate average7 = groups(3)
tab cntry average7,m
list cntry average7

**2.2.1.1 Euclidean sqaured + Centroid Linkage

cluster centroidlinkage  rexp_hc_cap rprof_gp rexp_gov_share rexp_oop_share rem_sp ///
	rexp_outp_cur_share rgpsprat rprev_tobacco rprev_alcohol ///
	raccess_sum  choice costshare_gp rquality_sum, measure (L2squared) 

cluster stop
**3

cluster stop, rule(duda)
** 3 o r 4


cluster generate centroid7 = groups(4)
tab cntry centroid7,m
list cntry centroid7

**2.2.1.1 Gower + Wards

cluster wardslinkage  rexp_hc_cap rprof_gp rexp_gov_share rexp_oop_share rem_sp ///
	rexp_outp_cur_share rgpsprat rprev_tobacco rprev_alcohol ///
	raccess_sum  choice costshare_gp rquality_sum, measure (L2squared) 

cluster stop
**3

cluster stop, rule(duda)
** 5

cluster dendrogram, labels(cntry2) horizontal
*4 sieht gut aus


cluster generate wards7 = groups(5)
tab cntry wards7,m
list cntry wards7

/*------------------------------------------------------------------------------
#3 K-Means cluster analysis
------------------------------------------------------------------------------*/

**3.1 Z-Standardization
**3.1.1 Gower

local list1 "zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol access_sum  choice costshare_gp quality_sum"


forvalues i = 1(1)20 {
cluster kmeans `list1', measure (Gower) k(`i') start(random(123)) name(cs`i')
cluster stop
**4 oder 8 cluster: zeigt sich auch unten in der Grafik
}

*WSS matrix
matrix WSS = J(20,5,.)
matrix colnames WSS = i WSS log(WSS) eta-squared PRE

*WSS for each clustering
forvalues i = 1(1)20 {
scalar ws`i' = 0
foreach v of varlist `list1' {
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

graph combine plot1 plot2 plot3 plot4, title("Reduced indicator set, Gower")
graph export screeplot_Gower_z.tif, replace

**4 clusters

tab cntry cs4,m
list cntry cs4

**3.1 Z-Standardization
**3.1.2 Euclidean2

drop cs*
local list1 "zexp_hc_cap zprof_gp zexp_gov_share zexp_oop_share rem_sp zexp_outp_cur_share zgpsprat zprev_tobacco zprev_alcohol access_sum  choice costshare_gp quality_sum"


forvalues i = 1(1)20 {
cluster kmeans `list1', measure (L2squared) k(`i') start(random(123)) name(cs`i')
cluster stop
**4 oder 8 cluster: zeigt sich auch unten in der Grafik
}

*WSS matrix
matrix WSS = J(20,5,.)
matrix colnames WSS = i WSS log(WSS) eta-squared PRE

*WSS for each clustering
forvalues i = 1(1)20 {
scalar ws`i' = 0
foreach v of varlist `list1' {
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

graph combine plot1 plot2 plot3 plot4, title("Reduced indicator set, Gower")
graph export screeplot_Euclidean_z.tif, replace

**4 clusters

tab cntry cs4,m
list cntry cs4


**3.2 Range-Standardization
**3.2.1 Gower

drop cs*

local list1 "rexp_hc_cap rprof_gp rexp_gov_share rexp_oop_share rem_sp rexp_outp_cur_share rgpsprat rprev_tobacco rprev_alcohol raccess_sum  choice costshare_gp rquality_sum"


forvalues i = 1(1)20 {
cluster kmeans `list1', measure (Gower) k(`i') start(random(123)) name(cs`i')
cluster stop
**4 oder 8 cluster: zeigt sich auch unten in der Grafik
}

*WSS matrix
matrix WSS = J(20,5,.)
matrix colnames WSS = i WSS log(WSS) eta-squared PRE

*WSS for each clustering
forvalues i = 1(1)20 {
scalar ws`i' = 0
foreach v of varlist `list1' {
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

graph combine plot1 plot2 plot3 plot4, title("Reduced indicator set, Gower")
graph export screeplot_Gower_r.tif, replace

**2, 5 oder 8  clusters

tab cntry cs2,m
tab cntry cs5,m
tab cntry cs8,m

list cntry cs2
list cntry cs5
list cntry cs8

**3.2 Range-Standardization
**3.2.2 Euclidean2

drop cs*
local list1 "rexp_hc_cap rprof_gp rexp_gov_share rexp_oop_share rem_sp rexp_outp_cur_share rgpsprat rprev_tobacco rprev_alcohol raccess_sum  choice costshare_gp rquality_sum"


forvalues i = 1(1)20 {
cluster kmeans `list1', measure (L2squared) k(`i') start(random(123)) name(cs`i')
cluster stop
**4 oder 8 cluster: zeigt sich auch unten in der Grafik
}

*WSS matrix
matrix WSS = J(20,5,.)
matrix colnames WSS = i WSS log(WSS) eta-squared PRE

*WSS for each clustering
forvalues i = 1(1)20 {
scalar ws`i' = 0
foreach v of varlist `list1' {
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

graph combine plot1 plot2 plot3 plot4, title("Reduced indicator set, Gower")
graph export screeplot_Euclidean_r.tif, replace

**3 or 5 clusters

tab cntry cs3,m
tab cntry cs5,m

list cntry cs3
list cntry cs5

