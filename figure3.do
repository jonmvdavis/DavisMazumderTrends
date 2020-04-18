* Figure 3: Trends in Intergenerational Mobility by Birth Year
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
 
 
 
 
levelsof byear, local(levels) 
di "`levels'"

* Interact parent rank with birth year indicators
foreach y in `levels' {
 gen p`y' = rank0*(byear==`y')
}


reg rank1 p1948-p1964 i.byear women [w=weight], cluster(hhid)
matrix rank= J(10,3,.)
local i =0
foreach y in `levels' {
 local i=`i'+1
 matrix rank[`i',1] = `y'
 matrix rank[`i',2] = _b[p`y']
 matrix rank[`i',3] = _se[p`y']
}

* Interact log parent income with birth year indicators
foreach y in `levels' {
 gen f0_`y' = lfaminc0*(byear==`y')
}



reg lfaminc1 f0_1948-f0_1964 i.byear women [w=weight], cluster(hhid)
matrix ige= J(10,3,.)
local i =0
foreach y in `levels' {
 local i=`i'+1
 matrix ige[`i',1] = `y'
 matrix ige[`i',2] = _b[f0_`y']
 matrix ige[`i',3] = _se[f0_`y']
}




clear
svmat rank
gen l95 = rank2-1.96*rank3
gen u95 = rank2+1.96*rank3

graph twoway (scatter rank2 rank1) (rcap u95 l95 rank1, lcolor(black)) (lpoly rank2 rank1, degree(3) lcolor(gs10) lpattern(dash)), graphregion(color(white)) legend(off) xtitle("Birth Year") ytitle("Rank-Rank Slope") ylabel(0(0.2)0.8,nogrid) title("Rank-Rank")
graph save ${results_dir}rank_byear.gph, replace


clear 
svmat ige
gen l95 = ige2-1.96*ige3
gen u95 = ige2+1.96*ige3

graph twoway (scatter ige2 ige1) (rcap u95 l95 ige1, lcolor(black)) (lpoly ige2 ige1, degree(3) lcolor(gs10) lpattern(dash)), graphregion(color(white)) legend(off) xtitle("Birth Year") ytitle("IGE") ylabel(0(0.2)0.8,nogrid) title("IGE")
graph save ${results_dir}ige_byear.gph, replace

graph combine ${results_dir}rank_byear.gph ${results_dir}ige_byear.gph, graphregion(color(white)) ycommon
graph export ${results_dir}figure3.png, replace

erase ${results_dir}rank_byear.gph
erase ${results_dir}ige_byear.gph

exit
