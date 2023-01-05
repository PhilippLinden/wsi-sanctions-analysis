***Imputation
	
mi set w																		// Declare data to be imputed wide data
mi register imputed he_2000-he_2017												// Declare variable for imputation
mi register regular country														// Declare regular vars (non-imputed)

*Imputation

mi impute mvn he_2012-he_2016 = country, add(10) replace
replace 

*For 2012

mi impute reg he_2012 he_2014 he_2013, add(10) replace dots						// Impute data by regressing coefficient
how_many_imputations, cv_se(.05)												// Check if more imputations are needed
	gen imp12 = cond(he_2012 == . & _10_he_2012 !=. , 1, 0)						// Generate indicator if data has been imputed
replace he_2012 = _10_he_2012													// Replace missing data with imputed data

*For 2011

mi impute reg he_2011 he_2014 he_2013 he_2012, add(10) replace dots					
how_many_imputations, cv_se(.05)												
	gen imp11 = cond(he_2011 == . & _20_he_2011 !=. , 1, 0)
replace he_2011 = _20_he_2011

*For 2010

mi impute reg he_2010 he_2014 he_2013 he_2012 he_2011, add(10) replace dots					
how_many_imputations, cv_se(.05)												
	gen imp10 = cond(he_2010 == . & _30_he_2010 !=. , 1, 0)
replace he_2010 = _30_he_2010

*For 2009

mi impute reg he_2009 = he_2014 he_2013 he_2012 he_2011 he_2010, add(10) replace dots					
how_many_imputations, cv_se(.05)												
	gen imp09 = cond(he_2009 == . & _40_he_2009 !=. , 1, 0)
replace he_2009 = _40_he_2009

*For 2008

mi impute reg he_2008 = he_2014 he_2013 he_2012 he_2011 he_2010 he_2009, add(10) replace dots					
how_many_imputations, cv_se(.05)												
	gen imp08 = cond(he_2008 == . & _50_he_2008 !=. , 1, 0)
replace he_2008 = _50_he_2008

*For 2007

mi impute reg he_2007 = he_2014 he_2013 he_2012 he_2011 he_2010 he_2009 he_2008, add(10) replace dots					
how_many_imputations, cv_se(.05)												
	gen imp07 = cond(he_2007 == . & _60_he_2007 !=. , 1, 0)
replace he_2007 = _10_he_2007

*For 2006

mi impute reg he_2006 = he_2014 he_2013 he_2012 he_2011 he_2010 he_2009 he_2008 he_2007, add(10) replace dots					
how_many_imputations, cv_se(.05)												
	gen imp06 = cond(he_2006 == . & _70_he_2006 !=. , 1, 0)
replace he_2006 = _70_he_2006

*For 2005

mi impute reg he_2005 = he_2014 he_2013 he_2012 he_2011 he_2010 he_2009 he_2008 he_2007 he_2006, add(10) replace dots					
how_many_imputations, cv_se(.05)												
	gen imp05 = cond(he_2005 == . & _80_he_2005 !=. , 1, 0)
replace he_2005 = _80_he_2005

*For 2004

mi impute reg he_2004 = he_2014 he_2013 he_2012 he_2011 he_2010 he_2009 he_2008 he_2007 he_2006 he_2005, add(10) replace dots					
how_many_imputations, cv_se(.05)												
	gen imp04 = cond(he_2004 == . & _90_he_2004 !=. , 1, 0)
replace he_2004 = _90_he_2004

*For 2003

mi impute reg he_2003 = he_2014 he_2013 he_2012 he_2011 he_2010 he_2009 he_2008 he_2007 he_2006 he_2005 he_2004, add(10) replace dots					
how_many_imputations, cv_se(.05)												
	gen imp03 = cond(he_2003 == . & _100_he_2003 !=. , 1, 0)
replace he_2003 = _100_he_2003

*For 2002

mi impute reg he_2002 = he_2014 he_2013 he_2012 he_2011 he_2010 he_2009 he_2008 he_2007 he_2006 he_2005 he_2004 he_2003, add(10) replace dots					
how_many_imputations, cv_se(.05)												
	gen imp02 = cond(he_2002 == . & _110_he_2002 !=. , 1, 0)
replace he_2002 = _110_he_2002

*For 2001

mi impute reg he_2001 = he_2014 he_2013 he_2012 he_2011 he_2010 he_2009 he_2008 he_2007 he_2006 he_2005 he_2004 he_2003 he_2002, add(10) replace dots					
how_many_imputations, cv_se(.05)												
	gen imp01 = cond(he_2001 == . & _120_he_2001 !=. , 1, 0)
replace he_2001 = _120_he_2001

*For 2000

mi impute reg he_2000 = he_2014 he_2013 he_2012 he_2011 he_2010 he_2009 he_2008 he_2007 he_2006 he_2005 he_2004 he_2003 he_2002 he_2001, add(10) replace dots					
how_many_imputations, cv_se(.05)												
	gen imp00 = cond(he_2000 == . & _130_he_2000 !=. , 1, 0)
replace he_2000 = _130_he_2000

*For 2015

mi impute reg he_2015 = he_2013 he_2014, add(10) replace dots					
how_many_imputations, cv_se(.05)												
	gen imp15 = cond(he_2015 == . & _140_he_2015 !=. , 1, 0)
replace he_2015 = _140_he_2015

*For 2016

mi impute reg he_2016 = he_2013 he_2014 he_2015, add(10) replace dots					
how_many_imputations, cv_se(.05)												
	gen imp16 = cond(he_2016 == . & _150_he_2016 !=. , 1, 0)
replace he_2016 = _150_he_2016

*For 2017

mi impute reg he_2017 = he_2013 he_2014 he_2015 he_2016, add(10) replace dots					
how_many_imputations, cv_se(.05)												
	gen imp17 = cond(he_2017 == . & _160_he_2017 !=. , 1, 0)
	
foreach var of varlist _all {
	replace `var' = 0 if `var' < 0
}							

egen m_imp_2012 = rowmean(_1_he_2012 _2_he_2012 _3_he_2012 _4_he_2012 _5_he_2012 _6_he_2012 _7_he_2012 _8_he_2012 _9_he_2012 _10_he_2012)
egen m_imp_2013 = rowmean(_1_he_2013 _2_he_2013 _3_he_2013 _4_he_2013 _5_he_2013 _6_he_2013 _7_he_2013 _8_he_2013 _9_he_2013 _10_he_2013)
egen m_imp_2014 = rowmean(_1_he_2014 _2_he_2014 _3_he_2014 _4_he_2014 _5_he_2014 _6_he_2014 _7_he_2014 _8_he_2014 _9_he_2014 _10_he_2014)
egen m_imp_2015 = rowmean(_1_he_2015 _2_he_2015 _3_he_2015 _4_he_2015 _5_he_2015 _6_he_2015 _7_he_2015 _8_he_2015 _9_he_2015 _10_he_2015)
egen m_imp_2016 = rowmean(_1_he_2016 _2_he_2016 _3_he_2016 _4_he_2016 _5_he_2016 _6_he_2016 _7_he_2016 _8_he_2016 _9_he_2016 _10_he_2016)
	
replace he_2017 = m_imp_2017

********************************************************************************

gen imp13 = 0
gen imp14 = 0
order country he_2000-he_2017 imp00 imp01 imp02 imp03 imp04 imp05 imp06 imp07 imp08 imp09 imp10 ///
				imp11 imp12 imp13 imp14 imp15 imp16 imp17
drop _1_he_2000 - _130_he_2017 _131_he_2000- m_imp_2017

********************************************************************************

********************************************************************************

*M1: Standardization: None / Measure: Gower / Linkage: Single / Single item vs. Index: Single item / Type: Hierarchical

*Clustering with single dimensions

cluster singlelinkage ///
		LTC_he LTC_beds LTC_inst ///
		priv_he cash_avail ///
		life_exp perc_he ///
		choice_index ///
		means_any, measure (Gower)	

cluster stop, rule(calinski)	
cluster stop, rule(duda)												

cluster generate M1C_a = groups(11)
tab country M1C_a,m
cluster generate M1C_b = groups(13)
tab country M1C_b,m
cluster generate M1D_a = groups(5)
tab country M1D_a,m
cluster generate M1D_b = groups(3)
tab country M1D_b,m

********************************************************************************

*M2: Standardization: Range / Measure: Gower / Linkage: Single / Single item vs. Index: Single item / Type: Hierarchical

*Clustering with single dimensions

cluster singlelinkage ///
		zr_LTC_he zr_LTC_beds zr_LTC_inst ///
		zr_priv_he zr_cash_avail ///
		zr_life_exp zr_perc_he ///
		zr_home_care zr_inst_care zr_cash_vs_inkind ///
		zr_means_any, measure (Gower)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M2C_a = groups(12)
tab country M2C_a,m
cluster generate M2C_b = groups(13)
tab country M2C_b,m
cluster generate M2D_a = groups(3)
tab country M2D_a,m
cluster generate M2D_b = groups(9)
tab country M2D_b,m

********************************************************************************

*M3: Standardization: z-Values / Measure: Gower / Linkage: Single / Single item vs. Index: Single item / Type: Hierarchical

*Clustering with single dimensions

cluster singlelinkage ///
		z_LTC_he z_LTC_beds z_LTC_inst ///
		z_priv_he z_cash_avail ///
		z_life_exp z_perc_he ///
		z_home_care z_inst_care z_cash_vs_inkind ///
		z_means_any, measure (Gower)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M3C_a = groups(13)
tab country M3C_a,m
cluster generate M3C_b = groups(12)
tab country M3C_b,m
cluster generate M3C_c = groups(14)
tab country M3C_c,m
cluster generate M3D_a = groups(3)
tab country M3D_a,m
cluster generate M3D_b = groups(6)
tab country M3D_b,m

********************************************************************************

*M4: Standardization: None / Measure: Euclidian / Linkage: Single / Single item vs. Index: Single item / Type: Hierarchical

*Clustering with single dimensions

cluster singlelinkage ///
		LTC_he LTC_beds LTC_inst ///
		priv_he cash_avail ///
		life_exp perc_he ///
		home_care inst_care cash_vs_inkind ///
		means_any, measure (L2squared)

cluster stop, rule(calinski)	
cluster stop, rule(duda)												

cluster generate M4C_a = groups(15)
tab country M4C_a,m
cluster generate M4C_b = groups(14)
tab country M4C_b,m
cluster generate M4D_a = groups(1)
tab country M4D_a,m
cluster generate M4D_b = groups(15)
tab country M4D_b,m

********************************************************************************

*M5: Standardization: Range / Measure: Euclidian / Linkage: Single / Single item vs. Index: Single item / Type: Hierarchical

*Clustering with single dimensions

cluster singlelinkage ///
		zr_LTC_he zr_LTC_beds zr_LTC_inst ///
		zr_priv_he zr_cash_avail ///
		zr_life_exp zr_perc_he ///
		zr_home_care zr_inst_care zr_cash_vs_inkind ///
		zr_means_any, measure (L2squared)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M5C_a = groups(15)
tab country M5C_a,m
cluster generate M5C_b = groups(14)
tab country M5C_b,m
cluster generate M5D_a = groups(1)
tab country M5D_a,m
cluster generate M5D_b = groups(4)
tab country M5D_b,m

********************************************************************************

*M6: Standardization: z-Values / Measure: Euclidian / Linkage: Single / Single item vs. Index: Single item / Type: Hierarchical

*Clustering with single dimensions

cluster singlelinkage ///
		z_LTC_he z_LTC_beds z_LTC_inst ///
		z_priv_he z_cash_avail ///
		z_life_exp z_perc_he ///
		z_home_care z_inst_care z_cash_vs_inkind ///
		z_means_any, measure (L2squared)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M6C_a = groups(15)
tab country M6C_a,m
cluster generate M6C_b = groups(14)
tab country M6C_b,m
cluster generate M6D_a = groups(1)
tab country M6D_a,m
cluster generate M6D_b = groups(15)
tab country M6D_b,m

********************************************************************************

*M7: Standardization: None / Measure: Gower / Linkage: Average / Single item vs. Index: Single item / Type: Hierarchical

*Clustering with single dimensions

cluster averagelinkage ///
		LTC_he LTC_beds LTC_inst ///
		priv_he cash_avail ///
		life_exp perc_he ///
		home_care inst_care cash_vs_inkind ///
		means_any, measure (Gower)	

cluster stop, rule(calinski)	
cluster stop, rule(duda)												

cluster generate M7C_a = groups(8)
tab country M7C_a,m
cluster generate M7C_b = groups(15)
tab country M7C_b,m
cluster generate M7D_a = groups(1)
tab country M7D_a,m
cluster generate M7D_b = groups(8)
tab country M7D_b,m

*M10: Standardization: None / Measure: Euclidian / Linkage: Average / Type: Hierarchical

*Clustering with single dimensions

cluster averagelinkage ///
		LTC_he LTC_beds LTC_inst ///
		priv_he cash_avail ///
		life_exp perc_he ///
		home_care inst_care cash_vs_inkind ///
		means_any, measure (L2squared)

cluster stop, rule(calinski)	
cluster stop, rule(duda)												

cluster generate M10C_a = groups(15)
tab country M10C_a,m
cluster generate M10C_b = groups(14)
tab country M10C_b,m
cluster generate M10D_a = groups(11)
tab country M10D_a,m
cluster generate M10D_b = groups(7)
tab country M10D_b,m

********************************************************************************

*M13: Standardization: None / Measure: Gower / Linkage: Ward / Type: Hierarchical

*Clustering with single dimensions

cluster wardslinkage ///
		LTC_he LTC_beds LTC_inst ///
		priv_he cash_avail ///
		life_exp perc_he ///
		home_care inst_care cash_vs_inkind ///
		means_any, measure (Gower)	

cluster stop, rule(calinski)	
cluster stop, rule(duda)												

cluster generate M13C_a = groups(7)
tab country M13C_a,m
cluster generate M13C_b = groups(14)
tab country M13C_b,m
cluster generate M13D_a = groups(2)
tab country M13D_a,m
cluster generate M13D_b = groups(5)
tab country M13D_b,m

********************************************************************************

*M16: Standardization: None / Measure: Euclidian / Linkage: Ward / Type: Hierarchical

*Clustering with single dimensions

cluster wardslinkage ///
		LTC_he LTC_beds LTC_inst ///
		priv_he cash_avail ///
		life_exp perc_he ///
		home_care inst_care cash_vs_inkind ///
		means_any, measure (L2squared)

cluster stop, rule(calinski)	
cluster stop, rule(duda)												

cluster generate M16C_a = groups(15)
tab country M16C_a,m
cluster generate M16C_b = groups(14)
tab country M16C_b,m
cluster generate M16D_a = groups(10)
tab country M16D_a,m
cluster generate M16D_b = groups(8)
tab country M16D_b,m

********************************************************************************

*M19: Standardization: None / Measure: Gower / Linkage: Centroid / Type: Hierarchical

*Clustering with single dimensions

cluster centroidlinkage ///
		LTC_he LTC_beds LTC_inst ///
		priv_he cash_avail ///
		life_exp perc_he ///
		home_care inst_care cash_vs_inkind ///
		means_any, measure (Gower)	

cluster stop, rule(calinski)	
cluster stop, rule(duda)												

cluster generate M19C_a = groups(15)
tab country M19C_a,m
cluster generate M19C_b = groups(6)
tab country M19C_b,m
cluster generate M19C_c = groups(12)
tab country M19C_c,m
cluster generate M19D_a = groups(13)
tab country M19D_a,m
cluster generate M19D_b = groups(9)
tab country M19D_b,m

********************************************************************************

********************************************************************************

*M20: Standardization: Range / Measure: Gower / Linkage: Centroid / Type: Hierarchical

*Clustering with single dimensions

cluster centroidlinkage ///
		zr_LTC_he zr_LTC_beds zr_LTC_inst ///
		zr_priv_he zr_cash_avail ///
		zr_life_exp zr_perc_he ///
		zr_home_care zr_inst_care zr_cash_vs_inkind ///
		zr_means_any, measure (Gower)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M20C_a = groups(15)
tab country M20C_a,m
cluster generate M20C_b = groups(14)
tab country M20C_b,m
cluster generate M20D_a = groups(1)
tab country M20D_a,m
cluster generate M20D_b = groups(15)
tab country M20D_b,m

********************************************************************************

*M21: Standardization: z-Values / Measure: Gower / Linkage: Centroid / Type: Hierarchical

*Clustering with single dimensions

cluster centroidlinkage ///
		z_LTC_he z_LTC_beds z_LTC_inst ///
		z_priv_he z_cash_avail ///
		z_life_exp z_perc_he ///
		z_home_care z_inst_care z_cash_vs_inkind ///
		z_means_any, measure (Gower)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M21C_a = groups(15)
tab country M21C_a,m
cluster generate M21C_b = groups(13)
tab country M21C_b,m
cluster generate M21C_c = groups(14)
tab country M21C_c,m
cluster generate M21D_a = groups(2)
tab country M21D_a,m
cluster generate M21D_b = groups(9)
tab country M21D_b,m

********************************************************************************

*M22: Standardization: None / Measure: Euclidian / Linkage: Centroid / Type: Hierarchical

*Clustering with single dimensions

cluster centroidlinkage ///
		LTC_he LTC_beds LTC_inst ///
		priv_he cash_avail ///
		life_exp perc_he ///
		home_care inst_care cash_vs_inkind ///
		means_any, measure (L2squared)

cluster stop, rule(calinski)	
cluster stop, rule(duda)												

cluster generate M22C_a = groups(15)
tab country M22C_a,m
cluster generate M22C_b = groups(14)
tab country M22C_b,m
cluster generate M22D_a = groups(3)
tab country M22D_a,m
cluster generate M22D_b = groups(8)
tab country M22D_b,m

********************************************************************************

*M23: Standardization: Range / Measure: Euclidian / Linkage: Centroid / Type: Hierarchical

*Clustering with single dimensions

cluster centroidlinkage ///
		zr_LTC_he zr_LTC_beds zr_LTC_inst ///
		zr_priv_he zr_cash_avail ///
		zr_life_exp zr_perc_he ///
		zr_home_care zr_inst_care zr_cash_vs_inkind ///
		zr_means_any, measure (L2squared)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M23C_a = groups(15)
tab country M23C_a,m
cluster generate M23C_b = groups(14)
tab country M23C_b,m
cluster generate M23D_a = groups(1)
tab country M23D_a,m
cluster generate M23D_b = groups(6)
tab country M23D_b,m

********************************************************************************

*M24: Standardization: z-Values / Measure: Euclidian / Linkage: Centroid / Type: Hierarchical

*Clustering with single dimensions

cluster centroidlinkage ///
		z_LTC_he z_LTC_beds z_LTC_inst ///
		z_priv_he z_cash_avail ///
		z_life_exp z_perc_he ///
		z_home_care z_inst_care z_cash_vs_inkind ///
		z_means_any, measure (L2squared)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M24C_a = groups(8)
tab country M24C_a,m
cluster generate M24C_b = groups(2)
tab country M24C_b,m
cluster generate M24D_a = groups(2)
tab country M24D_a,m
cluster generate M24D_b = groups(10)
tab country M24D_b,m

********************************************************************************

*M25: Standardization: None / Measure: Gower / Linkage: Single / Type: Hierarchical

*Clustering with single dimensions

cluster singlelinkage ///
		supply ppmix perf access1 access2, measure (Gower)	

cluster stop, rule(calinski)	
cluster stop, rule(duda)												

cluster generate M25C_a = groups(15)
tab country M25C_a,m
cluster generate M25C_b = groups(14)
tab country M25C_b,m
cluster generate M25D_a = groups(3)
tab country M25D_a,m
cluster generate M25D_b = groups(1)
tab country M25D_b,m

********************************************************************************

*M26: Standardization: Range / Measure: Gower / Linkage: Single / Type: Hierarchical

*Clustering with single dimensions

cluster singlelinkage ///
		zr_supply zr_ppmix zr_perf zr_access1 zr_access2, measure (Gower)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M26C_a = groups(15)
tab country M26C_a,m
cluster generate M26C_b = groups(14)
tab country M26C_b,m
cluster generate M26D_a = groups(5)
tab country M26D_a,m
cluster generate M26D_b = groups(8)
tab country M26D_b,m

********************************************************************************

*M27: Standardization: z-Values / Measure: Gower / Linkage: Single / Type: Hierarchical

*Clustering with single dimensions

cluster singlelinkage ///
		z_supply z_ppmix z_perf z_access1 z_access2, measure (Gower)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M27C_a = groups(13)
tab country M27C_a,m
cluster generate M27C_b = groups(14)
tab country M27C_b,m
cluster generate M27D_a = groups(8)
tab country M27D_a,m
cluster generate M27D_b = groups(6)
tab country M27D_b,m

********************************************************************************

*M28: Standardization: None / Measure: Euclidian / Linkage: Single / Type: Hierarchical

*Clustering with single dimensions

cluster singlelinkage ///
		supply ppmix perf access1 access2, measure (L2squared)

cluster stop, rule(calinski)	
cluster stop, rule(duda)												

cluster generate M28C_a = groups(14)
tab country M28C_a,m
cluster generate M28C_b = groups(13)
tab country M28C_b,m
cluster generate M28D_a = groups(1)
tab country M28D_a,m
cluster generate M28D_b = groups(12)
tab country M28D_b,m

********************************************************************************

*M29: Standardization: Range / Measure: Euclidian / Linkage: Single / Type: Hierarchical

*Clustering with single dimensions

cluster singlelinkage ///
		zr_supply zr_ppmix zr_perf zr_access1 zr_access2, measure (L2squared)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M29C_a = groups(14)
tab country M29C_a,m
cluster generate M29C_b = groups(13)
tab country M29C_b,m
cluster generate M29D_a = groups(4)
tab country M29D_a,m
cluster generate M29D_b = groups(2)
tab country M29D_b,m

********************************************************************************

*M30: Standardization: z-Values / Measure: Euclidian / Linkage: Single / Type: Hierarchical

*Clustering with single dimensions

cluster singlelinkage ///
		z_supply z_ppmix z_perf z_access1 z_access2, measure (L2squared)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M30C_a = groups(15)
tab country M30C_a,m
cluster generate M30C_b = groups(14)
tab country M30C_b,m
cluster generate M30D_a = groups(3)
tab country M30D_a,m
cluster generate M30D_b = groups(4)
tab country M30D_b,m

********************************************************************************

*M31: Standardization: None / Measure: Gower / Linkage: Average / Type: Hierarchical

*Clustering with single dimensions

cluster averagelinkage ///
		supply ppmix perf access1 access2, measure (Gower)	

cluster stop, rule(calinski)	
cluster stop, rule(duda)												

cluster generate M31C_a = groups(12)
tab country M31C_a,m
cluster generate M31C_b = groups(13)
tab country M31C_b,m
cluster generate M31D_a = groups(1)
tab country M31D_a,m
cluster generate M31D_b = groups(12)
tab country M31D_b,m

********************************************************************************

*M32: Standardization: Range / Measure: Gower / Linkage: Average / Type: Hierarchical

*Clustering with single dimensions

cluster averagelinkage ///
		zr_supply zr_ppmix zr_perf zr_access1 zr_access2, measure (Gower)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M32C_a = groups(15)
tab country M32C_a,m
cluster generate M32C_b = groups(14)
tab country M32C_b,m
cluster generate M32D_a = groups(3)
tab country M32D_a,m
cluster generate M32D_b = groups(15)
tab country M32D_b,m

********************************************************************************

*M33: Standardization: z-Values / Measure: Gower / Linkage: Average / Type: Hierarchical

*Clustering with single dimensions

cluster averagelinkage ///
		z_supply z_ppmix z_perf z_access1 z_access2, measure (Gower)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M33C_a = groups(15)
tab country M33C_a,m
cluster generate M33C_b = groups(14)
tab country M33C_b,m
cluster generate M33D_a = groups(1)
tab country M33D_a,m
cluster generate M33D_b = groups(15)
tab country M33D_b,m

********************************************************************************

*M34: Standardization: None / Measure: Euclidian / Linkage: Average / Type: Hierarchical

*Clustering with single dimensions

cluster averagelinkage ///
		supply ppmix perf access1 access2, measure (L2squared)

cluster stop, rule(calinski)	
cluster stop, rule(duda)												

cluster generate M34C_a = groups(15)
tab country M34C_a,m
cluster generate M34C_b = groups(14)
tab country M34C_b,m
cluster generate M34D_a = groups(7)
tab country M34D_a,m
cluster generate M34D_b = groups(8)
tab country M34D_b,m

********************************************************************************

*M35: Standardization: Range / Measure: Euclidian / Linkage: Average / Type: Hierarchical

*Clustering with single dimensions

cluster averagelinkage ///
		zr_supply zr_ppmix zr_perf zr_access1 zr_access2, measure (L2squared)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M35C_a = groups(2)
tab country M35C_a,m
cluster generate M35C_b = groups(3)
tab country M35C_b,m
cluster generate M35D_a = groups(3)
tab country M35D_a,m
cluster generate M35D_b = groups(5)
tab country M35D_b,m

********************************************************************************

*M36: Standardization: z-Values / Measure: Euclidian / Linkage: Average / Type: Hierarchical

*Clustering with single dimensions

cluster averagelinkage ///
		z_supply z_ppmix z_perf z_access1 z_access2, measure (L2squared)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M36C_a = groups(3)
tab country M36C_a,m
cluster generate M36C_b = groups(15)
tab country M36C_b,m
cluster generate M36D_a = groups(3)
tab country M36D_a,m
cluster generate M36D_b = groups(14)
tab country M36D_b,m

********************************************************************************

*M37: Standardization: None / Measure: Gower / Linkage: Ward / Type: Hierarchical

*Clustering with single dimensions

cluster wardslinkage ///
		supply ppmix perf access1 access2, measure (Gower)	

cluster stop, rule(calinski)	
cluster stop, rule(duda)												

cluster generate M37C_a = groups(12)
tab country M37C_a,m
cluster generate M37C_b = groups(8)
tab country M37C_b,m
cluster generate M37D_a = groups(10)
tab country M37D_a,m
cluster generate M37D_b = groups(12)
tab country M37D_b,m

********************************************************************************

*M38: Standardization: Range / Measure: Gower / Linkage: Ward / Type: Hierarchical

*Clustering with single dimensions

cluster wardslinkage ///
		zr_supply zr_ppmix zr_perf zr_access1 zr_access2, measure (Gower)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M38C_a = groups(15)
tab country M38C_a,m
cluster generate M38C_b = groups(4)
tab country M38C_b,m
cluster generate M38D_a = groups(1)
tab country M38D_a,m
cluster generate M38D_b = groups(9)
tab country M38D_b,m

********************************************************************************

*M39: Standardization: z-Values / Measure: Gower / Linkage: Ward / Type: Hierarchical

*Clustering with single dimensions

cluster wardslinkage ///
		z_supply z_ppmix z_perf z_access1 z_access2, measure (Gower)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M39C_a = groups(15)
tab country M39C_a,m
cluster generate M39C_b = groups(14)
tab country M39C_b,m
cluster generate M39D_a = groups(1)
tab country M39D_a,m
cluster generate M39D_b = groups(9)
tab country M39D_b,m

********************************************************************************

*M40: Standardization: None / Measure: Euclidian / Linkage: Ward / Type: Hierarchical

*Clustering with single dimensions

cluster wardslinkage ///
		supply ppmix perf access1 access2, measure (L2squared)

cluster stop, rule(calinski)	
cluster stop, rule(duda)												

cluster generate M40C_a = groups(15)
tab country M40C_a,m
cluster generate M40C_b = groups(14)
tab country M40C_b,m
cluster generate M40D_a = groups(7)
tab country M40D_a,m
cluster generate M40D_b = groups(9)
tab country M40D_b,m

********************************************************************************

*M41: Standardization: Range / Measure: Euclidian / Linkage: Ward / Type: Hierarchical

*Clustering with single dimensions

cluster wardslinkage ///
		zr_supply zr_ppmix zr_perf zr_access1 zr_access2, measure (L2squared)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M41C_a = groups(3)
tab country M41C_a,m
cluster generate M41C_b = groups(2)
tab country M41C_b,m
cluster generate M41D_a = groups(4)
tab country M41D_a,m
cluster generate M41D_b = groups(7)
tab country M41D_b,m

********************************************************************************

*M42: Standardization: z-Values / Measure: Euclidian / Linkage: Ward / Type: Hierarchical

*Clustering with single dimensions

cluster wardslinkage ///
		z_supply z_ppmix z_perf z_access1 z_access2, measure (L2squared)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M42C_a = groups(15)
tab country M42C_a,m
cluster generate M42C_b = groups(14)
tab country M42C_b,m
cluster generate M42D_a = groups(1)
tab country M42D_a,m
cluster generate M42D_b = groups(14)
tab country M42D_b,m

********************************************************************************

*M43: Standardization: None / Measure: Gower / Linkage: Centroid / Type: Hierarchical

*Clustering with single dimensions

cluster centroidlinkage ///
		supply ppmix perf access1 access2, measure (Gower)	

cluster stop, rule(calinski)	
cluster stop, rule(duda)												

cluster generate M43C_a = groups(9)
tab country M43C_a,m
cluster generate M43C_b = groups(15)
tab country M43C_b,m
cluster generate M43D_a = groups(6)
tab country M43D_a,m
cluster generate M43D_b = groups(3)
tab country M43D_b,m

********************************************************************************

*M44: Standardization: Range / Measure: Gower / Linkage: Centroid / Type: Hierarchical

*Clustering with single dimensions

cluster centroidlinkage ///
		zr_supply zr_ppmix zr_perf zr_access1 zr_access2, measure (Gower)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M44C_a = groups(15)
tab country M44C_a,m
cluster generate M44C_b = groups(13)
tab country M44C_b,m
cluster generate M44D_a = groups(6)
tab country M44D_a,m
cluster generate M44D_b = groups(9)
tab country M44D_b,m

********************************************************************************

*M45: Standardization: z-Values / Measure: Gower / Linkage: Centroid / Type: Hierarchical

*Clustering with single dimensions

cluster centroidlinkage ///
		z_supply z_ppmix z_perf z_access1 z_access2, measure (Gower)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M45C_a = groups(15)
tab country M45C_a,m
cluster generate M45C_b = groups(11)
tab country M45C_b,m
cluster generate M45D_a = groups(6)
tab country M45D_a,m
cluster generate M45D_b = groups(9)
tab country M45D_b,m

********************************************************************************

*M46: Standardization: None / Measure: Euclidian / Linkage: Centroid / Type: Hierarchical

*Clustering with single dimensions

cluster centroidlinkage ///
		supply ppmix perf access1 access2, measure (L2squared)

cluster stop, rule(calinski)	
cluster stop, rule(duda)												

cluster generate M46C_a = groups(15)
tab country M46C_a,m
cluster generate M46C_b = groups(14)
tab country M46C_b,m
cluster generate M46D_a = groups(7)
tab country M46D_a,m
cluster generate M46D_b = groups(8)
tab country M46D_b,m

********************************************************************************

*M47: Standardization: Range / Measure: Euclidian / Linkage: Centroid / Type: Hierarchical

*Clustering with single dimensions

cluster centroidlinkage ///
		zr_supply zr_ppmix zr_perf zr_access1 zr_access2, measure (L2squared)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M47C_a = groups(3)
tab country M47C_a,m
cluster generate M47C_b = groups(2)
tab country M47C_b,m
cluster generate M47D_a = groups(9)
tab country M47D_a,m
cluster generate M47D_b = groups(13)
tab country M47D_b,m

********************************************************************************

*M48: Standardization: z-Values / Measure: Euclidian / Linkage: Centroid / Type: Hierarchical

*Clustering with single dimensions

cluster centroidlinkage ///
		z_supply z_ppmix z_perf z_access1 z_access2, measure (L2squared)
		
cluster stop, rule(calinski)
cluster stop, rule(duda)												

cluster generate M48C_a = groups(15)
tab country M48C_a,m
cluster generate M48C_b = groups(14)
tab country M48C_b,m
cluster generate M48D_a = groups(2)
tab country M48D_a,m
cluster generate M48D_b = groups(5)
tab country M48D_b,m

********************************************************************************

clear all
use "$data\LTCT_aux.dta"

*M49: Standardization: None / Measure: Gower / Type: K-Means

local list1 "LTC_he LTC_beds LTC_inst priv_he cash_avail life_exp perc_he home_care inst_care cash_vs_inkind means_any"

forvalues i = 1(1)15 {
cluster kmeans `list1', measure (Gower) k(`i') start(random(123)) name(cs`i')
cluster stop
}

*Within Sum of squares matrix -> WSS matrix
*Plot and search for a kink in the graphs within WSS and log(WSS)
matrix WSS = J(15,5,.)
matrix colnames WSS = i WSS_in_100k log(WSS) eta-squared PRE

*WSS for each clustering
forvalues i = 1(1)15 {
scalar ws`i' = 0
foreach v of varlist `list1' {
quietly anova `v' cs`i'
scalar ws`i' = ws`i'+e(rss)
}
matrix WSS[`i', 1] = `i'
matrix WSS[`i', 2] = ws`i'/100000
matrix WSS[`i', 3] = log(ws`i')
matrix WSS[`i', 4] = 1 - ((ws`i'/100000)/WSS[1,2])
matrix WSS[`i', 5] = (WSS[`i'-1,2] - ((ws`i'/100000)/WSS[`i'-1,2]))
}

matrix list WSS

_matplot WSS, columns(2 1) connect(l) xlabel(#10) name(plot1, replace) noname nodraw
_matplot WSS, columns(3 1) connect(l) xlabel(#10) name(plot2, replace) noname nodraw
_matplot WSS, columns(4 1) connect(l) xlabel(#10) name(plot3, replace) noname nodraw
_matplot WSS, columns(5 1) connect(l) xlabel(#10) name(plot4, replace) noname nodraw

graph combine plot1 plot2 plot3 plot4, title("Standardization: None, Gower, Single items")
graph export "$graphs\plots_49.tif", replace

save "$data\LTCT_aux_k_49.dta", replace

*Result: Calinski: 2, 3 / Screeplot: 2, 6

********************************************************************************

clear all
use "$data\LTCT_aux.dta"

*M54: Standardization: z-Values / Measure: Euclidian / Type: K-Means

local list1 "z_LTC_he z_LTC_beds z_LTC_inst z_priv_he z_cash_avail z_life_exp z_perc_he z_home_care z_inst_care z_cash_vs_inkind z_means_any"

forvalues i = 1(1)15 {
cluster kmeans `list1', measure (L2squared) k(`i') start(random(123)) name(cs`i')
cluster stop
}

*WSS matrix
matrix WSS = J(15,5,.)
matrix colnames WSS = i WSS log(WSS) eta-squared PRE

*WSS for each clustering
forvalues i = 1(1)15 {
scalar ws`i' = 0
foreach v of varlist `list1' {
quietly anova `v' cs`i'
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

graph combine plot1 plot2 plot3 plot4, title("Standardization: z-Values, Euclidian, Single items")
graph export "$graphs\plots_54.tif", replace

save "$data\LTCT_aux_k_54.dta", replace

*Result: Calinski: 2, 5 / Screeplot: 3, 5

********************************************************************************

clear all
use "$data\LTCT_aux.dta"

*M55: Standardization: None / Measure: Gower / Type: K-Means

local list1 "supply ppmix perf access1 access2"

forvalues i = 1(1)15 {
cluster kmeans `list1', measure (Gower) k(`i') start(random(123)) name(cs`i')
cluster stop
}

*WSS matrix
matrix WSS = J(15,5,.)
matrix colnames WSS = i WSS_in_100k log(WSS) eta-squared PRE

*WSS for each clustering
forvalues i = 1(1)15 {
scalar ws`i' = 0
foreach v of varlist `list1' {
quietly anova `v' cs`i'
scalar ws`i' = ws`i'+e(rss)
}
matrix WSS[`i', 1] = `i'
matrix WSS[`i', 2] = ws`i'/100000
matrix WSS[`i', 3] = log(ws`i')
matrix WSS[`i', 4] = 1 - ((ws`i'/100000)/WSS[1,2])
matrix WSS[`i', 5] = (WSS[`i'-1,2] - ((ws`i'/100000)/WSS[`i'-1,2]))
}

matrix list WSS

_matplot WSS, columns(2 1) connect(l) xlabel(#10) name(plot1, replace) noname nodraw
_matplot WSS, columns(3 1) connect(l) xlabel(#10) name(plot2, replace) noname nodraw
_matplot WSS, columns(4 1) connect(l) xlabel(#10) name(plot3, replace) noname nodraw
_matplot WSS, columns(5 1) connect(l) xlabel(#10) name(plot4, replace) noname nodraw

graph combine plot1 plot2 plot3 plot4, title("Standardization: None, Gower, Index")
graph export "$graphs\plots_55.tif", replace

save "$data\LTCT_aux_k_55.dta", replace

*Result: Calinski: 3, 6 / Screeplot: 3, 6

********************************************************************************

clear all
use "$data\LTCT_aux.dta"

*M56: Standardization: Range / Measure: Gower / Type: K-Means

local list1 "zr_supply zr_ppmix zr_perf zr_access1 zr_access2"

forvalues i = 1(1)15 {
cluster kmeans `list1', measure (Gower) k(`i') start(random(123)) name(cs`i')
cluster stop
}

*WSS matrix
matrix WSS = J(15,5,.)
matrix colnames WSS = i WSS log(WSS) eta-squared PRE

*WSS for each clustering
forvalues i = 1(1)15 {
scalar ws`i' = 0
foreach v of varlist `list1' {
quietly anova `v' cs`i'
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

graph combine plot1 plot2 plot3 plot4, title("Standardization: Range, Gower, Index")
graph export "$graphs\plots_56.tif", replace

save "$data\LTCT_aux_k_56.dta", replace

*Result: Calinski: 2, 6, 13 / Screeplot: 2, 6

********************************************************************************

clear all
use "$data\LTCT_aux.dta"

*M57: Standardization: z-Values / Measure: Gower / Type: K-Means

local list1 "z_supply z_ppmix z_perf z_access1 z_access2"

forvalues i = 1(1)15 {
cluster kmeans `list1', measure (Gower) k(`i') start(random(123)) name(cs`i')
cluster stop
}

*WSS matrix
matrix WSS = J(15,5,.)
matrix colnames WSS = i WSS log(WSS) eta-squared PRE

*WSS for each clustering
forvalues i = 1(1)15 {
scalar ws`i' = 0
foreach v of varlist `list1' {
quietly anova `v' cs`i'
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

graph combine plot1 plot2 plot3 plot4, title("Standardization: z-Values, Gower, Index")
graph export "$graphs\plots_57.tif", replace

save "$data\LTCT_aux_k_57.dta", replace

*Result: Calinski: 6, 4, 8 / Screeplot: 4, 6

********************************************************************************

clear all
use "$data\LTCT_aux.dta"

*M58: Standardization: None / Measure: Euclidian / Type: K-Means

local list1 "supply ppmix perf access1 access2"

forvalues i = 1(1)15 {
cluster kmeans `list1', measure (L2squared) k(`i') start(random(123)) name(cs`i')
cluster stop
}

*WSS matrix
matrix WSS = J(15,5,.)
matrix colnames WSS = i WSS_in_100k log(WSS) eta-squared PRE

*WSS for each clustering
forvalues i = 1(1)15 {
scalar ws`i' = 0
foreach v of varlist `list1' {
quietly anova `v' cs`i'
scalar ws`i' = ws`i'+e(rss)
}
matrix WSS[`i', 1] = `i'
matrix WSS[`i', 2] = ws`i'/100000
matrix WSS[`i', 3] = log(ws`i')
matrix WSS[`i', 4] = 1 - ((ws`i'/100000)/WSS[1,2])
matrix WSS[`i', 5] = (WSS[`i'-1,2] - ((ws`i'/100000)/WSS[`i'-1,2]))
}

matrix list WSS

_matplot WSS, columns(2 1) connect(l) xlabel(#10) name(plot1, replace) noname nodraw
_matplot WSS, columns(3 1) connect(l) xlabel(#10) name(plot2, replace) noname nodraw
_matplot WSS, columns(4 1) connect(l) xlabel(#10) name(plot3, replace) noname nodraw
_matplot WSS, columns(5 1) connect(l) xlabel(#10) name(plot4, replace) noname nodraw

graph combine plot1 plot2 plot3 plot4, title("Standardization: None, Euclidian, Index")
graph export "$graphs\plots_58.tif", replace

save "$data\LTCT_aux_k_58.dta", replace

*Result: Calinski: 15, 14 / Screeplot: 3, 7

********************************************************************************

clear all
use "$data\LTCT_aux.dta"

*M59: Standardization: Range / Measure: Euclidian / Type: K-Means

local list1 "zr_supply zr_ppmix zr_perf zr_access1 zr_access2"

forvalues i = 1(1)15 {
cluster kmeans `list1', measure (L2squared) k(`i') start(random(123)) name(cs`i')
cluster stop
}

*WSS matrix
matrix WSS = J(15,5,.)
matrix colnames WSS = i WSS log(WSS) eta-squared PRE

*WSS for each clustering
forvalues i = 1(1)15 {
scalar ws`i' = 0
foreach v of varlist `list1' {
quietly anova `v' cs`i'
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

graph combine plot1 plot2 plot3 plot4, title("Standardization: Range, Euclidian, Index")
graph export "$graphs\plots_59.tif", replace

save "$data\LTCT_aux_k_59.dta", replace

*Result: Calinski: 2, 4 / Screeplot: 6, 10

********************************************************************************

clear all
use "$data\LTCT_aux.dta"

*M54: Standardization: z-Values / Measure: Euclidian / Type: K-Means

local list1 "z_supply z_ppmix z_perf z_access1 z_access2"

forvalues i = 1(1)15 {
cluster kmeans `list1', measure (L2squared) k(`i') start(random(123)) name(cs`i')
cluster stop
}

*WSS matrix
matrix WSS = J(15,5,.)
matrix colnames WSS = i WSS log(WSS) eta-squared PRE

*WSS for each clustering
forvalues i = 1(1)15 {
scalar ws`i' = 0
foreach v of varlist `list1' {
quietly anova `v' cs`i'
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

graph combine plot1 plot2 plot3 plot4, title("Standardization: z-Values, Euclidian, Index")
graph export "$graphs\plots_60.tif", replace

save "$data\LTCT_aux_k_60.dta", replace

*Result: Calinski: 2, 15 / Screeplot: 2, 13

********************************************************************************

	merge 1:1 id using "$data\LTCT_aux_k_53.dta"
		drop _merge
	merge 1:1 id using "$data\LTCT_aux_k_54.dta"
		drop _merge
	merge 1:1 id using "$data\LTCT_aux_k_55.dta"
		drop _merge
	merge 1:1 id using "$data\LTCT_aux_k_56.dta"
		drop _merge
	merge 1:1 id using "$data\LTCT_aux_k_57.dta"
		drop _merge
	merge 1:1 id using "$data\LTCT_aux_k_58.dta"
		drop _merge
	merge 1:1 id using "$data\LTCT_aux_k_59.dta"
		drop _merge
	merge 1:1 id using "$data\LTCT_aux_k_60.dta"
		drop _merge
		
********************************************************************************

erase "$data\LTCT_aux_k_53.dta"
erase "$data\LTCT_aux_k_54.dta"
erase "$data\LTCT_aux_k_55.dta"
erase "$data\LTCT_aux_k_56.dta"
erase "$data\LTCT_aux_k_57.dta"
erase "$data\LTCT_aux_k_58.dta"
erase "$data\LTCT_aux_k_59.dta"
erase "$data\LTCT_aux_k_60.dta"		