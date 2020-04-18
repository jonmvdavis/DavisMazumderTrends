* Table 6: Robustness to Choice of Survey Weights
clear
use "${data_dir}DavisMazumderData.dta"
keep if age_firstSurvey<=18
drop if miss0 | miss1
drop if (mom_outOfRange==1 & linkMom==1 & !(dad_outOfRange==0 & linkDad==1)) | (dad_outOfRange==1 & linkDad==1 & !(mom_outOfRange==0 & linkMom==1)) | (linkMom==0 & linkDad==0) 
 

* Ranks are generated using weights, so generate separate set of ranks using each choice of weight
* ------------------ *
* Ranks - No Weights *
* ------------------ *


gen N = .
 tab n  if surv79==0 & women==0 
 replace N = r(N) if surv79==0 & women==0
 tab n  if surv79==0 & women==1 
 replace N = r(N) if surv79==0 & women==1
 tab n  if surv79==1 & women==0 
 replace N = r(N) if surv79==1 & women==0
 tab n  if surv79==1 & women==1 
 replace N = r(N) if surv79==1 & women==1
 
sort women surv79 faminc0
by women surv79: gen __rank0 = sum(n) 
gen _rank0 = __rank0/N 
bys women surv79 faminc0: egen rank0_noweight = mean(_rank0) 
 
sort women surv79 faminc1
by women surv79: gen __rank1 = sum(n) 
gen _rank1 = __rank1/N 
bys women surv79 faminc1: egen rank1_noweight = mean(_rank1) 

gen perc66_noweight = rank0_noweight*(1-surv79)
gen perc79_noweight = rank0_noweight*surv79

drop N __rank0 _rank0 __rank1 _rank1



* ------------------------------ *
* Ranks - First Interview Weight *
* ------------------------------ *

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



* -------------------- *
* Ranks - First Income *
* -------------------- *


gen N = .
 tab n  if surv79==0 & women==0 [w=weight_incFirst]
 replace N = r(N) if surv79==0 & women==0
 tab n  if surv79==0 & women==1 [w=weight_incFirst]
 replace N = r(N) if surv79==0 & women==1
 tab n  if surv79==1 & women==0 [w=weight_incFirst]
 replace N = r(N) if surv79==1 & women==0
 tab n  if surv79==1 & women==1 [w=weight_incFirst]
 replace N = r(N) if surv79==1 & women==1
 
sort women surv79 faminc0
by women surv79: gen __rank0 = sum(weight_incFirst) 
gen _rank0 = __rank0/N 
bys women surv79 faminc0: egen rank0_incFirst = mean(_rank0) 
 
sort women surv79 faminc1
by women surv79: gen __rank1 = sum(weight_incFirst) 
gen _rank1 = __rank1/N 
bys women surv79 faminc1: egen rank1_first = mean(_rank1) 

gen perc66_first = rank0_incFirst*(1-surv79)
gen perc79_first = rank0_incFirst*surv79

drop N __rank0 _rank0 __rank1 _rank1


* -------------------- *
* Ranks - Last Income *
* -------------------- *


gen N = .
 tab n  if surv79==0 & women==0 [w=weight_incLast]
 replace N = r(N) if surv79==0 & women==0
 tab n  if surv79==0 & women==1 [w=weight_incLast]
 replace N = r(N) if surv79==0 & women==1
 tab n  if surv79==1 & women==0 [w=weight_incLast]
 replace N = r(N) if surv79==1 & women==0
 tab n  if surv79==1 & women==1 [w=weight_incLast]
 replace N = r(N) if surv79==1 & women==1
 
sort women surv79 faminc0
by women surv79: gen __rank0 = sum(weight_incLast) 
gen _rank0 = __rank0/N 
bys women surv79 faminc0: egen rank0_incLast = mean(_rank0) 
 
sort women surv79 faminc1
by women surv79: gen __rank1 = sum(weight_incLast) 
gen _rank1 = __rank1/N 
bys women surv79 faminc1: egen rank1_last = mean(_rank1) 

gen perc66_last = rank0_incLast*(1-surv79)
gen perc79_last = rank0_incLast*surv79

drop N __rank0 _rank0 __rank1 _rank1

* ---------------------- *
* Ranks - Average Income *
* ---------------------- *

replace weight_incAvg = round(weight_incAvg)
gen N = .
 tab n  if surv79==0 & women==0 [w=weight_incAvg]
 replace N = r(N) if surv79==0 & women==0
 tab n  if surv79==0 & women==1 [w=weight_incAvg]
 replace N = r(N) if surv79==0 & women==1
 tab n  if surv79==1 & women==0 [w=weight_incAvg]
 replace N = r(N) if surv79==1 & women==0
 tab n  if surv79==1 & women==1 [w=weight_incAvg]
 replace N = r(N) if surv79==1 & women==1
 
sort women surv79 faminc0
by women surv79: gen __rank0 = sum(weight_incAvg) 
gen _rank0 = __rank0/N 
bys women surv79 faminc0: egen rank0_incAvg = mean(_rank0) 
 
sort women surv79 faminc1
by women surv79: gen __rank1 = sum(weight_incAvg) 
gen _rank1 = __rank1/N 
bys women surv79 faminc1: egen rank1_avg = mean(_rank1) 

gen perc66_avg = rank0_incAvg*(1-surv79)
gen perc79_avg = rank0_incAvg*surv79

drop N __rank0 _rank0 __rank1 _rank1



* --------- Rank-Rank --------- *

* No weight
reg rank1_noweight perc66_noweight perc79_noweight surv79 women  , cluster(hhid)
eststo rank_none
test perc79=perc66
estadd scalar p = r(p): rank_none
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_none
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_none
lincom perc79_noweight-perc66_noweight
estadd scalar diff = r(estimate): rank_none
estadd scalar se = r(se): rank_none
drop s

* First Weight
reg rank1 perc66 perc79 surv79 women [w=weight] , cluster(hhid)
eststo rank_first
test perc79=perc66
estadd scalar p = r(p): rank_first
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_first
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_first
lincom perc79-perc66
estadd scalar diff = r(estimate): rank_first
estadd scalar se = r(se): rank_first
drop s

* First Income Weight
reg rank1_first perc66_first perc79_first surv79 women [w=weight_incFirst] , cluster(hhid)
eststo rank_incFirst
test perc79=perc66
estadd scalar p = r(p): rank_incFirst
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_incFirst
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_incFirst
lincom perc79_first-perc66_first
estadd scalar diff = r(estimate): rank_incFirst
estadd scalar se = r(se): rank_incFirst
drop s

* Last Income Weight
reg rank1_last perc66_last perc79_last surv79 women [w=weight_incLast] , cluster(hhid)
eststo rank_incLast
test perc79=perc66
estadd scalar p = r(p): rank_incLast
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_incLast
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_incLast
lincom perc79_last-perc66_last
estadd scalar diff = r(estimate): rank_incLast
estadd scalar se = r(se): rank_incLast
drop s

* Average Income Weight
reg rank1_avg perc66_avg perc79_avg surv79 women [w=weight_incAvg] , cluster(hhid)
eststo rank_incAvg
test perc79=perc66
estadd scalar p = r(p): rank_incAvg
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_incAvg
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_incAvg
lincom perc79_avg-perc66_avg
estadd scalar diff = r(estimate): rank_incAvg
estadd scalar se = r(se): rank_incAvg
drop s

* --------- IGE --------- *

* No Weight
reg lfaminc1 loginc66 loginc79 surv79 women ,  cluster(hhid)
eststo IGE_none
test loginc79=loginc66
estadd scalar p = r(p): IGE_none
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): IGE_none
count if surv79==1 & s==1
estadd scalar N79 = r(N): IGE_none
lincom loginc79-loginc66
estadd scalar diff = r(estimate): IGE_none
estadd scalar se = r(se): IGE_none
drop s

* First Weight
reg lfaminc1 loginc66 loginc79 surv79 women [w=weight],  cluster(hhid)
eststo IGE_first
test loginc79=loginc66
estadd scalar p = r(p): IGE_first
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): IGE_first
count if surv79==1 & s==1
estadd scalar N79 = r(N): IGE_first
lincom loginc79-loginc66
estadd scalar diff = r(estimate): IGE_first
estadd scalar se = r(se): IGE_first
drop s


* First Income Weight
reg lfaminc1 loginc66 loginc79 surv79 women [w=weight_incFirst],  cluster(hhid)
eststo IGE_incFirst
test loginc79=loginc66
estadd scalar p = r(p): IGE_incFirst
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): IGE_incFirst
count if surv79==1 & s==1
estadd scalar N79 = r(N): IGE_incFirst
lincom loginc79-loginc66
estadd scalar diff = r(estimate): IGE_incFirst
estadd scalar se = r(se): IGE_incFirst

drop s

* Last Income Weight
reg lfaminc1 loginc66 loginc79 surv79 women [w=weight_incLast],  cluster(hhid)
eststo IGE_incLast
test loginc79=loginc66
estadd scalar p = r(p): IGE_incLast
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): IGE_incLast
count if surv79==1 & s==1
estadd scalar N79 = r(N): IGE_incLast
lincom loginc79-loginc66
estadd scalar diff = r(estimate): IGE_incLast
estadd scalar se = r(se): IGE_incLast
drop s

* Average Income Weight
reg lfaminc1 loginc66 loginc79 surv79 women [w=weight_incAvg],  cluster(hhid)
eststo IGE_incAvg
test loginc79=loginc66
estadd scalar p = r(p): IGE_incAvg
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): IGE_incAvg
count if surv79==1 & s==1
estadd scalar N79 = r(N): IGE_incAvg
lincom loginc79-loginc66
estadd scalar diff = r(estimate): IGE_incAvg
estadd scalar se = r(se): IGE_incAvg
drop s

#delimit ;
estout rank_none rank_first rank_incFirst rank_incLast rank_incAvg
	using  "${results_dir}table6.txt", replace
	keep(perc66 perc79)
	rename(perc66_noweight perc66  perc79_noweight perc79
	perc66_first perc66 perc79_first perc79 
	perc66_last perc66 perc79_last perc79 
	perc66_avg perc66 perc79_avg perc79) 
	cells(b(star fmt(3))  se(par fmt(3))) 
	collabels(,none) stat(diff se p N66 N79) stardrop(*) ;	

estout IGE_none IGE_first IGE_incFirst IGE_incLast IGE_incAvg
	using  "${results_dir}table6.txt", append
	keep(loginc66 loginc79) 
	cells(b(star fmt(3))  se(par fmt(3))) 
	collabels(,none) stat(diff se p N66 N79) stardrop(*) ;		
#delimit cr	

exit
