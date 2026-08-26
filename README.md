# Drivers of Energy Poverty in Africa: An Algorithmic Approach

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
![Status: Analysis Complete — Manuscript in Preparation](https://img.shields.io/badge/Status-Analysis%20Complete%20%E2%80%94%20Manuscript%20in%20Preparation-yellow)
![Language: Python](https://img.shields.io/badge/Language-Python-3776AB)
![Language: Stata](https://img.shields.io/badge/Language-Stata-1A5276)

> **Private working repository.** This project is an unpublished working paper. Findings, figures and interpretation are intentionally not summarised here — see `paper/` for the manuscript. This README documents the repository structure and how to reproduce the pipeline only.

---

## Overview

This repository contains the replication code, data, and manuscript draft for:

> **"Drivers of Energy Poverty in Africa: An Algorithmic Approach"**
> Christopher Mbiba — University of Cape Coast, Ghana
> *Working paper, 2026 (unpublished)*

> **Note:** The project began as a Sub-Saharan Africa study (hence the repository name, `energy_poverty_ssa`) and has since been extended to cover **all 54 African countries**. The manuscript and code below reflect the expanded, continent-wide scope.

The pipeline proceeds in three stages: (1) construction of a **Multidimensional Energy Poverty Index (MEPI)** using the Alkire–Foster (2011) dual-cutoff methodology; (2) **Recursive Feature Elimination and nine machine learning models**, interpreted with feature importance, SHAP values, Partial Dependence Plots and Individual Conditional Expectation curves; and (3) validation with **panel fixed-effects/random-effects estimation** and a Hausman test.

---

## Repository Structure

```
energy_poverty_ssa/
│
├── paper/
│   └── Drivers_of_Energy_Poverty_in_Africa.docx   ← Full manuscript (working draft)
│
├── data/
│   ├── raw/
│   │   └── RAW_ENERGY_DATA.xlsx           ← Raw World Bank WDI extract
│   └── processed/
│       ├── ENERGY_POVERTY_CLEANED.xlsx    ← Cleaned panel data (post missing-data handling)
│       ├── mepi_with_drivers.xls          ← MEPI merged with the 34 candidate drivers
│       ├── mepi_country_summary.xls       ← Country-level MEPI summary
│       └── panel_data.dta                 ← Stata panel dataset used for FE/RE estimation
│
├── notebooks/
│   ├── 01_data_cleaning/          ← Missing-data handling and merging of raw WDI data
│   ├── 02_mepi_construction/      ← MEPI construction and validation (Alkire–Foster)
│   ├── 03_driver_analysis/        ← See note below — merged into 04_results
│   └── 04_results/                ← EDA, RFE, 9 ML models, lag analysis, SHAP/PDP/ICE interpretation
│
├── stata/
│   └── panel_analysis.do          ← Panel FE/RE estimation and Hausman test
│
├── outputs/
│   ├── figures/                   ← All charts (MEPI trends, model comparison, SHAP plots, etc.)
│   └── results/                   ← Regression/model comparison tables (descriptive stats, RFE,
│                                     feature importance, SHAP importance, lag analysis, etc.)
│
├── requirements.txt
└── README.md
```

**Note on `03_driver_analysis/`:** Recursive Feature Elimination and the nine machine-learning models are implemented together with the interpretability analysis in a single notebook, `04_results/Modelling.ipynb`, rather than as a separate stage. The `03_driver_analysis/` folder is kept for structural clarity but its content lives in `04_results/`.

---

## Data

All data are sourced from the **World Bank World Development Indicators (WDI)** database. The panel is balanced and covers **54 African countries** over **2000–2022** (1,242 country-year observations).

| Category | Variables | Role |
|---|---|---|
| MEPI construction | 13 indicators across 5 dimensions | Dependent variable components |
| Driver variables | 34 candidate variables across 6 theoretical traditions | Independent variables |

---

## MEPI Construction

The MEPI is built across five dimensions, each with equal weight (Alkire & Foster, 2011):

| Dimension | Indicators | Weight |
|---|---|---|
| D1 — Electricity access | Total, rural, urban access rates | 1/5 |
| D2 — Affordability & efficiency | GDP per unit of energy use, energy imports, energy intensity | 1/5 |
| D3 — Reliability | Transmission & distribution losses, electric power consumption per capita | 1/5 |
| D4 — Clean cooking | Total, rural, urban clean cooking access | 1/5 |
| D5 — Sustainability | Renewable energy consumption, alternative/nuclear energy share | 1/5 |

- **Indicator-level cutoff:** zⱼ = 1/3
- **Poverty cutoff:** k = 1/3
- **Index:** MEPI = H × A (incidence × intensity)
- Robustness checked under k = 1/5 and k = 1/2.

## Driver Variables

34 candidate driver variables spanning six theoretical traditions — economic & income, natural resource & fiscal, institutional & governance, demographic & spatial, environmental, and structural energy mix. Recursive Feature Elimination (Random Forest estimator) narrows these to a smaller final set used in the machine learning and panel models; see `notebooks/04_results/` and `outputs/results/rfe_results.xls` for the selected set.

## Machine Learning Models

LASSO, Ridge, Elastic Net, Decision Tree, Random Forest, Gradient Boosting, XGBoost, Support Vector Regression, and K-Nearest Neighbours — tuned with 5-fold `GridSearchCV` on an 80:20, temporally-ordered train/test split. Interpreted using feature importance, SHAP (TreeExplainer), Partial Dependence Plots, and Individual Conditional Expectation curves for the top-performing models.

## Panel Econometric Validation

`stata/panel_analysis.do` estimates fixed-effects and random-effects models on the selected drivers, applies log/IHS transformations for skewed variables, and uses a Hausman (1978) test to choose between FE and RE.

---

## Replication

Run notebooks in order:
```
01_data_cleaning       → produces data/processed/ENERGY_POVERTY_CLEANED.xlsx
02_mepi_construction   → produces country-year MEPI scores
04_results             → RFE, 9 ML models, lag analysis, SHAP/PDP/ICE interpretation
stata/panel_analysis.do → FE/RE estimation and Hausman test (run from within stata/)
```

### Requirements
```bash
pip install -r requirements.txt
```

---

## Progress

- [x] Data cleaning and merging
- [x] MEPI construction (Alkire–Foster)
- [x] MEPI merged with driver variables
- [x] Recursive Feature Elimination and 9-model comparison
- [x] Interpretable ML (feature importance, SHAP, PDP, ICE)
- [x] Panel FE/RE estimation and Hausman validation
- [x] Manuscript drafted
- [ ] Peer review / journal submission

---

## Contact

Christopher Mbiba
University of Cape Coast, Ghana
GitHub: [@Mbibachris](https://github.com/Mbibachris)

---

## Citation

If you use this code or data, please cite:

> Mbiba, C. (2026). *Drivers of Energy Poverty in Africa: An Algorithmic Approach*. Working paper, University of Cape Coast.

---

## License

This project is licensed under the MIT License.
