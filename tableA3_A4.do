* Table A3: Intergenerational Mobility in the 1948-1953 and 1961-1964 Cohorts
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


gen id = .
 replace id = id_son if survey==1966 & women==0
 replace id = id_daughter if survey==1966 & women==1
 replace id = CASEID if survey==1979
 
* Dataset created by figure4.do
merge 1:1 id survey women using  ${data_dir}weight_adjustments.dta


* Summary Statistics for Table A4 *
matrix sumstat = J(4,4,.)

local row = 0
foreach survey in 1966 1979 {
 local row = `row'+1
 su faminc0 if survey==`survey' [w=weight]
 matrix sumstat[`row',1] = r(mean)

   
 su faminc0 if survey==`survey' [w=wt_nls_parent]
 matrix sumstat[`row',2] = r(mean)

 su faminc0 if survey==`survey' [w=wt_nls_kid]
 matrix sumstat[`row',3] = r(mean)
 
 su faminc0 if survey==`survey' [w=wt_nls_avg]
 matrix sumstat[`row',4] = r(mean)
 
 }
 
foreach survey in 1966 1979 {
 local row = `row'+1
 su faminc1 if survey==`survey' [w=weight]
 matrix sumstat[`row',1] = r(mean)

   
 su faminc1 if survey==`survey' [w=wt_nls_parent]
 matrix sumstat[`row',2] = r(mean)

 su faminc1 if survey==`survey' [w=wt_nls_kid]
 matrix sumstat[`row',3] = r(mean)
 
 su faminc1 if survey==`survey' [w=wt_nls_avg]
 matrix sumstat[`row',4] = r(mean)
 
 }
 
 * Table A4 Summary Statistics
 matrix list sumstat
 

su faminc1 faminc0 if survey==1966 [w=weight]
su faminc1 faminc0 if survey==1966 [w=weight]


* ----------- Parent Weight Adjustments ---------------- *


* --------- Rank-Rank --------- *

* Pooled
reg rank1 perc66 perc79 surv79 women [w=wt_nls_parent] , cluster(hhid)
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



* --------- IGE --------- *

* Pooled
reg lfaminc1 loginc66 loginc79 surv79 women [w=wt_nls_parent], cluster(hhid)
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





* ----------- Kid Weight Adjustments ---------------- *


* --------- Rank-Rank --------- *

* Pooled
reg rank1 perc66 perc79 surv79 women [w=wt_nls_kid] , cluster(hhid)
eststo rank_k
test perc79=perc66
estadd scalar p = r(p): rank_k
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_k
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_k
drop s
lincom perc79-perc66
estadd scalar diff = r(estimate): rank_k
estadd scalar se = r(se): rank_k





* --------- IGE --------- *

* Pooled
reg lfaminc1 loginc66 loginc79 surv79 women [w=wt_nls_kid], cluster(hhid)
eststo IGE_k
test loginc79=loginc66
estadd scalar p = r(p): IGE_k
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): IGE_k
count if surv79==1 & s==1
estadd scalar N79 = r(N): IGE_k
drop s
lincom loginc79-loginc66
estadd scalar diff = r(estimate): IGE_k
estadd scalar se = r(se): IGE_k





* ----------- Average Weight Adjustments ---------------- *


* --------- Rank-Rank --------- *

* Pooled
reg rank1 perc66 perc79 surv79 women [w=wt_nls_avg] , cluster(hhid)
eststo rank_a
test perc79=perc66
estadd scalar p = r(p): rank_a
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_a
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_a
drop s
lincom perc79-perc66
estadd scalar diff = r(estimate): rank_a
estadd scalar se = r(se): rank_a


* --------- IGE --------- *

* Pooled
reg lfaminc1 loginc66 loginc79 surv79 women [w=wt_nls_avg], cluster(hhid)
eststo IGE_a
test loginc79=loginc66
estadd scalar p = r(p): IGE_a
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): IGE_a
count if surv79==1 & s==1
estadd scalar N79 = r(N): IGE_a
drop s
lincom loginc79-loginc66
estadd scalar diff = r(estimate): IGE_a
estadd scalar se = r(se): IGE_a



#delimit ;
estout rank_p IGE_p rank_k IGE_k rank_a IGE_a
	using  "${results_dir}tableA3.txt", replace
	keep(perc66 perc79) 
	rename(loginc66  perc66 loginc79 perc79)
	cells(b(star fmt(3))  se(par fmt(3))) 
	collabels(,none) stat(diff se p N66 N79) stardrop(*) ;	
#delimit cr	

