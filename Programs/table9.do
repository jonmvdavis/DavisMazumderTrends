* Table 9: Absolute Mobility in the NLS66 and NLSY79
clear
use "${data_dir}DavisMazumderData.dta"
keep if age_firstSurvey<=18
drop if miss0 | miss1
drop if (mom_outOfRange==1 & linkMom==1 & !(dad_outOfRange==0 & linkDad==1)) | (dad_outOfRange==1 & linkDad==1 & !(mom_outOfRange==0 & linkMom==1)) | (linkMom==0 & linkDad==0) 
 



* Absolute Mobility *

gen surv66 = survey==1966



reg up0 surv66 surv79 [w=weight] if women==1, nocons cluster(hhid)
eststo abs_w
test surv66=surv79
estadd scalar p=r(p): abs_w
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_w
estadd scalar se = r(se): abs_w
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_w
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_w
drop s

reg up0 surv66 surv79 [w=weight] if women==0, nocons cluster(hhid)
eststo abs_m
test surv66=surv79
estadd scalar p=r(p): abs_m
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_m
estadd scalar se = r(se): abs_m
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_m
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_m
drop s


* Again with No Weights *



reg up0 surv66 surv79 if women==1, nocons cluster(hhid)
eststo abs_w_noweight
test surv66=surv79
estadd scalar p=r(p): abs_w_noweight
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_w_noweight
estadd scalar se = r(se): abs_w_noweight
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_w_noweight
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_w_noweight
drop s

reg up0 surv66 surv79 if women==0, nocons cluster(hhid)
eststo abs_m_noweight
test surv66=surv79
estadd scalar p=r(p): abs_m_noweight
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_m_noweight
estadd scalar se = r(se): abs_m_noweight
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_m_noweight
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_m_noweight
drop s


* Drop Any Observation With Missing or Zero Income Report *

keep if all_parent==1 & all_kid==1

reg up0 surv66 surv79 [w=weight] if women==1, nocons cluster(hhid)
eststo abs_w_nomiss
test surv66=surv79
estadd scalar p=r(p): abs_w_nomiss
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_w_nomiss
estadd scalar se = r(se): abs_w_nomiss
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_w_nomiss
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_w_nomiss
drop s

reg up0 surv66 surv79 [w=weight] if women==0, nocons cluster(hhid)
eststo abs_m_nomiss
test surv66=surv79
estadd scalar p=r(p): abs_m_nomiss
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_m_nomiss
estadd scalar se = r(se): abs_m_nomiss
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_m_nomiss
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_m_nomiss
drop s


* No Weights *

reg up0 surv66 surv79  if women==1, nocons cluster(hhid)
eststo abs_w_nomiss_noweight
test surv66=surv79
estadd scalar p=r(p): abs_w_nomiss_noweight
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_w_nomiss_noweight
estadd scalar se = r(se): abs_w_nomiss_noweight
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_w_nomiss_noweight
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_w_nomiss_noweight
drop s

reg up0 surv66 surv79 if women==0, nocons cluster(hhid)
eststo abs_m_nomiss_noweight
test surv66=surv79
estadd scalar p=r(p): abs_m_nomiss_noweight
lincom surv79-surv66
estadd scalar diff = r(estimate): abs_m_nomiss_noweight
estadd scalar se = r(se): abs_m_nomiss_noweight
gen s=e(sample)
count if surv79==0 & s==1
estadd scalar N66 = r(N): abs_m_nomiss_noweight
count if surv79==1 & s==1
estadd scalar N79 = r(N): abs_m_nomiss_noweight
drop s



#delimit ;

estout abs_w abs_w_nomiss abs_w_noweight abs_w_nomiss_noweight abs_m abs_m_nomiss abs_m_noweight abs_m_nomiss_noweight    
	using  "${results_dir}table9.txt", replace
	keep(surv66 surv79)
	cells(b(star fmt(3))  se(par fmt(3))) 
	collabels(,none) stat(diff se p p2 N66 N79) stardrop(*) ;	
	
	
#delimit cr	

