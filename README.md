# Drivers of Energy Poverty in Sub-Saharan Africa: An Algorithmic Approach

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
![Status: Work in Progress](https://img.shields.io/badge/Status-Work%20in%20Progress-yellow)
![Language: Python](https://img.shields.io/badge/Language-Python-green)

---

## Overview

This repository contains the full replication code and data documentation 
for the paper:

> **"Drivers of Energy Poverty in Sub-Saharan Africa: An Algorithmic Approach"**  
> Christopher Mbiba — University of Cape Coast, Ghana  
> *Working Paper, 2025*

The paper proceeds in two stages. The first constructs a 
**Multidimensional Energy Poverty Index (MEPI)** for Sub-Saharan African 
countries using the Alkire-Foster dual-cutoff methodology. The second 
applies **algorithmic variable selection** to identify the key drivers 
of energy poverty from a candidate pool of 34 variables spanning six 
theoretical traditions.

---

## Repository Structure
```
energy_poverty_ssa/
│
├── data/
│   ├── raw/              ← Original downloaded datasets (not pushed to GitHub)
│   └── processed/        ← Cleaned and merged panel data
│
├── notebooks/
│   ├── 01_data_cleaning/         ← Data import, cleaning and merging
│   ├── 02_mepi_construction/     ← MEPI index construction and validation
│   ├── 03_driver_analysis/       ← Algorithmic driver identification
│   └── 04_results/               ← Final tables, figures, robustness checks
│
├── outputs/
│   ├── figures/          ← All charts and maps
│   ├── tables/           ← Regression and summary tables
│   └── scores/           ← Country-year MEPI scores
│
└── README.md
```

---

## Data

All data are sourced from the **World Bank World Development Indicators 
(WDI)** database. The panel covers Sub-Saharan African countries over 
the period **2000–2022**.

| Category | Variables | Role |
|---|---|---|
| MEPI construction | 13 variables across 5 dimensions | Dependent variable components |
| Driver variables | 34 candidate variables across 6 theoretical traditions | Independent variables |

Data are not pushed to this repository. To replicate, download the 
relevant indicators from:  
https://databank.worldbank.org/source/world-development-indicators

---

## MEPI Construction

The MEPI is built across five dimensions:

| Dimension | Indicators | Weight |
|---|---|---|
| D1 — Electricity access | Total, rural, urban access rates | 1/5 |
| D2 — Affordability & efficiency | GDP per energy use, energy imports, energy intensity | 1/5 |
| D3 — Reliability | T&D losses, kWh per capita | 1/5 |
| D4 — Clean cooking | Total, rural, urban clean cooking access | 1/5 |
| D5 — Sustainability | Renewable energy consumption, carbon intensity | 1/5 |

**Method:** Alkire-Foster dual-cutoff  
**First cutoff:** z_j = 1/3 (indicator-level deprivation threshold)  
**Second cutoff:** k = 1/3 (poverty identification threshold)  
**Final index:** MEPI = H × A (incidence × intensity)

---

## Driver Variables

34 candidate driver variables organised across six theoretical traditions:

- Economic & income (9 variables)
- Natural resource & fiscal (5 variables)
- Institutional & governance (1 variable)
- Demographic & spatial (7 variables)
- Environmental (3 variables)
- Structural & energy mix (9 variables)

---

## Replication

Run notebooks in order:
```
01_data_cleaning        →  produces data/processed/panel_clean.csv
02_mepi_construction    →  produces outputs/scores/mepi_country_year.csv
03_driver_analysis      →  produces outputs/tables/driver_results.csv
04_results              →  produces all figures and final tables
```

### Requirements
```bash
pip install pandas numpy matplotlib seaborn scikit-learn statsmodels openpyxl jupyter
```

---

## Progress

- [x] Data cleaning and merging
- [x] MEPI construction (Alkire-Foster)
- [x] MEPI merged with driver variables
- [ ] Algorithmic driver identification
- [ ] Results and robustness checks
- [ ] Paper write-up

---

## Contact

Christopher Mbiba  
University of Cape Coast, Ghana  
GitHub: [@Mbibachris](https://github.com/Mbibachris)

---

## Citation

If you use this code, please cite:

> Mbiba, C. (2025). *Drivers of Energy Poverty in Sub-Saharan Africa: 
> An Algorithmic Approach*. Working Paper, University of Cape Coast.

---

## License

This project is licensed under the MIT License.
