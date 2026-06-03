@echo off
:: ============================================================
:: ConectaOffice — Compilar lanzador .exe
:: Ejecutar este script en Windows (como Administrador)
:: No requiere Visual Studio ni Node.js
:: ============================================================

title Compilando ConectaOffice...
color 0A
echo.
echo  ============================================
echo   ConectaOffice — Build Script
echo   ConectaERP 2025
echo  ============================================
echo.

:: ── Verificar .NET Framework (incluido en Windows 10/11) ────
set CSC=""
for /f "delims=" %%i in ('where csc.exe 2^>nul') do set CSC="%%i"

if %CSC%=="" (
    :: Buscar csc.exe en .NET Framework
    for %%v in (4.0 3.5 2.0) do (
        if exist "%WINDIR%\Microsoft.NET\Framework64\v%%v*\csc.exe" (
            for /d %%d in ("%WINDIR%\Microsoft.NET\Framework64\v%%v*") do (
                set CSC="%%d\csc.exe"
            )
        )
    )
)

if %CSC%=="" (
    echo [ERROR] No se encontro csc.exe
    echo         Asegurate de tener .NET Framework instalado.
    echo         Descargalo en: https://dotnet.microsoft.com/download/dotnet-framework
    pause
    exit /b 1
)

echo [OK] Compilador encontrado: %CSC%
echo.

:: ── Verificar NuGet / WebView2 SDK ──────────────────────────
if not exist "launcher\packages\Microsoft.Web.WebView2\lib\net45\Microsoft.Web.WebView2.WinForms.dll" (
    echo [INFO] Descargando WebView2 SDK...
    if not exist "launcher\packages" mkdir "launcher\packages"
    
    :: Usar PowerShell para descargar NuGet
    powershell -Command ^
        "Invoke-WebRequest -Uri 'https://www.nuget.org/api/v2/package/Microsoft.Web.WebView2/1.0.2849.39' -OutFile 'launcher\webview2.nupkg'" ^
        2>nul
    
    if exist "launcher\webview2.nupkg" (
        powershell -Command ^
            "Expand-Archive -Path 'launcher\webview2.nupkg' -DestinationPath 'launcher\packages\Microsoft.Web.WebView2' -Force" ^
            2>nul
        echo [OK] WebView2 SDK descargado
    ) else (
        echo [WARN] No se pudo descargar WebView2 SDK automaticamente.
        echo        Descargalo manualmente desde: https://developer.microsoft.com/microsoft-edge/webview2/
        echo        Y coloca Microsoft.Web.WebView2.WinForms.dll en launcher\packages\
    )
)

:: ── Compilar ConectaOffice.exe ───────────────────────────────
echo [INFO] Compilando ConectaOffice.exe...

set WEBVIEW_DLL="launcher\packages\Microsoft.Web.WebView2\lib\net45\Microsoft.Web.WebView2.WinForms.dll"
set WEBVIEW_CORE="launcher\packages\Microsoft.Web.WebView2\lib\net45\Microsoft.Web.WebView2.Core.dll"

%CSC% ^
    /target:winexe ^
    /out:"assets\ConectaOffice.exe" ^
    /win32icon:"assets\icon.ico" ^
    /r:System.Windows.Forms.dll ^
    /r:System.Drawing.dll ^
    /r:%WEBVIEW_DLL% ^
    /r:%WEBVIEW_CORE% ^
    "launcher\ConectaOffice.cs"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] La compilacion fallo. Revisa los errores arriba.
    pause
    exit /b 1
)

:: ── Copiar DLLs necesarias junto al .exe ────────────────────
echo [INFO] Copiando DLLs de WebView2...
copy /Y "launcher\packages\Microsoft.Web.WebView2\lib\net45\Microsoft.Web.WebView2.WinForms.dll" "assets\" >nul
copy /Y "launcher\packages\Microsoft.Web.WebView2\lib\net45\Microsoft.Web.WebView2.Core.dll"     "assets\" >nul
copy /Y "launcher\packages\Microsoft.Web.WebView2\runtimes\win-x64\native\WebView2Loader.dll"    "assets\" >nul 2>nul

echo.
echo [OK] ConectaOffice.exe compilado correctamente en assets\
echo.

:: ── Compilar el instalador NSIS ─────────────────────────────
echo [INFO] Buscando NSIS...
set MAKENSIS=""

for %%p in (
    "C:\Program Files (x86)\NSIS\makensis.exe"
    "C:\Program Files\NSIS\makensis.exe"
) do (
    if exist %%p set MAKENSIS=%%p
)

if %MAKENSIS%=="" (
    echo [WARN] NSIS no encontrado.
    echo        Descargalo gratis en: https://nsis.sourceforge.io/Download
    echo        Luego ejecuta:
    echo          makensis ConectaOffice-Setup.nsi
    echo.
    echo  El archivo assets\ConectaOffice.exe ya esta listo.
    echo  Solo necesitas NSIS para generar el instalador .exe final.
    pause
    exit /b 0
)

echo [INFO] Compilando instalador NSIS...
%MAKENSIS% ConectaOffice-Setup.nsi

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] NSIS fallo. Revisa ConectaOffice-Setup.nsi
    pause
    exit /b 1
)

echo.
echo  ============================================
echo   LISTO: ConectaOffice-Setup-1.0.0.exe
echo  ============================================
echo.
echo  Distribuyelo a tus clientes.
echo  Al hacer doble clic instala ConectaOffice
echo  sin necesidad de nada adicional.
echo.
pause
