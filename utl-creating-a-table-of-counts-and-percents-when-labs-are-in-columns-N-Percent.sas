Creating a table of counts and percents when labs are in columns N Percent

Table of percent of labs completed

github
https://tinyurl.com/qsgx56d
https://github.com/rogerjdeangelis/utl-creating-a-table-of-counts-and-percents-when-labs-are-in-columns-N-Percent

I feel it is better to get a output table that a static report

   Two Solutions  (both produce sas tables)

        a. proc means stackodsoutput then transpose macro
        b. proc report (serious bug in proc report.does not honor ods output (proc corresp does)

repo macros
https://tinyurl.com/y9nfugth
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories


SAS Forum
https://tinyurl.com/qk4x7qb
https://communities.sas.com/t5/SAS-Programming/Summary-table-of-multiple-variables-by-one-variable/m-p/633943

Paige Miller
https://communities.sas.com/t5/user/viewprofilepage/user-id/10892

Also see
https://github.com/rogerjdeangelis?tab=repositories&q=N+Percent&type=&language=


*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

data have;
  input patientid drug hgb hct ast alt bun rbc ldl ;
cards4;
1 1 0 1 0 1 1 0 0
2 0 1 0 0 0 0 1 0
3 1 1 1 1 1 1 0 0
4 0 1 0 1 0 0 0 1
5 1 1 1 1 1 1 0 0
6 1 0 1 0 1 1 0 0
7 0 1 0 0 0 0 0 1
8 1 1 1 1 1 0 1 0
9 0 1 0 1 0 1 0 0
10 0 1 1 1 1 1 0 0
;;;;
run;quit;

 WORK.HAVE total obs=10

 PATIENTID    DRUG    HGB    HCT    AST    ALT    BUN    RBC    LDL

      1         1      0      1      0      1      1      0      0
      2         0      1      0      0      0      0      1      0
      3         1      1      1      1      1      1      0      0
      4         0      1      0      1      0      0      0      1
      5         1      1      1      1      1      1      0      0
      6         1      0      1      0      1      1      0      0
      7         0      1      0      0      0      0      0      1
      8         1      1      1      1      1      0      1      0
      9         0      1      0      1      0      1      0      0
     10         0      1      1      1      1      1      0      0

*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;

WORK.WANT total obs=7

PERCENT OF LABS COMPLETED

                   PERCENT_           PERCENT_
VARIABLE    N_0       0        N_1       1

  ALT        5        20%       5       100%
  AST        5        60%       5        60%
  BUN        5        40%       5        80%
  HCT        5        20%       5       100%
  HGB        5       100%       5        60%
  LDL        5        40%       5         0%
  RBC        5        20%       5        20%

*
 _ __  _ __ ___   ___ ___  ___ ___
| '_ \| '__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
  __ _     _ __  _ __ ___   ___   _ __ ___   ___  __ _ _ __  ___
 / _` |   | '_ \| '__/ _ \ / __| | '_ ` _ \ / _ \/ _` | '_ \/ __|
| (_| |_  | |_) | | | (_) | (__  | | | | | |  __/ (_| | | | \__ \
 \__,_(_) | .__/|_|  \___/ \___| |_| |_| |_|\___|\__,_|_| |_|___/
          |_|
;

ods output summary=havAvg(rename=mean=percent);
proc means data=have stackodsoutput n mean;
class drug;;
var hgb hct ast alt bun rbc ldl;
run;quit;

%utl_transpose(data=havAvg, out=want,by=variable,sort=YES, id=drug, delimiter=_, var=n percent);

proc print data=want width=min;
format percent: percent6.0;
run;quit;

*_                                                         _
| |__     _ __  _ __ ___   ___   _ __ ___ _ __   ___  _ __| |_
| '_ \   | '_ \| '__/ _ \ / __| | '__/ _ \ '_ \ / _ \| '__| __|
| |_) |  | |_) | | | (_) | (__  | | |  __/ |_) | (_) | |  | |_
|_.__(_) | .__/|_|  \___/ \___| |_|  \___| .__/ \___/|_|   \__|
         |_|                             |_|
;

proc transpose data=have out=havXpo(rename=(_name_=lab));
    by patientid drug;
    var hgb hct ast alt bun rbc ldl;
run;quit;

proc report data=havXpo out=want (rename=( %utl_renamel(_c2_ _c3_ _c4_ _c5_, N_0 Percent_0 N_1 Percent_1)));
    columns lab drug,(col1=_N col1);
    define  lab/group "NAME" order=data;
    define drug/across "DRUG";
    define _N/sum "N" format=comma6.0;
    define col1/mean "Percent" format=percent6.0;
run;quit;


proc print data=want width=min;
format percent: percent6.0;
run;quit;


