* Table A5 and A6: Robustness of Absolute Mobility Estimates
clear
use "${data_dir}DavisMazumderData.dta"
keep if age_firstSurvey<=18
drop if miss0 | miss1
drop if (mom_outOfRange==1 & linkMom==1 & !(dad_outOfRange==0 & linkDad==1)) | (dad_outOfRange==1 & linkDad==1 & !(mom_outOfRange==0 & linkMom==1)) | (linkMom==0 & linkDad==0) 
 

gen surv66 = surv79==0


* Table A5: Re-weighted Absolute Mobility Estimates

* Weight Adjustments *

gen id = .
 replace id = id_son if survey==1966 & women==0
 replace id = id_daughter if survey==1966 & women==1
 replace id = CASEID if survey==1979
 
merge 1:1 id survey women using  ${data_dir}weight_adjustments.dta

* Re-weight to match parents *

reg up0 surv66 surv79 [w=wt_nls_parent] if women==1, nocons cluster(hhid)
eststo abs_w_parent
test surv66=surv79
estadd scalar p=r(p): abs_w_parent
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_w_parent
estadd scalar se = r(se): abs_w_parent
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_w_parent
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_w_parent
drop s

reg up0 surv66 surv79 [w=wt_nls_parent] if women==0, nocons cluster(hhid)
eststo abs_m_parent
test surv66=surv79
estadd scalar p=r(p): abs_m_parent
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_m_parent
estadd scalar se = r(se): abs_m_parent
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_m_parent
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_m_parent
drop s

* Re-weight to match kids *

reg up0 surv66 surv79 [w=wt_nls_kid] if women==1, nocons cluster(hhid)
eststo abs_w_kid
test surv66=surv79
estadd scalar p=r(p): abs_w_kid
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_w_kid
estadd scalar se = r(se): abs_w_kid
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_w_kid
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_w_kid
drop s

reg up0 surv66 surv79 [w=wt_nls_kid] if women==0, nocons cluster(hhid)
eststo abs_m_kid
test surv66=surv79
estadd scalar p=r(p): abs_m_kid
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_m_kid
estadd scalar se = r(se): abs_m_kid
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_m_kid
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_m_kid
drop s


* Re-weight with average adjustment *

reg up0 surv66 surv79 [w=wt_nls_avg] if women==1, nocons cluster(hhid)
eststo abs_w_avg
test surv66=surv79
estadd scalar p=r(p): abs_w_avg
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_w_avg
estadd scalar se = r(se): abs_w_avg
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_w_avg
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_w_avg
drop s

reg up0 surv66 surv79 [w=wt_nls_avg] if women==0, nocons cluster(hhid)
eststo abs_m_avg
test surv66=surv79
estadd scalar p=r(p): abs_m_avg
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_m_avg
estadd scalar se = r(se): abs_m_avg
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_m_avg
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_m_avg
drop s



#delimit ;
estout abs_w_parent abs_w_kid abs_w_avg abs_m_parent abs_m_kid abs_m_avg
	using  "${results_dir}tableA5.txt", replace
	keep(surv66 surv79)
	cells(b(star fmt(3))  se(par fmt(3))) 
	collabels(,none) stat(diff se p p2 N66 N79) stardrop(*) ;	
	
#delimit cr	



* Table A6: Robustness of Absolute Mobility Results to Extreme Values


* Generate income ranks after applying sample restrictions
gen N = .
 tab n  if surv79==0 & women==0  [w=weight]
 replace N = r(N) if surv79==0 & women==0 
 tab n  if surv79==0 & women==1   [w=weight]
 replace N = r(N) if surv79==0 & women==1 
 tab n  if surv79==1 & women==0   [w=weight]
 replace N = r(N) if surv79==1 & women==0 
 tab n  if surv79==1 & women==1 [w=weight]
 replace N = r(N) if surv79==1 & women==1 
 
* Family Income Rank in Parent Generation
sort women surv79 faminc0
by women surv79: gen __rank0 = sum(weight) 
gen _rank0 = __rank0/N 
by women surv79 faminc0: egen rank0 = mean(_rank0) 
 replace rank0 = 100*rank0
gen perc66 = rank0*(1-surv79)
gen perc79 = rank0*surv79

 
* Family Income Rank in Kid Generation
sort women surv79 faminc1
by women surv79: gen __rank1 = sum(weight)
gen _rank1 = __rank1/N 
bys women surv79 faminc1: egen rank1 = mean(_rank1) 
replace rank1 = 100*rank1

drop N __rank0 _rank0 __rank1 _rank1 

***********************************************
* Exercise 1: Drop if parents in top 5% of income
***********************************************

preserve
drop if (rank0>95)

reg up0 surv66 surv79 [w=weight] if women==1, nocons cluster(hhid)
eststo abs_w_e1
test surv66=surv79
estadd scalar p=r(p): abs_w_e1
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_w_e1
estadd scalar se = r(se): abs_w_e1
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_w_e1
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_w_e1
drop s

reg up0 surv66 surv79 [w=weight] if women==0, nocons cluster(hhid)
eststo abs_m_e1
test surv66=surv79
estadd scalar p=r(p): abs_m_e1
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_m_e1
estadd scalar se = r(se): abs_m_e1
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_m_e1
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_m_e1
drop s


restore

***********************************************************
* Exercise 2: Topcode top 5%
***********************************************************


preserve

gen top5 = rank0>95 & rank0<.
bys survey women: egen tc_parent = mean(faminc0) if top5==1
 replace faminc0 = tc_parent if top5==1

drop up0
gen up0 = faminc1>faminc0 if faminc1<.


reg up0 surv66 surv79 [w=weight] if women==1, nocons cluster(hhid)
eststo abs_w_e2
test surv66=surv79
estadd scalar p=r(p): abs_w_e2
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_w_e2
estadd scalar se = r(se): abs_w_e2
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_w_e2
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_w_e2
drop s

reg up0 surv66 surv79 [w=weight] if women==0, nocons cluster(hhid)
eststo abs_m_e2
test surv66=surv79
estadd scalar p=r(p): abs_m_e2
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_m_e2
estadd scalar se = r(se): abs_m_e2
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_m_e2
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_m_e2
drop s


restore

*********************************************************
* Exercise 3: Drop if parents or kids in top 5% of income
*********************************************************

preserve

drop if (rank1>95 | rank0>95)


reg up0 surv66 surv79 [w=weight] if women==1, nocons cluster(hhid)
eststo abs_w_e3
test surv66=surv79
estadd scalar p=r(p): abs_w_e3
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_w_e3
estadd scalar se = r(se): abs_w_e3
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_w_e3
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_w_e3
drop s

reg up0 surv66 surv79 [w=weight] if women==0, nocons cluster(hhid)
eststo abs_m_e3
test surv66=surv79
estadd scalar p=r(p): abs_m_e3
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_m_e3
estadd scalar se = r(se): abs_m_e3
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_m_e3
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_m_e3
drop s


restore


***********************************************************
* Exercise 4: Topcode top 5% of parents and kids
***********************************************************




preserve

gen top5_parent = rank0>95 & rank0<.
bys survey women: egen tc_parent = mean(faminc0) if top5_parent==1
 replace faminc0 = tc_parent if top5_parent==1

gen top5_kid = rank1>95 & rank1<.
bys survey women: egen tc_kid = mean(faminc1) if top5_kid==1
 replace faminc1 = tc_kid if top5_kid==1

drop up0
gen up0 = faminc1>faminc0 if faminc1<.

reg up0 surv66 surv79 [w=weight] if women==1, nocons cluster(hhid)
eststo abs_w_e4
test surv66=surv79
estadd scalar p=r(p): abs_w_e4
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_w_e4
estadd scalar se = r(se): abs_w_e4
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_w_e4
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_w_e4
drop s

reg up0 surv66 surv79 [w=weight] if women==0, nocons cluster(hhid)
eststo abs_m_e4
test surv66=surv79
estadd scalar p=r(p): abs_m_e4
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_m_e4
estadd scalar se = r(se): abs_m_e4
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_m_e4
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_m_e4
drop s


restore


 

#delimit ;
estout abs_w_e1 abs_w_e2 abs_w_e3 abs_w_e4 abs_m_e1 abs_m_e2 abs_m_e3 abs_m_e4 
	using  "${results_dir}tableA6.txt", replace
	keep(surv66 surv79)
	cells(b(star fmt(3))  se(par fmt(3))) 
	collabels(,none) stat(diff se p p2 N66 N79) stardrop(*) ;	
			
	
#delimit cr	
