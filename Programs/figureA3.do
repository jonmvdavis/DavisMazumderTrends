* Figure A3: Sensitivity to Father's Age When Income Measured
clear
use "${data_dir}DavisMazumderData.dta"
keep if age_firstSurvey<=18
drop if miss0 | miss1
drop if (mom_outOfRange==1 & linkMom==1 & !(dad_outOfRange==0 & linkDad==1)) | (dad_outOfRange==1 & linkDad==1 & !(mom_outOfRange==0 & linkMom==1)) | (linkMom==0 & linkDad==0) 
 



* ---------------- *
* Ranks by Dad Age *
* ---------------- *

bys surv79 women dad_age_inc1 : egen N=sum(weight)

sort women surv79 dad_age_inc1  faminc0
by women surv79 dad_age_inc1 : gen __rank0 = sum(weight) 
gen _rank0 = __rank0/N 
bys women surv79 dad_age_inc1  faminc0: egen rank0_dad_age1 = mean(_rank0) 
 
sort women surv79 dad_age_inc1 faminc1
by women surv79 dad_age_inc1 : gen __rank1 = sum(weight) 
gen _rank1 = __rank1/N 
bys women surv79 dad_age_inc1  faminc1: egen rank1_dad_age = mean(_rank1) 

gen perc66_dad_age = rank0_dad_age*(1-surv79)
gen perc79_dad_age = rank0_dad_age*surv79

drop N __rank0 _rank0 __rank1 _rank1




* --------- Dad age when income measured--------- *

matrix rank_diff_byear = J(10,3,.)
matrix ige_diff = J(10,3,.)



local r=0
forv a=40/49 {
 local r=`r'+1
 
 matrix rank_diff_byear[`r',1]=`a'
 reg rank1_dad_age rank0_dad_age perc79_dad_age  surv79 women if dad_age_inc1 ==`a'  [w=weight], cluster(hhid)
 matrix rank_diff_byear[`r',2] = _b[perc79_dad_age]
 matrix rank_diff_byear[`r',3] = _se[perc79_dad_age] 
 
 matrix ige_diff[`r',1]=`a'
 qui reg lfaminc1 lfaminc0 loginc79 surv79 women if dad_age_inc1 ==`a'  [w=weight], cluster(hhid)
 matrix ige_diff[`r',2] = _b[loginc79]
 matrix ige_diff[`r',3] = _se[loginc79]
 
 
}

 



clear
svmat rank_diff_byear

ren rank_diff_byear1 age
ren rank_diff_byear2 diff
gen lb =  diff-1.96*rank_diff_byear3
gen ub =  diff+1.96*rank_diff_byear3


graph twoway   (rarea lb ub age , fcolor(gs15) lcolor(gs15) mcolor(gs15) ) (connected diff age, mcolor(black) lcolor(black) ) (function y=0.12, range(40 49) lcolor(black) lpattern(dash)), ///
	graphregion(color(white)) ylabel(-.3(0.15)0.6, nogrid) xtitle("Father age when income first measured") ytitle("Change in Rank-Rank Slope")  xlabel(40(1)49) ///
	legend(order( 2 "Change in Rank-Rank Slope" 1 "95 Percent CI"  3 "Main Estimate"))
	
graph export ${results_dir}figureA3_rank.png, replace





clear
svmat ige_diff

ren ige_diff1 age
ren ige_diff2 diff
gen lb =  diff-1.96*ige_diff3
gen ub =  diff+1.96*ige_diff3


graph twoway   (rarea lb ub age , fcolor(gs15) lcolor(gs15) mcolor(gs15) ) (connected diff age, mcolor(black) lcolor(black) ) (function y=0.29, range(40 49) lcolor(black) lpattern(dash)), ///
	graphregion(color(white)) ylabel(-.6(0.3)0.9, nogrid) xtitle("Father age when income first measured") ytitle("Change in IGE")  xlabel(40(1)49) ///
	legend(order( 2 "Change in IGE" 1 "95 Percent CI"  3 "Main Estimate"))
	
graph export ${results_dir}figureA3_ige.png, replace












































