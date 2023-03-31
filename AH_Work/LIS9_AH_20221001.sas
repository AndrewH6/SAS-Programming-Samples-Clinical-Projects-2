/*******************************************************************
* Client: AIRIS PHARMA Private Limited.                                                           
* Product:                                                   
* Project: Protocol 043-1810                                                  
* Program: LEX.SAS  
*
* Program Type: Listing
*
* Purpose: To producuce 16.2.1.9 Vital Signs
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

%INCLUDE "E:\ROSHE\PROGRAMS\_RTFSTYLE_.sas";
%_RTFSTYLE_;

DATA VS;
SET adam.ADVS;
KEEP USUBJID PARAM AVISITN AVISIT AVAL ADT TRTP;
RUN;

PROC SORT DATA = VS;
BY USUBJID PARAM AVISITN AVISIT;
RUN;

DATA VS1;
SET VS;
BY USUBJID PARAM AVISITN AVISIT;
RETAIN LNT PAGE1 0;
LNT + 1;

IF LNT>15 THEN DO;
PAGE1=PAGE1+1;
LNT=1;
END;
RUN;

TITLE1 J=L "AIRIS PHARMA Private Limited.";
TITLE2 J=L "Protocol: 043-1810";
TITLE3 J=C "16.2.1.9 Vital Signs";

FOOTNOTE1 J=L "E:\ROSHE\PROGRAMS\LIS9_AH_20221001.sas";
OPTIONS ORIENTATION=LANDSCAPE;
ODS ESCAPECHAR='^';
ODS RTF FILE = "E:\ROSHE30730\OUTPUTS\16_2_1_9.RTF" STYLE=styles.test;

PROC REPORT DATA=VS1 NOWD SPLIT="|" MISSING

STYLE ={OUTPUTWIDTH=100%} SPACING=1 WRAP
STYLE (HEADER)=[JUST=LEFT];

COLUMN PAGE1 USUBJID PARAM AVISITN AVISIT AVAL ADT TRTP;

DEFINE PAGE1 /ORDER NOPRINT;

DEFINE USUBJID /ORDER "Subject"
STYLE (COLUMN)= [JUST=LEFT CELLWIDTH=13%];

DEFINE PARAM /ORDER "Parameter (unit) "
STYLE (COLUMN)= [JUST=LEFT CELLWIDTH=20%];

DEFINE AVISITN /ORDER NOPRINT;

DEFINE AVISITN /DISPLAY "Visit"
STYLE (COLUMN)= [JUST=LEFT CELLWIDTH=13%];

DEFINE AVAL /DISPLAY "Observed value"
STYLE (COLUMN)= [JUST=LEFT CELLWIDTH=10%];

DEFINE ADT /DISPLAY "Date/Time of|Measurements"
STYLE (COLUMN)= [JUST=LEFT CELLWIDTH=10%];

DEFINE TRTP /DISPLAY "Planned|treatment " 
STYLE (COLUMN)= [JUST=LEFT CELLWIDTH=10%];

COMPUTE BEFORE _PAGE_;
LINE@1 "^{style [outputwidth=100% bordertopcolor=black bordertopwidth=0.5pt]}";
ENDCOMP;

COMPUTE AFTER _PAGE_;
LINE@1 "^{style [outputwidth=100% bordertopcolor=black bordertopwidth=0.5pt]}";
ENDCOMP;

BREAK AFTER PAGE1/PAGE;

COMPUTE AFTER PARAM;
LINE '';

ENDCOMP;
RUN;

ODS _ALL_ CLOSE;

