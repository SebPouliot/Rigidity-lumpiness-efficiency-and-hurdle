clear*
set more off
version 14

use "Data/Clean data.dta",clear

***********************************************************************************************
/*=========================MODEL 1 ==============================*/
xtset id year, yearly
set seed 14052004
frontier mland1 mlvout1 mlotout1 mlfeed1 mlabo1 mlmach1 mlocapi1 mlvout2 mlotout2 mlfeed2 mlabo2 mlmach2 mlocapi2 lout12 out1_feed out1_lab out1_mach out1_ocap ///
		out2_feed out2_lab out2_mach out2_ocap feed_lab feed_mach feed_ocap lab_mach lab_ocap mach_ocap, distribution(tnormal) cm(age offwork north south time d2009a t2009a)   
predict TE_TVAR, te
sum TE_TVAR if year<2009
sum TE_TVAR if year==2009
sum TE_TVAR if year==2010
estimates store model1

/*=========================MODEL 2 ==============================*/
xtset id year, yearly
set seed 14052004
frontier mland1 mlvout1 mlotout1 mlfeed1 mlabo1 mlmach1 mlocapi1 mlvout2 mlotout2 mlfeed2 mlabo2 mlmach2 mlocapi2 lout12 out1_feed out1_lab out1_mach out1_ocap ///
		out2_feed out2_lab out2_mach out2_ocap feed_lab feed_mach feed_ocap lab_mach lab_ocap mach_ocap time, distribution(tnormal) cm(age offwork north south d2009a t2009a)   
predict TE_Time, te
sum TE_Time if year<2009
sum TE_Time if year==2009
sum TE_Time if year==2010
estimates store model2

/*=========================MODEL 3 ==============================*/
xtset id year, yearly
set seed 14052004
frontier mland1 mlvout1 mlotout1 mlfeed1 mlabo1 mlmach1 mlocapi1 mlvout2 mlotout2 mlfeed2 mlabo2 mlmach2 mlocapi2 lout12 out1_feed out1_lab out1_mach out1_ocap ///
		out2_feed out2_lab out2_mach out2_ocap feed_lab feed_mach feed_ocap lab_mach lab_ocap mach_ocap, distribution(tnormal) cm(age offwork north south d2005 d2006 d2007 d2008 d2009 d2010)   
predict TE_Tdummy, te
sum TE_Tdummy if year<2009
sum TE_Tdummy if year==2009
sum TE_Tdummy if year==2010
estimates store model3


esttab model1 model2 model3 using Results_Stata.rtf, replace b(%10.4f) se star(* 0.10 ** 0.05 *** 0.01) scalars(N ll) mtitles keep(mlvout1 mlotout1 mlfeed1 mlabo1 mlmach1 mlocapi1 mlvout2 mlotout2 mlfeed2 mlabo2 mlmach2 mlocapi2 lout12 out1_feed out1_lab out1_mach out1_ocap out2_feed out2_lab out2_mach out2_ocap feed_lab feed_mach  feed_ocap lab_mach lab_ocap mach_ocap time age offwork south north d2005 d2006 d2007 d2008 d2009a t2009a d2009 d2010 _cons)


/*=====OTHER SPECIFICATIONS CHECK ===================*/


*keep only farms for which we have information before and after 2009
preserve
keep if(dbef2009==0 & daft2009==0)
frontier mland1 mlvout1 mlotout1 mlfeed1 mlabo1 mlmach1 mlocapi1 mlvout2 mlotout2 mlfeed2 mlabo2 mlmach2 mlocapi2 lout12 out1_feed out1_lab out1_mach out1_ocap ///
		out2_feed out2_lab out2_mach out2_ocap feed_lab feed_mach feed_ocap lab_mach lab_ocap mach_ocap, distribution(tnormal) cm(age offwork north south time d2009 t2009)   
restore

*control for farms that exited/disappeared before 2009 and farms that entered in 2009 or 2010
frontier mland1 mlvout1 mlotout1 mlfeed1 mlabo1 mlmach1 mlocapi1 mlvout2 mlotout2 mlfeed2 mlabo2 mlmach2 mlocapi2 lout12 out1_feed out1_lab out1_mach out1_ocap ///
		out2_feed out2_lab out2_mach out2_ocap feed_lab feed_mach feed_ocap lab_mach lab_ocap mach_ocap dbef2009 daft2009, distribution(tnormal) cm(age offwork north south time d2009 t2009 dbef2009 daft2009)   



**with trend + year dummies for 2007-2010 
frontier mland1 mlvout1 mlotout1 mlfeed1 mlabo1 mlmach1 mlocapi1 mlvout2 mlotout2 mlfeed2 mlabo2 mlmach2 mlocapi2 lout12 out1_feed out1_lab out1_mach out1_ocap ///
		out2_feed out2_lab out2_mach out2_ocap feed_lab feed_mach feed_ocap lab_mach lab_ocap mach_ocap, distribution(tnormal) cm(age offwork north south time d2007 d2008 d2009 d2010)   


******************************************************************

gen time2 = time^2
gen ti_out1 = time * mlvout1
gen ti_out2 = time * mlotout1
gen ti_fee = time * mlfeed1
gen ti_lab = time * mlabo1
gen ti_mac = time * mlmach1
gen ti_ocap = time * mlocapi1

preserve
keep if year<2007
xtfrontier mland1 mlvout1 mlotout1 mlfeed1 mlabo1 mlmach1 mlocapi1 mlvout2 mlotout2 mlfeed2 mlabo2 mlmach2 mlocapi2 lout12 out1_feed out1_lab out1_mach out1_ocap out2_feed ///
out2_lab out2_mach out2_ocap feed_lab feed_mach feed_ocap lab_mach lab_ocap mach_ocap time time2 ti_out1 ti_out2 ti_fee ti_lab ti_mac ti_ocap, tvd cost
restore

	
