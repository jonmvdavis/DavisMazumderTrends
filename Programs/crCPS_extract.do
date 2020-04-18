* NOTE: You need to set the Stata working directory to the path
* where the data file is located.


* YEAR , MONTH, and SERIAL, PERNUM uniquely identifies each person within IPUMS-CPS samples



* Create extract with birth year and and family income for moms and dads
* Re-do analysis at the child level
set more off

clear
quietly infix                   ///
  int     year         1-4      ///
  long    serial       5-9      ///
  byte    month        10-11    ///
  double  hwtfinl      12-21    ///
  double  cpsid        22-35    ///
  byte    asecflag     36-36    ///
  double  asecwth      37-46    ///
  double  marbasecidh  47-56    ///
  byte    asecoverh    57-57    ///
  double  hrhhid       58-72    ///
  long    hrhhid2      73-78    ///
  long    hseq         79-84    ///
  byte    pernum       85-86    ///
  double  wtfinl       87-100   ///
  double  cpsidp       101-114  ///
  double  asecwt       115-124  ///
  int     relate       125-128  ///
  byte    age          129-130  ///
  byte    sex          131-131  ///
  byte    momloc       132-133  ///
  byte    momloc2      134-135  ///
  byte    momrule      136-137  ///
  byte    mom2rule     138-139  ///
  byte    poploc       140-141  ///
  byte    poploc2      142-143  ///
  byte    poprule      144-145  ///
  byte    pop2rule     146-147  ///
  byte    famsize      148-149  ///
  byte    nchild       150-150  ///
  byte    nchlt5       151-151  ///
  byte    famunit      152-153  ///
  byte    eldch        154-155  ///
  byte    yngch        156-157  ///
  byte    nsibs        158-158  ///
  byte    aspouse      159-160  ///
  byte    pecohab      161-162  ///
  byte    pelnmom      163-164  ///
  byte    pelndad      165-166  ///
  byte    ftype        167-167  ///
  byte    famkind      168-168  ///
  byte    famrel       169-169  ///
  double  ftotval      170-179  ///
  double  inctot       180-187  ///
  long    incwage      188-194  ///
  using `"${data_dir}cps_00004.dat"'

replace hwtfinl     = hwtfinl     / 10000
replace asecwth     = asecwth     / 10000
replace wtfinl      = wtfinl      / 10000
replace asecwt      = asecwt      / 10000

format hwtfinl     %10.4f
format cpsid       %14.0g
format asecwth     %10.4f
format marbasecidh %10.0g
format hrhhid      %15.0g
format wtfinl      %14.4f
format cpsidp      %14.0g
format asecwt      %10.4f
format ftotval     %10.0g
format inctot      %8.0g

label var year        `"Survey year"'
label var serial      `"Household serial number"'
label var month       `"Month"'
label var hwtfinl     `"Household weight, Basic Monthly"'
label var cpsid       `"CPSID, household record"'
label var asecflag    `"Flag for ASEC"'
label var asecwth     `"Annual Social and Economic Supplement Household weight"'
label var marbasecidh `"Unique identifier for linking March Basic to ASEC"'
label var asecoverh   `"Identifier for ASEC oversample - Household"'
label var hrhhid      `"Household ID, part 1"'
label var hrhhid2     `"Household ID, part 2"'
label var hseq        `"Household sequence number"'
label var pernum      `"Person number in sample unit"'
label var wtfinl      `"Final Basic Weight"'
label var cpsidp      `"CPSID, person record"'
label var asecwt      `"Annual Social and Economic Supplement Weight"'
label var relate      `"Relationship to household head"'
label var age         `"Age"'
label var sex         `"Sex"'
label var momloc      `"Person number of first mother (from programming)"'
label var momloc2     `"Person number of second mother (from programming)"'
label var momrule     `"Rule for linking first mother"'
label var mom2rule    `"Rule for linking second mother"'
label var poploc      `"Person number of first father (from programming)"'
label var poploc2     `"Person number of second father (from programming)"'
label var poprule     `"Rule for linking first father"'
label var pop2rule    `"Rule for linking second father"'
label var famsize     `"Number of own family members in hh"'
label var nchild      `"Number of own children in household"'
label var nchlt5      `"Number of own children under age 5 in hh"'
label var famunit     `"Family unit membership"'
label var eldch       `"Age of eldest own child in household"'
label var yngch       `"Age of youngest own child in household"'
label var nsibs       `"Number of own siblings in household"'
label var aspouse     `"Spouse line number (self-reported)"'
label var pecohab     `"Cohabiting partner line number (self-reported)"'
label var pelnmom     `"Mother's line number (self-reported)"'
label var pelndad     `"Father's line number (self-reported)"'
label var ftype       `"Family Type"'
label var famkind     `"Kind of family"'
label var famrel      `"Relationship to family"'
label var ftotval     `"Total family income"'
label var inctot      `"Total personal income"'
label var incwage     `"Wage and salary income"'

label define month_lbl 01 `"January"'
label define month_lbl 02 `"February"', add
label define month_lbl 03 `"March"', add
label define month_lbl 04 `"April"', add
label define month_lbl 05 `"May"', add
label define month_lbl 06 `"June"', add
label define month_lbl 07 `"July"', add
label define month_lbl 08 `"August"', add
label define month_lbl 09 `"September"', add
label define month_lbl 10 `"October"', add
label define month_lbl 11 `"November"', add
label define month_lbl 12 `"December"', add
label values month month_lbl

label define asecflag_lbl 1 `"ASEC"'
label define asecflag_lbl 2 `"March Basic"', add
label values asecflag asecflag_lbl

label define asecoverh_lbl 0 `"March Basic Sample"'
label define asecoverh_lbl 1 `"ASEC Oversample"', add
label values asecoverh asecoverh_lbl

label define relate_lbl 0101 `"Head/householder"'
label define relate_lbl 0201 `"Spouse"', add
label define relate_lbl 0202 `"Opposite sex spouse"', add
label define relate_lbl 0203 `"Same sex spouse"', add
label define relate_lbl 0301 `"Child"', add
label define relate_lbl 0303 `"Stepchild"', add
label define relate_lbl 0501 `"Parent"', add
label define relate_lbl 0701 `"Sibling"', add
label define relate_lbl 0901 `"Grandchild"', add
label define relate_lbl 1001 `"Other relatives, n.s."', add
label define relate_lbl 1113 `"Partner/roommate"', add
label define relate_lbl 1114 `"Unmarried partner"', add
label define relate_lbl 1116 `"Opposite sex unmarried partner"', add
label define relate_lbl 1117 `"Same sex unmaried partner"', add
label define relate_lbl 1115 `"Housemate/roomate"', add
label define relate_lbl 1241 `"Roomer/boarder/lodger"', add
label define relate_lbl 1242 `"Foster children"', add
label define relate_lbl 1260 `"Other nonrelatives"', add
label define relate_lbl 9100 `"Armed Forces, relationship unknown"', add
label define relate_lbl 9200 `"Age under 14, relationship unknown"', add
label define relate_lbl 9900 `"Relationship unknown"', add
label define relate_lbl 9999 `"NIU"', add
label values relate relate_lbl

label define age_lbl 00 `"Under 1 year"'
label define age_lbl 01 `"1"', add
label define age_lbl 02 `"2"', add
label define age_lbl 03 `"3"', add
label define age_lbl 04 `"4"', add
label define age_lbl 05 `"5"', add
label define age_lbl 06 `"6"', add
label define age_lbl 07 `"7"', add
label define age_lbl 08 `"8"', add
label define age_lbl 09 `"9"', add
label define age_lbl 10 `"10"', add
label define age_lbl 11 `"11"', add
label define age_lbl 12 `"12"', add
label define age_lbl 13 `"13"', add
label define age_lbl 14 `"14"', add
label define age_lbl 15 `"15"', add
label define age_lbl 16 `"16"', add
label define age_lbl 17 `"17"', add
label define age_lbl 18 `"18"', add
label define age_lbl 19 `"19"', add
label define age_lbl 20 `"20"', add
label define age_lbl 21 `"21"', add
label define age_lbl 22 `"22"', add
label define age_lbl 23 `"23"', add
label define age_lbl 24 `"24"', add
label define age_lbl 25 `"25"', add
label define age_lbl 26 `"26"', add
label define age_lbl 27 `"27"', add
label define age_lbl 28 `"28"', add
label define age_lbl 29 `"29"', add
label define age_lbl 30 `"30"', add
label define age_lbl 31 `"31"', add
label define age_lbl 32 `"32"', add
label define age_lbl 33 `"33"', add
label define age_lbl 34 `"34"', add
label define age_lbl 35 `"35"', add
label define age_lbl 36 `"36"', add
label define age_lbl 37 `"37"', add
label define age_lbl 38 `"38"', add
label define age_lbl 39 `"39"', add
label define age_lbl 40 `"40"', add
label define age_lbl 41 `"41"', add
label define age_lbl 42 `"42"', add
label define age_lbl 43 `"43"', add
label define age_lbl 44 `"44"', add
label define age_lbl 45 `"45"', add
label define age_lbl 46 `"46"', add
label define age_lbl 47 `"47"', add
label define age_lbl 48 `"48"', add
label define age_lbl 49 `"49"', add
label define age_lbl 50 `"50"', add
label define age_lbl 51 `"51"', add
label define age_lbl 52 `"52"', add
label define age_lbl 53 `"53"', add
label define age_lbl 54 `"54"', add
label define age_lbl 55 `"55"', add
label define age_lbl 56 `"56"', add
label define age_lbl 57 `"57"', add
label define age_lbl 58 `"58"', add
label define age_lbl 59 `"59"', add
label define age_lbl 60 `"60"', add
label define age_lbl 61 `"61"', add
label define age_lbl 62 `"62"', add
label define age_lbl 63 `"63"', add
label define age_lbl 64 `"64"', add
label define age_lbl 65 `"65"', add
label define age_lbl 66 `"66"', add
label define age_lbl 67 `"67"', add
label define age_lbl 68 `"68"', add
label define age_lbl 69 `"69"', add
label define age_lbl 70 `"70"', add
label define age_lbl 71 `"71"', add
label define age_lbl 72 `"72"', add
label define age_lbl 73 `"73"', add
label define age_lbl 74 `"74"', add
label define age_lbl 75 `"75"', add
label define age_lbl 76 `"76"', add
label define age_lbl 77 `"77"', add
label define age_lbl 78 `"78"', add
label define age_lbl 79 `"79"', add
label define age_lbl 80 `"80"', add
label define age_lbl 81 `"81"', add
label define age_lbl 82 `"82"', add
label define age_lbl 83 `"83"', add
label define age_lbl 84 `"84"', add
label define age_lbl 85 `"85"', add
label define age_lbl 86 `"86"', add
label define age_lbl 87 `"87"', add
label define age_lbl 88 `"88"', add
label define age_lbl 89 `"89"', add
label define age_lbl 90 `"90 (90+, 1988-2002)"', add
label define age_lbl 91 `"91"', add
label define age_lbl 92 `"92"', add
label define age_lbl 93 `"93"', add
label define age_lbl 94 `"94"', add
label define age_lbl 95 `"95"', add
label define age_lbl 96 `"96"', add
label define age_lbl 97 `"97"', add
label define age_lbl 98 `"98"', add
label define age_lbl 99 `"99+"', add
label values age age_lbl

label define sex_lbl 1 `"Male"'
label define sex_lbl 2 `"Female"', add
label define sex_lbl 9 `"NIU"', add
label values sex sex_lbl

label define momrule_lbl 00 `"No mother link"'
label define momrule_lbl 01 `"Unambiguous mother link"', add
label define momrule_lbl 02 `"Daughter/granchild link"', add
label define momrule_lbl 03 `"Preceding male (no intervening person)"', add
label define momrule_lbl 07 `"Spouse of father becomes stepmother"', add
label values momrule momrule_lbl

label define mom2rule_lbl 00 `"No mother link"'
label define mom2rule_lbl 01 `"Unambiguous mother link"', add
label define mom2rule_lbl 02 `"Daughter/granchild link"', add
label define mom2rule_lbl 03 `"Preceding male (no intervening person)"', add
label define mom2rule_lbl 07 `"Spouse of father becomes stepmother"', add
label values mom2rule mom2rule_lbl

label define poprule_lbl 00 `"No father link"'
label define poprule_lbl 01 `"Unambiguous father link"', add
label define poprule_lbl 02 `"Son/granchild link"', add
label define poprule_lbl 03 `"Preceding male (no intervening person)"', add
label define poprule_lbl 07 `"Husband of mother becomes stepfather"', add
label values poprule poprule_lbl

label define pop2rule_lbl 00 `"No father link"'
label define pop2rule_lbl 01 `"Unambiguous father link"', add
label define pop2rule_lbl 02 `"Son/granchild link"', add
label define pop2rule_lbl 03 `"Preceding male (no intervening person)"', add
label define pop2rule_lbl 07 `"Husband of mother becomes stepfather"', add
label values pop2rule pop2rule_lbl

label define famsize_lbl 00 `"Missing"'
label define famsize_lbl 01 `"1 family member present"', add
label define famsize_lbl 02 `"2 family members present"', add
label define famsize_lbl 03 `"3 family members present"', add
label define famsize_lbl 04 `"4 family members present"', add
label define famsize_lbl 05 `"5 family members present"', add
label define famsize_lbl 06 `"6 family members present"', add
label define famsize_lbl 07 `"7 family members present"', add
label define famsize_lbl 08 `"8 family members present"', add
label define famsize_lbl 09 `"9 family members present"', add
label define famsize_lbl 10 `"10 family members present"', add
label define famsize_lbl 11 `"11 family members present"', add
label define famsize_lbl 12 `"12 family members present"', add
label define famsize_lbl 13 `"13 family members present"', add
label define famsize_lbl 14 `"14 family members present"', add
label define famsize_lbl 15 `"15 family members present"', add
label define famsize_lbl 16 `"16 family members present"', add
label define famsize_lbl 17 `"17 family members present"', add
label define famsize_lbl 18 `"18 family members present"', add
label define famsize_lbl 19 `"19 family members present"', add
label define famsize_lbl 20 `"20 family members present"', add
label define famsize_lbl 21 `"21 family members present"', add
label define famsize_lbl 22 `"22 family members present"', add
label define famsize_lbl 23 `"23 family members present"', add
label define famsize_lbl 24 `"24 family members present"', add
label define famsize_lbl 25 `"25 family members present"', add
label define famsize_lbl 26 `"26 family members present"', add
label define famsize_lbl 27 `"27 family members present"', add
label define famsize_lbl 28 `"28 family members present"', add
label define famsize_lbl 29 `"29 family members present"', add
label values famsize famsize_lbl

label define nchild_lbl 0 `"0 children present"'
label define nchild_lbl 1 `"1 child present"', add
label define nchild_lbl 2 `"2"', add
label define nchild_lbl 3 `"3"', add
label define nchild_lbl 4 `"4"', add
label define nchild_lbl 5 `"5"', add
label define nchild_lbl 6 `"6"', add
label define nchild_lbl 7 `"7"', add
label define nchild_lbl 8 `"8"', add
label define nchild_lbl 9 `"9+"', add
label values nchild nchild_lbl

label define nchlt5_lbl 0 `"No children under age 5"'
label define nchlt5_lbl 1 `"1 child under age 5"', add
label define nchlt5_lbl 2 `"2"', add
label define nchlt5_lbl 3 `"3"', add
label define nchlt5_lbl 4 `"4"', add
label define nchlt5_lbl 5 `"5"', add
label define nchlt5_lbl 6 `"6"', add
label define nchlt5_lbl 7 `"7"', add
label define nchlt5_lbl 8 `"8"', add
label define nchlt5_lbl 9 `"9+"', add
label values nchlt5 nchlt5_lbl

label define famunit_lbl 01 `"1st family in household or group quarters"'
label define famunit_lbl 02 `"2nd family in household or group quarters"', add
label define famunit_lbl 03 `"3rd"', add
label define famunit_lbl 04 `"4th"', add
label define famunit_lbl 05 `"5th"', add
label define famunit_lbl 06 `"6th"', add
label define famunit_lbl 07 `"7th"', add
label define famunit_lbl 08 `"8th"', add
label define famunit_lbl 09 `"9th"', add
label define famunit_lbl 10 `"10"', add
label define famunit_lbl 11 `"11"', add
label define famunit_lbl 12 `"12"', add
label define famunit_lbl 13 `"13"', add
label define famunit_lbl 14 `"14"', add
label define famunit_lbl 15 `"15"', add
label define famunit_lbl 16 `"16"', add
label define famunit_lbl 17 `"17"', add
label define famunit_lbl 18 `"18"', add
label define famunit_lbl 19 `"19"', add
label define famunit_lbl 20 `"20"', add
label define famunit_lbl 21 `"21"', add
label define famunit_lbl 22 `"22"', add
label define famunit_lbl 23 `"23"', add
label define famunit_lbl 24 `"24"', add
label define famunit_lbl 25 `"25"', add
label define famunit_lbl 26 `"26"', add
label define famunit_lbl 27 `"27"', add
label define famunit_lbl 28 `"28"', add
label define famunit_lbl 29 `"29"', add
label values famunit famunit_lbl

label define eldch_lbl 00 `"Less than 1 year old"'
label define eldch_lbl 01 `"1"', add
label define eldch_lbl 02 `"2"', add
label define eldch_lbl 03 `"3"', add
label define eldch_lbl 04 `"4"', add
label define eldch_lbl 05 `"5"', add
label define eldch_lbl 06 `"6"', add
label define eldch_lbl 07 `"7"', add
label define eldch_lbl 08 `"8"', add
label define eldch_lbl 09 `"9"', add
label define eldch_lbl 10 `"10"', add
label define eldch_lbl 11 `"11"', add
label define eldch_lbl 12 `"12"', add
label define eldch_lbl 13 `"13"', add
label define eldch_lbl 14 `"14"', add
label define eldch_lbl 15 `"15"', add
label define eldch_lbl 16 `"16"', add
label define eldch_lbl 17 `"17"', add
label define eldch_lbl 18 `"18"', add
label define eldch_lbl 19 `"19"', add
label define eldch_lbl 20 `"20"', add
label define eldch_lbl 21 `"21"', add
label define eldch_lbl 22 `"22"', add
label define eldch_lbl 23 `"23"', add
label define eldch_lbl 24 `"24"', add
label define eldch_lbl 25 `"25"', add
label define eldch_lbl 26 `"26"', add
label define eldch_lbl 27 `"27"', add
label define eldch_lbl 28 `"28"', add
label define eldch_lbl 29 `"29"', add
label define eldch_lbl 30 `"30"', add
label define eldch_lbl 31 `"31"', add
label define eldch_lbl 32 `"32"', add
label define eldch_lbl 33 `"33"', add
label define eldch_lbl 34 `"34"', add
label define eldch_lbl 35 `"35"', add
label define eldch_lbl 36 `"36"', add
label define eldch_lbl 37 `"37"', add
label define eldch_lbl 38 `"38"', add
label define eldch_lbl 39 `"39"', add
label define eldch_lbl 40 `"40"', add
label define eldch_lbl 41 `"41"', add
label define eldch_lbl 42 `"42"', add
label define eldch_lbl 43 `"43"', add
label define eldch_lbl 44 `"44"', add
label define eldch_lbl 45 `"45"', add
label define eldch_lbl 46 `"46"', add
label define eldch_lbl 47 `"47"', add
label define eldch_lbl 48 `"48"', add
label define eldch_lbl 49 `"49"', add
label define eldch_lbl 50 `"50"', add
label define eldch_lbl 51 `"51"', add
label define eldch_lbl 52 `"52"', add
label define eldch_lbl 53 `"53"', add
label define eldch_lbl 54 `"54"', add
label define eldch_lbl 55 `"55"', add
label define eldch_lbl 56 `"56"', add
label define eldch_lbl 57 `"57"', add
label define eldch_lbl 58 `"58"', add
label define eldch_lbl 59 `"59"', add
label define eldch_lbl 60 `"60"', add
label define eldch_lbl 61 `"61"', add
label define eldch_lbl 62 `"62"', add
label define eldch_lbl 63 `"63"', add
label define eldch_lbl 64 `"64"', add
label define eldch_lbl 65 `"65"', add
label define eldch_lbl 66 `"66"', add
label define eldch_lbl 67 `"67"', add
label define eldch_lbl 68 `"68"', add
label define eldch_lbl 69 `"69"', add
label define eldch_lbl 70 `"70"', add
label define eldch_lbl 71 `"71"', add
label define eldch_lbl 72 `"72"', add
label define eldch_lbl 73 `"73"', add
label define eldch_lbl 74 `"74"', add
label define eldch_lbl 75 `"75"', add
label define eldch_lbl 76 `"76"', add
label define eldch_lbl 77 `"77"', add
label define eldch_lbl 78 `"78"', add
label define eldch_lbl 79 `"79"', add
label define eldch_lbl 80 `"80"', add
label define eldch_lbl 81 `"81"', add
label define eldch_lbl 82 `"82"', add
label define eldch_lbl 83 `"83"', add
label define eldch_lbl 84 `"84"', add
label define eldch_lbl 85 `"85"', add
label define eldch_lbl 86 `"86"', add
label define eldch_lbl 87 `"87"', add
label define eldch_lbl 88 `"88"', add
label define eldch_lbl 89 `"89"', add
label define eldch_lbl 90 `"90"', add
label define eldch_lbl 91 `"91"', add
label define eldch_lbl 92 `"92"', add
label define eldch_lbl 93 `"93"', add
label define eldch_lbl 94 `"94"', add
label define eldch_lbl 95 `"95"', add
label define eldch_lbl 96 `"96"', add
label define eldch_lbl 97 `"97"', add
label define eldch_lbl 98 `"98"', add
label define eldch_lbl 99 `"NIU"', add
label values eldch eldch_lbl

label define yngch_lbl 00 `"Less than 1 year old"'
label define yngch_lbl 01 `"1"', add
label define yngch_lbl 02 `"2"', add
label define yngch_lbl 03 `"3"', add
label define yngch_lbl 04 `"4"', add
label define yngch_lbl 05 `"5"', add
label define yngch_lbl 06 `"6"', add
label define yngch_lbl 07 `"7"', add
label define yngch_lbl 08 `"8"', add
label define yngch_lbl 09 `"9"', add
label define yngch_lbl 10 `"10"', add
label define yngch_lbl 11 `"11"', add
label define yngch_lbl 12 `"12"', add
label define yngch_lbl 13 `"13"', add
label define yngch_lbl 14 `"14"', add
label define yngch_lbl 15 `"15"', add
label define yngch_lbl 16 `"16"', add
label define yngch_lbl 17 `"17"', add
label define yngch_lbl 18 `"18"', add
label define yngch_lbl 19 `"19"', add
label define yngch_lbl 20 `"20"', add
label define yngch_lbl 21 `"21"', add
label define yngch_lbl 22 `"22"', add
label define yngch_lbl 23 `"23"', add
label define yngch_lbl 24 `"24"', add
label define yngch_lbl 25 `"25"', add
label define yngch_lbl 26 `"26"', add
label define yngch_lbl 27 `"27"', add
label define yngch_lbl 28 `"28"', add
label define yngch_lbl 29 `"29"', add
label define yngch_lbl 30 `"30"', add
label define yngch_lbl 31 `"31"', add
label define yngch_lbl 32 `"32"', add
label define yngch_lbl 33 `"33"', add
label define yngch_lbl 34 `"34"', add
label define yngch_lbl 35 `"35"', add
label define yngch_lbl 36 `"36"', add
label define yngch_lbl 37 `"37"', add
label define yngch_lbl 38 `"38"', add
label define yngch_lbl 39 `"39"', add
label define yngch_lbl 40 `"40"', add
label define yngch_lbl 41 `"41"', add
label define yngch_lbl 42 `"42"', add
label define yngch_lbl 43 `"43"', add
label define yngch_lbl 44 `"44"', add
label define yngch_lbl 45 `"45"', add
label define yngch_lbl 46 `"46"', add
label define yngch_lbl 47 `"47"', add
label define yngch_lbl 48 `"48"', add
label define yngch_lbl 49 `"49"', add
label define yngch_lbl 50 `"50"', add
label define yngch_lbl 51 `"51"', add
label define yngch_lbl 52 `"52"', add
label define yngch_lbl 53 `"53"', add
label define yngch_lbl 54 `"54"', add
label define yngch_lbl 55 `"55"', add
label define yngch_lbl 56 `"56"', add
label define yngch_lbl 57 `"57"', add
label define yngch_lbl 58 `"58"', add
label define yngch_lbl 59 `"59"', add
label define yngch_lbl 60 `"60"', add
label define yngch_lbl 61 `"61"', add
label define yngch_lbl 62 `"62"', add
label define yngch_lbl 63 `"63"', add
label define yngch_lbl 64 `"64"', add
label define yngch_lbl 65 `"65"', add
label define yngch_lbl 66 `"66"', add
label define yngch_lbl 67 `"67"', add
label define yngch_lbl 68 `"68"', add
label define yngch_lbl 69 `"69"', add
label define yngch_lbl 70 `"70"', add
label define yngch_lbl 71 `"71"', add
label define yngch_lbl 72 `"72"', add
label define yngch_lbl 73 `"73"', add
label define yngch_lbl 74 `"74"', add
label define yngch_lbl 75 `"75"', add
label define yngch_lbl 76 `"76"', add
label define yngch_lbl 77 `"77"', add
label define yngch_lbl 78 `"78"', add
label define yngch_lbl 79 `"79"', add
label define yngch_lbl 80 `"80"', add
label define yngch_lbl 81 `"81"', add
label define yngch_lbl 82 `"82"', add
label define yngch_lbl 83 `"83"', add
label define yngch_lbl 84 `"84"', add
label define yngch_lbl 85 `"85"', add
label define yngch_lbl 86 `"86"', add
label define yngch_lbl 87 `"87"', add
label define yngch_lbl 88 `"88"', add
label define yngch_lbl 89 `"89"', add
label define yngch_lbl 90 `"90"', add
label define yngch_lbl 91 `"91"', add
label define yngch_lbl 92 `"92"', add
label define yngch_lbl 93 `"93"', add
label define yngch_lbl 94 `"94"', add
label define yngch_lbl 95 `"95"', add
label define yngch_lbl 96 `"96"', add
label define yngch_lbl 97 `"97"', add
label define yngch_lbl 98 `"98"', add
label define yngch_lbl 99 `"NIU"', add
label values yngch yngch_lbl

label define nsibs_lbl 0 `"0 Siblings"'
label define nsibs_lbl 1 `"1 Sibling"', add
label define nsibs_lbl 2 `"2 Siblings"', add
label define nsibs_lbl 3 `"3 Siblings"', add
label define nsibs_lbl 4 `"4 Siblings"', add
label define nsibs_lbl 5 `"5 Siblings"', add
label define nsibs_lbl 6 `"6 Siblings"', add
label define nsibs_lbl 7 `"7 Siblings"', add
label define nsibs_lbl 8 `"8 Siblings"', add
label define nsibs_lbl 9 `"9 or more Siblings"', add
label values nsibs nsibs_lbl

label define ftype_lbl 1 `"Primary family"'
label define ftype_lbl 2 `"Nonfamily householder"', add
label define ftype_lbl 3 `"Related subfamily"', add
label define ftype_lbl 4 `"Unrelated subfamily"', add
label define ftype_lbl 5 `"Secondary individual"', add
label define ftype_lbl 9 `"Missing"', add
label values ftype ftype_lbl

label define famkind_lbl 1 `"Husband/wife family"'
label define famkind_lbl 2 `"Male reference person"', add
label define famkind_lbl 3 `"Female reference person"', add
label values famkind famkind_lbl

label define famrel_lbl 0 `"Not a family member"'
label define famrel_lbl 1 `"Reference person"', add
label define famrel_lbl 2 `"Spouse"', add
label define famrel_lbl 3 `"Child"', add
label define famrel_lbl 4 `"Other relative (primary family only)"', add
label define famrel_lbl 9 `"Missing"', add
label values famrel famrel_lbl


* Generate Birth Year and Identify NLS Cohorts *
gen byear = year-age
gen nls66_cohort = 0
 replace nls66_cohort = 1 if (byear>=1948 & byear<=1952) & sex==2
 replace nls66_cohort = 1 if  (byear>=1949 & byear<=1953) & sex==1 
gen nlsy79_cohort = 0
 replace nlsy79_cohort = 1 if (byear>=1961 & byear<=1964) 


bys year serial famunit: egen n_nls66 = sum(nls66_cohort)
bys year serial famunit: egen n_nlsy79 = sum(nlsy79_cohort)
bys year serial famunit: egen fseq=seq()


replace ftotval = . if ftotval==999999
 forv y=1965/2000 {
 replace ftotval = ftotval * cpi2015/cpi`y' if year==`y'
} 



* Limit to March CPS Sample *
keep if month==3
keep if (n_nls66>0 | n_nlsy79>0)
 

keep if year==1966 | year==1968 | year==1970 | year==1978 ///
	| year==1979 | year==1980 | year==1977 | year==1979 | year==1980 ///
	| year==1990 | year==1991 | year==1992 | year==1993 | year==1994 ///
    | year==2001 | year==2003 | year==2005


keep if (fseq==1 & (year==1966 | year==1968 | year==1970) & n_nls66>0) | ///
	(fseq==1 & (year==1978 | year==1979 | year==1980) & n_nlsy79>0) | ///
	(nls66_cohort==1 & (year==1990 | year==1992 |year==1994) & sex==2) | ///
	(nls66_cohort==1 & (year==1977 | year==1979 |year==1980) & sex==1) | ///
	(nlsy79_cohort==1 & (year==2001 | year==2003 |year==2005) & sex==2) | ///
	(nlsy79_cohort==1 & (year==1990 | year==1991 |year==1993) & sex==1)
	
gen parent = (fseq==1 & (year==1966 | year==1968 | year==1970) & n_nls66>0) | ///
	(fseq==1 & (year==1978 | year==1979 | year==1980) & n_nlsy79>0) 

gen kid = (nls66_cohort==1 & (year==1990 | year==1992 |year==1994) & sex==2) | ///
	(nls66_cohort==1 & (year==1977 | year==1979 |year==1980) & sex==1) | ///
	(nlsy79_cohort==1 & (year==2001 | year==2003 |year==2005) & sex==2) | ///
	(nlsy79_cohort==1 & (year==1990 | year==1991 |year==1993) & sex==1)
	
gen survey = 1966 if (fseq==1 & (year==1966 | year==1968 | year==1970) & n_nls66>0)
 replace survey = 1979 if (fseq==1 & (year==1978 | year==1979 | year==1980) & n_nlsy79>0)
 replace survey = 1966 if (nls66_cohort==1 & (year==1990 | year==1992 |year==1994) & sex==2) | ///
	(nls66_cohort==1 & (year==1977 | year==1979 |year==1980) & sex==1) 
 replace survey = 1979 if (nlsy79_cohort==1 & (year==2001 | year==2003 |year==2005) & sex==2) | ///
	(nlsy79_cohort==1 & (year==1990 | year==1991 |year==1993) & sex==1)
	

gen wt_adj66 = asecwth
 replace wt_adj66 =  asecwth*n_nls66 if parent==1 & survey==1966
gen wt_adj79 = asecwth 
 replace wt_adj79 = asecwth*n_nlsy79 if parent==1 & survey==1979

save ${data_dir}march_cps.dta, replace

exit
