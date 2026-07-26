; ============================================================
;  ME Launcher - Setup ONLINE (nho gon, ~1-3MB)
;
;  Khac voi ban .zip day du (~150-300MB co san Java + JavaFX):
;  file setup nay CHI la 1 "vo tai ve" - luc chay moi tu tai ban
;  that tu GitHub Releases ve may nguoi dung, roi giai nen + tao
;  shortcut. Can co mang luc CAI, khong can luc build script nay.
;
;  ------------------------------------------------------------
;  CACH BIEN DICH (lam 1 lan tren may ban):
;  1. Cai NSIS (mien phi): https://nsis.sourceforge.io/Download
;  2. Chuot phai vao file nay -> "Compile NSIS Script"
;     -> ra file ME-Launcher-Setup.exe, chi vai MB
;  (Khong can cai them plugin gi ca - dung PowerShell co san trong Windows
;  de tai va giai nen, xu ly HTTPS/chuyen huong tot hon plugin NSISdl)
;  ------------------------------------------------------------
; ============================================================

!include "MUI2.nsh"
!include "LogicLib.nsh"

Name "ME Launcher"
OutFile "ME-Launcher-Setup.exe"
InstallDir "$LOCALAPPDATA\ME Launcher"
InstallDirRegKey HKCU "Software\MELauncher" "InstallDir"
RequestExecutionLevel user
Unicode true

!define DOWNLOAD_URL "https://github.com/giahuybuhbuh-maker/ME-launcher-release/releases/download/v.0.0.9/ME-Launcher.zip"

!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

Section "Cai dat ME Launcher" SecInstall
    ; Khai báo tay dung luong can - script nay KHONG nhung file truc tiep
    ; (toan bo tai luc cai dat), nen NSIS khong tu tinh duoc "Space required"
    ; tu lenh File nhu binh thuong. 150MB = 153600 KB, sua so nay neu ban
    ; kiem tra dung luong that cua ban build khac di.
    AddSize 153600

    SetOutPath "$INSTDIR"
    SetDetailsPrint both

    DetailPrint "Dang tai ME Launcher tu GitHub (can ket noi mang)..."
    nsExec::ExecToLog 'powershell -NoProfile -ExecutionPolicy Unrestricted -Command "(New-Object System.Net.WebClient).DownloadFile(\"${DOWNLOAD_URL}\", \"$TEMP\me-launcher-download.zip\")"'
    Pop $0
    ${If} $0 != "0"
        MessageBox MB_ICONSTOP "Tai that bai (ma loi $0). Kiem tra lai ket noi mang roi thu lai."
        Abort
    ${EndIf}

    DetailPrint "Dang giai nen (dung PowerShell co san trong Windows)..."
    nsExec::ExecToLog 'powershell -NoProfile -ExecutionPolicy Unrestricted -Command "Expand-Archive -Path \"$TEMP\me-launcher-download.zip\" -DestinationPath \"$INSTDIR\" -Force"'
    Pop $0
    ${If} $0 != "0"
        MessageBox MB_ICONSTOP "Giai nen that bai (ma loi $0). Kiem tra $INSTDIR co du quyen ghi khong."
        Abort
    ${EndIf}

    Delete "$TEMP\me-launcher-download.zip"

    ; LUU Y: file zip tren GitHub cua ban co cau truc long ben trong
    ; (ME-Launcher\build\dist\ME Launcher\...), khong phai file .exe nam
    ; phang ngay ngoai cung - nen duong dan ben duoi phai tro sau vao dung
    ; cau truc nay, khong chi la "$INSTDIR\ME Launcher.exe".
    !define EXE_RELATIVE_PATH "ME-Launcher\build\dist\ME Launcher\ME Launcher.exe"

    CreateShortcut "$DESKTOP\ME Launcher.lnk" "$INSTDIR\${EXE_RELATIVE_PATH}" "" "$INSTDIR\${EXE_RELATIVE_PATH}" 0
    CreateDirectory "$SMPROGRAMS\ME Launcher"
    CreateShortcut "$SMPROGRAMS\ME Launcher\ME Launcher.lnk" "$INSTDIR\${EXE_RELATIVE_PATH}"
    CreateShortcut "$SMPROGRAMS\ME Launcher\Go cai dat ME Launcher.lnk" "$INSTDIR\Uninstall.exe"

    WriteRegStr HKCU "Software\MELauncher" "InstallDir" "$INSTDIR"
    WriteUninstaller "$INSTDIR\Uninstall.exe"

    ; Dang ky trong "Add or Remove Programs" cua Windows cho dung chuan
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\MELauncher" "DisplayName" "ME Launcher"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\MELauncher" "UninstallString" "$INSTDIR\Uninstall.exe"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\MELauncher" "InstallLocation" "$INSTDIR"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\MELauncher" "Publisher" "giahuybuhbuh-maker"

    DetailPrint "Cai dat xong!"
SectionEnd

Section "Uninstall"
    Delete "$DESKTOP\ME Launcher.lnk"
    RMDir /r "$SMPROGRAMS\ME Launcher"
    RMDir /r "$INSTDIR"
    DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\MELauncher"
    DeleteRegKey HKCU "Software\MELauncher"
SectionEnd
