@ECHO off
TITLE Homestead Manager - Carles Javierre
@REM IMPORTANT!
@REM Remenber to change the path if it's not in the default path of the Laravel guide
@REM https://github.com/carlesjavierre/Homestead-Manager
SET homestead="%userprofile%\Homestead\"

ECHO Starting Homestead
CD %homestead% 
vagrant up
GOTO Selector


:Selector
cls
ECHO Homestead is now up and running. What should I do next?
ECHO 1. Restart VM
ECHO 2. Destroy VM and Restart it
ECHO 3. Destroy VM and close
ECHO 4. Close

CHOICE /C 1234 /M "Select your option:"

IF ERRORLEVEL 4 EXIT
IF ERRORLEVEL 3 GOTO DestroyAndClose
IF ERRORLEVEL 2 GOTO DestroyAndRestart
IF ERRORLEVEL 1 GOTO Restart


:Restart
CLS
ECHO Restarting VM...
vagrant reload
GOTO Selector


:DestroyAndRestart
cls
ECHO Destroying VM...
vagrant destroy --force
ECHO Starting CLEAN VM...
vagrant up
GOTO Selector


:DestroyAndClose
cls
ECHO Destroying VM...
vagrant destroy --force
ECHO Shutting Down console
EXIT

