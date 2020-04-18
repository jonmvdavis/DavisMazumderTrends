* Table 5: Robustness to Extreme Values
clear
use "${data_dir}DavisMazumderData.dta"
keep if age_firstSurvey<=18
drop if miss0 | miss1
drop if (mom_outOfRange==1 & linkMom==1 & !(dad_outOfRange==0 & linkDad==1)) | (dad_outOfRange==1 & linkDad==1 & !(mom_outOfRange==0 & linkMom==1)) | (linkMom==0 & linkDad==0) 
 

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

* Generate Ranks Using Non-Missing Sample *
drop perc66 perc79 rank0 rank1 
replace weight = round(weight)

gen N = .
 tab n  if surv79==0 & women==0 [w=weight]
 replace N = r(N) if surv79==0 & women==0
 tab n  if surv79==0 & women==1 [w=weight]
 replace N = r(N) if surv79==0 & women==1
 tab n  if surv79==1 & women==0 [w=weight]
 replace N = r(N) if surv79==1 & women==0
 tab n  if surv79==1 & women==1 [w=weight]
 replace N = r(N) if surv79==1 & women==1
 
sort women surv79 faminc0
by women surv79: gen __rank0 = sum(weight) 
gen _rank0 = __rank0/N 
bys women surv79 faminc0: egen rank0 = mean(_rank0) 
 
sort women surv79 faminc1
by women surv79: gen __rank1 = sum(weight) 
gen _rank1 = __rank1/N 
bys women surv79 faminc1: egen rank1 = mean(_rank1) 

gen perc66 = rank0*(1-surv79)
gen perc79 = rank0*surv79

drop N __rank0 _rank0 __rank1 _rank1



* --------- Rank-Rank --------- *

* Pooled
reg rank1 perc66 perc79 surv79 women [w=weight] , cluster(hhid)
eststo rank_e1
test perc79=perc66
estadd scalar p = r(p): rank_e1
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_e1
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_e1
lincom perc79-perc66
estadd scalar diff = r(estimate): rank_e1
estadd scalar se = r(se): rank_e1
drop s


* --------- IGE --------- *

* Pooled
reg lfaminc1 loginc66 loginc79 surv79 women [w=weight], cluster(hhid)
eststo IGE_e1
test loginc79=loginc66
estadd scalar p = r(p): IGE_e1
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): IGE_e1
count if surv79==1 & s==1
estadd scalar N79 = r(N): IGE_e1
lincom loginc79-loginc66
estadd scalar diff = r(estimate): IGE_e1
estadd scalar se = r(se): IGE_e1
drop s



restore



***********************************************************
* Exercise 2: Topcode top 5%
***********************************************************

preserve



gen top5 = rank0>95 & rank0<.
bys survey women: egen tc_parent = mean(faminc0) if top5==1
 replace faminc0 = tc_parent if top5==1
 replace lfaminc0 = log(faminc0) if top5==1
 
* Generate Ranks Using Non-Missing Sample *
drop perc66 perc79 rank0 rank1 
replace weight = round(weight)

gen N = .
 tab n  if surv79==0 & women==0 [w=weight]
 replace N = r(N) if surv79==0 & women==0
 tab n  if surv79==0 & women==1 [w=weight]
 replace N = r(N) if surv79==0 & women==1
 tab n  if surv79==1 & women==0 [w=weight]
 replace N = r(N) if surv79==1 & women==0
 tab n  if surv79==1 & women==1 [w=weight]
 replace N = r(N) if surv79==1 & women==1
 
sort women surv79 faminc0
by women surv79: gen __rank0 = sum(weight) 
gen _rank0 = __rank0/N 
bys women surv79 faminc0: egen rank0 = mean(_rank0) 
 
sort women surv79 faminc1
by women surv79: gen __rank1 = sum(weight) 
gen _rank1 = __rank1/N 
bys women surv79 faminc1: egen rank1 = mean(_rank1) 

gen perc66 = rank0*(1-surv79)
gen perc79 = rank0*surv79

drop N __rank0 _rank0 __rank1 _rank1



* --------- Rank-Rank --------- *

* Pooled
reg rank1 perc66 perc79 surv79 women [w=weight] , cluster(hhid)
eststo rank_e2
test perc79=perc66
estadd scalar p = r(p): rank_e2
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_e2
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_e2
lincom perc79-perc66
estadd scalar diff = r(estimate): rank_e2
estadd scalar se = r(se): rank_e2
drop s


* --------- IGE --------- *

* Pooled
reg lfaminc1 loginc66 loginc79 surv79 women [w=weight], cluster(hhid)
eststo IGE_e2
test loginc79=loginc66
estadd scalar p = r(p): IGE_e2
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): IGE_e2
count if surv79==1 & s==1
estadd scalar N79 = r(N): IGE_e2
lincom loginc79-loginc66
estadd scalar diff = r(estimate): IGE_e2
estadd scalar se = r(se): IGE_e2
drop s




restore





*********************************************************
* Exercise 3: Drop if parents or kids in top 5% of income
*********************************************************


preserve
drop if (rank1>95 | rank0>95)

* Generate Ranks Using Non-Missing Sample *
drop perc66 perc79 rank0 rank1 
replace weight = round(weight)

gen N = .
 tab n  if surv79==0 & women==0 [w=weight]
 replace N = r(N) if surv79==0 & women==0
 tab n  if surv79==0 & women==1 [w=weight]
 replace N = r(N) if surv79==0 & women==1
 tab n  if surv79==1 & women==0 [w=weight]
 replace N = r(N) if surv79==1 & women==0
 tab n  if surv79==1 & women==1 [w=weight]
 replace N = r(N) if surv79==1 & women==1
 
sort women surv79 faminc0
by women surv79: gen __rank0 = sum(weight) 
gen _rank0 = __rank0/N 
bys women surv79 faminc0: egen rank0 = mean(_rank0) 
 
sort women surv79 faminc1
by women surv79: gen __rank1 = sum(weight) 
gen _rank1 = __rank1/N 
bys women surv79 faminc1: egen rank1 = mean(_rank1) 

gen perc66 = rank0*(1-surv79)
gen perc79 = rank0*surv79

drop N __rank0 _rank0 __rank1 _rank1



* --------- Rank-Rank --------- *

* Pooled
reg rank1 perc66 perc79 surv79 women [w=weight] , cluster(hhid)
eststo rank_e3
test perc79=perc66
estadd scalar p = r(p): rank_e3
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_e3
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_e3
lincom perc79-perc66
estadd scalar diff = r(estimate): rank_e3
estadd scalar se = r(se): rank_e3
drop s


* --------- IGE --------- *

* Pooled
reg lfaminc1 loginc66 loginc79 surv79 women [w=weight], cluster(hhid)
eststo IGE_e3
test loginc79=loginc66
estadd scalar p = r(p): IGE_e3
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): IGE_e3
count if surv79==1 & s==1
estadd scalar N79 = r(N): IGE_e3
lincom loginc79-loginc66
estadd scalar diff = r(estimate): IGE_e3
estadd scalar se = r(se): IGE_e3
drop s





restore



***********************************************************
* Exercise 4: Topcode top 5% of parents and kids
***********************************************************


preserve

gen top5_parent = rank0>95 & rank0<.
bys survey women: egen tc_parent = mean(faminc0) if top5_parent==1
 replace faminc0 = tc_parent if top5_parent==1
replace lfaminc0 = log(faminc0) if top5_parent==1

gen top5_kid = rank1>95 & rank1<.
bys survey women: egen tc_kid = mean(faminc1) if top5_kid==1
 replace faminc1 = tc_kid if top5_kid==1
replace lfaminc1 = log(faminc1) if top5_kid==1

 


* Generate Ranks Using Non-Missing Sample *
drop perc66 perc79 rank0 rank1 
replace weight = round(weight)

gen N = .
 tab n  if surv79==0 & women==0 [w=weight]
 replace N = r(N) if surv79==0 & women==0
 tab n  if surv79==0 & women==1 [w=weight]
 replace N = r(N) if surv79==0 & women==1
 tab n  if surv79==1 & women==0 [w=weight]
 replace N = r(N) if surv79==1 & women==0
 tab n  if surv79==1 & women==1 [w=weight]
 replace N = r(N) if surv79==1 & women==1
 
sort women surv79 faminc0
by women surv79: gen __rank0 = sum(weight) 
gen _rank0 = __rank0/N 
bys women surv79 faminc0: egen rank0 = mean(_rank0) 
 
sort women surv79 faminc1
by women surv79: gen __rank1 = sum(weight) 
gen _rank1 = __rank1/N 
bys women surv79 faminc1: egen rank1 = mean(_rank1) 

gen perc66 = rank0*(1-surv79)
gen perc79 = rank0*surv79

drop N __rank0 _rank0 __rank1 _rank1



* --------- Rank-Rank --------- *

* Pooled
reg rank1 perc66 perc79 surv79 women [w=weight] , cluster(hhid)
eststo rank_e4
test perc79=perc66
estadd scalar p = r(p): rank_e4
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_e4
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_e4
lincom perc79-perc66
estadd scalar diff = r(estimate): rank_e4
estadd scalar se = r(se): rank_e4
drop s


* --------- IGE --------- *

* Pooled
reg lfaminc1 loginc66 loginc79 surv79 women [w=weight], cluster(hhid)
eststo IGE_e4
test loginc79=loginc66
estadd scalar p = r(p): IGE_e4
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): IGE_e4
count if surv79==1 & s==1
estadd scalar N79 = r(N): IGE_e4
lincom loginc79-loginc66
estadd scalar diff = r(estimate): IGE_e4
estadd scalar se = r(se): IGE_e4
drop s







#delimit ;
estout rank_e1 rank_e2 rank_e3 rank_e4
	using  "${results_dir}table5.txt", replace
	keep(perc66 perc79) 
	cells(b(star fmt(3))  se(par fmt(3))) 
	collabels(,none) stat(diff se p N66 N79) stardrop(*) ;	
	
	
estout IGE_e1 IGE_e2 IGE_e3 IGE_e4 
	using  "${results_dir}table5.txt", append
	keep(loginc66 loginc79) 
	cells(b(star fmt(3))  se(par fmt(3))) 
	collabels(,none) stat(diff se p N66 N79) stardrop(*) ;		
#delimit cr	

