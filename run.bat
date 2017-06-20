@ECHO off
TITLE Homestead Manager - Carles Javierre
@REM IMPORTANT!
@REM Remenber to change the path IF it's not in the default path of the Laravel guide
@REM https://github.com/carlesjavierre/Homestead-Manager
SET homestead="%userprofile%\Homestead\"
SET suspended=0

ECHO Starting Homestead
CD %homestead% 
CALL :DoStart
GOTO Selector


:Selector
CLS
ECHO Homestead is now up and running. What should I do next?
ECHO 1. Restart VM
ECHO 2. Suspend/Resume VM 
ECHO 3. Suspend VM and close
ECHO 4. Destroy VM and Restart it
ECHO 5. Destroy VM and close
ECHO 6. Get Status
ECHO 7. Close

CHOICE /C 1234567 /M "Select your option:"

IF ERRORLEVEL 7 EXIT
IF ERRORLEVEL 6 GOTO GetStatus
IF ERRORLEVEL 5 GOTO DestroyAndClose
IF ERRORLEVEL 4 GOTO DestroyAndRestart
IF ERRORLEVEL 3 GOTO SuspendAndClose
IF ERRORLEVEL 2 GOTO Suspend
IF ERRORLEVEL 1 GOTO Restart


:: Main Logic

:Restart
CLS
ECHO Restarting VM...
CALL :DoReload
GOTO Selector

:Suspend
CLS
IF %suspended%==0 (
	ECHO Suspending VM...
	CALL :DoSuspend
	SET suspended=1
	GOTO Selector
)
IF %suspended%==1 (
	ECHO Resuming VM...
	CALL :DoResume
	SET suspended=0
	GOTO Selector
)

:SuspendAndClose
CLS
ECHO Suspending VM...
CALL :DoSuspend
EXIT

:DestroyAndRestart
CLS
ECHO Destroying VM...
CALL :DoDestroy
ECHO Starting CLEAN VM...
CALL :DoStart
GOTO Selector

:DestroyAndClose
CLS
ECHO Destroying VM...
CALL :DoDestroy
ECHO Shutting Down console
EXIT

:GetStatus
CLS
ECHO Getting status...
CALL :DoStatus
PAUSE
GOTO Selector


:: Main Function classes

:DoStart
vagrant up
GOTO :eof

:DoDestroy
vagrant destroy --force
GOTO :eof

:DoSuspend
vagrant suspend
SET suspended=1
GOTO :eof

:DoResume
ECHO VM was suspended. Resuming...
vagrant resume
SET suspended=0
GOTO :eof

:DoReload 
ECHO VM was shut down. Starting...
vagrant reload
GOTO :eof


:DoStatus
vagrant status
PAUSE
GOTO :eof
