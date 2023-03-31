/*******************************************************************
* Client: AIRIS PHARMA Private Limited.                                                           
* Product:                                                   
* Project: Protocol 043-1810                                                  
* Program: LEX.SAS  
*
* Program Type: Listing
*
* Purpose: To producuce 16.2.1.1 Assignment to Analysis Populations
* Usage Notes: 
*
* SAS® Version: 9.4 [TS2M0]
* Operating System: Windows 11 Standard Edition.                   
*
* Author: Andrew Huang
* Date Created: Oct 01, 2022
*******************************************************************/


LIBNAME adam "E:\ROSHE30730\ADAM DATASETS";

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


DATA ADSL;
SET adam.ADSL;
KEEP USUBJID SAFFL DLTEVLFL PKEVLFL ENRLFL;
RUN;

TITLE1 J=L "AIRIS PHARMA Private Limited.";
TITLE2 J=L "Protocol: 043-1810";
TITLE3 J=C "16.2.1.1 Assignment to Analysis Populations";

FOOTNOTE1 J=L "E:\ROSHE\PROGRAMS\LIS1_AH_20221001.sas";
OPTIONS ORIENTATION=LANDSCAPE;
ODS ESCAPECHAR='^';
ODS RTF FILE="E:\ROSHE30730\OUTPUTS\16_2_1_1.RTF" STYLE=styles.test;

PROC REPORT DATA = ADSL NOWD SPLOT="|" MISSING
STYLE = {OUTPUTWIDTH=100%} SPACING=1 WRAP
STYLE (HEADER) = [JUST=LEFT];

COLUMN USUBJID SAFFL DLTEVLFL PKEVLFL ENRLFL;

DEFINE USUBJID /DISPLAY "Subject|Number"
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=10%];

DEFINE SAFFL /DISPLAY "Safety|Population"
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=10%];

DEFINE DLTEVLFL /DISPLAY "DLT Evaluable|Population"
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=10%];

DEFINE PKEVLFL /DISPLAY "PK Evaluable|Population"
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=10%];

DEFINE ENRLFL /DISPLAY "Enrolled|Population"
STYLE (COLUMN) =[JUST=LEFT CELLWIDTH=10%];

COMPUTE BEFORE _PAGE_;
LINE@1 "^{style [outputwidth=100% bordertopcolor=black bordertopwidth=0.5pt]}";
ENDCOMP;

COMPUTE AFTER _PAGE_;
LINE@1 "^{style [outputwidth=100% bordertopcolor=black bordertopwidth=0.5pt]}";
ENDCOMP;

RUN;

ODS _ALL_ CLOSE;
