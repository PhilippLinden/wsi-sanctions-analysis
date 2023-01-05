local varlist = "single1 average1 average2 centroid1 centroid2 wards1 wards2 single3 average3 average4 centroid3 centroid4 wards3 wards4 single5 average5 average6 centroid5 wards5 wards6 single7 centroid7 centroid8 wards7 wards8"
foreach var in `varlist' {
*tabstat exp_hc_cap prof_gp exp_gov_share exp_oop_share rem_sp ///
*	exp_outp_cur_share gpsprat prev_tobacco prev_alcohol ///
*	access_sum  choice costshare_gp quality_sum, by(`var')

anova exp_hc_cap i.`var'	
}


gen clustsol1 = .
recode clustsol1 (.=1) if country=="Australia" | country=="Ireland"
recode clustsol1 (.=2) if country=="Austria" | country=="Belgium" | country=="France" | country=="Germany" | country=="Luxembourg"
recode clustsol1 (.=3) if country=="Estonia " | country=="Hungary" | country=="Poland" | country=="Slovakia"
recode clustsol1 (.=4) if country=="Czech Republic " | country=="Slovenia"
recode clustsol1 (.=5) if country=="Switzerland" | country=="USA"
recode clustsol1 (.=6) if country=="Canada" | country=="Denmark" | country=="Italy" | country=="Netherlands" | country=="United Kingdom"
recode clustsol1 (.=7) if country=="Finland" | country=="Iceland" | country=="Japan" | country=="Norway" | country=="New Zealand" | country=="Sweden"
recode clustsol1 (.=8) if country=="Korea" 
recode clustsol1 (.=9) if country=="Portugal" 
recode clustsol1 (.=10) if country=="Spain" 


tabstat exp_hc_cap prof_gp exp_gov_share exp_oop_share rem_sp ///
	exp_outp_cur_share gpsprat prev_tobacco prev_alcohol ///
	access_sum  choice costshare_gp quality_sum, by(clustsol1)




tab clustsol1,m


