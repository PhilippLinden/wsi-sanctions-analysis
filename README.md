*When starting a new project, fill in the square brackets, upload (raw) dataset, and scripts and DELETE THIS LINE!*

# [Title]

## Abstract

[Abstract]

----

### History

`[TODAY]`
:  Setup

---

### Directories

`/01src`
:  Source materials, raw data

`/02prc`
:  Processed data and analytical scripts (possibly in subfolders)

`/03dok`
:  Documentation and output incl. figures and tables

---

### Description

This repository contains the code for the analysis in the paper entitled "[TITLE]" which is published in the [JOURNAL](link). The main analytical results can be found in the `analysis.html` file. This file can be downloaded and opened in any browser or it can be viewed online [here](link).

The data for this analysis comes from [...]. The raw data set is available [here](DOI).

---

### Replication instruction

All analysis were done in Stata [version number] and under Windows [version number]. Please follow the steps listed below to reproduce findings:

1. Fork the repository / Sync fork if necessary
2. Open and read the file `master.do` in Stata from the directory `input`
    - In this file, adapt the global wdir as specified
3. Run the file `master.do` in the `input` folder
4. See the output directories `/03doc/fig` and `03doc/tab`for output
