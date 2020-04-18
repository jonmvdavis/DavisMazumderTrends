* Table 1: Summary Statistics
clear
use "${data_dir}DavisMazumderData.dta"
drop if miss0 | miss1

gen dad_present = dad_age_inc<. 
gen mom_present = mom_age_inc<. 
gen spouse_present = spouse_age<.

gen keep =  !((mom_outOfRange==1 & linkMom==1 & !(dad_outOfRange==0 & linkDad==1)) | (dad_outOfRange==1 & linkDad==1 & !(mom_outOfRange==0 & linkMom==1)) | (linkMom==0 & linkDad==0) ) 
gen drop = 1-keep

mat sumstat = ., ., ., ., ., .
mat sumstat_w = ., ., ., ., ., .
mat sumstat_m = ., ., ., ., ., .


 su drop [w=weight] if surv79==0
 gen float n66 = round(r(N),.0001)
 gen float mn66 = round(r(mean),.0001)
 gen float sd66 = round(r(sd),.0001)
 su n66
 local n66 = r(mean)
 su mn66
 local m66 = r(mean)
 su sd66
 local s66 = r(mean)

 
 su drop [w=weight] if surv79==1
 gen float n79 = round(r(N),.0001)
 gen float mn79 = round(r(mean),.0001)
 gen float sd79 = round(r(sd),.0001)
 su n79
 local n79 = r(mean)
 su mn79
 local m79 = r(mean)
 su sd79
 local s79 = r(mean)
 
 mat sumstat = sumstat \ (`n66', `m66', `s66', `n79', `m79', `s79')
 drop n66 mn66 sd66 n79 mn79 sd79
  
 su drop [w=weight] if surv79==0 & women==1
 gen float n66 = round(r(N),.0001)
 gen float mn66 = round(r(mean),.0001)
 gen float sd66 = round(r(sd),.0001)
 su n66
 local n66 = r(mean)
 su mn66
 local m66 = r(mean)
 su sd66
 local s66 = r(mean)
 
 su drop [w=weight] if surv79==1 & women==1
 gen float n79 = round(r(N),.0001)
 gen float mn79 = round(r(mean),.0001)
 gen float sd79 = round(r(sd),.0001)
 su n79
 local n79 = r(mean)
 su mn79
 local m79 = r(mean)
 su sd79
 local s79 = r(mean)
 
 
 mat sumstat_w = sumstat_w \ (`n66', `m66', `s66', `n79', `m79', `s79')
 drop n66 mn66 sd66 n79 mn79 sd79
 
 su drop [w=weight] if surv79==0 & women==0
 gen float n66 = round(r(N),.0001)
 gen float mn66 = round(r(mean),.0001)
 gen float sd66 = round(r(sd),.0001)
 su n66
 local n66 = r(mean)
 su mn66
 local m66 = r(mean)
 su sd66
 local s66 = r(mean)
 
 su drop [w=weight] if surv79==1 & women==0
 gen float n79 = round(r(N),.0001)
 gen float mn79 = round(r(mean),.0001)
 gen float sd79 = round(r(sd),.0001)
 su n79
 local n79 = r(mean)
 su mn79
 local m79 = r(mean)
 su sd79
 local s79 = r(mean)
 
 mat sumstat_m = sumstat_m \ (`n66', `m66', `s66', `n79', `m79', `s79')
 drop n66 mn66 sd66 n79 mn79 sd79 
 
drop if keep==0
foreach var of varlist linkDad linkMom linkBoth faminc0  dad_present dad_age_inc mom_present mom_age_inc kid_age_parentInc faminc1 kid_age spouse_present spouse_age {
  su `var' [w=weight] if surv79==0
 gen float n66 = round(r(N),.001)
 gen float mn66 = round(r(mean),.001)
 gen float sd66 = round(r(sd),.001)
 su n66
 local n66 = r(mean)
 su mn66
 local m66 = r(mean)
 su sd66
 local s66 = r(mean)

 
 su `var' [w=weight] if surv79==1
 gen float n79 = round(r(N),.001)
 gen float mn79 = round(r(mean),.001)
 gen float sd79 = round(r(sd),.001)
 su n79
 local n79 = r(mean)
 su mn79
 local m79 = r(mean)
 su sd79
 local s79 = r(mean)
 
 mat sumstat = sumstat \ (`n66', `m66', `s66', `n79', `m79', `s79')
 drop n66 mn66 sd66 n79 mn79 sd79
  
 su `var' [w=weight] if surv79==0 & women==1
 gen float n66 = round(r(N),.001)
 gen float mn66 = round(r(mean),.001)
 gen float sd66 = round(r(sd),.001)
 su n66
 local n66 = r(mean)
 su mn66
 local m66 = r(mean)
 su sd66
 local s66 = r(mean)
 
 su `var' [w=weight] if surv79==1 & women==1
 gen float n79 = round(r(N),.001)
 gen float mn79 = round(r(mean),.001)
 gen float sd79 = round(r(sd),.001)
 su n79
 local n79 = r(mean)
 su mn79
 local m79 = r(mean)
 su sd79
 local s79 = r(mean)
 
 
 mat sumstat_w = sumstat_w \ (`n66', `m66', `s66', `n79', `m79', `s79')
 drop n66 mn66 sd66 n79 mn79 sd79
 
 su `var' [w=weight] if surv79==0 & women==0
 gen float n66 = round(r(N),.001)
 gen float mn66 = round(r(mean),.001)
 gen float sd66 = round(r(sd),.001)
 su n66
 local n66 = r(mean)
 su mn66
 local m66 = r(mean)
 su sd66
 local s66 = r(mean)
 
 su `var' [w=weight] if surv79==1 & women==0
 gen float n79 = round(r(N),.001)
 gen float mn79 = round(r(mean),.001)
 gen float sd79 = round(r(sd),.001)
 su n79
 local n79 = r(mean)
 su mn79
 local m79 = r(mean)
 su sd79
 local s79 = r(mean)
 
 mat sumstat_m = sumstat_m \ (`n66', `m66', `s66', `n79', `m79', `s79')
 drop n66 mn66 sd66 n79 mn79 sd79 
 
 
}

* Pooled Summary Statistics
matrix list sumstat

* Summary Statistics for Parent-Daughter Pairs
matrix list sumstat_w

* Summary Statistics for Parent-Son Pairs
matrix list sumstat_m
exit


