/*******************************************************************
* Client: AIRIS PHARMA Private Limited.                                                           
* Product:                                                   
* Project: Protocol 043-1810                                                  
* Program: FIG2_1_AH_20221001.SAS  
*
* Program Type: Figure
*
* Purpose: To produce the Figre 16.2.1  Distribution of Blood Pressure (Safety Population)
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

DATA VS;
SET ADAM.ADVS;
IF PARAM IN ("Systolic Blood Pressure (mmHg)"
"Diastolic Blood Pressure (mmHg)") AND SAFFL="Y";
KEEP USUBJID PARAM AVAL AVISIT;
RUN;

PROC SORT DATA=VS OUT=VS NODUPKEY;
BY USUBJID AVISIT PARAM;
RUN;

PROC TRANSPOSE DATA=VS OUT=VS1;
BY USUBJID AVISIT;
ID PARAM;
VAR AVAL;
RUN;

DATA VS2;
SET VS1;
DIASTOLIC=Diastolic_Blood_Pressure__mmHg_;
SYSTOLIC=Systolic_Blood_Pressure__mmHg_;
KEEP DIASTOLIC SYSTOLIC;
RUN;

TITLE1 J=L "AIRIS PHARMA Private Limited.";
TITLE2 J=L "Protocol: 043-1810";
TITLE3 J=C "Figre 16.2.1  Distribution of Blood Pressure (Safety Population)";

OPTIONS ORIENTATION=LANDSCAPE;
ODS ESCAPECHAR='^';
ODS RTF FILE="E:\ROSHE30730\OUTPUTS\16_2_1.rtf" STYLE=styles.test;

PROC SGPLOT DATA=VS2;
	HISTOGRAM DIASTOLIC / FILLATTRS=GRAPHDATA1 TRANSPARENCY=0.7 BINSTART=40 BINWIDTH=10;
	DENSITY DIASTOLIC / LINEATTRS=GRAPHDATA1;
	HISTOGRAM SYSTOLIC / FILLATTRS=GRAPHDATA2 TRANSPARENCY=0.5 BINSTART=40 BINWIDTH=10;
	DENSITY SYSTOLIC / LINEATTRS=GRAPHDATA2;
	KEYLEGEND / LOCATION=INSIDE POSITION=BOTTOMRIGHT BORDER ACROSS=2;
	YAXIS GRID;
	XAXIS VALUES=(0 TO 300 BY 50);
RUN;

ODS _ALL_ CLOSE;


