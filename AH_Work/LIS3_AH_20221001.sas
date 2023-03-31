/*******************************************************************
* Client: AIRIS PHARMA Private Limited.                                                           
* Product:                                                   
* Project: Protocol 043-1810                                                  
* Program: LIS3_AH_20221001.SAS  
*
* Program Type: Listing
*
* Purpose: To produce 16.2.1.3 Study Visits
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

DATA SV;
SET sdtm.SV;
KEEP USUBJID VISITNUM VISIT SVSTDTC SVENDTC;
RUN;

PROC SORT DATA = SV;
BY USUBJID VISITNUM;
RUN;

**********PAGE NUMBER*************************;

DATA SV1;
SET SV;
BY USUBJID VISITNUM;
RETAIN LNT PAGE1 0;
LNT + 1;

IF LNT>20 THEN DO;
PAGE1=PAGE1+1;
LNT=1;
END;
RUN;

TITLE1 J=L "AIRIS PHARMA Private Limited.";
TITLE2 J=L "Protocol: 043-1810";
TITLE3 J=C "16.2.1.3 Study Visits";

FOOTNOTE1 J=L "E:\ROSHE\PROGRAMS\LIS3_AH_20221001.sas";
OPTIONS ORIENTATION=LANDSCAPE;
ODS ESCAPECHAR='^';
ODS RTF FILE = "E:\ROSHE30730\OUTPUTS\16_2_1_3.RTF" STYLE=styles.test;

PROC REPORT DATA=SV1 NOWD SPLIT="|" MISSING
STYLE ={OUTPUTWIDTH=100%} SPACING=1 WRAP
STYLE (HEADER)= [JUST=LEFT];

COLUMN PAGE1 USUBJID VISITNUM VISIT SVSTDTC SVENDTC;
DEFINE PAGE1 /ORDER NOPRINT;

DEFINE USUBJID /ORDER "Subject Number"
STYLE (COLUMN)= [JUST=LEFT CELLWIDTH=10%];

DEFINE VISITNUM /ORDER NOPRINT ORDER=DATA;

DEFINE VISIT /ORDER "Visit"
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=10%];

DEFINE SVSTDTC /DISPLAY "Start date of Visit"
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=10%];

DEFINE SVENDTC /DISPLAY "End date of Visit"
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
