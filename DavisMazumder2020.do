*****************
* Preliminaries *
*****************

clear all
set more off
set matsize 11000
capture log close


/* Directories */
cd "/projectDirectory/"
global program_dir "Programs/Public/"
global data_dir "Data/"
global results_dir "Results/Public/"
                   
 
* Required packages
* ssc install binscatter
* ssc install estout 
* net install grc1leg 
* ssc install _gwtmean



 

* Tables *
do "${program_dir}table1.do" /* Also appendix Table A1 */
do "${program_dir}table2.do" /* Also appendix Figure A4 */
do "${program_dir}table3.do" 
do "${program_dir}table4.do" 
do "${program_dir}table5.do" 
do "${program_dir}table6.do" 
do "${program_dir}table7.do"
do "${program_dir}table8.do"
do "${program_dir}table9.do"

* Figures using NLS data (+ some CPS data)*
do "${program_dir}figure3.do"
qui do "${program_dir}cpi.do"
do "${program_dir}crCPS_extract.do" /* Create extract of CPS March data for comparison of income distributions in next program. */
do "${program_dir}figure4.do" /* Also appendix Figures A6, A7, and A8. This program uses CPS March data not included. Can be downlaoded here: https://data.nber.org/data/current-population-survey-data.html */


* Appendix Tables
do "${program_dir}tableA2.do"
do "${program_dir}tableA3_A4.do"

* Appendix Figures
do "${program_dir}figureA1.do"
do "${program_dir}figureA2.do"
do "${program_dir}figureA3.do"
do "${program_dir}figureA4.do"
do "${program_dir}figureA9.do"

exit	
