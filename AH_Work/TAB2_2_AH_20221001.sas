/*******************************************************************
* Client: AIRIS PHARMA Private Limited.                                                           
* Product:                                                   
* Project: Protocol 043-1810                                                  
* Program: tab2_1_AH_20221001.SAS  
*
* Program Type: Listing
*
* Purpose: To produce the Table 14.1.4  Subject Disposition by Treatment (Safety Population)
* Usage Notes: 
*
* SAS� Version: 9.4 [TS2M0]
* Operating System: Windows 11 Standard Edition.                   
*
* Author: Andrew Huang
* Date Created: Oct 01, 2022
*******************************************************************/

LIBNAME adam "E:\ROSHE30730\ADAM DATASETS";
LIBNAME sdtm "E:\ROSHE30730\SDTM DATASETS";

%include "E:\ROSHE\PROGRAMS\_RTFSTYLE_.sas";
%_RTFSTYLE_;

DATA ADSL;
SET adam.ADSL;
IF DLTEVLFL="Y";
OUTPUT;
TRT01P="Overall";
TRT01PN=5;
OUTPUT;

KEEP USUBJID TRT01P TRT01PN SAFFL DLTEVLFL ENRLFL DCSREAS;
RUN;

DATA DUMMY;
DO TRT01PN=1 TO 5;
OUTPUT;
END;
RUN;

PROC SORT DATA=ADSL;
BY TRT01PN;
RUN;

PROC SORT DATA=DUMMY;
BY TRT01PN;
RUN;

DATA ADSL_DUMM;
MERGE DUMMY ADSL;
BY TRT01PN;
RUN;

PROC SQL NOPRINT;
CREATE TABLE TRT AS
SELECT TRT01PN, TRT01P, COUNT(DISTINCT USUBJID) AS DENOM FROM ADSL_DUMM
GROUP BY TRT01PN, TRT01P
ORDER BY TRT01PN, TRT01P;

SELECT DENOM INTO: n1 - :n5 FROM TRT;
QUIT;
%PUT &n1 &n2 &n3 &n4 &n5;

PROC SQL NOPRINT;
CREATE TABLE PLAN AS
SELECT TRT01PN, COUNT(DISTINCT USUBJID) AS NN,
"Subjects Planned" AS POP LENGTH=100, 1 AS NUMB FROM ADSL_DUMM
WHERE TRT01P ^=" "
GROUP BY TRT01PN
ORDER BY TRT01PN;

CREATE TABLE ENRL AS
SELECT TRT01PN, COUNT(DISTINCT USUBJID) AS NN,
"Subjects Enrolled" AS POP LENGTH=100, 2 AS NUMB FROM ADSL_DUMM
WHERE ENRLFL = "Y"
GROUP BY TRT01PN
ORDER BY TRT01PN;

CREATE TABLE WTH AS
SELECT TRT01PN, COUNT(DISTINCT USUBJID) AS NN,
"Subjects Withdrawn" AS POP LENGTH=100, 3 AS NUMB FROM ADSL_DUMM
WHERE DCSREAS ^= " "
GROUP BY TRT01PN
ORDER BY TRT01PN;

QUIT;

PROC SQL;
CREATE TABLE ANY4 AS
SELECT TRT01PN, DCSREAS AS POP LENGTH=100, 
	COUNT(DISTINCT USUBJID) AS NN, 4 AS NUMB FROM ADSL_DUMM
WHERE DCSREAS ^=''
GROUP BY TRT01PN, DCSREAS
ORDER BY TRT01PN, DCSREAS;

QUIT;

DATA FINAL;
SET PLAN ENRL WTH ANY4;
RUN;

PROC SORT DATA = FINAL;
BY POP TRT01PN;
RUN;

DATA FINAL1;
SET FINAL;
LENGTH GRPA_1 $20.;

IF TRT01PN=1 THEN DO;
IF NN=. OR NN=0 THEN GRPA_1="0";
ELSE IF NN=&n1 THEN GRPA_1=PUT(NN,3.)||" (100)";
ELSE GRPA_1=PUT(NN,3.)||" ("||PUT(NN/&n1*100,4.1)||")";
END;

IF TRT01PN=2 THEN DO;
IF NN=. OR NN=0 THEN GRPA_1="0";
ELSE IF NN=&n2 THEN GRPA_1=PUT(NN,3.)||" (100)";
ELSE GRPA_1=PUT(NN,3.)||" ("||PUT(NN/&n2*100,4.1)||")";
END;

IF TRT01PN=3 THEN DO;
IF NN=. OR NN=0 THEN GRPA_1="0";
ELSE IF NN=&n3 THEN GRPA_1=PUT(NN,3.)||" (100)";
ELSE GRPA_1=PUT(NN,3.)||" ("||PUT(NN/&n3*100,4.1)||")";
END;

IF TRT01PN=4 THEN DO;
IF NN=. OR NN=0 THEN GRPA_1="0";
ELSE IF NN=&n4 THEN GRPA_1=PUT(NN,3.)||" (100)";
ELSE GRPA_1=PUT(NN,3.)||" ("||PUT(NN/&n4*100,4.1)||")";
END;

IF TRT01PN=5 THEN DO;
IF NN=. OR NN=0 THEN GRPA_1="0";
ELSE IF NN=&n5 THEN GRPA_1=PUT(NN,3.)||" (100)";
ELSE GRPA_1=PUT(NN,3.)||" ("||PUT(NN/&n5*100,4.1)||")";
END;

RUN;

PROC SORT DATA=FINAL1;
BY NUMB POP;
RUN;

PROC TRANSPOSE DATA=FINAL1 OUT=ALL_ PREFIX=T;
BY NUMB POP;
ID TRT01PN;
VAR GRPA_1;
RUN;

PROC SORT DATA=ALL_ OUT=ALL_2 (KEEP=NUMB) NODUPKEY;
BY NUMB;
RUN;

DATA DUMMY2;
SET ALL_2 (KEEP=NUMB);
LENGTH T1 T2 T3 T4 T5 $20.;
T1='  0';
T2='  0';
T3='  0';
T4='  0';
T5='  0';
RUN;

DATA FIN;
MERGE DUMMY2 ALL_;
BY NUMB;
RUN;

DATA FIN;
SET FIN;
IF T1='' THEN T1='  0';
IF T2='' THEN T2='  0';
IF T3='' THEN T3='  0';
IF T4='' THEN T4='  0';
IF T5='' THEN T5='  0';
RUN;

TITLE1 J=L "AIRIS PHARMA Private Limited.";
TITLE2 J=L "Protocol: 043-1810";
TITLE3 J=C "Table 14.1.4  Subject Disposition by Treatment (DLT Evaluable Population)";

FOOTNOTE1 J=L "E:\ROSHE30730\PROGRAMS\TAB2_2_AH_20221001.sas";
OPTIONS ORIENTATION=LANDSCAPE;
ODS ESCAPECHAR='^';

ODS RTF FILE ="E:\ROSHE30730\OUTPUTS\14_1_4.rtf" STYLE=styles.test;

PROC REPORT DATA=FIN NOWD MISSING
STYLE = {OUTPUTWIDTH=100%} SPLIT="|" SPACING=1 WRAP
STYLE (HEADER) =[JUST=LEFT];
COLUMN NUMB POP T1 T2 T3 T4 T5;

DEFINE NUMB/ORDER NOPRINT;
DEFINE POP/DISPLAY "CATEGORY"
STYLE (HEADER) =[JUST=LEFT CELLWIDTH=10%]
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=10%];

DEFINE T1/DISPLAY "DRUG A|(N = &n1)"
STYLE (HEADER) =[JUST=LEFT CELLWIDTH=5%]
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=5%];

DEFINE T2/DISPLAY "DRUG B|(N = &n2)"
STYLE (HEADER) =[JUST=LEFT CELLWIDTH=5%]
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=5%];

DEFINE T3/DISPLAY "DRUG C|(N = &n3)"
STYLE (HEADER) =[JUST=LEFT CELLWIDTH=5%]
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=5%];

DEFINE T4/DISPLAY "DRUG D|(N = &n4)"
STYLE (HEADER) =[JUST=LEFT CELLWIDTH=5%]
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=5%];

DEFINE T5/DISPLAY "ALL |(N = &n5)"
STYLE (HEADER) =[JUST=LEFT CELLWIDTH=5%]
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=5%];

COMPUTE BEFORE _PAGE_;
LINE @1 "^{STYLE [OUTPUTWIDTH=100% BORDERTOPCOLOR=BLACK BORDERTOPWIDTH=0.5pt]}";
ENDCOMP;

COMPUTE AFTER _PAGE_;
LINE @1 "^{STYLE [OUTPUTWIDTH=100% BORDERTOPCOLOR=BLACK BORDERTOPWIDTH=0.5pt]}";
ENDCOMP;
RUN;

ODS _ALL_ CLOSE;