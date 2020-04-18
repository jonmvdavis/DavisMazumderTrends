* Table 3: Missingness and Zero Income in the 1948-1953 and 1961-1964 cohorts
clear
use "${data_dir}DavisMazumderData.dta"

* Apply sample restrictions, except keep missing for now
keep if age_firstSurvey<=18
drop if (mom_outOfRange==1 & linkMom==1 & !(dad_outOfRange==0 & linkDad==1)) | (dad_outOfRange==1 & linkDad==1 & !(mom_outOfRange==0 & linkMom==1)) | (linkMom==0 & linkDad==0) 
 



gen inSample0 = 1-miss0
gen inSample1 = 1-miss1
gen inSample = inSample0 & inSample1

matrix both = J(3,6,.)
local row = 0
foreach var of varlist inSample0 inSample1 inSample {
	local row = `row'+1
	su `var' if surv79==0 [w=weight] 
	matrix both[`row',1] = r(mean)
	su `var' if surv79==1 [w=weight] 
	matrix both[`row',2] = r(mean)
	su `var' if surv79==0 & women==1 [w=weight] 
	matrix both[`row',3] = r(mean)
	su `var' if surv79==1 & women==1 [w=weight] 
	matrix both[`row',4] = r(mean)
	su `var' if surv79==0 & women==0 [w=weight] 
	matrix both[`row',5] = r(mean)
	su `var' if surv79==1 & women==0 [w=weight] 
	matrix both[`row',6] = r(mean)
}

* Panel A
matrix list both

keep if miss1==0 & miss0==0


matrix parent_det = J(7,6,.)

local row = 0
foreach var of varlist nparent ms_parent1 ms_parent2 ms_parent3 zero_parent1 zero_parent2 zero_parent3 {
	local row = `row'+1
	su `var' if surv79==0 [w=weight] 
	matrix parent_det[`row',1] = r(mean)
	su `var' if surv79==1 [w=weight] 
	matrix parent_det[`row',2] = r(mean)
	su `var' if surv79==0 & women==1 [w=weight] 
	matrix parent_det[`row',3] = r(mean)
	su `var' if surv79==1 & women==1 [w=weight] 
	matrix parent_det[`row',4] = r(mean)
	su `var' if surv79==0 & women==0 [w=weight] 
	matrix parent_det[`row',5] = r(mean)
	su `var' if surv79==1 & women==0 [w=weight] 
	matrix parent_det[`row',6] = r(mean)
}

* Parent Generation Panel
matrix list parent_det



matrix child_det = J(7,6,.)

local row = 0
foreach var of varlist nkid ms_kid1 ms_kid2 ms_kid3  zero_kid1 zero_kid2 zero_kid3  {
	local row = `row'+1
	su `var' if surv79==0 [w=weight] 
	matrix child_det[`row',1] = r(mean)
	su `var' if surv79==1 [w=weight] 
	matrix child_det[`row',2] = r(mean)
	su `var' if surv79==0 & women==1 [w=weight] 
	matrix child_det[`row',3] = r(mean)
	su `var' if surv79==1 & women==1 [w=weight] 
	matrix child_det[`row',4] = r(mean)
	su `var' if surv79==0 & women==0 [w=weight] 
	matrix child_det[`row',5] = r(mean)
	su `var' if surv79==1 & women==0 [w=weight] 
	matrix child_det[`row',6] = r(mean)
}

* Child Generation Panel
matrix list child_det 



exit

