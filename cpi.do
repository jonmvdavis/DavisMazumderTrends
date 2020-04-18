* Define CPI scalars for each year 1966 to 2011
* http://download.bls.gov/pub/time.series/cu/cu.data.1.AllItems
* Annual Average of Monthly CPI Urban, All Items

/*
clear
import excel using ${data_dir79}cu.data.1.AllItems.xlsx, firstrow
keep if series_id=="CUSR0000SA0"
collapse value, by(year)
keep if year>=1965 
 replace value = round(value,0.001)
 tostring year value, replace force
 
gen label = "scalar cpi" + year+ " = " + value
list label , clean noobs
*/


    scalar cpi1965 = 31.528  
    scalar cpi1966 = 32.471  
    scalar cpi1967 = 33.375  
    scalar cpi1968 = 34.792  
    scalar cpi1969 = 36.683  
    scalar cpi1970 = 38.842  
    scalar cpi1971 = 40.483  
    scalar cpi1972 = 41.808  
    scalar cpi1973 = 44.425  
    scalar cpi1974 = 49.317  
    scalar cpi1975 = 53.825  
    scalar cpi1976 = 56.933  
    scalar cpi1977 = 60.617  
    scalar cpi1978 = 65.242  
    scalar cpi1979 = 72.583  
    scalar cpi1980 = 82.383  
    scalar cpi1981 = 90.933  
    scalar cpi1982 = 96.533  
    scalar cpi1983 = 99.583  
    scalar cpi1984 = 103.933  
    scalar cpi1985 = 107.6  
    scalar cpi1986 = 109.692  
    scalar cpi1987 = 113.617  
    scalar cpi1988 = 118.275  
    scalar cpi1989 = 123.942  
    scalar cpi1990 = 130.658  
    scalar cpi1991 = 136.167  
    scalar cpi1992 = 140.308  
    scalar cpi1993 = 144.475  
    scalar cpi1994 = 148.225  
    scalar cpi1995 = 152.383  
    scalar cpi1996 = 156.858  
    scalar cpi1997 = 160.525  
    scalar cpi1998 = 163.008  
    scalar cpi1999 = 166.583  
    scalar cpi2000 = 172.192  
    scalar cpi2001 = 177.042  
    scalar cpi2002 = 179.867  
    scalar cpi2003 = 184  
    scalar cpi2004 = 188.908  
    scalar cpi2005 = 195.267  
    scalar cpi2006 = 201.558  
    scalar cpi2007 = 207.344  
    scalar cpi2008 = 215.254  
    scalar cpi2009 = 214.565  
    scalar cpi2010 = 218.076  
    scalar cpi2011 = 224.923  
    scalar cpi2012 = 229.596  
    scalar cpi2013 = 232.964  
    scalar cpi2014 = 236.715  
    scalar cpi2015 = 236.995  
 



exit
