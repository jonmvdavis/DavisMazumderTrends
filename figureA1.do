* Figure A1: Robustness to Maximum Age of Child
clear
use "${data_dir}DavisMazumderData.dta"
drop if miss0 | miss1
drop if (mom_outOfRange==1 & linkMom==1 & !(dad_outOfRange==0 & linkDad==1)) | (dad_outOfRange==1 & linkDad==1 & !(mom_outOfRange==0 & linkMom==1)) | (linkMom==0 & linkDad==0) 
 

mat rank = ., . , . , .
mat ige = ., . , . , .
quietly {
foreach max in 16 17 18 19 20 21 22 23 24 25 {
	preserve
	keep if age_firstSurvey<=`max'
	
	
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
	bys women surv79 faminc1: egen rank1_first = mean(_rank1) 

	gen perc79 = rank0*surv79

	drop N __rank0 _rank0 __rank1 _rank1 
	
	
	reg rank1 rank0 perc79 surv79 [w=weight], cluster(hhid)
	gen float n_rank = e(N)
	gen float rank_diff = _b[perc79]
	gen float rank_diff_se = _se[perc79]
	foreach var of varlist n_rank-rank_diff_se {
		su `var'
		local `var' = r(mean)
	}
	mat rank = rank \ (`max', `n_rank', `rank_diff', `rank_diff_se')
	
	
	reg lfaminc1 lfaminc0 loginc79 surv79 [w=weight], cluster(hhid)
	gen float n_ige = e(N)
	gen float ige_diff = _b[loginc79]
	gen float ige_diff_se = _se[loginc79]
	foreach var of varlist n_ige-ige_diff_se {
		su `var'
		local `var' = r(mean)
	 }
	 mat ige = ige \ (`max', `n_ige', `ige_diff', `ige_diff_se')

	 restore
	 
}
}


* Rank-Rank Figure
clear
svmat rank
drop in 1
ren rank1 age
ren rank3 diff
ren rank4 se

gen l96 = diff-1.96*se
gen u96 = diff+1.96*se

graph twoway  (rarea l96 u96 age if age<=25, fcolor(gs15) lcolor(gs15) mcolor(gs15)) (connected diff age if age<=25, mcolor(black) lcolor(black)), ///
	graphregion(color(white)) ylabel(0(0.05)0.25, nogrid) xtitle("Max Age of Child in First Survey") ytitle("Change in Rank-Rank Slope") legend(off) xlabel(16(2)25)
graph export ${results_dir}figureA1_rank.png, replace


* IGE Figure
clear
svmat ige
drop in 1
ren ige1 age
ren ige3 diff
ren ige4 se

gen l96 = diff-1.96*se
gen u96 = diff+1.96*se

graph twoway  (rarea l96 u96 age if age<=25, fcolor(gs15) lcolor(gs15) mcolor(gs15)) (connected diff age if age<=25, mcolor(black) lcolor(black)), ///
	graphregion(color(white)) ylabel(0(0.1)0.4, nogrid) xtitle("Max Age of Child in First Survey") ytitle("Change in IGE") legend(off) xlabel(16(2)25)
graph export ${results_dir}figureA1_ige.png, replace

exit



























