# DavisMazumderTrends
Data and code to replicate results in "The Decline in Intergenerational Mobility After 1980" by Jonathan M.V. Davis and Bhashkar Mazumder

The paper is available for download here: https://stonecenter.gc.cuny.edu/research/the-decline-in-intergenerational-mobility-after-1980/

Documentation for NLS66 and NLSY79 data is available here: https://www.bls.gov/nls/home.htm

Extracts of underlying survey data can be created here: https://www.bls.gov/nls/home.htm

# Program Organization

The analysis was conducted using Stata 15.1. The code is organized by the file DavisMazumder2020.do which calls separate programs to create each table and figure. The data is contained in the file DavisMazumderData.dta (or DavisMazumderData.csv).

# Variable Descriptions

|	Variable Name	|	Description	|
| ------------- | ----------- |
|	id_son	|	NLS66, Young Men Individual Identifier	|
|	id_daughter	|	NLS66, Young Women Individual Identifier	|
|	hhid	|	Household Identifier in both surveys	|
|	hgc	|	Highest Grade Completed	|
|	age_firstSurvey	|	Age in year of first survey	|
|	survey	|	Source of observation	|
|	CASEID	|	NLSY79 Individual Identifier	|
|	byear	|	Birth Year	|
|	share_married	|	Share of non-missing income years that youth was married	|
|	women	|	Indicator for being a daughter	|
|	surv79	|	Indicator for being an NLSY79 youth	|
|	dad_age_at_birth	|	Father Age at Birth	|
|	mom_age_at_birth	|	Mother Age at Birth	|
|	dad_age_inc	|	Average Father Age in Parent Income Years	|
|	mom_age_inc	|	Average Mother Age in Parent Income Years	|
|	dad_age_inc1	|	Father Age in First Interview Income Measured	|
|	mom_age_inc1	|	Mother Age in First Interview Income Measured	|
|	byear_mom	|	Mother Birth Year	|
|	byear_dad	|	Father Birth Year	|
|	mom_outOfRange	|	Mother not in age range implied by NLS66 sample frame	|
|	dad_outOfRange	|	Father not in age range implied by NLS66 sample frame	|
|	linkDad	|	Indicator for father-child link based on NLS66 sample frame	|
|	linkMom	|	Indicator for mother-child link based on NLS66 sample frame	|
|	linkBoth	|	Indicator for child being linked to both father and mother based on NLS66 sample frame	|
|	useDad	|	Indicator for using income reports in NLS66 Older Men	|
|	parent1	|	Total parent family income in first survey included in income average (2015$)	|
|	parent2	|	Total parent family income in second survey included in income average (2015$)	|
|	parent3	|	Total parent family income in third survey included in income average (2015$)	|
|	zero_parent1	|	Indicator for first parent income measure equalling exactly zero	|
|	zero_parent2	|	Indicator for second parent income measure equalling exactly zero	|
|	zero_parent3	|	Indicator for third parent income measure equalling exactly zero	|
|	ms_parent1	|	Indicator for missing first parent income measure	|
|	ms_parent2	|	Indicator for missing second parent income measure	|
|	ms_parent3	|	Indicator for missing third parent income measure	|
|	nparent	|	Number of non-missing, non-zero prent  income reports	|
|	miss0	|	Indicator for having zero non-missing, non-zero parent income reports	|
|	faminc0	|	Average of non-missing total family income in parent generation	|
|	lfaminc0	|	Log of average parent income	|
|	loginc66	|	Interaction of log parent income and indicator for being in NLS66	|
|	loginc79	|	Interaction of log parent income and indicator for being in NLSY79	|
|	kid_age_parentInc	|	Average child age in survey years parent income is measured	|
|	kid1	|	Total child family income in first survey included in income average (2015$)	|
|	kid2	|	Total child family income in second survey included in income average (2015$)	|
|	kid3	|	Total child family income in third survey included in income average (2015$)	|
|	ms_kid1	|	Indicator for missing first child income measure	|
|	ms_kid2	|	Indicator for missing second child income measure	|
|	ms_kid3	|	Indicator for missing third child income measure	|
|	zero_kid1	|	Indicator for first child income measure equalling exactly zero	|
|	zero_kid2	|	Indicator for second child income measure equalling exactly zero	|
|	zero_kid3	|	Indicator for third child income measure equalling exactly zero	|
|	nkid	|	Number of non-missing, non-zero parent income reports	|
|	miss1	|	Indicator for having zero non-missing, non-zero child income reports	|
|	miss1_prime	|	Indicator for having zero non-missing, non-zero prime age child income reports	|
|	miss1_early	|	Indicator for having zero non-missing, non-zero early career child income reports	|
|	faminc1	|	Average of non-missing total family income in child generation	|
|	lfaminc1	|	Log of average child income	|
|	faminc1_early	|	Average early career total family income (NLSY79 only)	|
|	faminc1_prime	|	Average prime age total family income (NLSY79 only)	|
|	lfaminc1_early	|	Log of early career average income (NLSY79 only)	|
|	lfaminc1_prime	|	Log of prime age average income (NLSY79 only)	|
|	up0	|	Indicator for average child family income (faminc1) being greater than average parent family income (faminc0)	|
|	owninc	|	Average wage and salary income of child (2015$)	|
|	lown	|	Log own wage and salary income of child	|
|	miss1_own	|	Indicator for having zero non-missing, non-zero child own wage and salary income reports	|
|	miss_spouse	|	Indicator for having zero non-missing, non-zero child own wage and salary income reports	|
|	spouse_inc	|	Average spouse wage and salary income for child (2015$)	|
|	spouse_age	|	Average spouse age in years child income is measured	|
|	weight	|	Survey weight from first survey round for child	|
|	weight_incFirst	|	Survey weight from first interview round where child income is measured	|
|	weight_incLast	|	Survey weight from last interview round where child income is measured	|
|	weight_incAvg	|	Average survey weight across interviews where child income is measured	|
|	all_parent	|	Indicator for having no missing or zero parent income reports	|
|	all_kid	|	Indicator for having no missing or zero child income reports	|
|	married	|	Indicator for child being married across all interviews where child income is measured (x100)	|

