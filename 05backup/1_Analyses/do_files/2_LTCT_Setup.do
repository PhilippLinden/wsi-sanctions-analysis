/*******************************************************************************

File name: 		2_LTCT_Setup.do
Task:			Cluster Analysis - Data setup
Project:		Long-term-care Typology
Version:		Stata 16
Author:			Philipp Linden/Mareike Ariaans
Last update:	2020-04-13

********************************************************************************

Content:
# 1. Setting up the dataset
# 2. Merge
# 3. Labeling and Recoding

*******************************************************************************/

********************************************************************************
****					1. Setting up the dataset							****
********************************************************************************

*First, we need all the indicators in one dataset
*However, we have missing data in many of the indicators
*Therefore we need to interpolate/impute some of the data and merge it together at the end

********************************************************************************

*I: LTC expenditure health

clear all

import excel "$data\20200116_coelcare_ma_Typology_Indicators_Data.xlsx", sheet("LTC expenditure, health") firstrow

br

*Generate and label vars

drop if A == ""
encode A, gen(country)
	lab var country "Country"
drop B xmlversion10encodingut D W X Y Z A*

*Drop of countries with missing data

drop if country == 2 |country == 5 | country == 12 | country == 14 | 	///
		country == 17 | country == 21 | country == 23 | country == 28 | ///
		country == 34 													///
																		

*Gen new id var

gen id = _n
label def id ///
	1 "AU" 2 "BE" 3 "CA" 4 "CZ" 5 "DK" 6 "EE" 7 "FI" 8 "FR" 9 "DE" 10 "HU" ///
	11 "IE" 12 "IL" 13 "JP" 14 "KR" 15 "LV" 16 "LU" 17 "NL" 18 "NZ" 19 "NO" 20 "PL" ///
	21 "SK" 22 "SI" 23 "ES" 24 "SE" 25 "CH" 26 "UK" 27 "US", replace
lab val id id

order id country

destring E, gen(v_2000) force
	lab var v_2000 "Year 2000"
destring F, gen(v_2001) force
	lab var v_2001 "Year 2001"
destring G, gen(v_2002) force
	lab var v_2002 "Year 2002"
destring H, gen(v_2003) force
	lab var v_2003 "Year 2003"
destring I, gen(v_2004) force
	lab var v_2004 "Year 2004"
destring J, gen(v_2005) force
	lab var v_2005 "Year 2005"
destring K, gen(v_2006) force
	lab var v_2006 "Year 2006"
destring L, gen(v_2007) force
	lab var v_2007 "Year 2007"
destring M, gen(v_2008) force
	lab var v_2008 "Year 2008"
destring N, gen(v_2009) force
	lab var v_2009 "Year 2009"
destring O, gen(v_2010) force
	lab var v_2010 "Year 2010"
destring P, gen(v_2011) force
	lab var v_2011 "Year 2011"
destring Q, gen(v_2012) force
	lab var v_2012 "Year 2012"
destring R, gen(v_2013) force
	lab var v_2013 "Year 2013"
destring S, gen(v_2014) force
	lab var v_2014 "Year 2014"
destring T, gen(v_2015) force
	lab var v_2015 "Year 2015"
destring U, gen(v_2016) force
	lab var v_2016 "Year 2016"
destring V, gen(v_2017) force
	lab var v_2017 "Year 2017"

drop E F G H I J K L M N O P Q R S T U V
	
********************************************************************************

***Imputation of 2014 values -> No missings

***Imputation of 2015 values

mi set w																		
mi register imputed v_2015									

mi impute pmm v_2015 v_2014, add(20) replace dots knn(1) rseed(24)

***Replace of missing 2015 values

mi est: mean v_2015, over(id)

gen m_v_2015 = (_1_v_2015 + _2_v_2015 + _3_v_2015 + _4_v_2015 + _5_v_2015 + _6_v_2015 ///
				+ _7_v_2015 + _8_v_2015 + _9_v_2015 + _10_v_2015 + _11_v_2015 + _12_v_2015 ///
				+ _13_v_2015 + _14_v_2015 + _15_v_2015 + _16_v_2015 + _17_v_2015 ///
				+ _18_v_2015 + _19_v_2015 + _20_v_2015)/20
				
mean m_v_2015, over(id)	// Exactly the same as means obtained of imputation				
				
replace v_2015 = m_v_2015 if v_2015 == .

mi unregister v_2015

***Imputation of 2016 values
																		
mi register imputed v_2016									

mi impute pmm v_2016 v_2015, add(20) replace dots knn(1) rseed(24)								

***Replace of missing 2016 values

mi est: mean v_2016, over(id)
gen m_v_2016 = (_1_v_2016 + _2_v_2016 + _3_v_2016 + _4_v_2016 + _5_v_2016 + _6_v_2016 ///
				+ _7_v_2016 + _8_v_2016 + _9_v_2016 + _10_v_2016 + _11_v_2016 + _12_v_2016 ///
				+ _13_v_2016 + _14_v_2016 + _16_v_2016 + _16_v_2016 + _17_v_2016 ///
				+ _18_v_2016 + _19_v_2016 + _20_v_2016)/20
replace v_2016 = m_v_2016 if v_2016 == .

mi unregister v_2016

********************************************************************************

*Clean up

keep id country v_2014 v_2015 v_2016

********************************************************************************

*Generate Overall mean for cluster analysis

egen LTC_he = rowmean(v_2014 v_2015 v_2016)
lab var LTC_he "LTC expenditure health (Mean 2014-2016)"		
	
********************************************************************************	

save "$data\LTCT_LTC_he.dta", replace

********************************************************************************
********************************************************************************
********************************************************************************

*II: LTC recipients beds

clear all

import excel "$data\20200116_coelcare_ma_Typology_Indicators_Data.xlsx", sheet("LTC residental beds") firstrow

br

*Generate and label vars

drop if A == ""
encode A, gen(country)
	lab var country "Country"
drop B xmlversion10encodingut D X Y Z A*

*Drop of countries with missing data

drop if country == 2 |country == 5 | country == 12 | country == 14 | 	///
		country == 17 | country == 21 | country == 23 | country == 28 | ///
		country == 34 														

*Gen new id var

gen id = _n
label def id ///
	1 "AU" 2 "BE" 3 "CA" 4 "CZ" 5 "DK" 6 "EE" 7 "FI" 8 "FR" 9 "DE" 10 "HU" ///
	11 "IE" 12 "IL" 13 "JP" 14 "KR" 15 "LV" 16 "LU" 17 "NL" 18 "NZ" 19 "NO" 20 "PL" ///
	21 "SK" 22 "SI" 23 "ES" 24 "SE" 25 "CH" 26 "UK" 27 "US", replace
lab val id id

order id country

destring F, gen(v_2000) force
	lab var v_2000 "Year 2000"
destring G, gen(v_2001) force
	lab var v_2001 "Year 2001"
destring H, gen(v_2002) force
	lab var v_2002 "Year 2002"
destring I, gen(v_2003) force
	lab var v_2003 "Year 2003"
destring J, gen(v_2004) force
	lab var v_2004 "Year 2004"
destring K, gen(v_2005) force
	lab var v_2005 "Year 2005"
destring L, gen(v_2006) force
	lab var v_2006 "Year 2006"
destring M, gen(v_2007) force
	lab var v_2007 "Year 2007"
destring N, gen(v_2008) force
	lab var v_2008 "Year 2008"
destring O, gen(v_2009) force
	lab var v_2009 "Year 2009"
destring P, gen(v_2010) force
	lab var v_2010 "Year 2010"
destring Q, gen(v_2011) force
	lab var v_2011 "Year 2011"
destring R, gen(v_2012) force
	lab var v_2012 "Year 2012"
destring S, gen(v_2013) force
	lab var v_2013 "Year 2013"
destring T, gen(v_2014) force
	lab var v_2014 "Year 2014"
destring U, gen(v_2015) force
	lab var v_2015 "Year 2015"
destring V, gen(v_2016) force
	lab var v_2016 "Year 2016"
destring W, gen(v_2017) force
	lab var v_2017 "Year 2017"

drop E F G H I J K L M N O P Q R S T U V W

********************************************************************************

***Imputation of 2014 values

mi set w																		
mi register imputed v_2014									

mi impute pmm v_2014 v_2013, add(20) replace dots knn(1) rseed(24)

***Replace of missing 2015 values

mi est: mean v_2014, over(id)

gen m_v_2014 = (_1_v_2014 + _2_v_2014 + _3_v_2014 + _4_v_2014 + _5_v_2014 + _6_v_2014 ///
				+ _7_v_2014 + _8_v_2014 + _9_v_2014 + _10_v_2014 + _11_v_2014 + _12_v_2014 ///
				+ _13_v_2014 + _14_v_2014 + _15_v_2014 + _16_v_2014 + _17_v_2014 ///
				+ _18_v_2014 + _19_v_2014 + _20_v_2014)/20		
				
replace v_2014 = m_v_2014 if v_2014 == .

mi unregister v_2014

***Imputation of 2015 values

mi set w																		
mi register imputed v_2015									

mi impute pmm v_2015 v_2014, add(20) replace dots knn(1) rseed(24)

***Replace of missing 2015 values

mi est: mean v_2015, over(id)

gen m_v_2015 = (_1_v_2015 + _2_v_2015 + _3_v_2015 + _4_v_2015 + _5_v_2015 + _6_v_2015 ///
				+ _7_v_2015 + _8_v_2015 + _9_v_2015 + _10_v_2015 + _11_v_2015 + _12_v_2015 ///
				+ _13_v_2015 + _14_v_2015 + _15_v_2015 + _16_v_2015 + _17_v_2015 ///
				+ _18_v_2015 + _19_v_2015 + _20_v_2015)/20
				
mean m_v_2015, over(id)		
				
replace v_2015 = m_v_2015 if v_2015 == .

mi unregister v_2015

***Imputation of 2016 alues
																		
mi register imputed v_2016									

mi impute pmm v_2016 v_2015, add(20) replace dots knn(1) rseed(24)								

***Replace of missing 2016 values

mi est: mean v_2016, over(id)
gen m_v_2016 = (_1_v_2016 + _2_v_2016 + _3_v_2016 + _4_v_2016 + _5_v_2016 + _6_v_2016 ///
				+ _7_v_2016 + _8_v_2016 + _9_v_2016 + _10_v_2016 + _11_v_2016 + _12_v_2016 ///
				+ _13_v_2016 + _14_v_2016 + _16_v_2016 + _16_v_2016 + _17_v_2016 ///
				+ _18_v_2016 + _19_v_2016 + _20_v_2016)/20
replace v_2016 = m_v_2016 if v_2016 == .

mi unregister v_2016

********************************************************************************	
		
*Clean up

keep id country v_2014 v_2015 v_2016

********************************************************************************

*Generate Overall mean for cluster analysis

egen LTC_beds = rowmean(v_2014 v_2015 v_2016)		
lab var LTC_beds "LTC beds (Mean 2014-2016)"

********************************************************************************	

save "$data\LTCT_LTC_beds.dta", replace

********************************************************************************
********************************************************************************
********************************************************************************

*III: LTC recipients institutions

clear all

import excel "$data\20200116_coelcare_ma_Typology_Indicators_Data.xlsx", sheet("LTC recipients institutions") firstrow

br

*Generate and label vars

drop if A == ""
encode A, gen(country)
	lab var country "Country"
drop B xmlversion10encodingut D X Y Z A*

*Drop of countries with missing data

drop if country == 2 |country == 5 | country == 12 | country == 14 | 	///
		country == 17 | country == 21 | country == 23 | country == 28 | ///
		country == 34 																

*Gen new id var

gen id = _n
label def id ///
	1 "AU" 2 "BE" 3 "CA" 4 "CZ" 5 "DK" 6 "EE" 7 "FI" 8 "FR" 9 "DE" 10 "HU" ///
	11 "IE" 12 "IL" 13 "JP" 14 "KR" 15 "LV" 16 "LU" 17 "NL" 18 "NZ" 19 "NO" 20 "PL" ///
	21 "SK" 22 "SI" 23 "ES" 24 "SE" 25 "CH" 26 "UK" 27 "US", replace
lab val id id

order id country

destring F, gen(v_2000) force
	lab var v_2000 "Year 2000"
destring G, gen(v_2001) force
	lab var v_2001 "Year 2001"
destring H, gen(v_2002) force
	lab var v_2002 "Year 2002"
destring I, gen(v_2003) force
	lab var v_2003 "Year 2003"
destring J, gen(v_2004) force
	lab var v_2004 "Year 2004"
destring K, gen(v_2005) force
	lab var v_2005 "Year 2005"
destring L, gen(v_2006) force
	lab var v_2006 "Year 2006"
destring M, gen(v_2007) force
	lab var v_2007 "Year 2007"
destring N, gen(v_2008) force
	lab var v_2008 "Year 2008"
destring O, gen(v_2009) force
	lab var v_2009 "Year 2009"
destring P, gen(v_2010) force
	lab var v_2010 "Year 2010"
destring Q, gen(v_2011) force
	lab var v_2011 "Year 2011"
destring R, gen(v_2012) force
	lab var v_2012 "Year 2012"
destring S, gen(v_2013) force
	lab var v_2013 "Year 2013"
destring T, gen(v_2014) force
	lab var v_2014 "Year 2014"
destring U, gen(v_2015) force
	lab var v_2015 "Year 2015"
destring V, gen(v_2016) force
	lab var v_2016 "Year 2016"
destring W, gen(v_2017) force
	lab var v_2017 "Year 2017"

drop E F G H I J K L M N O P Q R S T U V W

********************************************************************************

***Imputation of 2014 values -> No missings

***Imputation of 2015 values

mi set w																		
mi register imputed v_2015									

mi impute pmm v_2015 v_2014, add(20) replace dots knn(1) rseed(24)

***Replace of missing 2015 values

mi est: mean v_2015, over(id)

gen m_v_2015 = (_1_v_2015 + _2_v_2015 + _3_v_2015 + _4_v_2015 + _5_v_2015 + _6_v_2015 ///
				+ _7_v_2015 + _8_v_2015 + _9_v_2015 + _10_v_2015 + _11_v_2015 + _12_v_2015 ///
				+ _13_v_2015 + _14_v_2015 + _15_v_2015 + _16_v_2015 + _17_v_2015 ///
				+ _18_v_2015 + _19_v_2015 + _20_v_2015)/20		
				
replace v_2015 = m_v_2015 if v_2015 == .

mi unregister v_2015

***Imputation of 2016 values
																		
mi register imputed v_2016									

mi impute pmm v_2016 v_2015, add(20) replace dots knn(1) rseed(24)								

***Replace of missing 2016 values

mi est: mean v_2016, over(id)
gen m_v_2016 = (_1_v_2016 + _2_v_2016 + _3_v_2016 + _4_v_2016 + _5_v_2016 + _6_v_2016 ///
				+ _7_v_2016 + _8_v_2016 + _9_v_2016 + _10_v_2016 + _11_v_2016 + _12_v_2016 ///
				+ _13_v_2016 + _14_v_2016 + _16_v_2016 + _16_v_2016 + _17_v_2016 ///
				+ _18_v_2016 + _19_v_2016 + _20_v_2016)/20
replace v_2016 = m_v_2016 if v_2016 == .

mi unregister v_2016

********************************************************************************			
*Clean up

keep id country v_2014 v_2015 v_2016

********************************************************************************

*Generate Overall mean for cluster analysis

egen LTC_inst = rowmean(v_2014 v_2015 v_2016)
lab var LTC_inst "LTC recipients institutions (Mean 2014-2016)"

********************************************************************************	

save "$data\LTCT_LTC_inst.dta", replace

********************************************************************************
********************************************************************************
********************************************************************************

*IV: Share of private exp (health)

clear all

import excel "$data\20200116_coelcare_ma_Typology_Indicators_Data.xlsx", sheet("Share of private exp (health)") firstrow

br

*Generate and label vars

drop if A == ""
encode A, gen(country)
	lab var country "Country"
drop B xmlversion10encodingut D W X Y Z A*

*Drop of countries with missing data

drop if country == 2 |country == 5 | country == 12 | country == 14 | 	///
		country == 17 | country == 21 | country == 23 | country == 28 | ///
		country == 34																

*Gen new id var

gen id = _n
label def id ///
	1 "AU" 2 "BE" 3 "CA" 4 "CZ" 5 "DK" 6 "EE" 7 "FI" 8 "FR" 9 "DE" 10 "HU" ///
	11 "IE" 12 "IL" 13 "JP" 14 "KR" 15 "LV" 16 "LU" 17 "NL" 18 "NZ" 19 "NO" 20 "PL" ///
	21 "SK" 22 "SI" 23 "ES" 24 "SE" 25 "CH" 26 "UK" 27 "US", replace
lab val id id

order id country

destring E, gen(v_2000) force
	lab var v_2000 "Year 2000"
destring F, gen(v_2001) force
	lab var v_2001 "Year 2001"
destring G, gen(v_2002) force
	lab var v_2002 "Year 2002"
destring H, gen(v_2003) force
	lab var v_2003 "Year 2003"
destring I, gen(v_2004) force
	lab var v_2004 "Year 2004"
destring J, gen(v_2005) force
	lab var v_2005 "Year 2005"
destring K, gen(v_2006) force
	lab var v_2006 "Year 2006"
destring L, gen(v_2007) force
	lab var v_2007 "Year 2007"
destring M, gen(v_2008) force
	lab var v_2008 "Year 2008"
destring N, gen(v_2009) force
	lab var v_2009 "Year 2009"
destring O, gen(v_2010) force
	lab var v_2010 "Year 2010"
destring P, gen(v_2011) force
	lab var v_2011 "Year 2011"
destring Q, gen(v_2012) force
	lab var v_2012 "Year 2012"
destring R, gen(v_2013) force
	lab var v_2013 "Year 2013"
destring S, gen(v_2014) force
	lab var v_2014 "Year 2014"
destring T, gen(v_2015) force
	lab var v_2015 "Year 2015"
destring U, gen(v_2016) force
	lab var v_2016 "Year 2016"
destring V, gen(v_2017) force
	lab var v_2017 "Year 2017"

drop E F G H I J K L M N O P Q R S T U V

********************************************************************************

***Imputation of 2014 values -> No missings

***Imputation of 2015 values

mi set w																		
mi register imputed v_2015									

mi impute pmm v_2015 v_2014, add(20) replace dots knn(1) rseed(24)

***Replace of missing 2015 values

mi est: mean v_2015, over(id)

gen m_v_2015 = (_1_v_2015 + _2_v_2015 + _3_v_2015 + _4_v_2015 + _5_v_2015 + _6_v_2015 ///
				+ _7_v_2015 + _8_v_2015 + _9_v_2015 + _10_v_2015 + _11_v_2015 + _12_v_2015 ///
				+ _13_v_2015 + _14_v_2015 + _15_v_2015 + _16_v_2015 + _17_v_2015 ///
				+ _18_v_2015 + _19_v_2015 + _20_v_2015)/20
				
mean m_v_2015, over(id)		
				
replace v_2015 = m_v_2015 if v_2015 == .

mi unregister v_2015

***Imputation of 2016 values
																		
mi register imputed v_2016									

mi impute pmm v_2016 v_2015, add(20) replace dots knn(1) rseed(24)								

***Replace of missing 2016 values

mi est: mean v_2016, over(id)
gen m_v_2016 = (_1_v_2016 + _2_v_2016 + _3_v_2016 + _4_v_2016 + _5_v_2016 + _6_v_2016 ///
				+ _7_v_2016 + _8_v_2016 + _9_v_2016 + _10_v_2016 + _11_v_2016 + _12_v_2016 ///
				+ _13_v_2016 + _14_v_2016 + _16_v_2016 + _16_v_2016 + _17_v_2016 ///
				+ _18_v_2016 + _19_v_2016 + _20_v_2016)/20
replace v_2016 = m_v_2016 if v_2016 == .

mi unregister v_2016

********************************************************************************			
*Clean up

keep id country v_2014 v_2015 v_2016

********************************************************************************

*Generate Overall mean for cluster analysis

egen priv_he = rowmean(v_2014 v_2015 v_2016)
lab var priv_he "Share of private expenditure (Mean 2014-2016)"

********************************************************************************	

save "$data\LTCT_priv_he.dta", replace

********************************************************************************
********************************************************************************
********************************************************************************

*V: Life expectancy

clear all

import excel "$data\20200116_coelcare_ma_Typology_Indicators_Data.xlsx", sheet("Life expectancy") cellrange(D85:X120)

br

*Generate and label vars

encode D, gen(country)
	lab var country "Country"
drop E F

*Drop of countries with missing data

drop if country == 2 |country == 5 | country == 12 | country == 14 | 	///
		country == 17 | country == 21 | country == 23 | country == 28 | ///
		country == 34 																

*Gen new id var

gen id = _n
label def id ///
	1 "AU" 2 "BE" 3 "CA" 4 "CZ" 5 "DK" 6 "EE" 7 "FI" 8 "FR" 9 "DE" 10 "HU" ///
	11 "IE" 12 "IL" 13 "JP" 14 "KR" 15 "LV" 16 "LU" 17 "NL" 18 "NZ" 19 "NO" 20 "PL" ///
	21 "SK" 22 "SI" 23 "ES" 24 "SE" 25 "CH" 26 "UK" 27 "US", replace
lab val id id

order id country

rename G v_2000
	lab var v_2000 "Year 2000"
rename H v_2001
	lab var v_2001 "Year 2001"
rename I v_2002
	lab var v_2002 "Year 2002"
rename J v_2003
	lab var v_2003 "Year 2003"
rename K v_2004
	lab var v_2004 "Year 2004"
rename L v_2005
	lab var v_2005 "Year 2005"
rename M v_2006
	lab var v_2006 "Year 2006"
rename N v_2007
	lab var v_2007 "Year 2007"
rename O v_2008
	lab var v_2008 "Year 2008"
rename P v_2009
	lab var v_2009 "Year 2009"
rename Q v_2010
	lab var v_2010 "Year 2010"
rename R v_2011
	lab var v_2011 "Year 2011"
rename S v_2012
	lab var v_2012 "Year 2012"
rename T v_2013
	lab var v_2013 "Year 2013"
rename U v_2014
	lab var v_2014 "Year 2014"
rename V v_2015
	lab var v_2015 "Year 2015"
rename W v_2016
	lab var v_2016 "Year 2016"
rename X v_2017
	lab var v_2017 "Year 2017"	
	
drop D 

********************************************************************************

***Imputation of 2014 values -> No missings

***Imputation of 2015 values  -> No missings

***Imputation of 2016 values

mi set w																		
mi register imputed v_2016									

mi impute pmm v_2016 v_2015, add(20) replace dots knn(1) rseed(24)								

***Replace of missing 2016 values

mi est: mean v_2016, over(id)
gen m_v_2016 = (_1_v_2016 + _2_v_2016 + _3_v_2016 + _4_v_2016 + _5_v_2016 + _6_v_2016 ///
				+ _7_v_2016 + _8_v_2016 + _9_v_2016 + _10_v_2016 + _11_v_2016 + _12_v_2016 ///
				+ _13_v_2016 + _14_v_2016 + _16_v_2016 + _16_v_2016 + _17_v_2016 ///
				+ _18_v_2016 + _19_v_2016 + _20_v_2016)/20
replace v_2016 = m_v_2016 if v_2016 == .

mi unregister v_2016

********************************************************************************	
		
*Clean up

keep id country v_2014 v_2015 v_2016

********************************************************************************

*Generate Overall mean for cluster analysis

egen life_exp = rowmean(v_2014 v_2015 v_2016)		
lab var life_exp "Life expectancy (Mean 2014-2016)"

********************************************************************************	

save "$data\LTCT_life_exp.dta", replace

********************************************************************************
********************************************************************************
********************************************************************************

*VI: Percieved health status

clear all

import excel "$data\20200116_coelcare_ma_Typology_Indicators_Data.xlsx", sheet("Perceived health status") cellrange(E78:X113)

br

*Generate and label vars

encode E, gen(country)
	lab var country "Country"
drop E F

*Drop of countries with missing data

drop if country == 2 |country == 5 | country == 12 | country == 14 | 	///
		country == 17 | country == 21 | country == 23 | country == 28 | ///
		country == 34 															

*Gen new id var

gen id = _n
label def id ///
	1 "AU" 2 "BE" 3 "CA" 4 "CZ" 5 "DK" 6 "EE" 7 "FI" 8 "FR" 9 "DE" 10 "HU" ///
	11 "IE" 12 "IL" 13 "JP" 14 "KR" 15 "LV" 16 "LU" 17 "NL" 18 "NZ" 19 "NO" 20 "PL" ///
	21 "SK" 22 "SI" 23 "ES" 24 "SE" 25 "CH" 26 "UK" 27 "US", replace
lab val id id

order id country

destring G, gen(v_2000) force
	lab var v_2000 "Year 2000"
destring H, gen(v_2001) force
	lab var v_2001 "Year 2001"
destring I, gen(v_2002) force
	lab var v_2002 "Year 2002"
destring J, gen(v_2003) force
	lab var v_2003 "Year 2003"
destring K, gen(v_2004) force
	lab var v_2004 "Year 2004"
destring L, gen(v_2005) force
	lab var v_2005 "Year 2005"
destring M, gen(v_2006) force
	lab var v_2006 "Year 2006"
destring N, gen(v_2007) force
	lab var v_2007 "Year 2007"
destring O, gen(v_2008) force
	lab var v_2008 "Year 2009"
destring P, gen(v_2009) force
	lab var v_2009 "Year 2009"
destring Q, gen(v_2010) force
	lab var v_2010 "Year 2010"
destring R, gen(v_2011) force
	lab var v_2011 "Year 2011"
destring S, gen(v_2012) force
	lab var v_2012 "Year 2012"
destring T, gen(v_2013) force
	lab var v_2013 "Year 2013"
destring U, gen(v_2014) force
	lab var v_2014 "Year 2014"
destring V, gen(v_2015) force
	lab var v_2015 "Year 2015"
destring W, gen(v_2016) force
	lab var v_2016 "Year 2016"
destring X, gen(v_2017) force
	lab var v_2017 "Year 2017"	

drop G H I J K L M N O P Q R S T U V W X

********************************************************************************

***Imputation of 2014 values

mi set w		
mi register imputed v_2014									

mi impute pmm v_2014 v_2013, add(20) replace dots knn(1) rseed(24)								

***Replace of missing 2014 values

mi est: mean v_2014, over(id)
gen m_v_2014 = (_1_v_2014 + _2_v_2014 + _3_v_2014 + _4_v_2014 + _5_v_2014 + _6_v_2014 ///
				+ _7_v_2014 + _8_v_2014 + _9_v_2014 + _10_v_2014 + _11_v_2014 + _12_v_2014 ///
				+ _13_v_2014 + _14_v_2014 + _16_v_2014 + _16_v_2014 + _17_v_2014 ///
				+ _18_v_2014 + _19_v_2014 + _20_v_2014)/20
replace v_2014 = m_v_2014 if v_2014 == .

mi unregister v_2014

***Imputation of 2015 values

mi set w		
mi register imputed v_2015									

mi impute pmm v_2015 v_2014, add(20) replace dots knn(1) rseed(24)								

***Replace of missing 2015 values

mi est: mean v_2015, over(id)
gen m_v_2015 = (_1_v_2015 + _2_v_2015 + _3_v_2015 + _4_v_2015 + _5_v_2015 + _6_v_2015 ///
				+ _7_v_2015 + _8_v_2015 + _9_v_2015 + _10_v_2015 + _11_v_2015 + _12_v_2015 ///
				+ _13_v_2015 + _14_v_2015 + _16_v_2015 + _16_v_2015 + _17_v_2015 ///
				+ _18_v_2015 + _19_v_2015 + _20_v_2015)/20
replace v_2015 = m_v_2015 if v_2015 == .

mi unregister v_2015

***Imputation of 2016 values
		
mi set w		
mi register imputed v_2016									

mi impute pmm v_2016 v_2015, add(20) replace dots knn(1) rseed(24)								

***Replace of missing 2016 values

mi est: mean v_2016, over(id)
gen m_v_2016 = (_1_v_2016 + _2_v_2016 + _3_v_2016 + _4_v_2016 + _5_v_2016 + _6_v_2016 ///
				+ _7_v_2016 + _8_v_2016 + _9_v_2016 + _10_v_2016 + _11_v_2016 + _12_v_2016 ///
				+ _13_v_2016 + _14_v_2016 + _16_v_2016 + _16_v_2016 + _17_v_2016 ///
				+ _18_v_2016 + _19_v_2016 + _20_v_2016)/20
replace v_2016 = m_v_2016 if v_2016 == .

mi unregister v_2016

********************************************************************************			
*Clean up

keep id country v_2014 v_2015 v_2016

********************************************************************************

*Generate Overall mean for cluster analysis

egen perc_he = rowmean(v_2014 v_2015 v_2016)
lab var perc_he "Percieved health status (Mean 2014-2016)"

********************************************************************************	

save "$data\LTCT_perc_he.dta", replace

********************************************************************************

*VII: Categorical indicators

clear all

import excel "$data\20200116_coelcare_ma_Typology_Indicators_Data.xlsx", sheet("Overview Quali checked") firstrow

br

drop if A == ""

encode B, gen(country)
	lab var country "Country"
	
*Drop of countries with missing data

drop if country == 2 | country == 11 | country == 13 | country == 16 | 	///
		country == 20 | country == 26															

*Gen new id var

gen id = _n
label def id ///
	1 "AU" 2 "BE" 3 "CA" 4 "CZ" 5 "DK" 6 "EE" 7 "FI" 8 "FR" 9 "DE" 10 "HU" ///
	11 "IE" 12 "IL" 13 "JP" 14 "KR" 15 "LV" 16 "LU" 17 "NL" 18 "NZ" 19 "NO" 20 "PL" ///
	21 "SK" 22 "SI" 23 "ES" 24 "SE" 25 "CH" 26 "UK" 27 "US", replace
lab val id id

drop A B Meanstestingforcashbenefit Choiceofmixingcashaninkind ///
			Meanstestingforbenefitsinki Copaymentforresidentialcare Copaymentforhomecare
order id country

destring Choiceofhomecareprovider, gen(home_care)
	drop Choiceofhomecareprovider
destring Choiceofinstitutionalcarepro, gen(inst_care)
	drop Choiceofinstitutionalcarepro
destring Choicebetweencashvsinkind, gen(cash_vs_inkind)
	drop Choicebetweencashvsinkind
destring AvailabilityofCashbenefits, gen(cash_avail)
	drop AvailabilityofCashbenefits
destring Meanstestingforanybenefit, gen(means_any)
	drop Meanstestingforanybenefit
	
foreach var of varlist home_care - means_any  {
	replace `var' = . if `var' == -999
	}

********************************************************************************

compress
save "$data\LTCT_aux.dta", replace

********************************************************************************
****								2. Merge								****
********************************************************************************

clear all
use "$data\LTCT_LTC_he.dta"
keep id LTC_he
save "$data\LTCT_LTC_he_aux.dta", replace

clear all
use "$data\LTCT_priv_he.dta"
keep id priv_he
save "$data\LTCT_priv_he_aux.dta", replace

clear all
use "$data\LTCT_LTC_inst.dta"
keep id LTC_inst
save "$data\LTCT_LTC_inst_aux.dta", replace

clear all
use "$data\LTCT_LTC_beds.dta"
keep id LTC_beds
save "$data\LTCT_LTC_beds_aux.dta", replace

clear all
use "$data\LTCT_life_exp.dta"
keep id life_exp
save "$data\LTCT_life_exp_aux.dta", replace

clear all
use "$data\LTCT_perc_he.dta"
keep id perc_he
save "$data\LTCT_perc_he_aux.dta", replace

clear all
use "$data\LTCT_aux.dta"
	merge 1:1 id using "$data\LTCT_LTC_he_aux.dta"
		drop _merge
	merge 1:1 id using "$data\LTCT_priv_he_aux.dta"
		drop _merge
	merge 1:1 id using "$data\LTCT_LTC_inst_aux.dta"
		drop _merge		
	merge 1:1 id using "$data\LTCT_LTC_beds_aux.dta"
		drop _merge
	merge 1:1 id using "$data\LTCT_life_exp_aux.dta"
		drop _merge
	merge 1:1 id using "$data\LTCT_perc_he_aux.dta"
		drop _merge

order id country LTC_he - perc_he cash_avail home_care - cash_vs_inkind means_any

erase "$data\LTCT_LTC_he.dta"
erase "$data\LTCT_priv_he.dta"
erase "$data\LTCT_LTC_inst.dta"
erase "$data\LTCT_LTC_beds.dta"
erase "$data\LTCT_life_exp.dta"
erase "$data\LTCT_perc_he.dta"
erase "$data\LTCT_LTC_he_aux.dta"
erase "$data\LTCT_priv_he_aux.dta"
erase "$data\LTCT_LTC_inst_aux.dta"
erase "$data\LTCT_LTC_beds_aux.dta"
erase "$data\LTCT_life_exp_aux.dta"
erase "$data\LTCT_perc_he_aux.dta"

********************************************************************************

drop if id == 3 | id == 10
drop id

*Gen final id var

gen id = _n
label def id ///
	1 "AU" 2 "BE" 3 "CZ" 4 "DK" 5 "EE" 6 "FI" 7 "FR" 8 "DE" 9 "IE" 10 "IL" ///
	11 "JP" 12 "KR" 13 "LV" 14 "LU" 15 "NL" 16 "NZ" 17 "NO" 18 "PL" 19 "SK" ///
	20 "SI" 21 "ES" 22 "SE" 23 "CH" 24 "UK" 25 "US", replace
lab val id id

********************************************************************************
****						3. Labeling & Recoding							****
********************************************************************************	

**0/1 coded Variables

*Availability of cash benefits

lab def cash_avail 0 "Only in-kind benefits" 1 "Bound cash benefits" 2 "Unbound cash benefits", replace
lab val cash_avail cash_avail

*Choice of home care provider

lab def home_care 0 "Free choice" 1 "Limited choice", replace
lab val home_care home_care

*Choice of institutional provider

lab def inst_care 0 "Free choice" 1 "Limited choice", replace
lab val inst_care inst_care

*Choice between cash vs inkind

lab def cash_vs_inkind 0 "Free choice" 1 "Limited Choice" 2 "No cash benefit available", replace
lab val cash_vs_inkind cash_vs_inkind

*Means testing for any benefits

lab def means_any 0 "No Means-testing" 1 "Means-testing", replace
lab val means_any means_any

********************************************************************************

compress
save "$data\LTCT.dta", replace
erase "$data\LTCT_aux.dta"

********************************************************************************
