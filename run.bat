@ECHO off
TITLE Homestead Manager - Carles Javierre
@REM IMPORTANT!
@REM Remenber to change the path IF it's not in the default path of the Laravel guide
@REM https://github.com/carlesjavierre/Homestead-Manager
SET homestead="%userprofile%\Homestead\"
SET suspended=0

ECHO Starting Homestead
CD %homestead%
GOTO Selector


:Selector
CLS
ECHO Homestead is now up and running. What should I do next?
ECHO 1. Reload Vagrant
ECHO 2. Start/Restart VM
ECHO 3. Suspend/Resume VM
ECHO 4. Suspend VM and close
ECHO 5. Destroy VM and Restart it
ECHO 6. Destroy VM and close
ECHO 7. Get Status
ECHO 8. Update
ECHO 9. Close

CHOICE /C 123456789 /M "Select your option:"

IF ERRORLEVEL 9 EXIT
IF ERRORLEVEL 8 GOTO Update
IF ERRORLEVEL 7 GOTO GetStatus
IF ERRORLEVEL 6 GOTO DestroyAndClose
IF ERRORLEVEL 5 GOTO DestroyAndRestart
IF ERRORLEVEL 4 GOTO SuspendAndClose
IF ERRORLEVEL 3 GOTO Suspend
IF ERRORLEVEL 2 GOTO Restart
IF ERRORLEVEL 1 GOTO Reload


:: Main Logic

:Reload
CLS
ECHO Reloading Vagrant...
CALL :DoReload
GOTO Selector

:Restart
CLS
ECHO Restarting VM...
CALL :DoRestart
PAUSE
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

:Update
CLS
ECHO Destroying VM...
CALL :DoDestroy
ECHO Updating...
CALL :DoUpdate
PAUSE
GOTO Selector


:: Main Function classes

:DoReload
vagrant reload --provision
GOTO :eof

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

:DoRestart
ECHO VM was shut down. Starting...
vagrant reload
GOTO :eof

:DoStatus
vagrant status
GOTO :eof

:DoUpdate
vagrant box update
GOTO :eof
