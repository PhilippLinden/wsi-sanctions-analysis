/*******************************************************************************

File name: 		1_LTCT_Master.do
Task:			Cluster Analysis - Master
Project:		Long-term-care Typology
Version:		Stata 16
Author:			Philipp Linden/Mareike Ariaans
Last update:	2020-05-05

********************************************************************************

Content:
# 1. Settings
# 2. Directory
# 3. Needed Stata Ados

*******************************************************************************/

*Settings
version 16																	// You may change the version
clear all
set more off
cap log close
set maxvar 32676, perm
set matsize 11000, perm

*Directory: Define person specific path under "PATH"
*You have to create folders according to the data structure, except global files: Here use the Sciebo path!

*Philipp

/*
cd 				"C:\Users\Linden\sciebo\LTCT_Mareike_Ariaans\Analyses\" 					
global data 	"C:\Users\Linden\sciebo\LTCT_Mareike_Ariaans\Analyses\datasets"
global files 	"C:\Users\Linden\sciebo\LTCT_Mareike_Ariaans\Analyses\do_files"
global output	"C:\Users\Linden\sciebo\LTCT_Mareike_Ariaans\Analyses\output"
global graphs	"C:\Users\Linden\sciebo\LTCT_Mareike_Ariaans\Analyses\graphs_tables"	

*Philipp(Tower)

cd 				"C:\Users\Anima\sciebo\LTCT_Mareike_Ariaans\1_Analyses\" 					
global data 	"C:\Users\Anima\sciebo\LTCT_Mareike_Ariaans\1_Analyses\datasets"
global files 	"C:\Users\Anima\sciebo\LTCT_Mareike_Ariaans\1_Analyses\do_files"
global output	"C:\Users\Anima\sciebo\LTCT_Mareike_Ariaans\1_Analyses\output"
global graphs	"C:\Users\Anima\sciebo\LTCT_Mareike_Ariaans\1_Analyses\graphs_tables"	

********************************************************************************
*Needed Stata .ados

ssc install sumdist, all replace
ssc install pshare, all replace
ssc install coefplot, all replace
ssc install missing, all replace
ssc install catplot, all replace
ssc install fre, all replace
capture net install listtab, from(http://fmwww.bc.edu/RePEc/bocode/l)
ssc install how_many_imputations, all replace
ssc install mipolate, all replace
capture net install collin, from(https://stats.idre.ucla.edu/stat/stata/ado/analysis)

********************************************************************************/
