@ECHO OFF
TITLE Run OpenCart Automation Tests with Robot Framework

REM ============================================================
REM === SETUP: Virtual Environment (Optional)
REM ============================================================
REM Uncomment below line and replace ".env" with .venv
REM call workon .venv

REM ============================================================
REM === CLEANUP: Previous Results (Optional)
REM ============================================================
REM Uncomment if you have a results folder to clear
REM del /Q results\*

REM ============================================================
REM === TIMESTAMP FOR UNIQUE OUTPUT FOLDER
REM ============================================================
SET hh=%time:~0,2%
IF "%hh:~0,1%"==" " SET hh=0%hh:~1,1%
SET mydir=%date:~10,4%-%date:~4,2%-%date:~7,2%-%hh%-%time:~3,2%-%time:~6,2%

REM Path to the test cases or page objects directory
SET REL_PATH=..\page_objects

ECHO ============================================================
ECHO === FIRST TEST ITERATION: Run All Test Cases
ECHO ============================================================

call pabot                                      ^
    --processes 22                              ^
    --log log_1.html                            ^
    --report NONE                               ^
    --output output_1.xml                       ^
    --outputdir opencart-tests-reports%mydir%   ^
    --loglevel TRACE                            ^
    --removekeywords WUKS                       ^
    --variable SELENIUM_SPEED:0.01s             ^
    --variable SELENIUM_TIMEOUT:3s              ^
    --variable PORTAL:test                      ^
    --reporttitle "OpenCart Automation Reports" ^
    --include Regression                        ^
    %REL_PATH%

ECHO ============================================================
ECHO === SECOND TEST ITERATION: Rerun Failed Cases
ECHO ============================================================

call pabot
    --processes 22                                           ^
    --rerunfailed opencart-tests-reports%mydir%\output_1.xml ^
    --runemptysuite                                          ^
    --log log_2.html                                         ^
    --report NONE                                            ^
    --output output_2.xml                                    ^
    --outputdir opencart-tests-reports%mydir%                ^
    --loglevel TRACE                                         ^
    --removekeywords WUKS                                    ^
    --variable SELENIUM_SPEED:0.01s                          ^
    --variable SELENIUM_TIMEOUT:3s                           ^
    --variable PORTAL:test                                   ^
    --reporttitle "OpenCart Automation Reports"              ^
    --include Regression                                     ^
    %REL_PATH%

ECHO ============================================================
ECHO === FINAL POST PROCESSING: Merge Results
ECHO ============================================================

call rebot                                     ^
    --processemptysuite                        ^
    --log    FINAL_LOG.html                    ^
    --report FINAL_REPORT.html                 ^
    --output FINAL_OUTPUT.xml                  ^
    --outputdir opencart-tests-reports%mydir%  ^
    --merge                                    ^
    opencart-tests-reports%mydir%\output_*.xml

REM ============================================================
REM === OPTIONAL: Clean Up Intermediate Output Files
REM ============================================================
del /Q opencart-tests-reports%mydir%\output_*.xml

ECHO ============================================================
ECHO === TEST EXECUTION COMPLETE
ECHO === Reports: opencart-tests-reports%mydir%
ECHO ============================================================