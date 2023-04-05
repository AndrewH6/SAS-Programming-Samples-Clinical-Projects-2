/*******************************************************************
* Client: AIRIS PHARMA Private Limited.                                                           
* Product:                                                   
* Project: Protocol 043-1810                                                  
* Program: FIG1_1_AH_20221001.SAS  
*
* Program Type: Figure
*
* Purpose: To produce the Figure 16.1.1  Creatinine (umol/L) Level by Age Range (Safety Population)
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

DATA ADLB;
SET ADAM.ADLB;
IF PARAMCD EQ "CREAT";
KEEP USUBJID AVAL;
IF SAFFL="Y";
RUN;

DATA ADSL;
SET ADAM.ADSL;
KEEP USUBJID AGEGR1 AGE;
IF SAFFL="Y";
RUN;

DATA LB2;
MERGE ADLB(IN=A) ADSL(IN=B);
LABEL CHOLESTEROL="Creatinine (umol/L)";
BY USUBJID;
IF A AND B;
CHOLESTEROL=AVAL;
AgeAtStart=AGEGR1;
KEEP AgeAtStart CHOLESTEROL;
RUN;

TITLE1 J=L "AIRIS PHARMA Private Limited.";
TITLE2 J=L "Protocol: 043-1810";
TITLE3 J=C "Figure 16.1.1  Creatinine (umol/L) Level by Age Range (Safety Population)";

OPTIONS ORIENTATION=LANDSCAPE;
ODS ESCAPECHAR='^';
ODS RTF FILE="E:\ROSHE30730\OUTPUTS\16_1_1.rtf" STYLE=styles.test;

*FOOTNOTE1 J=L "E:\ROSHE30730\PROGRAMS\FIG1_1_AH_20221001.SAS";

PROC SGPLOT DATA=LB2;
	STYLEATTRS DATACOLORS=(RED GREEN);
	VBOX CHOLESTEROL / CATEGORY=AgeAtStart GROUP=AgeAtStart;
	*FORMAT AGEATSTART AGEFMT.;
RUN;

ODS _ALL_ CLOSE;
