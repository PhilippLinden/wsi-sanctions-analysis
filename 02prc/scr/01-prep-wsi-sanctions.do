/*==============================================================================
File name: 		00-master-wsi-sanctions.do
Task:			WSI Sanctions - Preparation file
Project:		MEPYSO
Version:		Stata 16.1
Author:			Philipp Linden
Last update:	2022-10-11
==============================================================================*/
/*------------------------------------------------------------------------------
Content:

# 1. Import data
# 2. Data preparation
#	2.1 Identifiers	
#	2.2 Vignette characteristics
#	2.3 Respondent characteristics
#	2.4 Scales/Answers
#	2.5 Global scales (Medicalization/Social desirability)
#	2.6 Final order, label and save of cleaned dataset
# 3. Export of open answers to excel
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Notes:

------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
#1 Import data
------------------------------------------------------------------------------*/

clear all
use "C:\Users\Linden\Desktop\vig_mepyso\01-rdata-vig-mepyso\vig-mepyso-2w-raw"

/*------------------------------------------------------------------------------
#2 Data preparation
------------------------------------------------------------------------------*/

* drop of unneccessary variables
		
drop fe* ke* gl* ag* inf* st_* tr* con* to* weight20 weight_total al_court-al_em ///
		r_birth_y r_birth_m r_educ_school r_educ_voc r_citship sta_wo ///
		r_job r_proftype r_unempl_dur r_children r_birthmonth r_educ_prof r_hhsize hinc
drop if year==2020

rename weight19 weight

* labeling

lab var al_vig_name "V: Name der Person, die arbeitslos ist"
lab def al_vig_name_de 1 "Hr. Bergmann" 2 "Hr. Yildirim"
lab val al_vig_name al_vig_name_de

lab var al_vig_age "V: Alter der Person, die arbeitslos ist"
lab def al_vig_age_de 1 "25" 2 "40" 3 "60", replace
lab val al_vig_age al_vig_age_de

lab var al_vig_reason "V: Begründung für Arbeitslosigkeit"
lab def al_vig_reason_de 1 "Persönliches Fehlverhalten" 2 "Zahlungsunfähigkeit des Arbeitgebers" 3 "Chronische Rückenschmerzen" 4 "Depression"
lab val al_vig_reason al_vig_reason_de

lab var al_vig_motivation "V: Motivation"
lab def al_vig_motivation_de 1 "Gering" 2 "Hoch"
lab val al_vig_motivation al_vig_motivation_de

lab var al_vig_children "V: Kinder"
lab def al_vig_children_de 1 "Single, keine Kinder" 2 "Verheiratet, keine Kinder" 3 "Verheiratet, 3-jähriges Kind"
lab val al_vig_children al_vig_children_de

lab var al_vig_appointment "V: Verpasste Termine"
lab def al_vig_appointment_de 1 "1. Mal" 2 "2. Mal"
lab val al_vig_appointment al_vig_appointment_de

lab def vig_lab_al_DE ///
	1 "Z/Y/20/G/V/2" 	2 "D/B/40/G/V/1" 	3 "P/Y/20/G/S/2" 	4 "P/B/60/G/S/2" 	5 "P/Y/40/H/V/2"	///
	6 "C/Y/60/H/S/2" 	7 "Z/B/20/H/V/1" 	8 "Z/Y/20/H/Vk/1"	9 "D/B/60/H/V/1" 	10 "C/Y/20/H/V/2"	///
	11 "Z/Y/20/H/V/1" 	12 "C/Y/40/G/S/1"	13 "Z/B/40/H/S/1" 	14 "Z/Y/40/G/S/1"	15 "D/Y/40/H/V/2"	///
	16 "P/B/60/H/Vk/1" 	17 "D/Y/60/G/V/2" 	18 "C/B/40/H/V/2" 	19 "Z/B/60/H/V/1" 	20 "D/Y/40/G/V/1"	///
	21 "C/B/60/H/S/1" 	22 "C/Y/20/H/Vk/2" 	23 "P/B/20/H/Vk/1"	24 "C/Y/20/H/V/1" 	25 "C/Y/40/G/S/2"	///
	26 "C/Y/20/H/S/1" 	27 "P/B/60/H/S/2"	28 "C/B/60/G/S/2" 	29 "D/Y/40/H/V/1" 	30 "P/B/60/G/S/1"	///
	31 "P/Y/40/H/S/2" 	32 "P/B/20/G/V/1"	33 "Z/Y/60/H/Vk/1" 	34 "C/B/40/G/Vk/2" 	35 "D/B/20/H/V/2"	///
	36 "D/B/40/G/Vk/1"	37 "D/Y/40/H/S/1" 	38 "D/Y/20/H/S/1" 	39 "P/Y/20/H/S/2" 	40 "P/B/40/G/V/2"	///
	41 "Z/Y/20/G/S/1" 	42 "P/B/40/G/S/2"	43 "D/B/40/G/S/2" 	44 "D/B/40/H/V/2"	45 "D/Y/20/H/V/2"	///
	46 "P/B/20/G/V/2" 	47 "D/B/20/H/Vk/1" 	48 "D/B/20/H/V/1" 	49 "Z/Y/20/G/Vk/2" 	50 "C/Y/60/G/Vk/1"	///
	51 "Z/Y/60/H/S/1" 	52 "C/Y/60/G/S/2"	53 "D/B/20/H/Vk/2" 	54 "P/B/20/G/S/2" 	55 "Z/Y/60/H/S/2"	///
	56 "C/B/40/H/Vk/2" 	57 "C/B/60/H/Vk/1" 	58 "C/Y/60/H/Vk/1" 	59 "D/Y/40/H/Vk/2"	60 "D/Y/40/G/V/2"	///
	61 "Z/B/20/G/S/2" 	62 "P/B/60/H/Vk/2" 	63 "P/Y/20/G/Vk/1" 	64 "C/B/40/H/S/2" 	65 "P/Y/20/H/S/1"	///
	66 "Z/B/20/G/Vk/2"	67 "Z/Y/20/G/Vk/1" 	68 "C/B/40/H/Vk/1" 	69 "Z/B/20/G/Vk/1"	70 "C/B/20/G/S/2"	///
	71 "C/Y/40/H/V/2" 	72 "P/Y/40/G/V/2"	73 "C/B/60/H/V/1" 	74 "D/B/20/G/S/2"	75 "C/Y/60/G/V/2"	///
	76 "P/Y/40/H/S/1" 	77 "Z/B/20/H/S/1"	78 "Z/Y/40/H/V/1" 	79 "P/Y/60/H/V/1"	80 "Z/B/20/G/S/1"	///
	81 "D/Y/40/G/S/2"	82 "P/Y/40/H/V/1"	83 "D/Y/20/G/Vk/2"	84 "P/B/60/G/V/2"	85 "D/Y/60/G/S/2"	///
	86 "D/B/20/G/V/1"	87 "D/Y/40/G/Vk/1"	88 "D/B/60/G/Vk/1"	89 "P/Y/60/H/S/2"	90 "P/Y/60/H/V/2"	///
	91 "P/Y/40/G/Vk/1"	92 "Z/B/40/G/V/2"	93 "Z/B/20/H/V/2"	94 "Z/B/60/H/S/2"	95 "Z/Y/60/G/V/1"	///
	96 "P/Y/40/G/S/1"	97 "P/Y/40/G/S/2"	98 "P/B/20/H/S/2"	99 "D/Y/20/G/Vk/1"	100 "D/B/40/H/Vk/1"	///
	101 "C/Y/40/G/V/2"	102 "Z/B/40/G/Vk/2"	103 "C/Y/20/G/V/1"	104 "Z/Y/20/H/Vk/2"	105 "D/B/20/H/S/2"	///
	106 "P/B/60/G/Vk/1"	107 "C/B/20/G/V/1"	108 "P/Y/40/G/V/1"	109 "P/Y/20/H/Vk/1"	110 "D/Y/40/H/Vk/1"	///
	111 "P/B/60/H/V/1"	112 "D/B/60/G/V/2"	113 "Z/Y/60/H/V/1"	114 "C/Y/20/G/V/2"	115 "D/B/40/G/Vk/2"	///
	116 "P/B/40/G/Vk/1"	117 "P/B/20/H/S/1"	118 "C/B/40/G/Vk/1"	119 "Z/Y/20/G/V/1"	120 "Z/B/40/H/V/2"	///
	121 "D/B/60/H/S/2"	122 "C/Y/20/G/Vk/1"	123 "Z/B/40/H/S/2"	124 "C/Y/20/H/Vk/1"	125 "C/B/20/H/S/2"	///
	126 "Z/B/60/G/S/1"	127 "Z/B/40/G/V/1"	128 "C/B/60/G/V/2"	129 "Z/B/40/G/S/2"	130 "P/Y/40/G/Vk/2" ///
	131 "P/Y/60/G/V/1"	132 "C/B/60/G/Vk/1"	133 "P/B/20/H/V/1"	134 "D/Y/20/G/V/2"	135 "C/B/20/G/S/1"	///
	136 "D/Y/60/G/V/1"	137 "D/B/40/H/V/1"	138 "Z/B/60/H/S/1"	139 "D/Y/20/G/S/1"	140 "P/B/40/G/V/1"	///
	141 "C/Y/60/G/S/1"	142 "D/Y/20/H/V/1"	143 "Z/Y/40/H/Vk/1"	144 "P/B/40/G/S/1"	145 "P/Y/60/G/S/1"	///
	146 "C/B/20/H/Vk/1"	147 "C/Y/40/H/V/1"	148 "Z/Y/40/H/S/1"	149 "Z/B/60/H/Vk/2"	150 "C/B/60/H/V/2"	///
	151 "P/Y/60/G/S/2"	152 "C/Y/40/G/Vk/1"	153 "C/Y/40/H/S/2"	154 "D/B/40/G/S/1"	155 "D/Y/40/G/S/1"	///
	156 "D/B/20/H/S/1"	157 "C/B/60/G/V/1"	158 "D/Y/20/H/S/2"	159 "D/B/60/G/S/2"	160 "Z/Y/40/G/V/2"	///
	161 "D/B/40/H/Vk/2"	162 "D/Y/60/H/Vk/2"	163 "D/B/40/G/V/2"	164 "Z/Y/20/H/S/2"	165 "Z/B/60/G/V/1"	///
	166 "P/B/20/G/S/1"	167 "P/Y/40/H/Vk/2"	168 "P/B/40/H/Vk/1"	169 "P/B/20/H/Vk/2"	170 "C/B/40/G/S/2"	///
	171 "P/B/40/H/V/2"	172 "P/B/60/G/Vk/2"	173 "C/B/20/H/Vk/2"	174 "D/B/60/H/Vk/2"	175 "Z/B/20/H/S/2"	///
	176 "Z/Y/60/G/V/2"	177 "Z/B/40/H/V/1"	178 "Z/B/20/H/Vk/1"	179 "C/Y/60/G/V/1"	180 "P/B/40/H/S/2"	///
	181 "Z/Y/60/G/S/1"	182 "C/B/20/H/S/1"	183 "C/B/20/H/V/1"	184 "D/B/60/H/V/2"	185 "D/B/60/H/S/1"	///
	186 "P/Y/60/G/Vk/2"	187 "C/Y/40/H/Vk/2"	188 "D/B/20/G/Vk/1"	189 "P/B/20/G/Vk/2"	190 "D/B/60/G/V/1"	///
	191 "Z/B/60/G/Vk/1"	192 "P/B/60/H/V/2"	193 "D/B/20/G/S/1"	194 "C/Y/20/G/S/2"	195 "C/Y/40/H/S/1"	///
	196 "Z/Y/60/H/V/2"	197 "Z/Y/40/H/Vk/2"	198 "Z/B/20/G/V/2"	199 "P/B/40/H/S/1"	200 "P/Y/60/H/S/1"	///
	201 "D/Y/60/G/Vk/2"	202 "Z/Y/40/G/Vk/1"	203 "C/B/60/H/S/2"	204 "Z/B/60/H/Vk/1"	205 "Z/B/60/G/Vk/2"	///
	206 "P/Y/20/G/Vk/2"	207 "C/B/20/G/Vk/1"	208 "D/B/40/H/S/2"	209 "Z/Y/20/H/S/1"	210 "P/Y/40/H/Vk/1"	///
	211 "D/Y/60/G/S/1"	212 "P/B/60/H/S/1"	213 "D/B/60/H/Vk/1"	214 "Z/Y/40/G/S/2"	215 "Z/Y/60/G/Vk/1"	///
	216 "P/Y/20/H/V/2"	217 "Z/B/60/H/V/2"	218 "D/B/20/G/Vk/2"	219 "C/Y/40/G/V/1"	220 "C/B/20/G/Vk/2"	///
	221 "Z/Y/20/H/V/2"	222 "D/Y/60/H/V/1"	223 "C/Y/20/G/S/1"	224 "Z/B/60/G/V/2"	225 "C/B/40/H/S/1"	///
	226 "P/Y/60/H/Vk/2"	227 "D/Y/40/H/S/2"	228 "P/Y/20/G/V/1"	229 "D/B/20/G/V/2"	230 "C/Y/60/G/Vk/2"	///
	231 "P/Y/20/H/Vk/2"	232 "Z/B/40/G/Vk/1"	233 "Z/Y/40/H/S/2"	234 "C/Y/60/H/V/1"	235 "D/Y/20/H/Vk/1"	///
	236 "Z/B/40/H/Vk/2"	237 "D/Y/60/H/S/1"	238 "P/Y/20/G/V/2"	239 "P/B/40/G/Vk/2"	240 "P/B/40/H/V/1"	///
	241 "C/Y/60/H/Vk/2"	242 "C/B/20/H/V/2"	243 "C/Y/40/H/Vk/1"	244 "D/B/60/G/S/1"	245 "P/B/20/H/V/2"	///
	246 "D/Y/60/H/S/2"	247 "D/Y/20/H/Vk/2"	248 "Z/Y/60/G/Vk/2"	249 "D/Y/60/H/V/2"	250 "D/B/40/H/S/1"	///
	251 "C/B/40/G/S/1"	252 "Z/B/40/H/Vk/1"	253 "Z/B/20/G/V/1"	254 "C/B/60/H/Vk/2"	255 "P/Y/60/H/Vk/1"	///
	256 "P/Y/20/H/V/1"	257 "C/B/20/G/V/2"	258 "D/Y/60/G/Vk/1"	259 "C/B/60/G/S/1"	260 "P/Y/60/G/V/2"	///
	261 "D/Y/40/G/Vk/2"	262 "C/B/40/G/V/1"	263 "P/Y/20/G/S/1"	264 "Z/Y/60/H/Vk/2"	265 "D/Y/20/G/V/1"	///
	266 "C/B/60/G/Vk/2"	267 "C/B/40/G/V/2"	268 "P/B/20/G/Vk/1"	269 "C/Y/20/G/Vk/2"	270 "Z/Y/60/G/S/2"	///
	271 "Z/Y/20/G/S/2"	272 "Z/Y/40/G/V/1"	273 "P/B/40/H/Vk/2"	274 "D/Y/20/G/S/2"	275 "C/Y/60/H/S/1"	///
	276 "C/Y/60/H/V/2"	277 "C/Y/20/H/S/2"	278 "P/Y/60/G/Vk/1"	279 "P/B/60/G/V/1"	280 "D/Y/60/H/Vk/1"	///
	281 "Z/B/60/G/S/2"	282 "C/B/40/H/V/1"	283 "Z/Y/40/G/Vk/2"	284 "C/Y/40/G/Vk/2"	285 "Z/B/40/G/S/1"	///
	286 "D/B/60/G/Vk/2"	287 "Z/Y/40/H/V/2"	288 "Z/B/20/H/Vk/2", replace
	
lab val deck vig_lab_al_DE

/*------------------------------------------------------------------------------
#2.2 Respondent characteristics
------------------------------------------------------------------------------*/

fre r_*

* gender

recode r_gender (1=0) (2=1)
lab def r_gender 0 "Männlich" 1 "Weiblich", replace
lab val r_gender r_gender
lab var r_gender "R: Geschlecht"

* age

lab var r_age "R: Geburtsjahr"

* age in categories of vignette levels

gen r_age_cat_vig = r_age, after(r_age)
recode r_age_cat_vig (18/39 = 0) (40/60 = 1) (61/100 = 2)
lab def r_age_cat_vig 0 "18-39" 1 "40-60" 2 "60+", replace
lab val r_age_cat_vig r_age_cat_vig
lab var r_age_cat_vig "R: Alter (Vignettenkategorien)"

* residence

lab def r_state 1 "Schleswig-Holstein" 2 "Hamburg" 3 "Niedersachsen" 4 "Bremen" 5 "Nordrhein-Westfalen" ///
				6 "Hessen" 7 "Rheinland-Pfalz" 8 "Baden-Würtemberg" 9 "Bayern" 10 "Saarland" 11 "Berlin" ///
				12 "Brandenburg" 13 "Mecklenburg-Vorpommern" 14 "Sachsen" 15 "Sachsen-Anhalt" 16 "Thüringen", replace
lab val r_state r_state
lab var r_state "R: Bundesland"

gen r_ost = r_state, after(r_state)
recode r_ost (1=0) (2=1)
lab def r_ost 0 "West" 1 "Ost", replace
lab val r_ost r_ost
lab var r_ost "R: Ost-/Westdeutschland"

* education

recode r_educ (1 2=0) (3 4 5=1) (6=2)
lab def r_educ 0 "Gering" 1 "Mittel" 2 "Hoch", replace
lab val r_educ r_educ
lab var r_educ "R: Bildungsniveau"

* political party				
			
recode r_party (8=0) (1=1) (2=2) (4=3) (5=4) (3=5) (6=6) (7=7)
lab def r_party 0 "Keine" 1 "CDU/CSU" 2 "SPD" 3 "Bündnis90/Die Grünen" 4 "FDP" 5 "Die Linke" 6 "AfD" 7 "Andere Partei", replace
lab val r_party r_party
lab var r_party "R: Parteizugehörigkeit"

* left-right

recode r_left_right (-1=.)
lab def r_left_right 0 "links" 10 "rechts", replace
lab val r_left_right r_left_right
lab var r_left_right "R: Pol. Selbsteinschätzung (Links-Rechts)"

* migration status

recode r_mig (2=0)
lab def r_mig 0 "Nein" 1 "Ja", replace
lab val r_mig r_mig
lab var r_mig "R: Migrationshintergrund"

* employment status

recode r_emplstat (1=0) (3=1) (5=2) (4=3) (10=4) (2=5) (8=6) (6=7) (9=8) (777=.)
lab def r_emplstat 0 "Erwerbstätig" 1 "Rente, Pension" 2 "Vermögen, Vermietung, Zinsen" 3 "Angehörige" 4 "Elterngeld/Erziehungsgeld" 5 "ALG I" 6 "ALG II" 7 "Hilfe zum Lebensunterhalt" 8 "Sonstiges (z.B. BAföG)", replace
lab val r_emplstat r_emplstat
lab var r_emplstat "R: Erwerbssituation"

* unemployed

recode r_unempl (2=0) (977=.)
lab def r_unempl 0 "Nein" 1 "Ja", replace
lab val r_unempl r_unempl
lab var r_unempl "R: Arbeitslosigkeit"

* income

recode r_inc (1 13=0) (2=1) (3 4=2) (5 6 =3) (7/12=4) (777=.)
lab def r_inc 0 "unter 500" 1 "500-999" 2 "1.000-1.999" 3 "2.000-2.999" 4 "3.000 und mehr", replace
lab val r_inc r_inc
lab var r_inc "R: Einkommen (in EUR)"

* family status

recode r_famstat (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (777=.)
lab def r_famstat 0 "ledig" 1 "verheiratet" 2 "Lebenspartnerschaft" 3 "mit Partner/in zusammenlebend" 4 "getrennt lebend" 5 "geschieden" 6 "verwitwet", replace
lab val r_famstat r_famstat
lab var r_famstat "R: Familienstand"

* subjective health

recode r_health (1=0) (2=1) (3=2) (4=3) (5=4) (977=.)
lab def r_health 0 "sehr schlecht" 1 "schlecht" 2 "mittelmäßig" 3 "gut" 4 "sehr gut", replace
lab val r_health r_health
lab var r_health "R: Selbst eingeschätzte Gesundheit"

/*------------------------------------------------------------------------------
#2.3 Dependant variables
------------------------------------------------------------------------------*/

lab var al_alg1 "Höhe des zugesprochenen ALG I (%)"

rename al_beha_1 al_beha_none
rename al_beha_2 al_beha_job_seeking
rename al_beha_3 al_beha_further_training
rename al_beha_4 al_beha_move
rename al_beha_5 al_beha_one_euro
rename al_beha_6 al_beha_any_job
rename al_beha_7 al_beha_physical_imp
	recode al_beha_physical_imp (9=.)
rename al_beha_8 al_beha_psychological_imp
	recode al_beha_psychological_imp (9=.)

lab var al_beha_none "Verhalten: Keine Bedingungen"
lab var al_beha_job_seeking "Verhalten: Aktiv um Arbeit bemühen"
lab var al_beha_further_training "Verhalten: Weiterbildungsmaßnahmen"
lab var al_beha_move "Verhalten: Bereitschaft umzuziehen"
lab var al_beha_one_euro "Verhalten: 1-Euro-Job"
lab var al_beha_any_job "Verhalten: Annahme jedes Arbeitsangebotes"
lab var al_beha_physical_imp "Verhalten: Physische Verbesserung (Reha)"
lab var al_beha_psychological_imp "Verhalten: Psychologische Verbesserung"

lab def al_beha_scale 0 "Nein" 1 "Ja", replace									
lab val al_beha_* al_beha_scale

lab var al_alg2 "Höhe des zugesprochenen ALG II (Absolut)"
lab var al_sanction "Kürzung der Grundsicherungsleistung (%)"

/*------------------------------------------------------------------------------
****			2.6 Final order, label and save of cleaned dataset			****
------------------------------------------------------------------------------*/

compress
save $pdta\prep-wsi-sanctions.dta, replace
label data "MEPYSO Factorial Survey data (Deutsch)"

*==============================================================================*
