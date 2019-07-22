/*
 *         _____
 *  ______ ___(_)______ ____________________________  ______  __
 *  _  __ `/_  /__  __ `__ \__  __ \_  ___/  __ \_  |/_/_  / / /
 *  / /_/ /_  / _  / / / / /_  /_/ /  /   / /_/ /_>  < _  /_/ /
 *  \__,_/ /_/  /_/ /_/ /_/_  .___//_/    \____//_/|_| _\__, /
 *                         /_/                         /____/
 *
 *                                                 Version 0.1.0
 *
 *           Micael Dias (@aimproxy) <diasmicaelandre@gmail.com>
 *
 *  ============================================================
 *
 *  Copyright (C) [2019] [Micael DIAS (@aimproxy)]
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 *  ============================================================
 *
 */

using App.Configs;
using App.Widgets;
using App.Views;

namespace App.Windows {

    public class MainWindow : Gtk.ApplicationWindow {

        public static GLib.Settings settings;
        public static Gtk.Stack stack;
        public static FontInfo font_info;
        Gtk.CssProvider provider;
        Gtk.Paned g_fonts;
        Sidebar sidebar;
        HeaderBar header;
        WelcomeView welcome;

        public MainWindow (Gtk.Application app) {
            Object (
                application: app,
                icon_name: Constants.ICON,
                resizable: true,
                title: Constants.APP_NAME
            );

            settings = new GLib.Settings (Constants.ID);

            provider = new Gtk.CssProvider ();
            provider.load_from_resource (Constants.CSS);
            Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

            header = new HeaderBar ();
            this.set_titlebar (header);
            var header_context = header.get_style_context ();
            header_context.add_class ("titlebar");
            header_context.add_class ("default-decoration");

            var settings = App.Configs.Settings.get_instance ();
            int x = settings.window_x;
            int y = settings.window_y;
            int width = settings.window_width;
            int height = settings.window_height;

            // Set save position
            if (x != -1 && y != -1) {
                move (x, y);
            }

            // Set save size
            if (width != -1 && height != -1) {
                set_default_size (width, height);
            } else {
                set_default_size (1100, 690);
            }

            delete_event.connect (() => {
                int root_x, root_y;
                int root_w, root_h;
                get_position (out root_x, out root_y);
                get_size (out root_w, out root_h);

                settings.window_x = root_x;
                settings.window_y = root_y;
                settings.window_width = root_w;
                settings.window_height = root_h;
                return false;
            });

            g_fonts = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
            font_info = new FontInfo ();
            sidebar = new Sidebar ();
            g_fonts.set_position (256);
            g_fonts.pack1 (sidebar, false, false);
            g_fonts.pack2 (font_info, true, false);

            welcome = new WelcomeView ();

            stack = new Gtk.Stack ();
            stack.add_named (welcome, "welcome_view");
            stack.add_named (g_fonts, "sidebar_view");

            welcome.search_on_google_fonts.connect (() => {
                stack.set_visible_child_full ("sidebar_view", Gtk.StackTransitionType.SLIDE_LEFT);
            });

            stack.set_visible_child_name ("welcome_view");

            this.add (stack);
            this.show_all ();
        }
    }
}
