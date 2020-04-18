* Figure 4: Comparison of NLS and CPS Income Distributions
clear
use "${data_dir}DavisMazumderData.dta"
keep if age_firstSurvey<=18
drop if miss0 | miss1
drop if (mom_outOfRange==1 & linkMom==1 & !(dad_outOfRange==0 & linkDad==1)) | (dad_outOfRange==1 & linkDad==1 & !(mom_outOfRange==0 & linkMom==1)) | (linkMom==0 & linkDad==0) 
 

gen id = .
 replace id = id_son if survey==1966 & women==0
 replace id = id_daughter if survey==1966 & women==1
 replace id = CASEID if survey==1979

 
gen all_inc = all_parent==1 & all_kid==1

 gen parent1965 = parent1 if survey==1966 & useDad==1
 gen parent1966 = parent2 if survey==1966 & useDad==1
 gen parent1968 = parent3 if survey==1966 & useDad==1
 replace parent1966 = parent1 if survey==1966 & useDad==0
 replace parent1968 = parent2 if survey==1966 & useDad==0
 gen parent1970 = parent3 if survey==1966 & useDad==0
 gen parent1978 = parent1 if survey==1979
 gen parent1979 = parent2 if survey==1979
 gen parent1980 = parent3 if survey==1979
 

 gen kid1990 = kid1 if survey==1966 & women==1
 gen kid1992 = kid2 if survey==1966 & women==1
 gen kid1994 = kid3 if survey==1966 & women==1
 
 gen kid1977 = kid1 if survey==1966 & women==0
 gen kid1979 = kid2 if survey==1966 & women==0
 gen kid1980 = kid3 if survey==1966 & women==0
 
 gen kid2001 = kid1 if survey==1979 & women==1
 gen kid2003 = kid2 if survey==1979 & women==1
 gen kid2005 = kid3 if survey==1979 & women==1
 
 replace kid1990 = kid1 if survey==1979 & women==0
 gen kid1991 = kid2 if survey==1979 & women==0
 gen kid1993 = kid3 if survey==1979 & women==0
 


 
 keep id survey women parent1965-kid1993 weight byear byear_dad byear_mom all_inc 
 
 reshape long parent kid p_obs parent_obs, i(id survey women) j(year)
 
 replace parent = . if parent_obs==0
 
 tempfile nls
 save `nls'
 
use ${data_dir}march_cps.dta 
gen cps=1
append using `nls'

replace cps = 0 if missing(cps)

gen is_parent = parent if cps==1
replace parent = ftotval if is_parent==1 & cps==1
gen is_kid = kid if cps==1
replace kid = ftotval if is_parent==1 & cps==1

replace weight = wt_adj66 if cps==1 & survey==1966
replace weight = wt_adj79 if cps==1 & survey==1979


 graph twoway (kdensity parent if survey==1966 & is_parent==1  & cps==1  & ftotval>0 &  ftotval<=500000 [w=wt_adj66]) (kdensity parent if survey==1966 & cps==0 & parent>0 & parent<=500000  [w=weight] ), ///
 graphregion(color(white)) legend(label(1 "CPS") label(2 "NLS")) xtitle("Parent Family Income") title("1966 Parents") ylabel(0(5e-6)1e-5, nogrid) ytitle("Density")  xlabel(0(125000)500000)
 graph save ${results_dir}comp_parents66.gph, replace


 
graph twoway (kdensity parent if survey==1979 & is_parent==1  & cps==1  & ftotval>0 & ftotval<=500000 [w=wt_adj79]) (kdensity parent if survey==1979 & cps==0 & parent>0 & parent<=500000 [w=weight] ), ///
 graphregion(color(white)) legend(label(1 "CPS") label(2 "NLS")) xtitle("Parent Family Income")  title("1979 Parents") ylabel(0(5e-6)1e-5, nogrid) ytitle("Density")  xlabel(0(125000)500000)
 graph save ${results_dir}comp_parents79.gph, replace


graph twoway (kdensity ftotval if survey==1966 & is_kid==1 & cps==1  & ftotval>0 & ftotval<=500000 [w=asecwth]) (kdensity kid if survey==1966 & cps==0  & kid>0 & kid<=500000 [w=weight] ), ///
 graphregion(color(white)) legend(label(1 "CPS") label(2 "NLS")) xtitle("Child Family Income")  title("1966 Children") ylabel(0(5e-6)1e-5, nogrid) ytitle("Density") xlabel(0(125000)500000)
 graph save ${results_dir}comp_kids66.gph, replace


graph twoway (kdensity ftotval if survey==1979 & is_kid==1 & cps==1 & ftotval>0  & ftotval<=500000 [w=asecwth]) (kdensity kid if survey==1979 & cps==0 & kid>0  & kid<=500000 [w=weight] ), ///
 graphregion(color(white)) legend(label(1 "CPS") label(2 "NLS")) xtitle("Child Family Income")  title("1979 Children") ylabel(0(5e-6)1e-5, nogrid) ytitle("Density") xlabel(0(125000)500000)
 graph save ${results_dir}comp_kids79.gph, replace


grc1leg ${results_dir}comp_parents66.gph ${results_dir}comp_parents79.gph ${results_dir}comp_kids66.gph ${results_dir}comp_kids79.gph, col(2) graphregion(color(white))
graph export ${results_dir}figure4.png, replace

erase ${results_dir}comp_parents66.gph 
erase ${results_dir}comp_parents79.gph 
erase ${results_dir}comp_kids66.gph 
erase ${results_dir}comp_kids79.gph





* Create Weights To Make Distributions Match


* Parent Generation Weights *

matrix dist_parents66_cps = J(252,1,.)
matrix dist_parents79_cps = J(252,1,.)
matrix dist_parents66_nls = J(252,1,.)
matrix dist_parents79_nls = J(252,1,.)


gen n=1
local r=0
forv num = 0(1000)250000 {
 local r=`r'+1
 
 qui su n  if survey==1966 & is_parent==1 & cps==1  & ~missing(ftotval) [w=wt_adj66]
 local N=r(sum_w)
 qui su n  if survey==1966 & is_parent==1 & cps==1 & ftotval<=`num' [w=wt_adj66]   
 matrix  dist_parents66_cps[`r',1] = r(sum_w)/`N'

 qui su n  if survey==1966  & cps==0 & ~missing(parent) [w=weight]
 local N=r(sum_w)
 qui su n  if survey==1966 & cps==0 & parent<=`num' [w=weight]   
 matrix  dist_parents66_nls[`r',1] = r(sum_w)/`N' 
 
 qui su n  if survey==1979 & is_parent==1 & cps==1  & ~missing(ftotval)   [w=wt_adj79]
 local N=r(sum_w)
 qui su n  if survey==1979 & is_parent==1 & cps==1 & ftotval<=`num' [w=wt_adj79]   
 matrix  dist_parents79_cps[`r',1] = r(sum_w)/`N'
 
 qui su n  if survey==1979 & cps==0 & ~missing(parent) [w=weight]
 local N=r(sum_w)
 qui su n  if survey==1979 & cps==0 & parent<=`num' [w=weight]   
 matrix  dist_parents79_nls[`r',1] = r(sum_w)/`N'  
}





* Kid Generation Weights *

matrix dist_kids66_cps = J(252,1,.)
matrix dist_kids79_cps = J(252,1,.)
matrix dist_kids66_nls = J(252,1,.)
matrix dist_kids79_nls = J(252,1,.)


local r=0
forv num = 0(1000)250000 {
 local r=`r'+1
 
 qui su n  if survey==1966 & is_kid==1 & cps==1  & ~missing(ftotval) [w=wt_adj66]
 local N=r(sum_w)
 qui su n  if survey==1966 & is_kid==1 & cps==1 & ftotval<=`num' [w=wt_adj66]   
 matrix  dist_kids66_cps[`r',1] = r(sum_w)/`N'

 qui su n  if survey==1966  & cps==0 & ~missing(kid) [w=weight]
 local N=r(sum_w)
 qui su n  if survey==1966 & cps==0 & kid<=`num' [w=weight]   
 matrix  dist_kids66_nls[`r',1] = r(sum_w)/`N' 
 
 qui su n  if survey==1979 & is_kid==1 & cps==1  & ~missing(ftotval)   [w=wt_adj79]
 local N=r(sum_w)
 qui su n  if survey==1979 & is_kid==1 & cps==1 & ftotval<=`num' [w=wt_adj79]   
 matrix  dist_kids79_cps[`r',1] = r(sum_w)/`N'
 
 qui su n  if survey==1979 & cps==0 & ~missing(kid ) [w=weight]
 local N=r(sum_w)
 qui su n  if survey==1979 & cps==0 & kid <=`num' [w=weight]   
 matrix  dist_kids79_nls[`r',1] = r(sum_w)/`N'  
}

preserve
clear
svmat dist_parents66_cps
svmat dist_parents79_cps
svmat dist_parents66_nls
svmat dist_parents79_nls

svmat dist_kids66_cps
svmat dist_kids79_cps
svmat dist_kids66_nls
svmat dist_kids79_nls

foreach f in parents66_cps parents79_cps parents66_nls parents79_nls kids66_cps kids79_cps kids66_nls kids79_nls {
replace dist_`f' = 1 if _n==252

 gen dens_`f' = dist_`f'
  replace dens_`f' = dist_`f'-dist_`f'[_n-1] if _n>1
}

gen adj_parents66 = dens_parents66_cps/dens_parents66_nls
gen adj_parents79 = dens_parents79_cps/dens_parents79_nls

gen adj_kids66 = dens_kids66_cps/dens_kids66_nls
gen adj_kids79 = dens_kids79_cps/dens_kids79_nls

gen adj_cat_parent = _n 
gen adj_cat_kid = _n
tempfile working
save `working'

keep adj_cat_parent adj_parents*
save ${data_dir}wt_adjustments_parents.dta, replace

clear
use `working'
keep adj_cat_kid adj_kids*
save ${data_dir}wt_adjustments_kids.dta, replace

restore


gen adj_cat_parent = .
gen adj_cat_kid = .


replace adj_cat_parent = 0 if parent<=0
replace adj_cat_kid = 0 if kid<=0
local r=1
forv num = 1000(1000)250000 {
 local lnum = `num'-1000
 local r=`r'+1
 
 replace adj_cat_parent = `r' if parent>`lnum' & parent<=`num'
 replace adj_cat_kid = `r' if kid>`lnum' & kid<=`num'
}
replace adj_cat_parent = 1 if ~missing(parent) & missing(adj_cat_parent)
replace adj_cat_kid = 1 if ~missing(kid) & missing(adj_cat_kid)

merge m:1 adj_cat_parent using ${data_dir}wt_adjustments_parents.dta, gen(merge_wt_adj_parents)
 drop if merge_wt_adj_parents==2 
 
merge m:1 adj_cat_kid  using ${data_dir}wt_adjustments_kids.dta, gen(merge_wt_adj_kids)
 drop if merge_wt_adj_kids==2 
 
 
gen _wt_nls_parent = weight
 replace _wt_nls_parent = weight*adj_parents66 if survey==1966 & cps==0
 replace _wt_nls_parent = weight*adj_parents79 if survey==1979 & cps==0
 
bys id survey women: egen wt_nls_parent = mean(_wt_nls_parent)
 
gen _wt_nls_kid = weight
 replace _wt_nls_kid = weight*adj_kids66 if survey==1966 & cps==0
 replace _wt_nls_kid = weight*adj_kids79 if survey==1979 & cps==0 

 bys id survey women: egen wt_nls_kid = mean(_wt_nls_kid)

 gen wt_nls_avg = .5*wt_nls_parent+.5*wt_nls_kid 
 
 
 
* Kid Weights * 
 
graph twoway (kdensity parent if survey==1966 & is_parent==1  & cps==1  & ftotval>0 &  ftotval<=500000 [w=wt_adj66]) (kdensity parent if survey==1966 & cps==0 & parent>0 & parent<=500000  [w=wt_nls_kid] ), ///
 graphregion(color(white)) legend(label(1 "CPS") label(2 "NLS")) xtitle("Parent Family Income") title("1966 Parents") ylabel(0(5e-6)1e-5, nogrid) ytitle("Density")  xlabel(0(125000)500000)
 graph save ${results_dir}comp_parents66_adjwt_k.gph, replace

graph twoway (kdensity parent if survey==1979 & is_parent==1  & cps==1  & ftotval>0 & ftotval<=500000 [w=wt_adj79]) (kdensity parent if survey==1979 & cps==0 & parent>0 & parent<=500000 [w=wt_nls_kid] ), ///
 graphregion(color(white)) legend(label(1 "CPS") label(2 "NLS")) xtitle("Parent Family Income")  title("1979 Parents") ylabel(0(5e-6)1e-5, nogrid) ytitle("Density")  xlabel(0(125000)500000)
 graph save ${results_dir}comp_parents79_adjwt_k.gph, replace

graph twoway (kdensity ftotval if survey==1966 & is_kid==1 & cps==1  & ftotval>0 & ftotval<=500000 [w=asecwth]) (kdensity kid if survey==1966 & cps==0  & kid>0 & kid<=500000 [w=wt_nls_kid] ), ///
 graphregion(color(white)) legend(label(1 "CPS") label(2 "NLS")) xtitle("Child Family Income")  title("1966 Children") ylabel(0(5e-6)1e-5, nogrid) ytitle("Density") xlabel(0(125000)500000)
 graph save ${results_dir}comp_kids66_adjwt_k.gph, replace

graph twoway (kdensity ftotval if survey==1979 & is_kid==1 & cps==1 & ftotval>0  & ftotval<=500000 [w=asecwth]) (kdensity kid if survey==1979 & cps==0 & kid>0  & kid<=500000 [w=wt_nls_kid] ), ///
 graphregion(color(white)) legend(label(1 "CPS") label(2 "NLS")) xtitle("Child Family Income")  title("1979 Children") ylabel(0(5e-6)1e-5, nogrid) ytitle("Density") xlabel(0(125000)500000)
 graph save ${results_dir}comp_kids79_adjwt_k.gph, replace

grc1leg ${results_dir}comp_parents66_adjwt_k.gph ${results_dir}comp_parents79_adjwt_k.gph ${results_dir}comp_kids66_adjwt_k.gph ${results_dir}comp_kids79_adjwt_k.gph, col(2) graphregion(color(white))
graph export ${results_dir}figure_a7.png, replace
 
erase ${results_dir}comp_parents66_adjwt_k.gph 
erase ${results_dir}comp_parents79_adjwt_k.gph
erase ${results_dir}comp_kids66_adjwt_k.gph 
erase ${results_dir}comp_kids79_adjwt_k.gph
 
 
* Parent Weights * 
 
graph twoway (kdensity parent if survey==1966 & is_parent==1  & cps==1  & ftotval>0 &  ftotval<=500000 [w=wt_adj66]) (kdensity parent if survey==1966 & cps==0 & parent>0 & parent<=500000  [w=wt_nls_parent] ), ///
 graphregion(color(white)) legend(label(1 "CPS") label(2 "NLS")) xtitle("Parent Family Income") title("1966 Parents") ylabel(0(5e-6)1e-5, nogrid) ytitle("Density")  xlabel(0(125000)500000)
 graph save ${results_dir}comp_parents66_adjwt_p.gph, replace


graph twoway (kdensity parent if survey==1979 & is_parent==1  & cps==1  & ftotval>0 & ftotval<=500000 [w=wt_adj79]) (kdensity parent if survey==1979 & cps==0 & parent>0 & parent<=500000 [w=wt_nls_parent] ), ///
 graphregion(color(white)) legend(label(1 "CPS") label(2 "NLS")) xtitle("Parent Family Income")  title("1979 Parents") ylabel(0(5e-6)1e-5, nogrid) ytitle("Density")  xlabel(0(125000)500000)
 graph save ${results_dir}comp_parents79_adjwt_p.gph, replace

graph twoway (kdensity ftotval if survey==1966 & is_kid==1 & cps==1  & ftotval>0 & ftotval<=500000 [w=asecwth]) (kdensity kid if survey==1966 & cps==0  & kid>0 & kid<=500000 [w=wt_nls_parent] ), ///
 graphregion(color(white)) legend(label(1 "CPS") label(2 "NLS")) xtitle("Child Family Income")  title("1966 Children") ylabel(0(5e-6)1e-5, nogrid) ytitle("Density") xlabel(0(125000)500000)
 graph save ${results_dir}comp_kids66_adjwt_p.gph, replace

graph twoway (kdensity ftotval if survey==1979 & is_kid==1 & cps==1 & ftotval>0  & ftotval<=500000 [w=asecwth]) (kdensity kid if survey==1979 & cps==0 & kid>0  & kid<=500000 [w=wt_nls_parent] ), ///
 graphregion(color(white)) legend(label(1 "CPS") label(2 "NLS")) xtitle("Child Family Income")  title("1979 Children") ylabel(0(5e-6)1e-5, nogrid) ytitle("Density") xlabel(0(125000)500000)
 graph save ${results_dir}comp_kids79_adjwt_p.gph, replace

grc1leg ${results_dir}comp_parents66_adjwt_p.gph ${results_dir}comp_parents79_adjwt_p.gph ${results_dir}comp_kids66_adjwt_p.gph ${results_dir}comp_kids79_adjwt_p.gph, col(2) graphregion(color(white))
graph export ${results_dir}figure_a6.png, replace
 
erase ${results_dir}comp_parents66_adjwt_p.gph 
erase ${results_dir}comp_parents79_adjwt_p.gph 
erase ${results_dir}comp_kids66_adjwt_p.gph 
erase ${results_dir}comp_kids79_adjwt_p.gph
 
 
 
* Average Weights * 
 
graph twoway (kdensity parent if survey==1966 & is_parent==1  & cps==1  & ftotval>0 &  ftotval<=500000 [w=wt_adj66]) (kdensity parent if survey==1966 & cps==0 & parent>0 & parent<=500000  [w=wt_nls_avg] ), ///
 graphregion(color(white)) legend(label(1 "CPS") label(2 "NLS")) xtitle("Parent Family Income") title("1966 Parents") ylabel(0(5e-6)1e-5, nogrid) ytitle("Density")  xlabel(0(125000)500000)
 graph save ${results_dir}comp_avgs66_adjwt_avg.gph, replace

 
graph twoway (kdensity parent if survey==1979 & is_parent==1  & cps==1  & ftotval>0 & ftotval<=500000 [w=wt_adj79]) (kdensity parent if survey==1979 & cps==0 & parent>0 & parent<=500000 [w=wt_nls_avg] ), ///
 graphregion(color(white)) legend(label(1 "CPS") label(2 "NLS")) xtitle("Parent Family Income")  title("1979 Parents") ylabel(0(5e-6)1e-5, nogrid) ytitle("Density")  xlabel(0(125000)500000)
 graph save ${results_dir}comp_avgs79_adjwt_avg.gph, replace

graph twoway (kdensity ftotval if survey==1966 & is_kid==1 & cps==1  & ftotval>0 & ftotval<=500000 [w=asecwth]) (kdensity kid if survey==1966 & cps==0  & kid>0 & kid<=500000 [w=wt_nls_avg] ), ///
 graphregion(color(white)) legend(label(1 "CPS") label(2 "NLS")) xtitle("Child Family Income")  title("1966 Children") ylabel(0(5e-6)1e-5, nogrid) ytitle("Density") xlabel(0(125000)500000)
 graph save ${results_dir}comp_kids66_adjwt_avg.gph, replace

graph twoway (kdensity ftotval if survey==1979 & is_kid==1 & cps==1 & ftotval>0  & ftotval<=500000 [w=asecwth]) (kdensity kid if survey==1979 & cps==0 & kid>0  & kid<=500000 [w=wt_nls_avg] ), ///
 graphregion(color(white)) legend(label(1 "CPS") label(2 "NLS")) xtitle("Child Family Income")  title("1979 Children") ylabel(0(5e-6)1e-5, nogrid) ytitle("Density") xlabel(0(125000)500000)
 graph save ${results_dir}comp_kids79_adjwt_avg.gph, replace

grc1leg ${results_dir}comp_avgs66_adjwt_avg.gph ${results_dir}comp_avgs79_adjwt_avg.gph ${results_dir}comp_kids66_adjwt_avg.gph ${results_dir}comp_kids79_adjwt_avg.gph, col(2) graphregion(color(white))
graph export ${results_dir}figure_a8.png, replace 

erase ${results_dir}comp_avgs66_adjwt_avg.gph 
erase ${results_dir}comp_avgs79_adjwt_avg.gph 
erase ${results_dir}comp_kids66_adjwt_avg.gph 
erase ${results_dir}comp_kids79_adjwt_avg.gph

bys id survey women: egen seq=seq()
keep if seq==1

keep id survey women wt_nls_parent wt_nls_kid wt_nls_avg
save ${data_dir}weight_adjustments.dta, replace
 
exit
