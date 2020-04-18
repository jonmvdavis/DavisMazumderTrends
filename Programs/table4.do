* Table 4: Missingness and Zero Income in the 1948-1953 and 1961-1964 cohorts

clear
use "${data_dir}DavisMazumderData.dta"
keep if age_firstSurvey<=18
drop if miss0 | miss1
drop if (mom_outOfRange==1 & linkMom==1 & !(dad_outOfRange==0 & linkDad==1)) | (dad_outOfRange==1 & linkDad==1 & !(mom_outOfRange==0 & linkMom==1)) | (linkMom==0 & linkDad==0) 
 

 
 
 
 
* Need to generate decile indicator for inverse propensity score weights
* Will drop and generate using sample with no missing or zero data 
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

 * Parent Decile Indicators
gen decile0 = 1 if rank0<=10
 replace decile0 = 2 if rank0>10 & rank0<=20
 replace decile0 = 3 if rank0>20 & rank0<=30
 replace decile0 = 4 if rank0>30 & rank0<=40
 replace decile0 = 5 if rank0>40 & rank0<=50
 replace decile0 = 6 if rank0>50 & rank0<=60
 replace decile0 = 7 if rank0>60 & rank0<=70
 replace decile0 = 8 if rank0>70 & rank0<=80
 replace decile0 = 9 if rank0>80 & rank0<=90
 replace decile0 = 10 if rank0>90 & rank0<=100
 
 
 
 
* Calculate probability have no missing or zero data by survey, gender, and parent income decile
gen all_inc = all_parent==1 & all_kid==1
bys surv79 women decile: egen p_all_inc = wtmean(all_inc), weight(weight)
keep if all_inc==1 & lfaminc0<. & lfaminc1<.
gen ipw_weight = weight/p_all_inc



* Generate ranks again using non-missing sample *
drop N __rank0 _rank0 rank0

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



* And again with IPW Weight
replace ipw_weight=round(100*ipw_weight)
gen N = .
 tab n  if surv79==0 & women==0 [w=ipw_weight]
 replace N = r(N) if surv79==0 & women==0
 tab n  if surv79==0 & women==1 [w=ipw_weight]
 replace N = r(N) if surv79==0 & women==1
 tab n  if surv79==1 & women==0 [w=ipw_weight]
 replace N = r(N) if surv79==1 & women==0
 tab n  if surv79==1 & women==1 [w=ipw_weight]
 replace N = r(N) if surv79==1 & women==1
 
sort women surv79 faminc0
by women surv79: gen __rank0 = sum(ipw_weight) 
gen _rank0 = __rank0/N 
bys women surv79 faminc0: egen rank0_rewt = mean(_rank0) 
 
sort women surv79 faminc1
by women surv79: gen __rank1 = sum(ipw_weight) 
gen _rank1 = __rank1/N 
bys women surv79 faminc1: egen rank1_rewt = mean(_rank1) 

gen perc66_rewt = rank0_rewt*(1-surv79)
gen perc79_rewt = rank0_rewt*surv79

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
lincom perc79-perc66
estadd scalar diff = r(estimate): rank_p
estadd scalar se = r(se): rank_p
drop s

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
lincom loginc79-loginc66
estadd scalar diff = r(estimate): IGE_p
estadd scalar se = r(se): IGE_p
drop s

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






* --------- Rank-Rank --------- *

* Pooled
reg rank1_rewt perc66_rewt perc79_rewt surv79 women [w=ipw_weight] , cluster(hhid)
eststo rank_p_ipw
test perc79_rewt=perc66_rewt
estadd scalar p = r(p): rank_p_ipw
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_p_ipw
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_p_ipw
lincom perc79_rewt-perc66_rewt
estadd scalar diff = r(estimate): rank_p_ipw
estadd scalar se = r(se): rank_p_ipw
drop s

* Women
reg rank1_rewt perc66_rewt perc79_rewt surv79 if women==1 [w=ipw_weight] , cluster(hhid)
eststo rank_w_ipw
test perc79_rewt=perc66_rewt
estadd scalar p = r(p): rank_w_ipw
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_w_ipw
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_w_ipw
lincom perc79_rewt-perc66_rewt
estadd scalar diff = r(estimate): rank_w_ipw
estadd scalar se = r(se): rank_w_ipw
drop s

* Men
reg rank1_rewt perc66_rewt perc79_rewt surv79 if women==0 [w=ipw_weight] , cluster(hhid)
eststo rank_m_ipw
test perc79_rewt=perc66_rewt
estadd scalar p = r(p): rank_m_ipw
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_m_ipw
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_m_ipw
lincom perc79_rewt-perc66_rewt
estadd scalar diff = r(estimate): rank_m_ipw
estadd scalar se = r(se): rank_m_ipw
drop s

* --------- IGE --------- *

* Pooled
reg lfaminc1 loginc66 loginc79 surv79 women [w=ipw_weight], cluster(hhid)
eststo IGE_p_ipw
test loginc79=loginc66
estadd scalar p = r(p): IGE_p_ipw
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): IGE_p_ipw
count if surv79==1 & s==1
estadd scalar N79 = r(N): IGE_p_ipw
lincom loginc79-loginc66
estadd scalar diff = r(estimate): IGE_p_ipw
estadd scalar se = r(se): IGE_p_ipw
drop s

* Women
reg lfaminc1 loginc66 loginc79 surv79 if women==1 [w=ipw_weight], cluster(hhid)
eststo IGE_w_ipw
test loginc79=loginc66
estadd scalar p = r(p): IGE_w_ipw
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): IGE_w_ipw
count if surv79==1 & s==1
estadd scalar N79 = r(N): IGE_w_ipw
lincom loginc79-loginc66
estadd scalar diff = r(estimate): IGE_w_ipw
estadd scalar se = r(se): IGE_w_ipw
drop s

* Men
reg lfaminc1 loginc66 loginc79 surv79 if women==0 [w=ipw_weight], cluster(hhid)
eststo IGE_m_ipw
test loginc79=loginc66
estadd scalar p = r(p): IGE_m_ipw
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): IGE_m_ipw
count if surv79==1 & s==1
estadd scalar N79 = r(N): IGE_m_ipw
lincom loginc79-loginc66
estadd scalar diff = r(estimate): IGE_m_ipw
estadd scalar se = r(se): IGE_m_ipw
drop s



#delimit ;
estout rank_p IGE_p rank_p_ipw IGE_p_ipw
	using  "${results_dir}table4.txt", replace
	keep(perc66 perc79) 
	rename(loginc66  perc66 loginc79 perc79 perc66_rewt perc66 perc79_rewt perc79)
	cells(b(star fmt(3))  se(par fmt(3))) 
	collabels(,none) stat(diff se p N66 N79) stardrop(*) ;	
#delimit cr	

exit
#delimit ;
estout rank_p IGE_p rank_w IGE_w rank_m IGE_m
	using  "${results_dir}table4.txt", append
	keep(perc66_rewt perc79_rewt) 
	rename(loginc66  perc66_rewt loginc79 perc79_rewt)
	cells(b(star fmt(3))  se(par fmt(3))) 
	collabels(,none) stat(p N66 N79) stardrop(*) ;	
#delimit cr	
