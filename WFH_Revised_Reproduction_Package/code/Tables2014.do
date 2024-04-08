
* Changes made to Figure X. 

*This replicates everything in the paper "Does working from home work: evidence from a Chinese Experiment?"
*To execute simply run this file in the same directory as all the data
*February 2014
*For questions please contact
	*Nick Bloom on nbloom@stanford 

cd "" 
version 13
set more off	
cap log close
log using WFH_august18,replace t	

************************************************************************************************************************************
//Table 1. Characteristics of employees who volunteer to join WFH
use summary_volunteer.dta, clear
*col (1) 
dprobit volunteer children, robust
*col (2) 
dprobit volunteer married, robust
*col (3) 
dprobit volunteer children married commute bedroom, robust
*col (4) 
dprobit volunteer children married commute bedroom high_educ tenure, robust
*col (5) 
dprobit volunteer children married commute bedroom high_educ tenure grosswage
*col (6) 
dprobit volunteer grosswage
*col (7) 
dprobit volunteer children married commute bedroom high_educ tenure grosswage age men
*sample mean
sum children married commute bedroom high_educ tenure grosswage age men
************************************************************************************************************************************

************************************************************************************************************************************
//Table 2. Performance Impact during the experiment (note week 201049 was the transition week so is dropped)
use performance_during_exper.dta, clear
*col(1)
xi:areg perform1 experiment_treatment i.year_week if year_week~=201049 &(expgroup==1|expgroup==0),ab(personid) cluster(personid)
*col(2)
xi:reg perform1 treatment i.year_week if year_week>201049 & (expgroup==1|expgroup==0),cluster(personid)
*col(3)
xi:areg phonecall experiment_treatment i.year_week if year_week~=201049 &(expgroup==1|expgroup==0) & logcallpersec~=. & phonecallraw>20,ab(personid) cluster(personid)
*col(4)
xi:areg logphonecall experiment_treatment i.year_week if year_week~=201049 &(expgroup==1|expgroup==0) & logcallpersec~=. & phonecallraw>20,ab(personid) cluster(personid)
*col(5)
xi:areg logcallpersec experiment_treatment i.year_week if year_week~=201049 & (expgroup==1|expgroup==0) & logphonecall~=. & phonecallraw>20,ab(personid) cluster(personid)
*col(6)
xi:areg logcalllength experiment_treatment i.year_week if year_week~=201049 & (expgroup==1|expgroup==0) & logphonecall~=. & phonecallraw>20, ab(personid) cluster(personid)
*col(7)
use wage_new.dta, clear
xi: areg loggrosswage experiment_treatment i.wage_month if wage_month<201109, ab(personid) cluster(personid)

************************************************************************************************************************************

************************************************************************************************************************************
//Table 3. Decomposition of labor supply
use performance_during_exper.dta, clear
*col (1) 
xi:areg logcalllength experiment_treatment i.year_week if year_week~=201049 & (expgroup==1|expgroup==0) & logphonecall~=. & phonecallraw>20, ab(personid) cluster(personid)
*col(2) 
xi:areg logcall_dayworked experiment_treatment i.year_week if year_week~=201049 & (expgroup==1|expgroup==0) & logphonecall~=. & phonecallraw>20, ab(personid) cluster(personid)
*col(3)
xi:areg logdaysworked experiment_treatment i.year_week if year_week~=201049 & (expgroup==1|expgroup==0) & logphonecall~=. & phonecallraw>20 & logcall_dayworked~=., ab(personid) cluster(personid)
*col (4) 
xi:areg logcalllength experiment_treatment_commute120 experiment_treatment i.year_week if year_week~=201049 & (expgroup==1|expgroup==0) & logphonecall~=. & phonecallraw>20, ab(personid) cluster(personid)
*col(5) 
xi:areg logcall_dayworked experiment_treatment_commute120 experiment_treatment i.year_week if year_week~=201049 & (expgroup==1|expgroup==0) & logphonecall~=. & phonecallraw>20, ab(personid) cluster(personid)
*col(6)
xi:areg logdaysworked experiment_treatment_commute120 experiment_treatment i.year_week if year_week~=201049 & (expgroup==1|expgroup==0) & logphonecall~=. & phonecallraw>20 & logcall_dayworked~=., ab(personid) cluster(personid)
************************************************************************************************************************************


************************************************************************************************************************************
//Table 4. Spillover
use performance_during_exper.dta, clear
*(1) Compare T, C with Nantong, PERFORMANCE
xi:areg perform1 experiment_treatment experiment_control i.year_week if year_week~=201049 & (expgroup~=2),ab(personid) cluster(personid)
*(2) Compare T, C with Nantong, PHONECALL
xi:areg phonecall experiment_treatment experiment_control i.year_week if year_week~=201049 & (expgroup~=2), ab(personid) cluster(personid)
*(3) Compare T, C with non-exper, PERFORMANCE
xi:areg perform1 experiment_treatment experiment_control i.year_week if year_week~=201049 & (expgroup~=3),ab(personid) cluster(personid)
*(4) Compare T, C with non-exper, PHONECALL
xi:areg phonecall experiment_treatment experiment_control i.year_week if year_week~=201049 & (expgroup~=3), ab(personid) cluster(personid)

************************************************************************************************************************************

************************************************************************************************************************************
//Table 5. Selection
use selection_new.dta, clear
*col(1) 
xi:areg perform1 experiment_treatment i.year_week if year_week~=201049 & year_week<=201133,ab(personid) cluster(personid)
*col(2)
xi:areg perform1 experiment_treatment treatment_post_experiment i.year_week if year_week~=201049,ab(personid) cluster(personid)
*col(3)
xi:areg perform1 experiment_treatment treatment_post_experiment i.year_week if year_week~=201049 & balanced==1,ab(personid) cluster(personid)
*col(4)
xi:areg logphonecall experiment_treatment i.year_week if year_week~=201049 & year_week<=201133 & phonecallraw>20,ab(personid) cluster(personid)
*col(5)
xi:areg logphonecall experiment_treatment treatment_post_experiment i.year_week if year_week~=201049 & phonecallraw>20,ab(personid) cluster(personid)
*col(6)
xi:areg logphonecall experiment_treatment treatment_post_experiment i.year_week if year_week~=201049 & phonecallraw>20 & balanced==1,ab(personid) cluster(personid)
************************************************************************************************************************************

************************************************************************************************************************************
//Table 6. Switching after the experiment
//return
use switch_return.dta, clear
*(1)
dprobit return perform11, robust
*(2)
dprobit return perform10, robust
*(3)
dprobit return perform10 perform11, robust
*(4)
dprobit return perform11 perform10 married livewparents costofcommute, robust
//join
use switch_gohome.dta, clear
*(1)
dprobit join perform11, robust
*(2)
dprobit join perform10, robust
*(3)
dprobit join perform10 perform11, robust
*(4)
dprobit join perform11 perform10 married livewparents costofcommute, robust
************************************************************************************************************************************

************************************************************************************************************************************
//Table 7. Self-reported work outcomes
*col (1)-(3) satisfaction
use satisfaction.dta, clear
foreach i in satisfaction general life {
gen ln`i'=ln(`i')
xi:areg ln`i' expgroup_treatment i.surveyno, ab(personid) cluster(personid)
}
*col (4) work exhaustion
use exhaustion.dta, clear
xi:reg lnexhaustion experiment_expgroup announcement_expgroup i.year_week, cluster(personid)
*col (5) positive attitude
use positive.dta, clear
xi:reg lnpositive experiment_expgroup announcement_expgroup i.year_week, cluster(personid)
*col (6) negative attitude
use negative.dta, clear
xi:reg lnnegative experiment_expgroup announcement_expgroup i.year_week, cluster(personid)
************************************************************************************************************************************

************************************************************************************************************************************
//Table 8. Attrition
use quit_data.dta, clear
*col(1)
dprobit quitjob expgroup age men married costofcommute children, robust
*col(2)
dprobit quitjob perform11 age men married costofcommute children, robust
*col(3)
dprobit quitjob expgroup perform11 age men married costofcommute children, robust
*col(4) 
dprobit quitjob perform11 perform11_expgroup expgroup age men married costofcommute children, robust
*col(5) & (6)
foreach j in "expgroup==0" "expgroup==1"  {
dprobit quitjob perform11 age men married costofcommute children if `j', robust
}
************************************************************************************************************************************

************************************************************************************************************************************
//Table 9. Promotion
use promotion, clear
*col(1)
dprobit promote_switch expgroup, robust
*col(2)
dprobit promote_switch perform11, robust
*col(3)
dprobit promote_switch expgroup perform11, robust
*col(4)
dprobit promote_switch expgroup perform11 men tenure high_school, robust
*col(5)
dprobit promote_switch expgroup perform11 perform11_expgroup men tenure high_school, robust
************************************************************************************************************************************



************************************************************************************************************************************
//Appendix A1. Table for different types of workers and their key performance measures
*Descriptive - directly from observation

//Appendix A2(a). Treatment and Control comparison
use tc_comparison.dta, clear
*Means by group
bysort expgroup: sum age men second_tec high_school tert univ prior tenure married children ageyoung rental costofc internet bedroom basewage bonus grosswage
*Overall SD
sum age men second_tec high_school tert univ prior tenure married children ageyoung rental costofc internet bedroom basewage bonus grosswage
*Significance of difference 
pwcorr  expgroup age men second_tec high_school tert univ prior tenure married children ageyoung rental costofc internet bedroom basewage bonus grosswage,sig
*Significance of difference within type - is the split different from 50:50
gen share=expgroup-0.5
replace type=2 if type==3
label define type  2 "Order takers", modify
so type
by type:reg share,rob


//Appendix A2(b) (ORDER TAKER) Treatment and Control comparison 
use tc_comparison.dta, clear
keep if type==1
*Means by group
bysort expgroup: sum age men second_tec high_school tert univ prior tenure married children ageyoung rental costofc internet bedroom basewage bonus grosswage
*Overall SD
sum age men second_tec high_school tert univ prior tenure married children ageyoung rental costofc internet bedroom basewage bonus grosswage
*Significance of difference 
pwcorr  expgroup age men second_tec high_school tert univ prior tenure married children ageyoung rental costofc internet bedroom basewage bonus grosswage,sig


************************************************************************************************************************************
//Appendix O1. Comparison between Volunteers and Non-volunteers
use summary_volunteer.dta, clear
matrix A = J(18,3,0)
local j =1
foreach i in children married commute bedroom high_educ tenure grosswage age men {
sum `i' if volunteer==1
matrix A[`j',1]=r(mean)
matrix A[`j'+1,1]=r(sd)
sum `i' if volunteer==0
matrix A[`j',2]=r(mean)
matrix A[`j'+1,2]=r(sd)
reg `i' volunteer
matrix a = e(V)
matrix b = e(b)
matrix A[`j',3]=b[1,1]/sqrt(a[1,1])
local j=`j'+2
}
matrix list A

//Appendix O2. Explanations of the Work Satisfaction Survey
*No replication - text

//Appendix O3. Quality
use recording.dta, clear
su grade
*col(1)
xi:reg grade experiment_treatment expgroup i.year_week if year_week~=201049 & year_week<=201133, cluster(personid)
*col(2)
xi:areg grade experiment_treatment i.year_week if year_week~=201049 & year_week<=201133,ab(personid) cluster(personid)
use conversion.dta, clear
su zconversion
*col(3)
xi:reg zconversion experiment_treatment expgroup i.year_week, cluster(personid)
*col(4)
xi:areg zconversion experiment_treatment i.year_week,ab(personid) cluster(personid)

//Appendix O4. Treatment effects
use treatment_effect.dta, clear
foreach var in children women childrenwomen commute120 rental young short_exper short_tenure livewparents livewspouse livewfriend perform10 {
xi:areg perform1 exper_treat_`var' experiment_treatment experiment_`var' i.year_week if year_week~=201049,ab(personid) cluster(personid)
}


****************************
//Appendix O5. IV regressions: Performance Impact during the experiment (Same as Table 2)
use performance_during_exper.dta, clear
keep if (expgroup==1|expgroup==0)
*col(1)
xi:ivreg perform1 (experiment_home=experiment_treatment) i.year_week i.personid if year_week~=201049 &(expgroup==1|expgroup==0), cluster(personid) first
*col(2)
preserve
collapse (max) experiment_home, by(personid wage_month)
so personid wage_month
merge personid wage_month using wage_new.dta
keep if _merge==3
xi:ivreg loggrosswage (experiment_home=experiment_treatment) i.wage_month i.personid if wage_month<201109, cluster(personid) first
*col(3)
restore
xi:ivreg perform1 (homethatweek=treatment) i.year_week if year_week>201049 &(expgroup==1|expgroup==0),cluster(personid) first
*col(4)
xi:ivreg phonecall (experiment_home=experiment_treatment) i.year_week i.personid if year_week~=201049 &(expgroup==1|expgroup==0) & logcallpersec~=. & phonecallraw>20, cluster(personid) first
*col(5)
xi:ivreg logphonecall (experiment_home=experiment_treatment) i.year_week i.personid if year_week~=201049 &(expgroup==1|expgroup==0) & logcallpersec~=. & phonecallraw>20, cluster(personid) first
*col(6)
xi:ivreg logcallpersec (experiment_home=experiment_treatment) i.year_week i.personid if year_week~=201049 & (expgroup==1|expgroup==0) & logphonecall~=. & phonecallraw>20, cluster(personid)
*col(7)
xi:ivreg logcalllength (experiment_home=experiment_treatment) i.year_week i.personid if year_week~=201049 & (expgroup==1|expgroup==0) & logphonecall~=. & phonecallraw>20, cluster(personid)


//Appendix O6. Experimental IMPACT ON WAGE
use "wage_new.dta", clear
*(1)
xi: areg grosswage experiment_treatment i.wage_month if wage_month<201109, ab(personid) cluster(personid)
*(2)
xi: areg basewage experiment_treatment i.wage_month if wage_month<201109, ab(personid) cluster(personid)
*(3)
xi: areg bonustotal experiment_treatment i.wage_month if wage_month<201109, ab(personid) cluster(personid)
*(4)
xi: areg loggrosswage experiment_treatment i.wage_month if wage_month<201109, ab(personid) cluster(personid)
*(5)
xi: areg logbasewage experiment_treatment i.wage_month if wage_month<201109, ab(personid) cluster(personid)
*(6)
xi: areg logbonustotal experiment_treatment i.wage_month if wage_month<201109, ab(personid) cluster(personid)


************************************************************************************************************************************
//Figure I. In the US primarily working from home is relatively more common for the highest and lowest wage deciles.
use wage_wfh.dta, clear
twoway (bar wfh wageq, sort), ylabel(, nogrid) ytitle(" ") xtitle(" ") xlabel(1(1)10) legend(off) graphregion(margin(medium) fcolor(white) lcolor(none) lwidth(vvvthin) ifcolor(white) ilcolor(white) ilwidth(vvvthin))
graph export Figure1.pdf, replace

************************************************************************************************************************************
//Figure III. CTrip share of employees working at home
use daysathome.dta, clear
scatter homeatleastoneday* wk if wk~=2707, c(l l l) xline(2647.5 2684) tlabel(,format(%tw)) ms(+ diamond) scale(0.8) ylabel(, nogrid) xtitle(" ") legend(off) graphregion(margin(medium) fcolor(white) lcolor(none) lwidth(none) lpattern(blank) ifcolor(white) ilcolor(white) ilwidth(vvvthin)) xlabel(2600(8)2724, angle(forty_five))
graph export Figure3.pdf, replace

************************************************************************************************************************************
//Figure IV. Performance of treatment and control employees: phone calls
use performance_during_exper.dta, clear
keep if expgroup==0|expgroup==1
collapse phonecallraw (min) date,by(expgroup year_week)
reshape wide phonecallraw date, i(year_week) j(expgroup)

tsset date1
gen wk = wofd(date1)
label var wk "Week"
local condition1 c(l l l) xline(2647.5) tlabel(,format(%tw)) ms(+) scale(0.8) 
local legend1 legend(order(1 "control" 2 "treatment"))
local xlabel  xlabel(2600(8)2694, angle(forty_five))

drop if wk==2600
scatter phonecallraw0 phonecallraw1 wk, `condition1' ytitle(" ") ylabel(300(50)550, nogrid) xtitle(" ") legend(off) graphregion(margin(medium) fcolor(white) lcolor(none) lwidth(none) lpattern(blank) ifcolor(white) ilcolor(white) ilwidth(vvvthin)) xlabel(2600(8)2680, angle(forty_five))
graph export Figure4.pdf, replace

************************************************************************************************************************************
//Figure V. Cross-sectional performance spread during the experiment
use performance_during_exper.dta, clear
keep if expgroup==0|expgroup==1
keep if year_week==201109
label define expgroup 1 "treatment" 0 "control"
label val expgroup expgroup
histogram perform1, bin(40) by(expgroup, col(1)) ylabel(0(0.2)0.6, nogrid) xlabel(-2.5(0.5)2.5) xtitle(" ") ytitle(" ") legend(off) scale(0.8) graphregion(fcolor(white) lcolor(none) ifcolor(white) ilcolor(none))
graph export Figure5.pdf, replace

************************************************************************************************************************************
//Figure VI. Selection further increased the performance impact of home working during the company roll-out
use "post_sep_home.dta", clear
gen wk = wofd(date1)
label var wk "Week"
local graphcond1 c(l l ) xline(2647.5 2684) tlabel(,format(%tw)) ms(+) scale(0.8) 
local xlabel xlabel(2601(8)2743, angle(forty_five))
scatter phonecallraw_d_home wk, c(l) xline(2647.5 2684) tlabel(,format(%tw)) lwidth(medium) scale(0.8)  ytitle(" ") xlabel(2600(8)2743, angle(forty_five)) ylabel(-50(50)150, nogrid) xtitle(" ") legend(off) graphregion(margin(medium) fcolor(white) lcolor(none) lwidth(none) lpattern(blank) ifcolor(white) ilcolor(white) ilwidth(vvvthin))
graph export Figure6.pdf, replace

************************************************************************************************************************************
//Figure VII. Attrition is halved by working from home
use "attrition.dta", clear
so personid week
replace quitjob=1 if quitjob[_n-1]==1 & personid==personid[_n-1]
replace quitjob=0 if quitjob==.

gen sdquit=quitjob
gen n=1
collapse (mean) quitjob (sum) n (sd) sdquit, by(expgroup week)
replace quitjob=quitjob*100
replace sdquit=sdquit*100
gen upbound= quitjob+1.96*sdquit/sqrt(n)
gen lowerbound= quitjob-1.96*sdquit/sqrt(n)

format quit %2.0f
label var quit "attrition rate(%)"
twoway (connected quitjob week if expgroup==0, sort) (connected quitjob week if expgroup==1, sort msymbol(triangle) lcolor(maroon)) (line upbound week if expgroup==0, sort lcolor(navy) lpattern(dash)) (line lowerbound week if expgroup==0, sort lcolor(navy) lpattern(dash))(line upbound week if expgroup==1, sort lcolor(maroon) lpattern(dash_dot)) (line lowerbound week if expgroup==1, sort lcolor(maroon) lpattern(dash_dot)), ytitle(" ") xlabel(0(2)38) ylabel(0(5)45, nogrid) xtitle(" ") legend(off) graphregion(margin(medium) fcolor(white) lcolor(none) lwidth(none) lpattern(blank) ifcolor(white) ilcolor(white) ilwidth(vvvthin))
graph export Figure7.pdf, replace

************************************************************************************************************************************
//Figure X. The top and bottom half of employees by pre-experiment performance both improved from working at home
use "perform_top_bottom.dta", clear
gen expgroup_top=1 if expgroup==1 & perform1_before_top==1
replace expgroup_top=2 if expgroup==1 & perform1_before_top==0
replace expgroup_top=3 if expgroup==0 & perform1_before_top==1
replace expgroup_top=4 if expgroup==0 & perform1_before_top==0

drop expgroup perform1_before_top phonecall_before 
reshape wide perform1 phonecall, i(year_week) j(expgroup_top)
gen perform_gap_top=perform11-perform13
gen perform_gap_bottom=perform12-perform14

label var perform_gap_top "performance gap between the top half of the performance distribution of the pre-experimental performance"
label var perform_gap_bottom "performance gap between the bottom half of the performance distribution of the pre-experimental performance"

tsset date
gen wk = wofd(date)
label var wk "Week"
sort wk
drop if wk==2600
scatter perform_gap_top perform_gap_bottom wk if year_week<=201133, c(l l) xline(2647.5) tlabel(,format(%tw)) ms(+) scale(0.8) xlabel(2600(8)2685, angle(forty_five)) ylabel(, nogrid) ytitle("Difference between home and office (normalized calls per week)") xtitle(" ") legend(off) graphregion(margin(medium) fcolor(white) lcolor(none) lwidth(none) lpattern(blank) ifcolor(white) ilcolor(white) ilwidth(vvvthin)) text(2608 -.5 "Before the experiment", size(small) color(black)) text(2653 -.5 "Before the experiment", size(small) color(black))   
graph export Figure8.pdf, replace
***********************************************************************************************************************************
log close
