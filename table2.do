* Table 2: Intergenerational Mobility in the 1948-1953 and 1961-1964 Cohorts
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






* --------- Rank-Rank --------- *

* Pooled
reg rank1 perc66 perc79 surv79 women [w=weight] , cluster(hhid)
eststo rank_p
test perc79=perc66
estadd scalar p = r(p): rank_p
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_p
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_p
drop s
lincom perc79-perc66
estadd scalar diff = r(estimate): rank_p
estadd scalar se = r(se): rank_p



* Women
reg rank1 perc66 perc79 surv79 if women==1 [w=weight] , cluster(hhid)
eststo rank_w
test perc79=perc66
estadd scalar p = r(p): rank_w
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_w
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_w
lincom perc79-perc66
estadd scalar diff = r(estimate): rank_w
estadd scalar se = r(se): rank_w
drop s

* Men
reg rank1 perc66 perc79 surv79 if women==0 [w=weight] , cluster(hhid)
eststo rank_m
test perc79=perc66
estadd scalar p = r(p): rank_m
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_m
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_m
lincom perc79-perc66
estadd scalar diff = r(estimate): rank_m
estadd scalar se = r(se): rank_m
drop s



* --------- IGE --------- *

* Pooled
reg lfaminc1 loginc66 loginc79 surv79 women [w=weight], cluster(hhid)
eststo IGE_p
test loginc79=loginc66
estadd scalar p = r(p): IGE_p
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): IGE_p
count if surv79==1 & s==1
estadd scalar N79 = r(N): IGE_p
drop s
lincom loginc79-loginc66
estadd scalar diff = r(estimate): IGE_p
estadd scalar se = r(se): IGE_p


* Women
reg lfaminc1 loginc66 loginc79 surv79 if women==1 [w=weight], cluster(hhid)
eststo IGE_w
test loginc79=loginc66
estadd scalar p = r(p): IGE_w
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): IGE_w
count if surv79==1 & s==1
estadd scalar N79 = r(N): IGE_w
lincom loginc79-loginc66
estadd scalar diff = r(estimate): IGE_w
estadd scalar se = r(se): IGE_w
drop s

* Men
reg lfaminc1 loginc66 loginc79 surv79 if women==0 [w=weight], cluster(hhid)
eststo IGE_m
test loginc79=loginc66
estadd scalar p = r(p): IGE_m
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): IGE_m
count if surv79==1 & s==1
estadd scalar N79 = r(N): IGE_m
lincom loginc79-loginc66
estadd scalar diff = r(estimate): IGE_m
estadd scalar se = r(se): IGE_m
drop s

#delimit ;
estout rank_p IGE_p rank_w IGE_w rank_m IGE_m
	using  "${results_dir}table2.txt", replace
	keep(perc66 perc79) 
	rename(loginc66  perc66 loginc79 perc79)
	cells(b(star fmt(3))  se(par fmt(3))) 
	collabels(,none) stat(diff se p  N66 N79) stardrop(*) ;	
#delimit cr	

exit
