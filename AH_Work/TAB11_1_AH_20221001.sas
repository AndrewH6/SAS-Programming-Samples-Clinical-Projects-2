/*******************************************************************
* Client: AIRIS PHARMA Private Limited.                                                           
* Product:                                                   
* Project: Protocol 043-1810                                                  
* Program: TAB11_1_AH_20221001.SAS   
*
* Program Type: Table
*
* Purpose: To produce the Table 14.1.24  Survival Estimates (Safety Population)
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

DATA ADTTE;
SET ADAM.ADTTE;
IF SAFFL="Y";
RUN;

ODS TRACE ON;
ODS OUTPUT CensoredSummary=_CENSORSUM
Means=_mean
Quartiles=_quartiles
HomTests=_HomTests;

PROC LIFETEST DATA=ADTTE PLOTS=(s);
TIME AVAL*CNSR(0);
STRATA TRT01P;
RUN;

ODS TRACE OFF;

PROC SORT DATA=_CENSORSUM;
BY STRATUM;
RUN;

DATA FINAL;
MERGE _CENSORSUM _MEAN;
BY STRATUM;
RUN;

DATA FINAL1;
SET FINAL;
IF CONTROL_VAR NE '-';
MEANST=STRIP(PUT(MEAN,6.3))||" ("||STRIP(PUT(StdErr,6.3))||")";
RUN;

PROC TRANSPOSE DATA=FINAL1 OUT=ALL_ PREFIX=tt;
ID STRATUM;
VAR TOTAL MEAN StdErr;
RUN;

DATA ALL_;
SET ALL_;
t1=PUT(tt1,6.3);
t2=PUT(tt2,6.3);
t3=PUT(tt3,6.3);
RUN;

DATA _QUARTILES;
SET _QUARTILES;
IF ESTIMATE NE .;
RANGE=TRIM(PUT(Estimate, 6.3))||'('||TRIM(PUT(LowerLimit,6.3))||","||TRIM(PUT(UpperLimit,6.3))||")";
RUN;

PROC SORT DATA=_QUARTILES OUT=_QUARTILES;
BY PERCENT;
RUN;

PROC TRANSPOSE DATA=_QUARTILES OUT=ALL_2 PREFIX=t;
ID STRATUM;
BY PERCENT;
VAR RANGE;
RUN;

DATA ALL_3;
SET _HomTests;
pvalue=TRIM(PUT(ProbChiSq,PVALUE7.3));
IF Test="Log-Rank";
RUN;

DATA F;
SET ALL_2 ALL_3 ALL_;
RUN;

DATA FINAL_F;
SET F;
IF _NAME_="Total" THEN DO;OD=1;VAR="Number of Subjects";END;
IF _NAME_="Mean" THEN DO;OD=2;VAR="Mean";END;
IF _NAME_="StdErr" THEN DO;OD=3;VAR="STD ERROR";END;

IF PERCENT=25 THEN DO;OD=4;VAR="25 Percentile";END;
IF PERCENT=50 THEN DO;OD=5;VAR="50 Percentile";END;
IF PERCENT=75 THEN DO;OD=6;VAR="75 Percentile";END;

IF PVALUE NE . THEN DO;OD=7;VAR="pvalue";END;
KEEP OD VAR t1 t2 t3 PVALUE;
RUN;

PROC SORT DATA=FINAL_F OUT=FINAL_F;
BY OD;
RUN;

TITLE1 J=L "AIRIS PHARMA Private Limited.";
TITLE2 J=L "Protocol: 043-1810";
TITLE3 J=C "Table 14.1.24  Survival Estimates";

FOOTNOTE1 J=L "CR = complete response, PR = partial response, SD = stable disease, PD = progressive disease.";
FOOTNOTE2 J=L "E:\ROSHE30730\PROGRAMS\TAB11_1_AH_20221001.SAS";

OPTIONS ORIENTATION=LANDSCAPE;
ODS ESCAPECHAR='^';
ODS RTF FILE="E:\ROSHE30730\OUTPUTS\14_1_24.rtf" STYLE=styles.test;

PROC REPORT DATA=FINAL_F NOWD SPLIT="|" MISSING
STYLE={OUTPUTWIDTH=100%} SPACING=1 WRAP
STYLE (HEADER)=[JUST=L];

COLUMN OD VAR t1 t2 t3 PVALUE;

DEFINE OD/ORDER NOPRINT;
DEFINE VAR/ORDER "Parameter"
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=20%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=20%]
;

DEFINE t1/DISPLAY "DRUG A"
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=15%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=15%]
;

DEFINE t2/DISPLAY "DRUG B"
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=15%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=15%]
;

DEFINE t3/DISPLAY "DRUG C"
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=15%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=15%]
;

DEFINE PVALUE/DISPLAY "P-Value"
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=15%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=15%]
;

COMPUTE BEFORE _PAGE_;
LINE@1 "^{STYLE [OUTPUTWIDTH=100% BORDERTOPCOLOR=BLACK BORDERTOPWIDTH=0.5PT]}";
ENDCOMP;

COMPUTE AFTER _PAGE_;
LINE@1 "^{STYLE [OUTPUTWIDTH=100% BORDERTOPCOLOR=BLACK BORDERTOPWIDTH=0.5PT]}";
ENDCOMP;

RUN;

ODS _ALL_ CLOSE;

