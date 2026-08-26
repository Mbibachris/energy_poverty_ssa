*==============================================================================
* PANEL DATA ANALYSIS: LOG TRANSFORMATIONS, FE, RE & HAUSMAN TEST
* Variables: mepi gdp pemd geff pop popd rpop co2pc co2ch altnuc eupc gdpg ffuel
*==============================================================================

*------------------------------------------------------------------------------
* SECTION 1: SETUP
*------------------------------------------------------------------------------

clear all
set more off
capture log close
log using "panel_analysis.log", replace text

*--- LOAD YOUR DATA FIRST ---
* Path is relative to this .do file's location (stata/panel_analysis.do)
use "../data/processed/panel_data.dta", clear

*--- Set panel structure (adjust countryname and time to your id/time vars) ---
encode countryname, gen(country_id)       // convert string country to numeric
xtset country_id time, yearly             // declare panel; change yearly if needed


*------------------------------------------------------------------------------
* SECTION 2: LOG TRANSFORMATIONS
*------------------------------------------------------------------------------

*--- Standard log (strictly positive variables) ---
foreach var in gdp pop co2pc eupc pemd popd {
    gen ln_`var' = ln(`var')
    label variable ln_`var' "Log of `var'"
}

*--- Log(x+1) for variables with zeros ---
foreach var in altnuc ffuel {
    gen ln_`var' = ln(`var' + 1)
    label variable ln_`var' "Log(1 + `var')"
}

*--- Inverse hyperbolic sine for CO2CH (contains negative values) ---
gen ihs_co2ch = asinh(co2ch)
label variable ihs_co2ch "IHS transformation of co2ch"

*--- Leave untransformed: mepi, geff, rpop, gdpg ---

*--- Confirm transformations reduced skewness ---
summarize ln_gdp ln_pop ln_co2pc ln_eupc ln_pemd ln_popd ///
          ln_altnuc ln_ffuel ihs_co2ch mepi geff rpop gdpg, detail


*------------------------------------------------------------------------------
* SECTION 3: DEFINE DEPENDENT AND INDEPENDENT VARIABLES
*
*   Dependent variable : mepi (MPI index — bounded [0,1], near-symmetric)
*   Independent vars   : logged/transformed versions + untransformed controls
*   Adjust this list to match your theoretical model
*------------------------------------------------------------------------------

global depvar  mepi

global indvars ln_gdp ln_pemd geff ln_pop ln_popd rpop ///
               ln_co2pc ihs_co2ch ln_altnuc ln_eupc gdpg ln_ffuel


*------------------------------------------------------------------------------
* SECTION 4: DESCRIPTIVE CHECK ON PANEL STRUCTURE
*------------------------------------------------------------------------------

xtsum $depvar $indvars
xtline mepi, overlay legend(off) title("MEPI over time by country")


*------------------------------------------------------------------------------
* SECTION 5: FIXED EFFECTS (FE) ESTIMATION
*   - Absorbs all time-invariant country heterogeneity
*   - Use vce(robust) for heteroskedasticity-robust SEs
*------------------------------------------------------------------------------

xtreg $depvar $indvars, fe vce(robust)
estimates store fe_model

*--- Save FE residuals for diagnostics ---
predict resid_fe, e
predict yhat_fe,  xb


*------------------------------------------------------------------------------
* SECTION 6: RANDOM EFFECTS (RE) ESTIMATION
*   - Assumes country effects are uncorrelated with regressors
*   - More efficient than FE if assumption holds
*------------------------------------------------------------------------------

xtreg $depvar $indvars, re vce(robust)
estimates store re_model


*------------------------------------------------------------------------------
* SECTION 7: HAUSMAN TEST
*   - H0: RE is consistent (country effects uncorrelated with regressors)
*   - H1: FE is consistent, RE is not
*   - If p < 0.05 → reject H0 → use Fixed Effects
*   - If p > 0.05 → fail to reject H0 → Random Effects preferred
*
*   NOTE: hausman requires non-robust estimates for the standard test.
*         We re-estimate without vce(robust) solely for the Hausman test.
*------------------------------------------------------------------------------

quietly xtreg $depvar $indvars, fe
estimates store fe_hausman

quietly xtreg $depvar $indvars, re
estimates store re_hausman

hausman fe_hausman re_hausman, sigmamore

*--- Display interpretation reminder ---
display ""
display "  HAUSMAN TEST INTERPRETATION:"
display "  p < 0.05 → Reject H0 → Use FIXED EFFECTS"
display "  p > 0.05 → Fail to reject H0 → RANDOM EFFECTS preferred"
display ""


*------------------------------------------------------------------------------
* SECTION 8: ADDITIONAL DIAGNOSTICS
*------------------------------------------------------------------------------

*--- Test for time fixed effects (add time dummies to FE model) ---
quietly xtreg $depvar $indvars i.time, fe vce(robust)
testparm i.time
display "If p < 0.05, time fixed effects are jointly significant → include them"

*--- Breusch-Pagan LM test: random effects vs pooled OLS ---
xtreg $depvar $indvars, re
xttest0

*--- Modified Wald test for groupwise heteroskedasticity in FE residuals ---
xtreg $depvar $indvars, fe
xttest3

*--- Wooldridge test for serial autocorrelation in panel data ---
xtserial $depvar $indvars


*------------------------------------------------------------------------------
* SECTION 9: COEFFICIENT TABLE COMPARISON
*------------------------------------------------------------------------------

*--- Side-by-side comparison of FE and RE coefficients ---
estimates table fe_model re_model, ///
    b(%9.4f) se(%9.4f) stats(N r2_w r2_b r2_o) ///
    title("Fixed Effects vs Random Effects — Coefficient Comparison")


*------------------------------------------------------------------------------
* CLOSE LOG
*------------------------------------------------------------------------------

log close
*==============================================================================
* END OF DO FILE
*==============================================================================
