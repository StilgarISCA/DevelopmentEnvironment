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

ECHO "Remove Windows Store Apps icon from the Taskbar"
REG QUERY "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StoreAppsOnTaskbar" | Find "0x0"
IF ERRORLEVEL 0 (
	REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StoreAppsOnTaskbar" /t REG_DWORD /d 0 /f
)

ECHO "Disable Windows System Restore"
REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v "DisableConfig" | Find "0x0"
IF ERRORLEVEL 0 (
	REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v "DisableConfig" /t REG_DWORD /d 1 /f
)

ECHO "Installing Chocolatey"
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

ECHO "Installing Git"
CALL cinst git

ECHO "Installing Notepad++"
CALL cinst notepadplusplus

ECHO "Installing 7zip"
CALL cinst 7zip

ECHO "Script complete. Restart now."
