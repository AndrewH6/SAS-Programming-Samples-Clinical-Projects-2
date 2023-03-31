/*******************************************************************
* Client: AIRIS PHARMA Private Limited.                                                           
* Product:                                                   
* Project: Protocol 043-1810                                                  
* Program: LIS11_AH_20221001.SAS  
*
* Program Type: Listing
*
* Purpose: To producuce 16.2.2.2 Serious Adverse Events Leading to Death
*                       16.2.2.3 Serious Adverse Events
*                       16.2.2.4  Adverse Events
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

**********KEEP THE REQUIRED VARIABLES FROM SDTM SV DATASET***********;

DATA ADAE_DUM;
SET adam.ADAE;
IF AESER="Y" THEN DELETE;
RUN;

OPTIONS MPRINT MLOGIC SYMBOLGEN;
%MACRO AE (V1=, V2=, V3=, V4=);


TITLE1 J=L "AIRIS PHARMA Private Limited.";
TITLE2 J=L "Protocol: 043-1810";
TITLE3 J=C "&V2";

FOOTNOTE1 J=L "E:\ROSHE\PROGRAMS\&V3..sas";
OPTIONS ORIENTATION=LANDSCAPE;
ODS ESCAPECHAR='^';
ODS RTF FILE="E:\ROSHE30730\OUTPUTS\&V4..RTF" STYLE=styles.test;

DATA AE1;
SET adam.ADAE;
spa = STRIP(AETERM)||"/"||STRIP(AESOC)||"/"||STRIP(AEDECOD);

IF &V1;


KEEP USUBJID SPA AESTDTC AEENDTC AESER AEACN AEREL AEOUT;
RUN;

PROC SQL NOPRINT;
SELECT COUNT(*) INTO: NBR_OBS
FROM AE1;
QUIT;

%PUT &NBR_OBS;

%IF &NBR_OBS EQ 0 %THEN %DO;

DATA AE1;
TEXT = "NO OBSERVATIONS";
RUN;

PROC REPORT DATA=AE1;
COLUMN TEXT;
DEFINE TEXT /'';
RUN;

%END;

%IF &NBR_OBS GT 0 %THEN %DO;

ODS ESCAPECHAR'^';
PROC REPORT DATA=AE1 SPLIT='|' HEADLINE HEADSKIP MISSING STYLE(HEADER)={JUST=LEFT} SPACING=1 NOWD
			                     NOWINDOWS HEADLINE HEADSKIP SPLIT='|' MISSING STYLE={OUTPUTWIDTH=100%};;

	COLUMN USUBJID SPA AESTDTC AEENDTC AESER AEACN AEREL AEOUT;
	
	DEFINE USUBJID/ORDER "Subj.|No." 
	STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=9%] ID;;

	DEFINE SPA/DISPLAY "Adverse Event/Primary System Organ Class/ Preferred term"
	STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=25%];

	DEFINE AESTDTC/DISPLAY "Start Date/Time"
	STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=7%] SPACING=1;

	DEFINE AEENDTC/DISPLAY "End Date/Time"
	STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=7%];

	DEFINE AEREL/DISPLAY "Relationship to |Study Drug"
	STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=8%];
	
	DEFINE AEOUT/DISPLAY "Outcome"
	STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=8.5%];

	DEFINE AEACN/DISPLAY "Action taken"
	STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=9%];

	COMPUTE BEFORE _PAGE_;
	LINE@1 "^{STYLE [OUTPUTWIDTH=100% BORDERTOPCOLOR=BLACK BORDERTOPWIDTH=0.5pt]}";
	ENDCOMP;

	COMPUTE AFTER _PAGE_;
	LINE@1 "^{STYLE [OUTPUTWIDTH=100% BORDERTOPCOLOR=BLACK BORDERTOPWIDTH=0.5pt]}";
	ENDCOMP;

	RUN;

%END;

ODS _ALL_ CLOSE;

%MEND;

%AE (V1 = %STR( AESER = "Y" AND AEOUT = "FATAL"),
	V2 = %STR(16.2.2.2 Serious Adverse Events Leading to Death),
	V3 = LIS11_AH_20221001,
	V4 = %STR(16_2_2_2));

%AE (V1 = %STR( AESER = "Y" ),
	V2 = %STR(16.2.2.3 Serious Adverse Events),
	V3 = LIS11_AH_20221001,
	V4 = %STR(16_2_2_3));

%AE (V1 = %STR( USUBJID NE " "),
	V2 = %STR(16.2.2.4  Adverse Events),
	V3 = LIS11_AH_20221001,
	V4 = %STR(16_2_2_4));

