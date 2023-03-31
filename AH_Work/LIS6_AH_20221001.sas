/*******************************************************************
* Client: AIRIS PHARMA Private Limited.                                                           
* Product:                                                   
* Project: Protocol 043-1810                                                  
* Program: LEX.SAS  
*
* Program Type: Listing
*
* Purpose: To producuce 16.2.1.6 Prior and Concomitant Medications
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



**********KEEP THE REQUIRED VARIABLES FROM SDTM SV DATASET***********;

%macro _RTFSTYLE_;

proc template;
 define style styles.test;
     parent=styles.rtf;
    replace fonts /
     'BatchFixedFont' = ("Courier New",9pt)
     'TitleFont2' = ("Courier New",9pt)
     'TitleFont' = ("Courier New",9pt)
     'StrongFont' = ("Courier New",9pt)
     'EmphasisFont' = ("Courier New",9pt)
     'FixedEmphasisFont' = ("Courier New",9pt)
     'FixedStrongFont' = ("Courier New",9pt)
     'FixedHeadingFont' = ("Courier New",9pt)
     'FixedFont' = ("Courier New",9pt)
     'headingEmphasisFont' = ("Courier New",9pt)
     'headingFont' = ("Courier New",9pt)
     'docFont' = ("Courier New",9pt);
      replace table from output /
      cellpadding = 0pt
      cellspacing = 0pt
	    borderwidth = 0.50pt
      background=white
      frame=void;
	 replace color_list	/
     'link' = black
     'bgH' = white
     'fg' = black
     'bg' = white;

	 replace Body from Document /
      bottommargin = 1.00in
      topmargin = 1.00in
      rightmargin = 1.00in
      leftmargin = 1.00in; 
   end;
run;

%MEND _RTFSTYLE_;
%_RTFSTYLE_;

DATA ADCM;
SET adam.ADCM;
KEEP USUBJID CMTRT CMDECOD CMSTDTC CMENDTC CMDOSE  CMDOSTXT CMDOSU TRTP CMDOSE_GOOD CMDOSTXT_GOOD CMDOSE_ALL CMTRT_CMDECOD;

IF CMDOSE = . THEN CMDOSE_GOOD = 0;
ELSE CMDOSE_GOOD = 1;

IF CMDOSTXT = "" THEN CMDOSTXT_GOOD = 0;
ELSE CMDOSTXT_GOOD = 1;

IF CMDOSE_GOOD = 1 OR CMDOSTXT_GOOD = 1;
IF CMDOSE_GOOD = 1 THEN CMDOSE_ALL = PUT(CMDOSE, $11.);
IF CMDOSE_GOOD = 0 AND CMDOSTXT_GOOD = 1 THEN CMDOSE_ALL = CMDOSTXT;

IF CMTRT NE '' AND CMDECOD NE '' THEN CMTRT_CMDECOD = STRIP(CMTRT)||"/"||STRIP(CMDECOD);
ELSE IF CMTRT = '' AND CMDECOD NE '' THEN CMTRT_CMDECOD = STRIP(CMDECOD);
ELSE IF CMTRT NE '' AND CMDECOD = '' THEN CMTRT_CMDECOD = STRIP(CMTRT);

RUN;

DATA ADCM1;
SET ADCM;
RETAIN LNT PAGE1 0;
LNT + 1;

IF LNT>8 THEN DO;
PAGE1=PAGE1+1;
LNT=1;
END;
RUN;

TITLE1 J=L "AIRIS PHARMA Private Limited.";
TITLE2 J=L "Protocol: 043-1810";
TITLE3 J=C "16.2.1.6 Prior and Concomitant Medications";

FOOTNOTE1 J=L "E:\ROSHE\PROGRAMS\LIS6_AH_20221001.sas";
OPTIONS ORIENTATION=LANDSCAPE;
ODS ESCAPECHAR='^';
ODS RTF FILE = "E:\ROSHE30730\OUTPUTS\16_2_1_6.RTF" STYLE=styles.test;

PROC REPORT DATA=ADCM1 NOWD SPLIT="|" MISSING
STYLE ={OUTPUTWIDTH=100%} SPACING=1 WRAP
STYLE (HEADER)= [JUST=LEFT];

COLUMN PAGE1 USUBJID CMTRT_CMDECOD CMSTDTC CMENDTC CMDOSE_ALL CMDOSU;
DEFINE PAGE1 /ORDER NOPRINT;

DEFINE USUBJID /ORDER "Subject Number"
STYLE (COLUMN)= [JUST=LEFT CELLWIDTH=10%];

DEFINE CMTRT_CMDECOD /ORDER "Medication Name/Preferred term"
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=10%];

DEFINE CMSTDTC /DISPLAY "Start Date/Time"
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=10%];

DEFINE CMENDTC /DISPLAY "End Date/Time"
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=10%];

DEFINE CMDOSE_ALL /DISPLAY "Dose"
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=10%];

DEFINE CMDOSU /DISPLAY "Units"
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
