/*******************************************************************
* Client: AIRIS PHARMA Private Limited.                                                           
* Product:                                                   
* Project: Protocol 043-1810                                                  
* Program: TAB9_1_AH_20221001.SAS  
*
* Program Type: Table
*
* Purpose: To produce the Table 14.1.20  Medical History by Treatment, System Organ Class and Preferred Term (Safety Population)
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
KEEP USUBJID TRT01P TRT01PN SAFFL DLTEVLFL ENRLFL DCSREAS SEX RACE;
RUN;

PROC SQL NOPRINT;
CREATE TABLE TRT AS
SELECT TRT01PN, TRT01P, COUNT(DISTINCT USUBJID) AS DENOM FROM ADSL
GROUP BY TRT01PN, TRT01P
ORDER BY TRT01PN, TRT01P;

SELECT DENOM INTO: n1 - :n4 FROM TRT;
QUIT;

%PUT &n1 &n2 &n3 &n4;

DATA ADMH;
SET ADAM.ADMH;
IF MHCAT="MEDICAL HISTORY" AND SAFFL="Y" AND TRTP NE '';
IF MHBODSYS="" THEN MHBODSYS="UNCODED";
KEEP USUBJID TRTP TRTPN MHBODSYS MHDECOD;
RUN;

PROC SQL NOPRINT;
CREATE TABLE ANY1 AS
SELECT TRTPN, TRTP, COUNT(DISTINCT USUBJID) AS n,
"  Number of Subjects with one Medical History" AS MHBODSYS LENGTH=200
FROM ADMH
GROUP BY TRTPN, TRTP;

CREATE TABLE SOC AS
SELECT TRTPN, TRTPN, MHBODSYS, COUNT(DISTINCT USUBJID) AS n
FROM ADMH
GROUP BY TRTPN, TRTP, MHBODSYS;

CREATE TABLE PT AS
SELECT TRTPN, TRTP, MHBODSYS, MHDECOD, COUNT(DISTINCT USUBJID) AS n
FROM ADMH
GROUP BY TRTPN, TRTP, MHBODSYS, MHDECOD;

QUIT;

DATA ALL;
SET ANY1 SOC PT;
RUN;

DATA FINAL;
SET ALL;
NN=n;
LENGTH GRPA_1 $20.;

IF TRTPN=1 THEN DO;
	IF NN=. OR NN=0 THEN GRPA_1="0";
	ELSE IF NN=&n1 THEN GRPA_1=COMPRESS(NN)||" (100)";
	ELSE GRPA_1=PUT(NN,3.)||" ("||PUT(NN/&n1*100,4.1)||")";
END;

IF TRTPN=2 THEN DO;
	IF NN=. OR NN=0 THEN GRPA_1="0";
	ELSE IF NN=&n2 THEN GRPA_1=COMPRESS(NN)||" (100)";
	ELSE GRPA_1=PUT(NN,3.)||" ("||PUT(NN/&n2*100,4.1)||")";
END;

IF TRTPN=3 THEN DO;
	IF NN=. OR NN=0 THEN GRPA_1="0";
	ELSE IF NN=&n3 THEN GRPA_1=COMPRESS(NN)||" (100)";
	ELSE GRPA_1=PUT(NN,3.)||" ("||PUT(NN/&n3*100,4.1)||")";
END;

IF TRTPN=4 THEN DO;
	IF NN=. OR NN=0 THEN GRPA_1="0";
	ELSE IF NN=&n4 THEN GRPA_1=COMPRESS(NN)||" (100)";
	ELSE GRPA_1=PUT(NN,3.)||" ("||PUT(NN/&n4*100,4.1)||")";
END;

RUN;

PROC SORT DATA=FINAL OUT=FINAL;
BY MHBODSYS MHDECOD;
RUN;

PROC TRANSPOSE DATA=FINAL OUT=ALL_ PREFIX=t;
BY MHBODSYS MHDECOD;
ID TRTPN;
VAR GRPA_1;
RUN;

DATA DUMMY;
SET ALL_ (KEEP=MHBODSYS MHDECOD);
LENGTH t1 t2 t3 t4 $20.;
t1="";
t2="";
t3="";
t4="";
RUN;

DATA ALL_;
MERGE DUMMY ALL_;
BY MHBODSYS MHDECOD;
RUN;

DATA FINAL;
SET ALL_;
LENGTH NEWV $200.;
IF MHDECOD EQ '' THEN NEWV=MHBODSYS;
ELSE NEWV="   "||MHDECOD;

IF t1="" THEN t1="  0";
IF t2="" THEN t2="  0";
IF t3="" THEN t3="  0";
IF t4="" THEN t4="  0";
RUN;

DATA FINAL;
SET FINAL;
BY MHBODSYS MHDECOD;
RETAIN LNT PAGE1 0;
LNT+1;
IF LNT>17 THEN DO;
	PAGE1=PAGE1+1;
	LNT=1;
END;
RUN;

TITLE1 J=L "AIRIS PHARMA Private Limited.";
TITLE2 J=L "Protocol: 043-1810";
TITLE3 J=C "Table 14.1.20  Medical History by Treatment, 
System Organ Class and Preferred Term (Safety Population)";

FOOTNOTE1 J=L "E:\ROSHE30730\PROGRAMS\TAB9_1_AH_20221001.SAS";
OPTIONS ORIENTATION=LANDSCAPE;
ODS ESCAPECHAR='^';
ODS RTF FILE="E:\ROSHE30730\OUTPUTS\14_1_20.rtf" STYLE=styles.test;

PROC REPORT DATA=FINAL NOWD SPLIT="|" MISSING
STYLE={OUTPUTWIDTH=100%} SPACING=1 WRAP
STYLE (HEADER)=[JUST=L];

COLUMN PAGE1 LNT NEWV t1 t2 t3 t4;

DEFINE PAGE1/ORDER NOPRINT;
DEFINE LNT/ORDER NOPRINT;

DEFINE NEWV/ORDER "MedDRA?System Organ Class|   MedDRA?Preferred Term"
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=20% ASIS=ON]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=20% ASIS=ON];

DEFINE t1/DISPLAY "DRUG A|(N = &n1)"
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=5%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=5%]
;

DEFINE t2/DISPLAY "DRUG B|(N = &n2)"
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=5%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=5%]
;

DEFINE t3/DISPLAY "DRUG C|(N = &n3)"
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=5%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=5%]
;

DEFINE t4/DISPLAY "DRUG D|(N = &n4)"
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=5%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=5%]
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