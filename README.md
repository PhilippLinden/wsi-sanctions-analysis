# How much money is appropriate? A vignette study on the acceptance of sanctions in SGB II

## Abstract

Since the reforms of the Social Code Book II in 2004/05, sanctions in the minimum income system have been considered a central pillar of the activating welfare state. However, in terms of social policy, it is often debated whether sanctions are generally permissible, since those affected then live (temporarily) below the socio-cultural subsistence level. In addition, the Federal Constitutional Court classified cuts above 30 % of the minimum income benefits as unconstitutional in 2019 and called for a reform process. A broad public acceptance of the changed sanction practice may be achieved if empirical evidence on the perception of such sanctions accompanies the reform process. This article investigates – based on a Vignette analysis – which sanctions are considered acceptable by the population, when hypothetical welfare recipients violate their obligation to cooperate. A majority of the representative German sample (N = 2621) favours sanctions up to 30 % of the minimum income benefit. Sole factors such as low levels of motivation to look for work, missed appointments with the specialist advisors or having a foreign-sounding name significantly increase the acceptance of sanctions amongst the wider public. Especially a combination of these factors increases the acceptance of placing sanctions on welfare recipients. In contrast, the age of the hypothetical benefit recipients plays a marginal role.

----

### History

`2022-10-11`
:  Setup

---

### Directories

`\01src`
:  Source materials, raw data

`\02prc`
:  Processed data and analytical scripts (in subfolders)

`\03doc`
:  Documentation and output incl. figures and tables

---

### Description

This repository contains the code for the analysis in the paper entitled "Wieviel Geld ist angemessen? Eine Vignettenstudie zur Akzeptanz von Sanktionen im SGB II" which is published in the [WSI Mitteilungen - Ausgabe 06/2021](https://www.wsi.de/de/wsi-mitteilungen-vignettenstudie-akzeptanz-sanktionen-im-sgb-ii-36761.htm). The main analytical results can be found in the `analysis.html` file. This file can be downloaded and opened in any browser or it can be viewed online [here]().

The data for this analysis comes from a self-designed and self-programmed factorial survey with vignettes. Vignette are little case descriptions of situations or individuals, which allow to systematically vary factors under study (e.g. gender, age etc.). The factorial survey was implemented in the [YouGov panel Germany](https://yougov.de/panel/) with roughly 350.000 panelists. From here, we were able to recruit a sample of N=2.621 individuals, which are representative on the key variables gender, age, education and residence at state level. The raw data set is available after registration [here](DOI GESIS EINFÜGEN).

---

### Replication instruction

All analysis were done in Stata 16 and under Windows 11. Please follow the steps listed below to reproduce findings:

1. Fork the repository / Sync fork if necessary
2. Open and read the file `master.do` in Stata from the directory `input`
    - In this file, adapt the global wdir as specified
3. Run the file `master.do` in the `input` folder
4. See the output directories `\03doc\fig`, `03doc\tab` & `03doc\var` for output
