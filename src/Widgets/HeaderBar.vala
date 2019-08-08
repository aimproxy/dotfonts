/*
 *         _____
 *  ______ ___(_)______ ____________________________  ______  __
 *  _  __ `/_  /__  __ `__ \__  __ \_  ___/  __ \_  |/_/_  / / /
 *  / /_/ /_  / _  / / / / /_  /_/ /  /   / /_/ /_>  < _  /_/ /
 *  \__,_/ /_/  /_/ /_/ /_/_  .___//_/    \____//_/|_| _\__, /
 *                         /_/                         /____/
 *
 */

using App.Configs;
using App.Windows;
using App.Services;
using App.Views;

namespace App.Widgets {

    public class HeaderBar : Gtk.HeaderBar {

        Gtk.Settings gtk_settings;
        Granite.ModeSwitch mode_switch;
        public Gtk.Button go_back;

        public HeaderBar () {
            this.show_close_button = true;
            this.set_title ("DotFonts");

            gtk_settings = Gtk.Settings.get_default ();

            mode_switch = new Granite.ModeSwitch.from_icon_name ("display-brightness-symbolic", "weather-clear-night-symbolic");
            mode_switch.primary_icon_tooltip_text = "Light";
            mode_switch.secondary_icon_tooltip_text = "Dark";
            mode_switch.valign = Gtk.Align.CENTER;
            mode_switch.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");

            var context = get_style_context ();
            mode_switch.notify["active"].connect (() => {
                detect_dark_mode (gtk_settings, context);
            });

            MainWindow.settings.bind ("use-dark-theme", mode_switch, "active", GLib.SettingsBindFlags.DEFAULT);

            this.pack_end (mode_switch);
        }

        private void detect_dark_mode (Gtk.Settings gtk_settings, Gtk.StyleContext context) {
            if (gtk_settings.gtk_application_prefer_dark_theme) {
                App.Configs.Settings.get_instance ().use_dark_theme = true;
                context.add_class ("dark");
            } else {
                App.Configs.Settings.get_instance ().use_dark_theme = false;
                context.remove_class ("dark");
            }
        }
    }

}
