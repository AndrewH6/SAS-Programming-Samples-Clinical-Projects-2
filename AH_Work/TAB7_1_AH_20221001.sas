/*******************************************************************
* Client: AIRIS PHARMA Private Limited.                                                           
* Product:                                                   
* Project: Protocol 043-1810                                                  
* Program: tab1_1_AH_20221001.SAS  
*
* Program Type: Listing
*
* Purpose: To produce the Table 14.1.16 Summary of Changes in Vital Signs from Baseline to Final Visit (Safety Population)
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

PROC SUMMARY DATA=ADAM.ADVS NWAY;
WHERE INDEX(AVISIT,"UNSCHEDULED")=0 AND SAFFL="Y";
CLASS PARAM TRTPN TRTP AVISITN AVISIT;
VAR AVAL;
OUTPUT OUT=ADSL2
n=n mean=mean median=median min=min max=max std=std;
RUN;

DATA ADSL3;
SET ADSL2;

cn=LEFT(PUT(n,4.));
cmean=LEFT(PUT(mean,5.1));
cmedian=LEFT(PUT(median,5.1));
cstd=LEFT(PUT(std,6.2));
cmin=LEFT(PUT(min,4.));
cmax=LEFT(PUT(max,4.));

RUN;

PROC SUMMARY DATA=ADAM.ADVS NWAY;
WHERE INDEX(AVISIT,"UNSCHEDULED")=0 AND SAFFL="Y";
CLASS PARAM TRTPN TRTP AVISITN AVISIT;
VAR CHG;
OUTPUT OUT=ADSL2_C
n=n mean=mean median=median min=min max=max std=std;
RUN;

DATA ADSL3_C;
SET ADSL2_C;

cn_c=LEFT(PUT(n,4.));
cmean_c=LEFT(PUT(mean,5.1));
cmedian_c=LEFT(PUT(median,5.1));
cstd_c=LEFT(PUT(std,6.2));
cmin_c=LEFT(PUT(min,4.));
cmax_c=LEFT(PUT(max,4.));

RUN;

DATA FINAL;
MERGE ADSL3 ADSL3_C;
BY PARAM TRTPN TRTP AVISITN AVISIT;
RUN;

TITLE1 J=L "AIRIS PHARMA Private Limited.";
TITLE2 J=L "Protocol: 043-1810";
TITLE3 J=C "Table 14.1.16 Summary of Changes in Vital Signs from Baseline to Final Visit (Safety Population) ";

FOOTNOTE1 J=L "E:\ROSHE30730\PROGRAMS\TAB7_1_AH_20221001.SAS";

OPTIONS ORIENTATION=LANDSCAPE;
ODS ESCAPECHAR='^';
ODS RTF FILE="E:\ROSHE30730\OUTPUTS\14_1_16.rtf" STYLE=styles.test;

PROC REPORT DATA=final NOWD SPLIT="|" MISSING
STYLE={OUTPUTWIDTH=100%} SPACING=1 WRAP
STYLE (HEADER)=[JUST=C];

COLUMN PARAM TRTPN TRTP AVISITN AVISIT
("Observed" "----------------------------------" cn cmean cmedian cstd cmin cmax)
("CFB" "-------------------------------------" cn_c cmean_c cmedian_c cstd_c cmin_c cmax_c);

DEFINE PARAM/ORDER "Parameter (units)" NOPRINT
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=15%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=15%]
;

DEFINE TRTPN/ORDER NOPRINT;

DEFINE TRTP/ORDER "Planned Treatment"
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=10%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=10%]
;

DEFINE AVISITN/ORDER NOPRINT;

DEFINE AVISIT/DISPLAY "Visit" FLOW
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=10%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=10%]
;

DEFINE cn/DISPLAY "n" 
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=03%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=03%]
;

DEFINE cmean/DISPLAY "Mean" 
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=05%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=05%]
;

DEFINE cmedian/DISPLAY "Median" 
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=05%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=05%]
;

DEFINE cstd/DISPLAY "SD" 
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=05%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=05%]
;

DEFINE cmin/DISPLAY "Min" 
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=05%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=05%]
;

DEFINE cmax/DISPLAY "Max" 
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=05%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=05%]
;


DEFINE cn_c/DISPLAY "n" 
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=03%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=03%]
;

DEFINE cmean_c/DISPLAY "Mean" 
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=05%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=05%]
;

DEFINE cmedian_c/DISPLAY "Median" 
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=05%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=05%]
;

DEFINE cstd_c/DISPLAY "SD" 
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=05%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=05%]
;

DEFINE cmin_c/DISPLAY "Min" 
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=05%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=05%]
;

DEFINE cmax_c/DISPLAY "Max" 
STYLE(COLUMN)=[JUST=LEFT CELLWIDTH=05%]
STYLE(HEADER)=[JUST=LEFT CELLWIDTH=05%]
;

COMPUTE BEFORE _PAGE_;
LINE @1 'Parameter:  ' PARAM $;
LINE "^{STYLE [OUTPUTWIDTH=100% BORDERBOTTOMCOLOR=BLACK BORDERBOTTOMWIDTH=0.5PT]}";
ENDCOMP;

BREAK AFTER PARAM/PAGE;

COMPUTE AFTER _PAGE_;
LINE @1 "^{STYLE [OUTPUTWIDTH=100% BORDERBOTTOMCOLOR=BLACK BORDERBOTTOMWIDTH=0.5PT]}";
ENDCOMP;

RUN;

ODS _ALL_ CLOSE;
