* Figure A2: Robustness to Inclusion of Additional Controls
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



* Quartic Polynomial in Parent Age at Birth

gen dage = dad_age_at_birth
gen dage_ms = missing(dad_age_at_birth)
 su dage 
 replace dage = r(mean) if dage_ms
gen dage2 = dage^2
gen dage3 = dage^3
gen dage4 = dage^4


gen mage = mom_age_at_birth
gen mage_ms = missing(mom_age_at_birth)
 su mage 
 replace mage = r(mean) if mage_ms
gen mage2 = mage^2
gen mage3 = mage^3
gen mage4 = mage^4

local page_quart "dage dage2 dage3 dage4 mage mage2 mage3 mage4 dage_ms mage_ms"



* --------- Rank-Rank --------- *
mat rank = ., . , .

* No Controls
reg rank1 rank0 perc79 surv79 women [w=weight] , cluster(hhid)
gen float n_rank = e(N)
gen float rank_diff = _b[perc79]
gen float rank_diff_se = _se[perc79]
foreach var of varlist n_rank-rank_diff_se {
	su `var'
	local `var' = r(mean)
}
mat rank = rank \ (`n_rank', `rank_diff', `rank_diff_se')
drop n_rank-rank_diff_se 

* Birth Year Fixed Effects
reg rank1 rank0 perc79 surv79 women i.byear [w=weight] , cluster(hhid)
gen float n_rank = e(N)
gen float rank_diff = _b[perc79]
gen float rank_diff_se = _se[perc79]
foreach var of varlist n_rank-rank_diff_se {
	su `var'
	local `var' = r(mean)
}
mat rank = rank \ (`n_rank', `rank_diff', `rank_diff_se')
drop n_rank-rank_diff_se 

* Quartic in Parent Age
reg rank1 rank0 perc79 surv79 women `page_quart' [w=weight] , cluster(hhid)
gen float n_rank = e(N)
gen float rank_diff = _b[perc79]
gen float rank_diff_se = _se[perc79]
foreach var of varlist n_rank-rank_diff_se {
	su `var'
	local `var' = r(mean)
}
mat rank = rank \ (`n_rank', `rank_diff', `rank_diff_se')
drop n_rank-rank_diff_se 



* Birth Year Fixed Effects and Quartic in Parent Age
reg rank1 rank0 perc79 surv79 women i.byear `page_quart' [w=weight] , cluster(hhid)
gen float n_rank = e(N)
gen float rank_diff = _b[perc79]
gen float rank_diff_se = _se[perc79]
foreach var of varlist n_rank-rank_diff_se {
	su `var'
	local `var' = r(mean)
}
mat rank = rank \ (`n_rank', `rank_diff', `rank_diff_se')
drop n_rank-rank_diff_se 



* --------- IGE --------- *
mat ige = ., . , .

* No Controls
reg lfaminc1 lfaminc0  loginc79 surv79 women [w=weight] , cluster(hhid)
gen float n_ige = e(N)
gen float ige_diff = _b[ loginc79]
gen float ige_diff_se = _se[ loginc79]
foreach var of varlist n_ige-ige_diff_se {
	su `var'
	local `var' = r(mean)
}
mat ige = ige \ (`n_ige', `ige_diff', `ige_diff_se')
drop n_ige-ige_diff_se 

* Birth Year Fixed Effects
reg lfaminc1 lfaminc0  loginc79 surv79 women i.byear [w=weight] , cluster(hhid)
gen float n_ige = e(N)
gen float ige_diff = _b[ loginc79]
gen float ige_diff_se = _se[ loginc79]
foreach var of varlist n_ige-ige_diff_se {
	su `var'
	local `var' = r(mean)
}
mat ige = ige \ (`n_ige', `ige_diff', `ige_diff_se')
drop n_ige-ige_diff_se 

* Quartic in Parent Age
reg lfaminc1 lfaminc0  loginc79 surv79 women `page_quart' [w=weight] , cluster(hhid)
gen float n_ige = e(N)
gen float ige_diff = _b[ loginc79]
gen float ige_diff_se = _se[ loginc79]
foreach var of varlist n_ige-ige_diff_se {
	su `var'
	local `var' = r(mean)
}
mat ige = ige \ (`n_ige', `ige_diff', `ige_diff_se')
drop n_ige-ige_diff_se 



* Birth Year Fixed Effects and Quartic in Parent Age
reg lfaminc1 lfaminc0  loginc79 surv79 women i.byear `page_quart' [w=weight] , cluster(hhid)
gen float n_ige = e(N)
gen float ige_diff = _b[ loginc79]
gen float ige_diff_se = _se[ loginc79]
foreach var of varlist n_ige-ige_diff_se {
	su `var'
	local `var' = r(mean)
}
mat ige = ige \ (`n_ige', `ige_diff', `ige_diff_se')
drop n_ige-ige_diff_se 



* Rank-Rank Figure -------------------
clear
svmat rank
drop in 1
ren rank2 diff
ren rank3 se
gen l95 = diff-1.96*se
gen u95 = diff+1.96*se

gen pos = 2*_n-1 

graph twoway (bar diff pos, lcolor(black) fcolor(gs10)) (rcap u95 l95 pos, lcolor(black)), ///
	ylabel(0(0.05)0.25, nogrid) xlabel(1 "None" 3 "Birth Year" 5 "Quartic in Parents' Ages" 7 "Both") ///
	legend(off) ytitle("Change in Rank-Rank Slope") xtitle("") graphregion(color(white))
graph export ${results_dir}figureA2_rank.png, replace



* IGE Figure ------------------------
clear
svmat ige
drop in 1
ren ige2 diff
ren ige3 se
gen l95 = diff-1.96*se
gen u95 = diff+1.96*se

gen pos = 2*_n-1 

graph twoway (bar diff pos, lcolor(black) fcolor(gs10)) (rcap u95 l95 pos, lcolor(black)), ///
	ylabel(0(0.1)0.4, nogrid) xlabel(1 "None" 3 "Birth Year" 5 "Quartic in Parents' Ages" 7 "Both") ///
	legend(off) ytitle("Change in IGE") xtitle("") graphregion(color(white))
graph export ${results_dir}figureA2_ige.png, replace


exit

























