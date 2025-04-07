@ECHO OFF

REM ============================================
REM Activate required Python virtual environment
REM ============================================
REM Uncomment the line below if using virtualenvwrapper-win
REM call workon NAME_OF_YOUR_VIRTUALENV

REM ============================================
REM Create dynamic result folder name with timestamp
REM ============================================
set hh=%time:~-11,2%
set /a hh=%hh%+100
set hh=%hh:~1%
set mydir=%date:~10,4%-%date:~4,2%-%date:~7,2%-%hh%-%time:~3,2%-%time:~6,2%

SET REL_PATH=..\page_objects

ECHO _
ECHO ========================
ECHO First test iteration...
ECHO ========================

call pabot --processes 22                            ^
           --log log_1.html                          ^
           --report NONE                             ^
           --output output_1.xml                     ^
           --outputdir opencart-tests-reports%mydir% ^
           --loglevel TRACE                          ^
           --removekeywords WUKS                     ^
           --variable SELENIUM_SPEED:0.01s           ^
           --variable SELENIUM_TIMEOUT:3s            ^
           --variable PORTAL:test                    ^
           --reporttitle opencart-tests-reports      ^
           --i Sanity                                ^
           %REL_PATH%

ECHO _
ECHO ==========================
ECHO Second test iteration...
ECHO ==========================

call pabot --processes 22                                           ^
           --rerunfailed opencart-tests-reports%mydir%\output_1.xml ^
           --runemptysuite                                          ^
           --log log_2.html                                         ^
           --report NONE                                            ^
           --output output_2.xml                                    ^
           --outputdir opencart-tests-reports%mydir%                ^
           --loglevel TRACE                                         ^
           --removekeywords WUKS                                    ^
           --variable SELENIUM_SPEED:0.03s                          ^
           --variable SELENIUM_TIMEOUT:6s                           ^
           --variable PORTAL:test                                   ^
           --reporttitle opencart-tests-reports                     ^
           --i Sanity                                               ^
           %REL_PATH%

ECHO _
ECHO ====================================
ECHO Final Report Generation & Merging...
ECHO ====================================

call rebot --processemptysuite                           ^
           --log FINAL_LOG.html                          ^
           --report FINAL_REPORT.html                    ^
           --output FINAL_OUTPUT.xml                     ^
           --outputdir opencart-tests-reports%mydir%     ^
           --merge                                       ^
           opencart-tests-reports%mydir%\*.xml

ECHO _
ECHO ==============================
ECHO Cleaning up temporary files...
ECHO ==============================

del /Q opencart-tests-reports%mydir%\output_*.xml

ECHO Done!