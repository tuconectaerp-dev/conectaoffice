; ============================================================
; ConectaOffice — Instalador NSIS
; ConectaERP © 2025
; ============================================================

Unicode True

!include "MUI2.nsh"
!include "FileFunc.nsh"
!include "LogicLib.nsh"
!include "WinVer.nsh"

!define PRODUCT_NAME        "ConectaOffice"
!define PRODUCT_VERSION     "1.0.0"
!define PRODUCT_PUBLISHER   "ConectaERP"
!define PRODUCT_URL         "https://conectaerp.com"
!define PRODUCT_EXE         "ConectaOffice.exe"
!define INSTALL_DIR         "$PROGRAMFILES64\ConectaERP\ConectaOffice"
!define UNINSTALL_KEY       "Software\Microsoft\Windows\CurrentVersion\Uninstall\ConectaOffice"
!define REG_KEY             "Software\ConectaERP\ConectaOffice"

Name                  "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile               "ConectaOffice-Setup-${PRODUCT_VERSION}.exe"
InstallDir            "${INSTALL_DIR}"
InstallDirRegKey      HKLM "${REG_KEY}" "InstallPath"
RequestExecutionLevel admin
SetCompressor         /SOLID lzma

!define MUI_ICON              "assets\icon.ico"
!define MUI_UNICON            "assets\icon.ico"
!define MUI_ABORTWARNING

!define MUI_WELCOMEPAGE_TITLE  "Bienvenido al instalador de ConectaOffice"
!define MUI_WELCOMEPAGE_TEXT   "Este asistente instalará ConectaOffice en tu equipo.$\r$\n$\r$\nSe recomienda cerrar todas las aplicaciones antes de continuar."

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE      "assets\license.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "Spanish"

!define MUI_FINISHPAGE_RUN         "$INSTDIR\${PRODUCT_EXE}"
!define MUI_FINISHPAGE_RUN_TEXT    "Ejecutar ConectaOffice ahora"
!define MUI_FINISHPAGE_LINK        "Visitar conectaerp.com"
!define MUI_FINISHPAGE_LINK_LOCATION "https://conectaerp.com"

VIProductVersion "1.0.0.0"
VIAddVersionKey /LANG=${LANG_SPANISH} "ProductName"     "${PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_SPANISH} "ProductVersion"  "${PRODUCT_VERSION}"
VIAddVersionKey /LANG=${LANG_SPANISH} "CompanyName"     "${PRODUCT_PUBLISHER}"
VIAddVersionKey /LANG=${LANG_SPANISH} "LegalCopyright"  "© 2025 ConectaERP"
VIAddVersionKey /LANG=${LANG_SPANISH} "FileDescription" "Instalador de ConectaOffice"
VIAddVersionKey /LANG=${LANG_SPANISH} "FileVersion"     "${PRODUCT_VERSION}"

Section "ConectaOffice" SEC_MAIN

  SectionIn RO
  SetOutPath "$INSTDIR"
  SetOverwrite on

  File "assets\suite.html"
  File "assets\activacion.html"
  File "assets\splash.html"
  File "assets\icon.ico"
  File "assets\ConectaOffice.exe"

  WriteRegStr   HKLM "${REG_KEY}" "InstallPath"  "$INSTDIR"
  WriteRegStr   HKLM "${REG_KEY}" "Version"      "${PRODUCT_VERSION}"
  WriteRegStr   HKLM "${REG_KEY}" "Publisher"    "${PRODUCT_PUBLISHER}"

  WriteRegStr   HKLM "${UNINSTALL_KEY}" "DisplayName"     "${PRODUCT_NAME}"
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "DisplayVersion"  "${PRODUCT_VERSION}"
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "Publisher"       "${PRODUCT_PUBLISHER}"
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "URLInfoAbout"    "${PRODUCT_URL}"
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "DisplayIcon"     "$INSTDIR\icon.ico"
  WriteRegDWORD HKLM "${UNINSTALL_KEY}" "NoModify"        1
  WriteRegDWORD HKLM "${UNINSTALL_KEY}" "NoRepair"        1

  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD HKLM "${UNINSTALL_KEY}" "EstimatedSize" "$0"

  CreateShortcut "$DESKTOP\ConectaOffice.lnk" "$INSTDIR\${PRODUCT_EXE}" "" "$INSTDIR\icon.ico"
  CreateDirectory "$SMPROGRAMS\ConectaERP"
  CreateShortcut  "$SMPROGRAMS\ConectaERP\ConectaOffice.lnk" "$INSTDIR\${PRODUCT_EXE}" "" "$INSTDIR\icon.ico"
  CreateShortcut  "$SMPROGRAMS\ConectaERP\Desinstalar ConectaOffice.lnk" "$INSTDIR\Uninstall.exe"

  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

Section "Uninstall"

  Delete "$INSTDIR\suite.html"
  Delete "$INSTDIR\activacion.html"
  Delete "$INSTDIR\splash.html"
  Delete "$INSTDIR\icon.ico"
  Delete "$INSTDIR\${PRODUCT_EXE}"
  Delete "$INSTDIR\Uninstall.exe"
  RMDir  "$INSTDIR"
  RMDir  "$PROGRAMFILES64\ConectaERP"

  Delete "$DESKTOP\ConectaOffice.lnk"
  Delete "$SMPROGRAMS\ConectaERP\ConectaOffice.lnk"
  Delete "$SMPROGRAMS\ConectaERP\Desinstalar ConectaOffice.lnk"
  RMDir  "$SMPROGRAMS\ConectaERP"

  DeleteRegKey HKLM "${UNINSTALL_KEY}"
  DeleteRegKey HKLM "${REG_KEY}"

SectionEnd

Function .onInit
  ${IfNot} ${AtLeastWin10}
    MessageBox MB_ICONSTOP "ConectaOffice requiere Windows 10 o superior."
    Abort
  ${EndIf}
FunctionEnd
