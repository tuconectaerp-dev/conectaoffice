; ============================================================
; ConectaOffice — Instalador NSIS
; ConectaERP © 2025
; Compilar: makensis ConectaOffice-Setup.nsi
; ============================================================

Unicode True

; ── Plugins requeridos (incluidos en NSIS 3.x) ──────────────
; nsDialogs, LangFile, MUI2, nsExec, FileFunc

!include "MUI2.nsh"
!include "FileFunc.nsh"
!include "LogicLib.nsh"
!include "WinVer.nsh"

; ── Información del producto ─────────────────────────────────
!define PRODUCT_NAME        "ConectaOffice"
!define PRODUCT_VERSION     "1.0.0"
!define PRODUCT_PUBLISHER   "ConectaERP"
!define PRODUCT_URL         "https://conectaerp.com"
!define PRODUCT_EXE         "ConectaOffice.exe"
!define INSTALL_DIR         "$PROGRAMFILES64\ConectaERP\ConectaOffice"
!define UNINSTALL_KEY       "Software\Microsoft\Windows\CurrentVersion\Uninstall\ConectaOffice"
!define REG_KEY             "Software\ConectaERP\ConectaOffice"

; ── Configuración del instalador ─────────────────────────────
Name                  "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile               "ConectaOffice-Setup-${PRODUCT_VERSION}.exe"
InstallDir            "${INSTALL_DIR}"
InstallDirRegKey      HKLM "${REG_KEY}" "InstallPath"
RequestExecutionLevel admin
SetCompressor         /SOLID lzma
SetCompress           auto

; ── Ícono ────────────────────────────────────────────────────
!define MUI_ICON              "assets\icon.ico"
!define MUI_UNICON            "assets\icon.ico"

; ── MUI: apariencia ──────────────────────────────────────────
!define MUI_ABORTWARNING
!define MUI_ABORTWARNING_TEXT "¿Seguro que deseas cancelar la instalación de ConectaOffice?"
!define MUI_WELCOMEFINISHPAGE_BITMAP_NOSTRETCH

; Colores de cabecera (azul ConectaERP)
!define MUI_BGCOLOR           "FFFFFF"
!define MUI_TEXTCOLOR         "1A1A1A"

; ── Páginas del instalador ───────────────────────────────────
; Página de bienvenida personalizada
!define MUI_WELCOMEPAGE_TITLE     "Bienvenido al instalador de ConectaOffice"
!define MUI_WELCOMEPAGE_TEXT      "Este asistente te guiará durante la instalación de ConectaOffice $\"Suite completa de productividad para empresas$\".$\r$\n$\r$\nIncluyendo: ConectaWord · ConectaExcel · ConectaPoint · ConectaMail · ConectaTeams · ConectaCalendar · ConectaNote · ConectaDrive · ConectaForms$\r$\n$\r$\nSe recomienda cerrar todas las aplicaciones antes de continuar."

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE      "assets\license.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Páginas del desinstalador
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; ── Idioma ───────────────────────────────────────────────────
!insertmacro MUI_LANGUAGE "Spanish"

; ── Textos personalizados en español ─────────────────────────
LangString MUI_TEXT_WELCOME_INFO_TITLE    ${LANG_SPANISH} "Bienvenido a ConectaOffice"
LangString MUI_TEXT_WELCOME_INFO_TEXT     ${LANG_SPANISH} "Este asistente instalará ConectaOffice en tu equipo.$\r$\n$\r$\nCierra todas las aplicaciones antes de continuar."
LangString MUI_TEXT_LICENSE_TITLE         ${LANG_SPANISH} "Acuerdo de Licencia"
LangString MUI_TEXT_LICENSE_SUBTITLE      ${LANG_SPANISH} "Lee atentamente el acuerdo antes de instalar ConectaOffice."
LangString MUI_TEXT_DIRECTORY_TITLE       ${LANG_SPANISH} "Carpeta de instalación"
LangString MUI_TEXT_DIRECTORY_SUBTITLE    ${LANG_SPANISH} "Elige dónde instalar ConectaOffice."
LangString MUI_TEXT_INSTALLING_TITLE      ${LANG_SPANISH} "Instalando ConectaOffice"
LangString MUI_TEXT_INSTALLING_SUBTITLE   ${LANG_SPANISH} "Por favor espera mientras se instala ConectaOffice…"
LangString MUI_TEXT_FINISH_TITLE          ${LANG_SPANISH} "Instalación completada"
LangString MUI_TEXT_FINISH_SUBTITLE       ${LANG_SPANISH} "ConectaOffice se instaló correctamente."
LangString MUI_TEXT_ABORT_TITLE           ${LANG_SPANISH} "Instalación cancelada"
LangString MUI_TEXT_ABORT_SUBTITLE        ${LANG_SPANISH} "La instalación fue cancelada."
LangString MUI_BUTTONTEXT_FINISH          ${LANG_SPANISH} "Finalizar"
LangString MUI_TEXT_FINISH_INFO_TITLE     ${LANG_SPANISH} "ConectaOffice instalado"
LangString MUI_TEXT_FINISH_INFO_TEXT      ${LANG_SPANISH} "ConectaOffice se ha instalado en tu equipo.$\r$\n$\r$\nAl ejecutar por primera vez deberás ingresar tu código de licencia.$\r$\n$\r$\nHaz clic en Finalizar para cerrar este asistente."
LangString MUI_TEXT_FINISH_RUN            ${LANG_SPANISH} "Ejecutar ConectaOffice ahora"
LangString MUI_UNTEXT_CONFIRM_TITLE       ${LANG_SPANISH} "Desinstalar ConectaOffice"
LangString MUI_UNTEXT_CONFIRM_SUBTITLE    ${LANG_SPANISH} "Se eliminará ConectaOffice de tu equipo."
LangString MUI_UNTEXT_FINISH_TITLE        ${LANG_SPANISH} "Desinstalación completada"
LangString MUI_UNTEXT_FINISH_SUBTITLE     ${LANG_SPANISH} "ConectaOffice fue eliminado correctamente."

; ── Página de finalización: ejecutar la app ──────────────────
!define MUI_FINISHPAGE_RUN         "$INSTDIR\${PRODUCT_EXE}"
!define MUI_FINISHPAGE_RUN_TEXT    "Ejecutar ConectaOffice ahora"
!define MUI_FINISHPAGE_SHOWREADME  ""
!define MUI_FINISHPAGE_LINK        "Visitar conectaerp.com"
!define MUI_FINISHPAGE_LINK_LOCATION "https://conectaerp.com"

; ── Versión Info del .exe ────────────────────────────────────
VIProductVersion "${PRODUCT_VERSION}.0"
VIAddVersionKey /LANG=${LANG_SPANISH} "ProductName"      "${PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_SPANISH} "ProductVersion"   "${PRODUCT_VERSION}"
VIAddVersionKey /LANG=${LANG_SPANISH} "CompanyName"      "${PRODUCT_PUBLISHER}"
VIAddVersionKey /LANG=${LANG_SPANISH} "LegalCopyright"   "© 2025 ConectaERP"
VIAddVersionKey /LANG=${LANG_SPANISH} "FileDescription"  "Instalador de ConectaOffice"
VIAddVersionKey /LANG=${LANG_SPANISH} "FileVersion"      "${PRODUCT_VERSION}"

; ============================================================
; SECCIÓN PRINCIPAL — INSTALACIÓN
; ============================================================
Section "ConectaOffice" SEC_MAIN

  SectionIn RO   ; No desmarcable

  SetOutPath "$INSTDIR"
  SetOverwrite on

  ; ── Archivos principales ────────────────────────────────
  File "assets\suite.html"
  File "assets\activacion.html"
  File "assets\splash.html"
  File "assets\icon.ico"

  ; ── Ejecutable principal (lanzador HTA) ─────────────────
  ; ConectaOffice.exe es un lanzador que abre suite.html
  ; con el motor WebView2 de Windows (ya incluido en Win10/11)
  File "assets\ConectaOffice.exe"
  File "assets\WebView2Loader.dll"

  ; ── Archivos de datos ───────────────────────────────────
  SetOutPath "$INSTDIR\data"
  File /r "assets\data\*.*"

  ; ── Registro de Windows ─────────────────────────────────
  WriteRegStr   HKLM "${REG_KEY}" "InstallPath"  "$INSTDIR"
  WriteRegStr   HKLM "${REG_KEY}" "Version"      "${PRODUCT_VERSION}"
  WriteRegStr   HKLM "${REG_KEY}" "Publisher"    "${PRODUCT_PUBLISHER}"

  ; ── Entradas de desinstalación ──────────────────────────
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "DisplayName"          "${PRODUCT_NAME}"
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "DisplayVersion"       "${PRODUCT_VERSION}"
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "Publisher"            "${PRODUCT_PUBLISHER}"
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "URLInfoAbout"         "${PRODUCT_URL}"
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "InstallLocation"      "$INSTDIR"
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "UninstallString"      "$INSTDIR\Uninstall.exe"
  WriteRegStr   HKLM "${UNINSTALL_KEY}" "DisplayIcon"          "$INSTDIR\icon.ico"
  WriteRegDWORD HKLM "${UNINSTALL_KEY}" "NoModify"             1
  WriteRegDWORD HKLM "${UNINSTALL_KEY}" "NoRepair"             1

  ; Calcular tamaño instalado
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD HKLM "${UNINSTALL_KEY}" "EstimatedSize" "$0"

  ; ── Acceso directo en Escritorio ────────────────────────
  CreateShortcut "$DESKTOP\ConectaOffice.lnk" \
    "$INSTDIR\${PRODUCT_EXE}" "" \
    "$INSTDIR\icon.ico" 0 \
    SW_SHOWNORMAL "" "ConectaOffice"

  ; ── Acceso directo en Menú Inicio ───────────────────────
  CreateDirectory "$SMPROGRAMS\ConectaERP"
  CreateShortcut  "$SMPROGRAMS\ConectaERP\ConectaOffice.lnk" \
    "$INSTDIR\${PRODUCT_EXE}" "" \
    "$INSTDIR\icon.ico" 0 \
    SW_SHOWNORMAL "" "ConectaOffice"
  CreateShortcut  "$SMPROGRAMS\ConectaERP\Desinstalar ConectaOffice.lnk" \
    "$INSTDIR\Uninstall.exe"

  ; ── Desinstalador ───────────────────────────────────────
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

; ============================================================
; SECCIÓN DESINSTALACIÓN
; ============================================================
Section "Uninstall"

  ; Eliminar archivos instalados
  Delete "$INSTDIR\suite.html"
  Delete "$INSTDIR\activacion.html"
  Delete "$INSTDIR\splash.html"
  Delete "$INSTDIR\icon.ico"
  Delete "$INSTDIR\${PRODUCT_EXE}"
  Delete "$INSTDIR\WebView2Loader.dll"
  Delete "$INSTDIR\Uninstall.exe"
  RMDir  /r "$INSTDIR\data"
  RMDir  "$INSTDIR"
  RMDir  "$PROGRAMFILES64\ConectaERP"

  ; Eliminar accesos directos
  Delete "$DESKTOP\ConectaOffice.lnk"
  Delete "$SMPROGRAMS\ConectaERP\ConectaOffice.lnk"
  Delete "$SMPROGRAMS\ConectaERP\Desinstalar ConectaOffice.lnk"
  RMDir  "$SMPROGRAMS\ConectaERP"

  ; Limpiar registro
  DeleteRegKey HKLM "${UNINSTALL_KEY}"
  DeleteRegKey HKLM "${REG_KEY}"

SectionEnd

; ============================================================
; FUNCIONES
; ============================================================

; Verificar Windows 10 o superior (necesario para WebView2)
Function .onInit
  ${IfNot} ${AtLeastWin10}
    MessageBox MB_ICONSTOP "ConectaOffice requiere Windows 10 o superior."
    Abort
  ${EndIf}
FunctionEnd

; Mensaje de confirmación al cancelar
Function .onUserAbort
  MessageBox MB_YESNO|MB_ICONQUESTION \
    "¿Deseas cancelar la instalación de ConectaOffice?" \
    IDYES abort
  Abort
  abort:
FunctionEnd
