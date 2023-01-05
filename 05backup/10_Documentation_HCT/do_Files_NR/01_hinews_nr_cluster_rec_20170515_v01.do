/*==============================================================================
File name:    01_hinews_nr_cluster_rec_20170515.do
Task:         Prepares data for cluster analysis                                                   
Project:      Health system typology
Author(s):    Nadine Reibling, Mareike Ariaans                                            
Last update:  2017-05-15                                                                             
==============================================================================*/

/*------------------------------------------------------------------------------ 
Content:

#1 Load data
#2 Reduce to necessary indicators
#3 Final recodes
#4 Label variables
#5 Z-standardization
#6 Quality Scale
#7 Range-standardization
#8 Descriptives Table
#9 Save data
------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------
Notes:

------------------------------------------------------------------------------*/

version 13.1   // Stata version control

/*------------------------------------------------------------------------------
#1 Load data
------------------------------------------------------------------------------*/

clear

import excel "C:\Users\Reibling\Documents\A01_current_projects\2015_HINEWS\2015_healthtyp\10_Data\Final Tables 040117_v03.xlsx", sheet("all data") firstrow

/*------------------------------------------------------------------------------
#2 Reduce to necessary indicators
------------------------------------------------------------------------------*/

drop entitle rem_gp rem_hosp bb_drugs exp_inp_cur_share exp_ltc_cap  ///
	res_mri prev_HIV res_cur_hosp_bed prev_fat AN 

/*------------------------------------------------------------------------------
#3 Final recodes
------------------------------------------------------------------------------*/

**Country variable

encode country,gen(cntry)
label define cntry 1"AU" 2"AT" 3"BE" 4"CA" 5"CZ" 6"DK" 7"EE" 8"FI" 9"FR" ///
					10"DE" 11"HU" 12"IS" 13"IE" 14"IT" 15"JA" 16"KO" 17"LU" ///
					18"NL" 19"NZ" 20"NO" 21"PL" 22"PT" 23"SK" 24"SI" 25"ES" 26"SE" 27"CH" 28"US" 29"UK", modify
					
label value cntry cntry
decode cntry, gen(cntry2)
**Remuneration specialists

recode rem_sp (2=1)
tab rem_sp,m

**GP-to-specialist ratio

gen gpsprat = prof_gp/prof_sp

**Doctor number

gen prof_doc = prof_gp+prof_sp
drop prof_sp

**Access scale

gen access_sum = access_gp_reg + access_sp
tab access_sum, gen(access_d)

drop  access_gp_reg access_sp

**Cost sharing scale

gen costsharesect = 0
recode costsharesect (0=1) if costshare_hosp==1 & (costshare_gp==1 | costshare_sp==1)
tab costsharesect,m
tab costsharesect costshare_hosp,m
tab costsharesect costshare_gp,m
tab costsharesect costshare_sp,m

drop costshare_sp costshare_hosp  costshare_drugs

**Choice scale

gen choice_sum = choice_gp + choice_sp + choice_hosp
clonevar choice = choice_sum 
recode choice (1/3=1)
tab choice_sum choice,m

drop choice_gp choice_sp choice_hosp choice_sum

**Benefit basket
tab bb_med,m

gen bb_poslist = bb_med
recode bb_poslist (1=0) (3/4=0) (2=1)
tab bb_med bb_poslist,m

drop bb_med

**Health Insurance Coverage

tab shi_cov,m
gen fullcov = shi_cov
recode fullcov (100=1) (0/99.9=0)
tab  shi_cov fullcov,m


/*------------------------------------------------------------------------------
#4 Label variables
------------------------------------------------------------------------------*/

**RESOURCES

label variable exp_hc_cap "Resources: HExpenditure per capita"
label variable prof_gp "Resources: Number of GPs per capita"
label variable prof_doc "Resources: Number of doctors per capita"
label variable res_ct "Resources: Number of CT scanners per capita"

**PUBLIC-PRIVATE-MIX
label variable exp_gov_share "Public-Private: Public share, % Hexp"
label variable exp_oop_share "Public-Private: Out-of-pocket, % Hexp"
label variable rem_sp "Public-Private: Remuneration specialists"
label define rem_sp 0"fee-for-service" 1"salary"
label value rem_sp rem_sp

**PREVENTION

label variable prev_tobacco "Prevention: Tobacco consumption"
label variable prev_alcohol "Prevention: Alcohol consumption"
label variable exp_prev_share "Prevention: Expenditure,% of Hexp"

**PRIMARY CARE

label variable exp_outp_cur_share "Primary: Outpatient care, % Hexp"
label variable gpsprat "Primary: GP to Specialist ratio"

**QUALITY

label variable primary_asthma_hosp "Quality: Asthma/COPD admissions"
label variable primary_heart_hosp "Quality: Heart admissions"
label variable primary_diabetes_hosp "Quality Diabetes admissions"
label variable acute_30_infarc "Quality: Infarction mortality"
label variable acute_30_hem_stroke "Quality: Hemorrhagic stroke mortality"
label variable acute_30_isch_stroke "Quality: Ischaemic stroke mortality"

**ACCESS

label variable access_d1 "Access: Access regulation index 0"
label variable access_d2 "Access: Access regulation index 1"
label variable access_d3 "Access: Access regulation index 2"
label variable access_d4 "Access: Access regulation index 3"
label variable access_sum "Access: Access regulation index"
*label variable costshare_d1 "Access: No outpatient/inpatient cost sharing"
*label variable costshare_d2 "Access: Some outpatient cost sharing"
*label variable costshare_d3 "Access: Full outpatient cost sharing"

label variable choice "Access: Choice restrictions (yes/no)"

label variable bb_poslist "Access: Benefit basket (positive list/other)"

label variable costshare_gp "Access: Cost sharing for GP visits"
label variable costsharesect "Acess: Cost sharing for outpatient + inpatient care"

label variable fullcov "Access: Full population coverage"
/*------------------------------------------------------------------------------
#5 Z-Standardization 
------------------------------------------------------------------------------*/

for any exp_hc_cap exp_gov_share prof_gp prof_doc res_ct exp_oop_share exp_outp_cur_share exp_prev_share ///
	prev_tobacco prev_alcohol primary_asthma_hosp primary_heart_hosp ///
	primary_diabetes_hosp acute_30_infarc acute_30_hem_stroke acute_30_isch_stroke gpsprat: egen zX = std(X)


/*------------------------------------------------------------------------------
#6 Quality Scale 
------------------------------------------------------------------------------*/

sum zprimary_asthma_hosp zprimary_heart_hosp zprimary_diabetes_hosp zacute_30_infarc zacute_30_hem_stroke zacute_30_isch_stroke

gen quality_sum = (zprimary_asthma_hosp + zprimary_heart_hosp + zprimary_diabetes_hosp + zacute_30_infarc + zacute_30_hem_stroke + zacute_30_isch_stroke)/6
label variable quality_sum "Quality: Quality summary scale"

tab quality_sum,m

/*------------------------------------------------------------------------------
#7 Descriptives Table
------------------------------------------------------------------------------*/

gen test = exp_oop_share/36.78

for any  exp_hc_cap prof_gp exp_gov_share exp_oop_share rem_sp ///
	exp_outp_cur_share gpsprat prev_tobacco prev_alcohol ///
	access_sum costshare_gp choice  quality_sum: egen X_max = max(X)

for any  exp_hc_cap prof_gp exp_gov_share exp_oop_share rem_sp ///
	exp_outp_cur_share gpsprat prev_tobacco prev_alcohol ///
	access_sum costshare_gp choice  quality_sum: gen rX = X/X_max
	
/*------------------------------------------------------------------------------
#8 Descriptives Table
------------------------------------------------------------------------------*/

vardesc exp_hc_cap exp_hc_cap prof_gp exp_gov_share exp_oop_share rem_sp ///
	exp_outp_cur_share gpsprat prev_tobacco prev_alcohol ///
	access_sum costshare_gp choice  quality_sum, optimize

/*------------------------------------------------------------------------------
#9 Save Data
------------------------------------------------------------------------------*/

cd "C:\Users\Reibling\Documents\A01_current_projects\2015_HINEWS\2015_healthtyp\10_Data"

save hinews_nr_cluster_rec03.dta, replace

*==============================================================================*/

