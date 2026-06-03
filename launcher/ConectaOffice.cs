using System;
using System.IO;
using System.Windows.Forms;

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
        private WebBrowser browser;

        public MainWindow()
        {
            this.Text = "ConectaOffice";
            this.Width = 1280;
            this.Height = 800;
            this.MinimumSize = new System.Drawing.Size(900, 600);
            this.WindowState = FormWindowState.Maximized;
            this.StartPosition = FormStartPosition.CenterScreen;
            this.BackColor = System.Drawing.Color.FromArgb(8, 8, 16);

            string iconPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "icon.ico");
            if (File.Exists(iconPath))
                this.Icon = new System.Drawing.Icon(iconPath);

            browser = new WebBrowser();
            browser.Dock = DockStyle.Fill;
            browser.ScriptErrorsSuppressed = true;
            browser.IsWebBrowserContextMenuEnabled = false;
            browser.WebBrowserShortcutsEnabled = false;
            this.Controls.Add(browser);
            this.Load += (s, e) => LoadPage();
        }

        private void LoadPage()
        {
            string appDir = AppDomain.CurrentDomain.BaseDirectory;
            string page = Path.Combine(appDir, "activacion.html");
            if (!File.Exists(page))
                page = Path.Combine(appDir, "suite.html");
            browser.Navigate(new Uri(page));
        }
    }
}
