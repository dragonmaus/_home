@ECHO OFF
SETLOCAL
SET BASE=%~DP0
CHDIR /D %BASE%
CALL INSTALL abspath -lcore
IF ERRORLEVEL 1 EXIT /B %ERRORLEVEL%
CALL INSTALL cargo-foreach -lcore
IF ERRORLEVEL 1 EXIT /B %ERRORLEVEL%
CALL INSTALL en%%%% -lcore
IF ERRORLEVEL 1 EXIT /B %ERRORLEVEL%
CALL INSTALL lefix -lcore
IF ERRORLEVEL 1 EXIT /B %ERRORLEVEL%
CALL INSTALL printenv -lcore
IF ERRORLEVEL 1 EXIT /B %ERRORLEVEL%
CALL INSTALL realpath -lcore
IF ERRORLEVEL 1 EXIT /B %ERRORLEVEL%
CALL INSTALL un%%%% -lcore
IF ERRORLEVEL 1 EXIT /B %ERRORLEVEL%
ENDLOCAL
