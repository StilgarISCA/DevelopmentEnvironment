REM
REM Batch file which installs some typical software and configurations
REM I like to use when developing.
REM
@ECHO off

ECHO "Show file extensions in Windows Explorer"
REG QUERY "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" | Find "0x0"
IF ERRORLEVEL 0 (
	REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f
)

ECHO "Show system folders in Windows Explorer"
REG QUERY "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" | Find "0x0"
IF ERRORLEVEL 0 (
	REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f
)

ECHO "Switch to small icons in Taskbar"
REG QUERY "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSmallIcons" | Find "0x0"
IF ERRORLEVEL 0 (
	REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSmallIcons" /t REG_DWORD /d 1 /f
)

ECHO "Don't show Windows Store Apps on the Taskbar"
REG QUERY "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StoreAppsOnTaskbar" | Find "0x0"
IF ERRORLEVEL 0 (
	REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StoreAppsOnTaskbar" /t REG_DWORD /d 0 /f
)

ECHO "Enable DOS Prompt Quick Edit"
REG QUERY "HKEY_CURRENT_USER\Console" /v "QuickEdit" | Find "0x0"
IF ERRORLEVEL 0 (
	REG ADD "HKEY_CURRENT_USER\Console" /v "QuickEdit" /t REG_DWORD /d 1 /f
)

ECHO "Enable DOS Prompt Insert Mode"
REG QUERY "HKEY_CURRENT_USER\Console" /v "InsertMode" | Find "0x0"
IF ERRORLEVEL 0 (
	REG ADD "HKEY_CURRENT_USER\Console" /v "InsertMode" /t REG_DWORD /d 1 /f
)

ECHO "Disable Windows System Restore"
REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v "DisableSR" | Find "0x0"
IF ERRORLEVEL 0 (
	REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v "DisableSR" /t REG_DWORD /d 1 /f
)

ECHO "Disable Remote Assistance"
REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fAllowToGetHelp" | Find "0x0"
IF ERRORLEVEL 0 (
	REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fAllowToGetHelp" /t REG_DWORD /d 0 /f
)

ECHO "Enable Remote Desktop Protocol (RDP)"
REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" | Find "0x0"
IF ERRORLEVEL 0 (
	REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 0 /f
)

ECHO "Disableing Hibernate"
powercfg.exe -h off

ECHO "Installing Chocolatey"
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
choco feature enable -n allowGlobalConfirmation

ECHO "Installing Git"
CALL cinst git

ECHO "Installing Notepad++"
CALL cinst notepadplusplus

ECHO "Installing 7zip"
CALL cinst 7zip

ECHO "Installing Classic Shell"
CALL cinst classic-shell -installArgs ADDLOCAL=ClassicStartMenu

ECHO "Installing Visual Studio Components"
IF NOT EXIST "%PROGRAMFILES(X86)%\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe" (
   ECHO Installing Visual Studio 2015
   CALL cinst VisualStudio2015Enterprise -force
)
CALL cinst resharper

ECHO "Script complete. Restart now."
