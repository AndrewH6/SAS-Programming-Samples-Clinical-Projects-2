/*******************************************************************
* Client: AIRIS PHARMA Private Limited.                                                           
* Product:                                                   
* Project: Protocol 043-1810                                                  
* Program: LIS7_and_LIS8_MACRO_AH_20221001.SAS  
*
* Program Type: Listing
*
* Purpose: To producuce 16.2.1.7 Abnormal Biochemistry Values and
*          16.2.1.8 Abnormal HEMATOLOGY Values
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

%include "E:\ROSHE\PROGRAMS\_RTFSTYLE_.sas";
%_RTFSTYLE_;


OPTIONS MPRINT MLOGIC SYMBOLGEN;
%MACRO LAB (V1=, V2=, V3=, V4=);

DATA LB;
SET adam.ADLB;
IF PARCAT1 = "&V1" AND ANRIND NOT IN (" " "NORMAL");
IF ANRLO NE '' AND ANRHI THEN DO;
	LH=STRIP(ANRLO) ||"-"|| STRIP(ANRHI);
END;

KEEP USUBJID PARAMN PARAM AVISITN AVISIT LH ADT AVAL ANRIND;
RUN;

PROC SORT DATA = LB;
BY USUBJID PARAMN PARAM AVISITN AVISIT;
RUN;

DATA LB1;
SET LB;
BY USUBJID PARAMN PARAM AVISITN AVISIT;
RETAIN LNT PAGE1 0;
LNT+1;

IF LNT>15 THEN DO;
	PAGE1=PAGE1+1;
	LNT=1;
END;
RUN;

TITLE1 J=L "AIRIS PHARMA Private Limited.";
TITLE2 J=L "Protocol: 043-1810";
TITLE3 J=C "&V2";

FOOTNOTE1 J=L "E:\ROSHE\PROGRAMS\&V3..sas";
OPTIONS ORIENTATION=LANDSCAPE;
ODS ESCAPECHAR='^';
ODS RTF FILE = "E:\ROSHE30730\OUTPUTS\&V4..RTF" STYLE=styles.test;

PROC REPORT DATA=LB1 NOWD SPLIT="|" MISSING
STYLE ={OUTPUTWIDTH=100%} SPACING=1 WRAP
STYLE (HEADER)= [JUST=LEFT];

COLUMN PAGE1 USUBJID PARAMN PARAM AVISITN AVISIT LH ADT AVAL ANRIND;
DEFINE PAGE1 /ORDER NOPRINT;

DEFINE USUBJID /ORDER "Subject Number"
STYLE (COLUMN)= [JUST=LEFT CELLWIDTH=15%];

DEFINE PARAMN /ORDER NOPRINT ORDER=DATA;

DEFINE PARAM /ORDER "Test"
STYLE (COLUMN)= [JUST=LEFT CELLWIDTH=19%];

DEFINE AVISITN /ORDER NOPRINT ORDER=DATA;

DEFINE AVISIT /ORDER "Visit"
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=16%];

DEFINE LH /DISPLAY "Normal Range"
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=10%];

DEFINE ADT /DISPLAY "Date/Time of|Measurement"
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=10%];

DEFINE AVAL /DISPLAY "Result"
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=10%];

DEFINE ANRIND /DISPLAY "Flag"
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=10%];

COMPUTE BEFORE _PAGE_;
LINE@1 "^{style [outputwidth=100% bordertopcolor=black bordertopwidth=0.5pt]}";
ENDCOMP;

COMPUTE AFTER _PAGE_;
LINE@1 "^{style [outputwidth=100% bordertopcolor=black bordertopwidth=0.5pt]}";
ENDCOMP;

BREAK AFTER PAGE1/PAGE;
RUN;

ODS _ALL_ CLOSE;

%MEND;


%LAB (V1= CHEMISTRY ,V2= %STR(16.2.1.7 Abnormal Biochemistry Values),
V3=LIS7_AH_20221001, V4=%STR(16_2_1_7));

%LAB (V1= HEMATOLOGY ,V2= %STR(16.2.1.8 Abnormal HEMATOLOGY Values),
V3=LIS8_AH_20221001,V4=%STR(16_2_1_8));
