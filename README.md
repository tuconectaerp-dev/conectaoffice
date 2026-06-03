# ConectaOffice — Instalador NSIS (.exe nativo Windows)

## Qué hay en este ZIP

```
ConectaOffice-NSIS/
├── ConectaOffice-Setup.nsi     ← Script NSIS (genera el instalador .exe)
├── build.bat                   ← Script que compila TODO automáticamente
├── launcher/
│   └── ConectaOffice.cs        ← Lanzador C# (WebView2 + WinForms)
└── assets/
    ├── suite.html              ← La suite completa (9 apps)
    ├── activacion.html         ← Pantalla de activación de licencia
    ├── splash.html             ← Pantalla de carga
    ├── icon.ico                ← Ícono de la app
    └── license.txt             ← EULA mostrado en el instalador
```

---

## Generar el ConectaOffice-Setup-1.0.0.exe

### Paso 1 — Instalar NSIS (gratis, 5 minutos)
Descargar en: https://nsis.sourceforge.io/Download
→ Instalar con opciones por defecto

### Paso 2 — Ejecutar el build
1. Descomprime este ZIP en tu PC Windows
2. Doble clic en **build.bat** (como Administrador)
3. El script:
   - Descarga WebView2 SDK automáticamente
   - Compila ConectaOffice.exe (el lanzador nativo)
   - Compila el instalador NSIS
4. Resultado: **ConectaOffice-Setup-1.0.0.exe** en la carpeta raíz

---

## Qué hace el .exe instalador

1. Muestra el asistente de instalación en español
2. El usuario acepta el EULA
3. Elige carpeta de instalación (por defecto: C:\Program Files\ConectaERP\ConectaOffice)
4. Instala los archivos
5. Crea acceso directo en Escritorio y Menú Inicio
6. Registra el desinstalador en "Agregar/quitar programas"
7. Opción de ejecutar ConectaOffice al finalizar

## Qué hace ConectaOffice.exe (la app instalada)

- Abre una ventana nativa de Windows
- Carga la pantalla de activación (activacion.html)
- El usuario ingresa su código de licencia
- Se valida contra office369.panel.conectaerp.com
- Si es válido, carga la suite completa (suite.html)
- Todo usando WebView2 (ya incluido en Windows 10/11, sin instalar nada)

## Requisitos del cliente final

- Windows 10 o superior
- Conexión a internet (para activación de licencia)
- Nada más — WebView2 ya viene con Windows 10/11

## Soporte
soporte@conectaerp.com
