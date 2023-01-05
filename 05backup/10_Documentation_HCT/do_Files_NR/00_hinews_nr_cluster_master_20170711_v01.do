/*==============================================================================
File name:    01_hinews_nr_cluster_rec_20170515.do
Task:         Prepares data for cluster analysis                                                   
Project:      Health system typology
Author(s):    Nadine Reibling, Mareike Ariaans                                            
Last update:  2017-07-11                                                                             
==============================================================================*/


/*------------------------------------------------------------------------------ 
Content:

#1 installs ado files used in the analysis
#2 specifies directories in globals
#3 specifies order and task of code files and runs them
------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------
Notes:
  
------------------------------------------------------------------------------*/

version 13.1          // Stata version control

clear all             // clear memory

macro drop _all       // delete all macros

set linesize 82       // result window has room for 82 chars in one line

set more off, perm    // prevents pause in results window

set matsize 1000      // size of data matrix


/*------------------------------------------------------------------------------
#1 Install ado files                                                         
------------------------------------------------------------------------------*/

* vardesc
*ssc install vardesc, replace


/*------------------------------------------------------------------------------
#2 Specify folder directories
------------------------------------------------------------------------------*/

* clear memory
clear all 


* working directory (specify your own path for replication)
global wdir "C:\Users\Reibling\Documents\A01_current_projects\2015_HINEWS\2015_healthtyp"


* directory for original data (use instead commented path below for replication)
global origdat "${wdir}/10_Data\raw"
*global origdat  "${wdir}/data/original"


* subfolders in work directory
global analysis  "${wdir}/1_Analysis"           // for code files
global prepdat   "${wdir}/10_Data"      		// for prepared data
global tables    "${wdir}/2_Results/tables"     // for tables
global graphs    "${wdir}/2_Results/figures"    // for figures


/*------------------------------------------------------------------------------
#3 Specify name, task and sequence of code files to run
------------------------------------------------------------------------------*/

do "${analysis}/01_hinews_nr_cluster_rec_20170711_v01"        // Recodes of dataset 

do "${analysis}/02_hinews_nr_cluster_ana01_20170515_v01"      // Cluster analyses

do "${analysis}/03_hinews_nr_cluster_des_20170525_v01"        // Description/validation of results

do "${analysis}/04_hinews_nr_cluster_rob_20170327_v01"        // Robustness checks



*==============================================================================*
