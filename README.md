# Examining-The-Relationship-Between-History-of-Detention-and-MDR-TB-in-Moldova-Between-2008-2009

This is my Integrated Learning Experience (ILE) project in completion of my MPH graudation requirements where I analyzed the relationship between detention and multi-drug resistant TB (MDR-TB) using data from a large database of notified TB cases in Moldova between 2008-2009 containing 11,687 cases and 218 variables.

Data Preparation:
- Imported original excel dataset into SAS
- Removed 108 variables that did not contain TB data
- Created a clean dataset for analysis by removing observations with missing values for variables of interest
- Created outcome vairable (dichotomous MDR-TB) using if-then-else
- Created and applied formats
- Created final analysis dataset that kept only the variables of interest

Statistical Analyses:
- Chi-square tests of independence for variables of interest against exposure and outcome using SAS Macro
- Simple logistic regression model for primary exposure-outcome (detention and MDR-TB) relationship
- Multivariable logistic regression model adjusting for confounders identified through the chi-square tests

Conclusions:
Our crude model estimates that patients with a history of detention have 3.108 times the odds of developing MDR-TB compared to patients without a history of detention. Our adjusted model found that patients with a history of detention have 1.877 times the odds of developing MDR-TB, adjusted for previous TB treatment, concurrent HIV, sex, residence, occupation, and being unhoused, compared to patients without a history of detention. Education was found to be a confounder for the relationship between detention and MDR-TB due to it being associated with both exposure and outcome, however, when included in the adjusted model education lost its significance as a predictor. When comparing the adjusted models, one that includes education and one that does not, both models were roughly the same in terms of significance and fit, therefore we remove education from the final model.

Demonstrated SAS skills: importing excel datasets into SAS; drop and keep statements; proc freq; proc contents; creating and applying formats using proc format; variable creation using conditional statements; Macro creation and utilization; chi-square tests; logisitic regression analysis using proc logistic
