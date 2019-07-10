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

namespace App.Windows {

    public class MainWindow : Gtk.ApplicationWindow {

        public static GLib.Settings settings;

        public MainWindow (Gtk.Application app) {
            Object (
                application: app,
                icon_name: Constants.ICON,
                resizable: true,
                title: Constants.APP_NAME
            );

            settings = new GLib.Settings (Constants.ID);

            var provider = new Gtk.CssProvider ();
            provider.load_from_resource (Constants.CSS);
            Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

            var header = new HeaderBar ();
            this.set_titlebar (header);

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
                set_default_size (1094, 690);
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
        }
    }
}
