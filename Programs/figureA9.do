* Figure A9: Absolute Mobility, 1949 to 1953 versus 1961 to 194
clear
use "${data_dir}DavisMazumderData.dta"
keep if age_firstSurvey<=18
drop if miss0 | miss1
drop if (mom_outOfRange==1 & linkMom==1 & !(dad_outOfRange==0 & linkDad==1)) | (dad_outOfRange==1 & linkDad==1 & !(mom_outOfRange==0 & linkMom==1)) | (linkMom==0 & linkDad==0) 
keep if women==1 

su up0 if surv79==0 [w=weight]
local abs0 = r(mean)
su byear if surv79==0
local by_l0 = r(min)
local by_u0 = r(max)
su up0 if surv79==1 [w=weight]
local abs1 = r(mean)
su byear if surv79==1
local by_l1 = r(min)
local by_u1 = r(max)


foreach y in 1948 1949 1950 1951 1952 1953 1961 1962 1963 1964 {
 su n if byear==`y' [w=weight]
 local w`y' = r(sum_w) 
} 

* Chetty Absolute Mobility Estimates.xlsx was created using public data from: 
* https://opportunityinsights.org/data/?geographic_level=0&topic=121&paper_id=0#resource-listing
* cohort_mean is from "Fading American Dream: Baseline Estimates of Absolute Mobility by Parent Income Percentile and Child Birth Cohort"
* Excel file: table1_national_absmob_by_cohort_parpctile.xlsx (cohort_mean is last column)
* lb_fosd and	ub_fosd are from "Alternative Estimates of Absolute Income Mobility by Birth Cohort"
* Excel file: table4_robustness_by_cohort.xlsx (last two columns)
* Merge this file in directly too

clear
import excel using "${data_dir}Chetty Absolute Mobility Estimates.xlsx", sheet("Data") firstrow


merge 1:1 cohort using ${data_dir}table4_robustness_by_cohort.dta
 
gen our_est0 = . 
 replace our_est0 = `abs0' if cohort>=`by_l0' & cohort<=`by_u0'
gen our_est1 = . 
 replace our_est1 = `abs1' if cohort>=`by_l1' & cohort<=`by_u1'

gen chetty_est0 = .
 su cohort_mean if cohort>=`by_l0' & cohort<=`by_u0'
 replace chetty_est0 = r(mean) if cohort>=`by_l0' & cohort<=`by_u0'
 
gen chetty_est1 = .
 su cohort_mean if cohort>=`by_l1' & cohort<=`by_u1'
 replace chetty_est1 = r(mean) if cohort>=`by_l1' & cohort<=`by_u1'
  
  
gen cop_assum = cohort_mean if cohort<1980 
gen cop_obs = cohort_mean if cohort>=1980 & cohort<=1982

gen weight = .
foreach y in 1948 1949 1950 1951 1952 1953 1961 1962 1963 1964 {
 replace weight = `w`y'' if cohort==`y'
}
su lb_fosd [w=weight] if cohort>=1949 & cohort<=1953
gen avg_lb = r(mean) if cohort>=1949 & cohort<=1953

 
graph twoway (line lb_fosd ub_fosd cop_obs our_est0 our_est1 avg_lb cohort, lwidth(medium medium medium thick thick medium) lcolor(black black black navy maroon black) lpattern(longdash longdash solid solid solid dot)), ///
	graphregion(color(white)) ylabel(,nogrid) ytitle("% Children Earning More Than Parents") xtitle("Birth Year") ///
	legend(label(1 "Lower Bound") label(2 "Upper Bound") label(3 "Copula Observed") label(4 "NLS66") label(5 "NLSY79") label(6 "Avg Lower Bound") ) ylabel(0(0.2)1)
graph export ${results_dir}figureA9.png, replace








exit
