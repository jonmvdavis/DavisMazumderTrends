* Table 7: Education and Intergenerational Mobility in the 1948-1953 and 1961-1964 Cohorts
clear
use "${data_dir}DavisMazumderData.dta"
keep if age_firstSurvey<=18
drop if miss0 | miss1
drop if (mom_outOfRange==1 & linkMom==1 & !(dad_outOfRange==0 & linkDad==1)) | (dad_outOfRange==1 & linkDad==1 & !(mom_outOfRange==0 & linkMom==1)) | (linkMom==0 & linkDad==0) 
 

* Top and Bottom Codes Years of Education
replace hgc = 8 if hgc<8
replace hgc = 16 if hgc>16 & hgc<=20


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



* Gradient of Years of Education versus Parent Income

reg hgc perc66 perc79 surv79  women [w=weight], cluster(hhid)
eststo hgc
test perc79=perc66
estadd scalar p = r(p): hgc
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): hgc
count if surv79==1 & s==1
estadd scalar N79 = r(N): hgc
lincom perc79-perc66
estadd scalar diff = r(estimate): hgc
estadd scalar se = r(se): hgc
drop s


reg hgc loginc66 loginc79 surv79  women [w=weight], cluster(hhid)
eststo hgc_ige
test loginc66=loginc79
estadd scalar p = r(p): hgc_ige
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): hgc_ige
count if surv79==1 & s==1
estadd scalar N79 = r(N): hgc_ige
lincom loginc79-loginc66
estadd scalar diff = r(estimate): hgc_ige
estadd scalar se = r(se): hgc_ige
drop s



* Returns to Education
gen hgc66 = hgc*(surv79==0)
gen hgc79 = hgc*(surv79==1)
reg lfaminc1 hgc66 hgc79 surv79 women  [w=weight], cluster(hhid)
eststo returns
test hgc66=hgc79
estadd scalar p = r(p): returns
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): returns
count if surv79==1 & s==1
estadd scalar N79 = r(N): returns
lincom hgc79-hgc66
estadd scalar diff = r(estimate): returns
estadd scalar se = r(se): returns
drop s

* Holding Returns to Education Fixed

foreach s in 66 79 {
 gen prem_faminc_19`s' = .
 forv w=0/1 {
  su faminc1 if survey==19`s' & women==`w' & hgc==12 [w=weight]
  local r12 = r(mean)
  forv g=8/16 {
   su faminc1 if survey==19`s' & women==`w' & hgc==`g' [w=weight]
   replace prem_faminc_19`s' = r(mean)-`r12' if hgc==`g' & women==`w'
  }
 }
}

gen faminc1_sim = faminc1 if surv79==0
 replace faminc1_sim = faminc1-prem_faminc_1979 +prem_faminc_1966 if surv79==1
gen lfaminc1_sim = log(faminc1_sim)

************************************
* Generate Rank Using 1966 Returns *
************************************


gen N = .
 tab n  if surv79==0 & women==0  [w=weight]
 replace N = r(N) if surv79==0 & women==0 
 tab n  if surv79==0 & women==1   [w=weight]
 replace N = r(N) if surv79==0 & women==1 
 tab n  if surv79==1 & women==0   [w=weight]
 replace N = r(N) if surv79==1 & women==0 
 tab n  if surv79==1 & women==1  [w=weight]
 replace N = r(N) if surv79==1 & women==1 
 

sort women surv79 faminc1_sim
by women surv79: gen __rank1 = sum(weight) 
gen _rank1 = __rank1/N 
bys women surv79 faminc1_sim: egen rank1_sim = mean(_rank1) 
replace rank1_sim = 100*rank1_sim
drop __rank1 _rank1  N 


reg lfaminc1_sim hgc66 hgc79 surv79 women  [w=weight], cluster(hhid)
eststo returns_sim
test hgc66=hgc79
estadd scalar p = r(p): returns_sim
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): returns_sim
count if surv79==1 & s==1
estadd scalar N79 = r(N): returns_sim
lincom hgc79-hgc66
estadd scalar diff = r(estimate): returns_sim
estadd scalar se = r(se): returns_sim
drop s

reg rank1_sim perc66 perc79 surv79 women  [w=weight], cluster(hhid)
eststo rank_sim
test perc66=perc79
estadd scalar p = r(p): rank_sim
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_sim
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_sim
lincom perc79-perc66
estadd scalar diff = r(estimate): rank_sim
estadd scalar se = r(se): rank_sim
drop s
lincom perc79-perc66
global rank_edret_est = r(estimate)
global rank_edret_se = r(se)


reg lfaminc1_sim loginc66 loginc79 surv79 women  [w=weight], cluster(hhid)
eststo ige_sim
test loginc66= loginc79
estadd scalar p = r(p): ige_sim
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): ige_sim
count if surv79==1 & s==1
estadd scalar N79 = r(N): ige_sim
lincom loginc79-loginc66
estadd scalar diff = r(estimate): ige_sim
estadd scalar se = r(se): ige_sim
global ige_edret_est = r(estimate)
global ige_edret_se = r(se)
reg lfaminc1 loginc66 loginc79 surv79 women  [w=weight] if s==1, cluster(hhid)
drop s



#delimit ;
estout  hgc hgc_ige   returns returns_sim rank_sim ige_sim 
	using  "${results_dir}table7.txt", replace
	keep(perc66 perc79) 
	rename(loginc66  perc66 loginc79 perc79 hgc66 perc66 hgc79 perc79)
	cells(b(star fmt(3))  se(par fmt(3))) 
	collabels(,none) stat(diff se p N66 N79) stardrop(*) ;	
#delimit cr	

exit
