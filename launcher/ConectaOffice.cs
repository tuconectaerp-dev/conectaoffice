// ============================================================
// ConectaOffice.exe — Lanzador nativo Windows con WebView2
// Compilar (incluido en Windows, no necesita Visual Studio):
//   csc.exe ConectaOffice.cs /target:winexe /r:Microsoft.Web.WebView2.WinForms.dll
// O con el script build.bat incluido en este ZIP
// ============================================================

using System;
using System.IO;
using System.Windows.Forms;
using Microsoft.Web.WebView2.Core;
using Microsoft.Web.WebView2.WinForms;

namespace ConectaOffice
{
    static class Program
    {
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainWindow());
        }
    }

    public class MainWindow : Form
    {
        private WebView2 webView;

        public MainWindow()
        {
            // ── Configuración de la ventana ──────────────────
            this.Text            = "ConectaOffice";
            this.Width           = 1280;
            this.Height          = 800;
            this.MinimumSize     = new System.Drawing.Size(900, 600);
            this.WindowState     = FormWindowState.Maximized;
            this.StartPosition   = FormStartPosition.CenterScreen;
            this.BackColor       = System.Drawing.Color.FromArgb(8, 8, 16);

            // Ícono
            string iconPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "icon.ico");
            if (File.Exists(iconPath))
                this.Icon = new System.Drawing.Icon(iconPath);

            // ── WebView2 ─────────────────────────────────────
            webView = new WebView2();
            webView.Dock = DockStyle.Fill;
            this.Controls.Add(webView);

            this.Load += async (s, e) => await InitWebView();
        }

        private async System.Threading.Tasks.Task InitWebView()
        {
            // Carpeta de datos del usuario
            string userDataFolder = Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
                "ConectaOffice", "UserData"
            );

            var env = await CoreWebView2Environment.CreateAsync(
                userDataFolder: userDataFolder
            );

            await webView.EnsureCoreWebView2Async(env);

            // Configurar WebView2
            webView.CoreWebView2.Settings.IsStatusBarEnabled      = false;
            webView.CoreWebView2.Settings.AreDevToolsEnabled       = false;
            webView.CoreWebView2.Settings.IsZoomControlEnabled     = false;
            webView.CoreWebView2.Settings.AreDefaultContextMenusEnabled = false;
            webView.CoreWebView2.Settings.IsBuiltInErrorPageEnabled = false;

            // Exponer funciones nativas al JavaScript de la suite
            webView.CoreWebView2.AddHostObjectToScript("nativeApp", new NativeBridge(this));

            // Navegar a la pantalla de activación
            string appDir    = AppDomain.CurrentDomain.BaseDirectory;
            string firstPage = Path.Combine(appDir, "activacion.html");

            if (!File.Exists(firstPage))
            {
                // Si no existe activacion.html, ir directo a la suite
                firstPage = Path.Combine(appDir, "suite.html");
            }

            webView.CoreWebView2.Navigate("file:///" + firstPage.Replace("\\", "/"));
        }

        // ── Navegar a otra página desde JS ───────────────────
        public void NavigateTo(string page)
        {
            string appDir  = AppDomain.CurrentDomain.BaseDirectory;
            string path    = Path.Combine(appDir, page);
            webView.CoreWebView2.Navigate("file:///" + path.Replace("\\", "/"));
        }
    }

    // ── Puente nativo expuesto al JavaScript ─────────────────
    [System.Runtime.InteropServices.ComVisible(true)]
    public class NativeBridge
    {
        private MainWindow _window;

        public NativeBridge(MainWindow window)
        {
            _window = window;
        }

        // Llamado desde JS: window.chrome.webview.hostObjects.nativeApp.OpenSuite()
        public void OpenSuite()
        {
            _window.Invoke(new Action(() => _window.NavigateTo("suite.html")));
        }

        public void OpenActivation()
        {
            _window.Invoke(new Action(() => _window.NavigateTo("activacion.html")));
        }

        public void CloseApp()
        {
            _window.Invoke(new Action(() => Application.Exit()));
        }

        public string GetVersion()
        {
            return "1.0.0";
        }
    }
}
