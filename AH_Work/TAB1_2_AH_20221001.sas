/*******************************************************************
* Client: AIRIS PHARMA Private Limited.                                                           
* Product:                                                   
* Project: Protocol 043-1810                                                  
* Program: tab1_1_AH_20221001.SAS  
*
* Program Type: Listing
*
* Purpose: To produce the Table 14.1.1 Subject Assignment to Analysis Populations
* Usage Notes: 
*
* SAS® Version: 9.4 [TS2M0]
* Operating System: Windows 11 Standard Edition.                   
*
* Author: Andrew Huang
* Date Created: Oct 01, 2022
*******************************************************************/

LIBNAME adam "E:\ROSHE30730\ADAM DATASETS";
LIBNAME sdtm "E:\ROSHE30730\SDTM DATASETS";

%include "E:\ROSHE\PROGRAMS\TABLE_POP.sas";
%include "E:\ROSHE\PROGRAMS\_RTFSTYLE_.sas";
%_RTFSTYLE_;

DATA TRT01PN_DATA_1;
SET adam.ADSL;
KEEP TRT01PN TRT01P;
IF TRT01PN NE .;
OUTPUT;
TRT01P = "Overall";
TRT01PN = 5;
OUTPUT;
RUN;

PROC SORT DATA = TRT01PN_DATA_1;
BY TRT01PN;
RUN;

DATA TRT01PN_DATA;
SET TRT01PN_DATA_1;
BY TRT01PN;
IF FIRST.TRT01PN;
RUN;

DATA ADSL_safety;
SET adam.ADSL;
RUN;


%TABLE_POP_1(V1=ADSL_safety, V2=FINAL_safety, V3=Safety Population, V4=1, V5=ADSL_safety);

DATA ADSL_DLT;
SET adam.ADSL;
IF DLTEVLFL = 'Y';
RUN;

%TABLE_POP_1(V1=ADSL_DLT, V2=FINAL_DLT, V3=DLT Evaluable Population, V4=2, V5=ADSL_safety);


PROC SQL;
CREATE TABLE Final_table AS
SELECT * FROM FINAL_safety
UNION
SELECT * FROM FINAL_DLT
;
QUIT;


PROC SQL NOPRINT;
CREATE TABLE TRT AS
SELECT TRT01PN, TRT01P, COUNT(DISTINCT USUBJID) AS DENOM FROM ADSL_safety
GROUP BY TRT01PN, TRT01P
ORDER BY TRT01PN, TRT01P;

SELECT DENOM INTO: n1 -:n5 FROM TRT;
QUIT;

%PUT &n1 &n2 &n3 &n4 &n5;

TITLE J=L "AIRIS PHARMA Private Limited.";
TITLE J=L "Protocol: 043-1810";
TITLE J=C "Table 14.1.2 Subject Assignment to Analysis Populations";

FOOTNOTE1 J=L "E:\ROSHE30730\PROGRAMS\TAB1_2_AH_20221001.sas";
OPTIONS ORIENTATION=LANDSCAPE;
ODS ESCAPECHAR='^';

ODS RTF FILE = "E:\ROSHE30730\OUTPUTS\14_1_2.rtf" STYLE=styles.test;

PROC REPORT DATA=Final_table NOWD MISSING
STYLE = {OUTPUTWIDTH=100%} SPLIT="|" SPACING=1 WRAP
STYLE (HEADER) = [JUST=LEFT];

COLUMN SQ POP STAT T1 T2 T3 T4 T5;

DEFINE SQ/ORDER NOPRINT;
DEFINE POP/DISPLAY "Population"
STYLE (HEADER) = [JUST=LEFT CELLWIDTH=10%]
STYLE (COLUMN) = [JUST=LEFT CELLWIDTH=10%];

DEFINE STAT/DISPLAY "Statistic"
STYLE (HEADER) = [JUST=LEFT CELLWIDTH=5%]
STYLE (COLUMN) = [JUST=LEFT CELLWIDTH=5%];

DEFINE T1/DISPLAY "DRUG A|(N = &n1)"
STYLE (HEADER) = [JUST=LEFT CELLWIDTH=5%]
STYLE (COLUMN) = [JUST=LEFT CELLWIDTH=5%];

DEFINE T2/DISPLAY "DRUG B|(N = &n2)"
STYLE (HEADER) = [JUST=LEFT CELLWIDTH=5%]
STYLE (COLUMN) = [JUST=LEFT CELLWIDTH=5%];

DEFINE T3/DISPLAY "DRUG C|(N = &n3)"
STYLE (HEADER) = [JUST=LEFT CELLWIDTH=5%]
STYLE (COLUMN) = [JUST=LEFT CELLWIDTH=5%];

DEFINE T4/DISPLAY "DRUG D|(N = &n4)"
STYLE (HEADER) = [JUST=LEFT CELLWIDTH=5%]
STYLE (COLUMN) = [JUST=LEFT CELLWIDTH=5%];

DEFINE T5/DISPLAY "ALL|(N = &n5)"
STYLE (HEADER) = [JUST=LEFT CELLWIDTH=5%]
STYLE (COLUMN) = [JUST=LEFT CELLWIDTH=5%];

COMPUTE BEFORE _PAGE_;
LINE@1 "^{STYLE [OUTPUTWIDTH=100% BORDERTOPCOLOR=BLACK BORDERTOPWIDTH=0.5pt]}";
ENDCOMP;

COMPUTE AFTER _PAGE_;
LINE@1 "^{STYLE [OUTPUTWIDTH=100% BORDERTOPCOLOR=BLACK BORDERTOPWIDTH=0.5pt]}";
ENDCOMP;

ODS _ALL_ CLOSE;
