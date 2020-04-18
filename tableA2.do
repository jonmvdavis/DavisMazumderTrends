* Table A2: Sensitivty of NLSY79 Mobility Estimates


* ----------------------------------------- *
* Use prime earnings for sons and daughters *
* ----------------------------------------- *
clear
use "${data_dir}DavisMazumderData.dta"
keep if surv79==1
keep if age_firstSurvey<=18
drop if miss0 | miss1_prime 
drop if (mom_outOfRange==1 & linkMom==1 & !(dad_outOfRange==0 & linkDad==1)) | (dad_outOfRange==1 & linkDad==1 & !(mom_outOfRange==0 & linkMom==1)) | (linkMom==0 & linkDad==0) 
 



* Generate income ranks after applying sample restrictions
gen N = .
 tab n  if surv79==1 & women==0   [w=weight]
 replace N = r(N) if surv79==1 & women==0 
 tab n  if surv79==1 & women==1 [w=weight]
 replace N = r(N) if surv79==1 & women==1 
 
* Family Income Rank in Parent Generation
sort women faminc0
by women : gen __rank0 = sum(weight) 
gen _rank0 = __rank0/N 
by women faminc0: egen rank0_prime = mean(_rank0) 
 replace rank0_prime = 100*rank0_prime


 
* Family Income Rank in Kid Generation
sort women  faminc1_prime
by women: gen __rank1 = sum(weight)
gen _rank1 = __rank1/N 
bys women faminc1_prime: egen rank1_prime = mean(_rank1) 
replace rank1_prime = 100*rank1_prime

drop N __rank0 _rank0 __rank1 _rank1

* --------- Rank-Rank --------- *

* Pooled
reg rank1_prime rank0_prime women [w=weight], cluster(hhid)
eststo rank_p_prime

* Women
reg rank1_prime rank0_prime if women==1 [w=weight] , cluster(hhid)
eststo rank_w_prime

* Men
reg rank1_prime rank0_prime if women==0 [w=weight] , cluster(hhid)
eststo rank_m_prime

* --------- IGE --------- *

* Pooled
reg lfaminc1_prime lfaminc0 women [w=weight], cluster(hhid)
eststo IGE_p_prime



* Women
reg lfaminc1_prime lfaminc0 if women==1 [w=weight], cluster(hhid)
eststo IGE_w_prime


* Men
reg lfaminc1_prime lfaminc0 if women==0 [w=weight], cluster(hhid)
eststo IGE_m_prime



#delimit ;
estout rank_p_prime IGE_p_prime rank_w_prime IGE_w_prime rank_m_prime IGE_m_prime
	using  "${results_dir}tableA2.txt", replace
	keep(rank0_prime)
	rename(lfaminc0 rank0_prime)
	cells(b(star fmt(3))  se(par fmt(3))) 
	collabels(,none) stat(N) stardrop(*) ;	
#delimit cr	
	
	
	
* ------------------------------------------------ *
* Use early career earnings for sons and daughters *
* ------------------------------------------------ *	
clear
use "${data_dir}DavisMazumderData.dta"
keep if surv79==1
keep if age_firstSurvey<=18
drop if miss0 | miss1_early
drop if (mom_outOfRange==1 & linkMom==1 & !(dad_outOfRange==0 & linkDad==1)) | (dad_outOfRange==1 & linkDad==1 & !(mom_outOfRange==0 & linkMom==1)) | (linkMom==0 & linkDad==0) 
 



* Generate income ranks after applying sample restrictions
gen N = .
 tab n  if surv79==1 & women==0   [w=weight]
 replace N = r(N) if surv79==1 & women==0 
 tab n  if surv79==1 & women==1 [w=weight]
 replace N = r(N) if surv79==1 & women==1 
 
* Family Income Rank in Parent Generation
sort women faminc0
by women : gen __rank0 = sum(weight) 
gen _rank0 = __rank0/N 
by women faminc0: egen rank0_early = mean(_rank0) 
 replace rank0_early = 100*rank0_early


 
* Family Income Rank in Kid Generation
sort women  faminc1_early
by women: gen __rank1 = sum(weight)
gen _rank1 = __rank1/N 
bys women faminc1_early: egen rank1_early = mean(_rank1) 
replace rank1_early = 100*rank1_early

drop N __rank0 _rank0 __rank1 _rank1

* --------- Rank-Rank --------- *

* Pooled
reg rank1_early rank0_early women [w=weight], cluster(hhid)
eststo rank_p_early

* Women
reg rank1_early rank0_early if women==1 [w=weight] , cluster(hhid)
eststo rank_w_early

* Men
reg rank1_early rank0_early if women==0 [w=weight] , cluster(hhid)
eststo rank_m_early

* --------- IGE --------- *

* Pooled
reg lfaminc1_early lfaminc0 women [w=weight], cluster(hhid)
eststo IGE_p_early



* Women
reg lfaminc1_early lfaminc0 if women==1 [w=weight], cluster(hhid)
eststo IGE_w_early


* Men
reg lfaminc1_early lfaminc0 if women==0 [w=weight], cluster(hhid)
eststo IGE_m_early
	
	

#delimit ;
estout rank_p_early IGE_p_early rank_w_early IGE_w_early rank_m_early IGE_m_early
	using  "${results_dir}tableA2.txt", append
	keep(rank0_early)
	rename(lfaminc0 rank0_early)
	cells(b(star fmt(3))  se(par fmt(3))) 
	collabels(,none) stat(N) stardrop(*) ;	
#delimit cr	
		
		
* ----------------------------------------- *
* Use prime earnings for sons and daughters *
* But drop NLS66 Sampling Restriction       *
* ----------------------------------------- *
clear
use "${data_dir}DavisMazumderData.dta"
keep if surv79==1
keep if age_firstSurvey<=18
drop if miss0 | miss1_prime 
*drop if (mom_outOfRange==1 & linkMom==1 & !(dad_outOfRange==0 & linkDad==1)) | (dad_outOfRange==1 & linkDad==1 & !(mom_outOfRange==0 & linkMom==1)) | (linkMom==0 & linkDad==0) 
 



* Generate income ranks after applying sample restrictions
gen N = .
 tab n  if surv79==1 & women==0   [w=weight]
 replace N = r(N) if surv79==1 & women==0 
 tab n  if surv79==1 & women==1 [w=weight]
 replace N = r(N) if surv79==1 & women==1 
 
* Family Income Rank in Parent Generation
sort women faminc0
by women : gen __rank0 = sum(weight) 
gen _rank0 = __rank0/N 
by women faminc0: egen rank0_prime = mean(_rank0) 
 replace rank0_prime = 100*rank0_prime


 
* Family Income Rank in Kid Generation
sort women  faminc1_prime
by women: gen __rank1 = sum(weight)
gen _rank1 = __rank1/N 
bys women faminc1_prime: egen rank1_prime = mean(_rank1) 
replace rank1_prime = 100*rank1_prime

drop N __rank0 _rank0 __rank1 _rank1

* --------- Rank-Rank --------- *

* Pooled
reg rank1_prime rank0_prime women [w=weight], cluster(hhid)
eststo rank_p_prime

* Women
reg rank1_prime rank0_prime if women==1 [w=weight] , cluster(hhid)
eststo rank_w_prime

* Men
reg rank1_prime rank0_prime if women==0 [w=weight] , cluster(hhid)
eststo rank_m_prime

* --------- IGE --------- *

* Pooled
reg lfaminc1_prime lfaminc0 women [w=weight], cluster(hhid)
eststo IGE_p_prime



* Women
reg lfaminc1_prime lfaminc0 if women==1 [w=weight], cluster(hhid)
eststo IGE_w_prime


* Men
reg lfaminc1_prime lfaminc0 if women==0 [w=weight], cluster(hhid)
eststo IGE_m_prime



#delimit ;
estout rank_p_prime IGE_p_prime rank_w_prime IGE_w_prime rank_m_prime IGE_m_prime
	using  "${results_dir}tableA2.txt", append
	keep(rank0_prime)
	rename(lfaminc0 rank0_prime)
	cells(b(star fmt(3))  se(par fmt(3))) 
	collabels(,none) stat(N) stardrop(*) ;	
#delimit cr	
	
	
	
	
	
* ------------------------------------------------ *
* Use early career earnings for sons and daughters *
* But drop NLS66 Sampling Restriction              *
* ------------------------------------------------ *	
clear
use "${data_dir}DavisMazumderData.dta"
keep if surv79==1
keep if age_firstSurvey<=18
drop if miss0 | miss1_early
*drop if (mom_outOfRange==1 & linkMom==1 & !(dad_outOfRange==0 & linkDad==1)) | (dad_outOfRange==1 & linkDad==1 & !(mom_outOfRange==0 & linkMom==1)) | (linkMom==0 & linkDad==0) 
 



* Generate income ranks after applying sample restrictions
gen N = .
 tab n  if surv79==1 & women==0   [w=weight]
 replace N = r(N) if surv79==1 & women==0 
 tab n  if surv79==1 & women==1 [w=weight]
 replace N = r(N) if surv79==1 & women==1 
 
* Family Income Rank in Parent Generation
sort women faminc0
by women : gen __rank0 = sum(weight) 
gen _rank0 = __rank0/N 
by women faminc0: egen rank0_early = mean(_rank0) 
 replace rank0_early = 100*rank0_early


 
* Family Income Rank in Kid Generation
sort women  faminc1_early
by women: gen __rank1 = sum(weight)
gen _rank1 = __rank1/N 
bys women faminc1_early: egen rank1_early = mean(_rank1) 
replace rank1_early = 100*rank1_early

drop N __rank0 _rank0 __rank1 _rank1

* --------- Rank-Rank --------- *

* Pooled
reg rank1_early rank0_early women [w=weight], cluster(hhid)
eststo rank_p_early

* Women
reg rank1_early rank0_early if women==1 [w=weight] , cluster(hhid)
eststo rank_w_early

* Men
reg rank1_early rank0_early if women==0 [w=weight] , cluster(hhid)
eststo rank_m_early

* --------- IGE --------- *

* Pooled
reg lfaminc1_early lfaminc0 women [w=weight], cluster(hhid)
eststo IGE_p_early



* Women
reg lfaminc1_early lfaminc0 if women==1 [w=weight], cluster(hhid)
eststo IGE_w_early


* Men
reg lfaminc1_early lfaminc0 if women==0 [w=weight], cluster(hhid)
eststo IGE_m_early
	
	

#delimit ;
estout rank_p_early IGE_p_early rank_w_early IGE_w_early rank_m_early IGE_m_early
	using  "${results_dir}tableA2.txt", append
	keep(rank0_early)
	rename(lfaminc0 rank0_early)
	cells(b(star fmt(3))  se(par fmt(3))) 
	collabels(,none) stat(N) stardrop(*) ;	
#delimit cr	
		

		


