* Table 8: Marraige and Intergenerational Mobility in the 1948-1953 and 1961-1964 Cohorts
clear
set seed 620955


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


* Own Income Rank in Kid Generation
drop N
gen N = .
 tab n  if surv79==0 & women==0   & miss1_own==0 [w=weight]
 replace N = r(N) if surv79==0 & women==0   & miss1_own==0
 tab n  if surv79==0 & women==1     & miss1_own==0 [w=weight]
 replace N = r(N) if surv79==0 & women==1    & miss1_own==0
 tab n  if surv79==1 & women==0     & miss1_own==0 [w=weight]
 replace N = r(N) if surv79==1 & women==0    & miss1_own==0
 tab n  if surv79==1 & women==1    & miss1_own==0 [w=weight]
 replace N = r(N) if surv79==1 & women==1    & miss1_own==0


gen owninc_nm = owninc
replace owninc_nm = . if !(miss1_own==0 )
sort women surv79 owninc_nm
by women surv79: gen __ownrank = sum(weight) if miss1_own==0
gen _ownrank = __ownrank/N if miss1_own==0
bys women surv79 owninc_nm: egen ownrank = mean(_ownrank) if miss1_own==0
replace ownrank = 100*ownrank


drop N __rank0 _rank0 __rank1 _rank1  __ownrank _ownrank owninc_nm 

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
 
 


* Married Always
reg married perc66 perc79 surv79  women [w=weight], cluster(hhid)
eststo married
test perc79=perc66
estadd scalar p = r(p): married
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): married
count if surv79==1 & s==1
estadd scalar N79 = r(N): married
lincom perc79-perc66
estadd scalar diff = r(estimate): married
estadd scalar se = r(se): married
drop s



reg married loginc66 loginc79 surv79  women [w=weight], cluster(hhid)
eststo married_ige
test loginc66=loginc79
estadd scalar p = r(p): married_ige
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): married_ige
count if surv79==1 & s==1
estadd scalar N79 = r(N): married_ige
lincom loginc79-loginc66
estadd scalar diff = r(estimate): married_ige
estadd scalar se = r(se): married_ige
drop s


* Own Rank

reg ownrank perc66 perc79 surv79  women [w=weight] , cluster(hhid)
eststo ownrank
test perc79=perc66
estadd scalar p = r(p): ownrank
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): ownrank
count if surv79==1 & s==1
estadd scalar N79 = r(N): ownrank
lincom perc79-perc66
estadd scalar diff = r(estimate): ownrank
estadd scalar se = r(se): ownrank
drop s


reg lown loginc66 loginc79 surv79  women [w=weight] , cluster(hhid)
eststo ownrank_ige
test loginc66=loginc79
estadd scalar p = r(p): ownrank_ige
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): ownrank_ige
count if surv79==1 & s==1
estadd scalar N79 = r(N): ownrank_ige
lincom loginc79-loginc66
estadd scalar diff = r(estimate): ownrank_ige
estadd scalar se = r(se): ownrank_ige
drop s



replace spouse_inc = . if share_married<100

gen spouse_mean = .
gen spouse_sd = .
forv women=0/1 {
	forv surv=0/1 {
		forv decile = 1/10 {
			qui su spouse_inc if women==`women' & surv79==`surv' & decile==`decile' [w=weight]
			replace spouse_mean = r(mean) if women==`women' & surv79==`surv' & decile==`decile'
			replace spouse_sd = r(sd) if women==`women' & surv79==`surv' & decile==`decile'
		}
	}
}

gen spouse_impute = rnormal(spouse_mean,spouse_sd)


replace spouse_inc = spouse_impute if share_married<100

gen faminc1_impute = faminc1 if share_married==100
 replace faminc1_impute = faminc1+spouse_impute if share_married<100
gen lfaminc1_impute = log(faminc1_impute)

* Rank Mobility
gen rank0_married = .
gen rank1_married = .
gen rank1_impute = .

replace weight = round(weight)

gen N = .
 tab n  if surv79==0 & women==0  [w=weight]
 replace N = r(N) if surv79==0 & women==0 
 tab n  if surv79==0 & women==1   [w=weight]
 replace N = r(N) if surv79==0 & women==1 
 tab n  if surv79==1 & women==0   [w=weight]
 replace N = r(N) if surv79==1 & women==0 
 tab n  if surv79==1 & women==1  [w=weight]
 replace N = r(N) if surv79==1 & women==1 
 
sort women surv79 faminc1_impute
by women surv79: gen __rank1 = sum(weight) 
gen _rank1 = __rank1/N 
bys women surv79 faminc1_impute: egen rank1_impute_ = mean(_rank1) 
replace rank1_impute = rank1_impute_ 
drop __rank1 _rank1 rank1_impute_ N 



replace rank1_impute = rank1_impute*100


reg rank1_impute perc66 perc79 surv79  women [w=weight] , cluster(hhid)
eststo rank_impute
test perc79=perc66
estadd scalar p = r(p): rank_impute
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_impute
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_impute
drop s
lincom perc79-perc66
estadd scalar diff = r(estimate): rank_impute
estadd scalar se = r(se): rank_impute
global rank_married_est = r(estimate)
global rank_married_se = r(se)


reg lfaminc1_impute loginc66 loginc79 surv79  women [w=weight] , cluster(hhid)
eststo rank_impute_ige
test loginc66=loginc79
estadd scalar p = r(p): rank_impute_ige
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): rank_impute_ige
count if surv79==1 & s==1
estadd scalar N79 = r(N): rank_impute_ige
drop s
lincom loginc79-loginc66
estadd scalar diff = r(estimate): rank_impute_ige
estadd scalar se = r(se): rank_impute_ige
global ige_married_est = r(estimate)
global ige_married_se = r(se)

gen ownrank66 = ownrank*(1-surv79)
gen ownrank79 = ownrank*surv79




reg  rank1  ownrank66 ownrank79 surv79  women [w=weight] if share_married==100, cluster(hhid)
eststo assort
test ownrank66 =ownrank79
estadd scalar p = r(p): assort
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): assort
count if surv79==1 & s==1
estadd scalar N79 = r(N): assort
lincom ownrank79-ownrank66
estadd scalar diff = r(estimate): assort
estadd scalar se = r(se): assort
drop s

gen lown66 = lown*(1-surv79)
gen lown79 = lown*surv79



reg  lfaminc1  lown66 lown79 surv79  women [w=weight] if share_married==100, cluster(hhid)
eststo assort_ige
test lown66=lown79
estadd scalar p = r(p): assort_ige
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): assort_ige
count if surv79==1 & s==1
estadd scalar N79 = r(N): assort_ige
lincom lown79-lown66
estadd scalar diff = r(estimate): assort_ige
estadd scalar se = r(se): assort_ige
drop s


reg  rank1_impute  ownrank66 ownrank79 surv79  women [w=weight] , cluster(hhid)
eststo assort_impute
test ownrank66 =ownrank79
estadd scalar p = r(p): assort_impute
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): assort_impute
count if surv79==1 & s==1
estadd scalar N79 = r(N): assort_impute
lincom ownrank79-ownrank66
estadd scalar diff = r(estimate): assort_impute
estadd scalar se = r(se): assort_impute
drop s

reg  lfaminc1_impute  lown66 lown79 surv79  women [w=weight] , cluster(hhid)
eststo assort_impute_ige
test lown66=lown79
estadd scalar p = r(p): assort_impute_ige
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): assort_impute_ige
count if surv79==1 & s==1
estadd scalar N79 = r(N): assort_impute_ige
lincom lown79-lown66
estadd scalar diff = r(estimate): assort_impute_ige
estadd scalar se = r(se): assort_impute_ige
drop s




#delimit ;
estout  married ownrank rank_impute assort assort_impute 
	using  "${results_dir}table8.txt",  replace
	keep(perc66 perc79) 
	rename(ownrank66 perc66 ownrank79 perc79)
	cells(b(star fmt(3))  se(par fmt(3))) 
	collabels(,none) stat(diff se p N66 N79) stardrop(*) ;	


estout  married_ige ownrank_ige rank_impute_ige assort_ige assort_impute_ige 
	using  "${results_dir}table8.txt", append
	keep(loginc66 loginc79) 
	rename(lown66 loginc66 lown79 loginc79)
	cells(b(star fmt(3))  se(par fmt(3))) 
	collabels(,none) stat(diff se p N66 N79) stardrop(*) ;	
#delimit cr	










exit
