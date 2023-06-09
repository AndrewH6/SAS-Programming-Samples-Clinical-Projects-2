/*******************************************************************
* Client: AIRIS PHARMA Private Limited.                                                           
* Product:                                                   
* Project: Protocol 043-1810                                                  
* Program: TAB8_1_AH_20221001.SAS  
*
* Program Type: Listing
*
* Purpose: To produce the Table Table 14.1.18 Shift Table from Baseline to End of period (Safety Population)
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

%include "E:\ROSHE\PROGRAMS\TABLE_POP.sas";
%include "E:\ROSHE\PROGRAMS\_RTFSTYLE_.sas";
%_RTFSTYLE_;

DATA ADSL;
SET ADAM.ADSL;
IF TRT01P NE '' AND SAFFL="Y";
OUTPUT;
TRT01P="Overall";
TRT01PN=5;
OUTPUT;
KEEP USUBJID TRT01P TRT01PN SAFFL DLTEVLFL ENRLFL SEX RACE;
RUN;

PROC SQL NOPRINT;
CREATE TABLE TRT AS
SELECT TRT01PN, TRT01P, COUNT(DISTINCT(USUBJID)) AS DENOM FROM ADSL
GROUP BY TRT01PN, TRT01P
ORDER BY TRT01PN, TRT01P;

SELECT DENOM INTO: n1 - :n5 FROM trt;
QUIT;

%PUT &n5;

DATA LB1;
SET ADAM.ADLB;

IF SAFFL="Y" AND INDEX(AVISIT,"UNSCH")=0 AND PARCAT1 IN ("CHEMISTRY","HEMATOLOGY");

IF BNRIND EQ '' THEN BNRIND="Missing";
IF ANRIND EQ '' THEN ANRIND="Missing";

KEEP USUBJID PARCAT1 PARAMN PARAM BNRIND ANRIND AVIISITN;
RUN;

PROC SORT DATA = LB1 OUT = LB1;
BY USUBJID PARCAT1 PARAMN;
RUN;

DATA LB2;
SET LB1;
BY USUBJID PARCAT1 PARAMN;
IF LAST.PARAMN;
RUN;

PROC FREQ DATA=LB2 NOPRINT;
TABLES PARCAT1*PARAMN*PARAM*BNRIND*ANRIND/OUT=LB3 (DROP=PERCENT);
WHERE BNRIND NE 'Missing' AND ANRIND NE 'Missing';
RUN;

DATA LB4;
SET LB3;
LENGTH GRPA_1 $20.;

IF COUNT=. OR COUNT=0 THEN GRPA_1="0";
ELSE IF COUNT=&n5 then GRPA_1 =COMPRESS(COUNT)||" (100)";
ELSE GRPA_1=PUT(COUNT,3.)||" ("||PUT(COUNT/&n5*100,4.1)||")";

RUN;

PROC TRANSPOSE DATA=LB4 OUT=LB5;
BY PARCAT1 PARAMN PARAM BNRIND;
ID ANRIND;
VAR GRPA_1;
RUN;

DATA LB6;
SET LB5;
IF LOW="" THEN LOW="  0";
IF HIGH="" THEN HIGH="  0";
IF NORMAL="" THEN NORMAL="  0";
RUN;

DATA LB7;
SET LB6;
BY PARCAT1;

RETAIN LNT PAGE1 0;
LNT+1;

IF LNT>17 THEN DO;
PAGE1=PAGE1+1;
LNT=1;
END;
RUN;

TITLE1 J=L "AIRIS PHARMA Private Limited.";
TITLE2 J=L "Protocol: 043-1810";
TITLE3 J=C "Table 14.1.18 Shift Table from Baseline to End of period (Safety Population)";

FOOTNOTE1 J=L "E:\ROSHE30730\PROGRAMS\TAB8_1_AH_20221001.SAS";

OPTIONS ORIENTATION=LANDSCAPE;
ODS ESCAPECHAR='^';
ODS RTF FILE ="E:\ROSHE30730\OUTPUTS\14_1_18.rtf" STYLE=styles.test;

PROC REPORT DATA=LB7 NOWD SPLIT="|" MISSING
STYLE ={OUTPUTWIDTH=100%} SPACING=1 WRAP
STYLE (HEADER)=[JUST=C];

COLUMN PAGE1 PARCAT1 PARAMN PARAM BNRIND
("^{STYLE [OUTPUTWIDTH=100% BORDERBOTTOMCOLOR=BLACK BORDERBOTTOMWIDTH=0.5PT]} Treatment  end|(N=&n5)" low normal high);

DEFINE PAGE1/ORDER NOPRINT;
DEFINE PARCAT1/ORDER "Parameter|category"
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=10%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=10%]
;

DEFINE PARAMN/ORDER NOPRINT;
DEFINE PARAM/ORDER "Parameter (Unit)"
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=20%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=20%]
;
DEFINE BNRIND/DISPLAY "Baseline"
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=10%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=10%]
;
DEFINE LOW/DISPLAY "Low"
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=10%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=10%]
;
DEFINE NORMAL/DISPLAY "Normal"
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=10%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=10%]
;
DEFINE HIGH/DISPLAY "High"
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=10%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=10%]
;

COMPUTE BEFORE _PAGE_;
LINE@1 "^{STYLE [OUTPUTWIDTH=100% BORDERTOPCOLOR=BLACK BORDERTOPWIDTH=0.5PT]}";
ENDCOMP;

COMPUTE AFTER _PAGE_;
LINE@1 "^{STYLE [OUTPUTWIDTH=100% BORDERTOPCOLOR=BLACK BORDERTOPWIDTH=0.5PT]}";
ENDCOMP;

BREAK AFTER PAGE1/PAGE;
RUN;

ODS _ALL_ CLOSE;
