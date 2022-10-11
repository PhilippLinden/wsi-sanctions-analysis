/*==============================================================================
File name: 		00-master-wsi-sanctions.do
Task:			WSI Sanctions - Master file
Project:		MEPYSO
Version:		Stata 16.1
Author:			Philipp Linden
Last update:	2022-10-11
==============================================================================*/

/*------------------------------------------------------------------------------ 
Content:

#1 Installs ado files used in the analysis
#2 Stata Settings
#3 Defines globals and set up folder structure
#4 Specifies order and task of code files and runs them
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Notes:

------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
#1 Install ado files                                                         
------------------------------------------------------------------------------*/

ssc install plotplain, all replace												// Blind and colorblind scheme for graphs
*ssc install [ado], all replace													// [DESCRIBE]

/*------------------------------------------------------------------------------
#2 Stata settings
------------------------------------------------------------------------------*/

version 16.1          // Stata version control
clear all             // clear memory
macro drop _all       // delete all macros
set linesize 82       // result window has room for 82 chars in one line
set more off, perm    // prevents pause in results window
set scheme plotplain  // sets color scheme for graphs
set maxvar 32767      // size of data matrix

/*------------------------------------------------------------------------------
#3 Define globals and set up folder structure
------------------------------------------------------------------------------*/

* working directory 

* -> Retrieve c(username) by typing disp "`c(username)'" in command line

if "`c(username)'" == "INSERT c(USERNAME) here" {
	global wdir "INSERT PATH HERE"
}

* main folder

global main		"${wdir}"						// main analysis folder

* sub-folders

global rdata	"${main}//01src/rdata"			// raw data
global pdata	"${main}//02prc/pdta"			// processed data
global code		"${main}//02prc/scr"			// code files
global plot		"${main}//03doc/fig"			// figures
global text		"${main}//03doc/tab"			// logfiles + tables
global cbook	"${main}//03doc/var"			// codebooks


/*------------------------------------------------------------------------------
#4 Specify name, task and sequence of code files to run
------------------------------------------------------------------------------*/

/// ------ Project-Do-Files *

*do "[do-file]"    				// [DESCRIPTION]

*==============================================================================*
