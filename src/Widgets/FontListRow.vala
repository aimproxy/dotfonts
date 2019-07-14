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

namespace App.Widgets {

    public class FontListRow : Gtk.ListBoxRow {

        public string font_family { get; construct; }
        public string font_category { get; construct; }
        public Array<string> font_variants { get; construct; }

        public FontListRow (string family, string category, Array<string> variants) {
            Object (
                font_family: family,
                font_category: category,
                font_variants: variants
            );
        }

        construct {
            var icon = new Gtk.Image ();
            icon.icon_name = "font-x-generic";
            icon.pixel_size = 24;

            var label = new Gtk.Label (font_family);
            label.ellipsize = Pango.EllipsizeMode.MIDDLE;

            var grid = new Gtk.Grid ();
            grid.column_spacing = 12;
            grid.margin = 3;
            grid.margin_start = 6;
            grid.margin_end = 6;
            grid.add (icon);
            grid.add (label);

            add(grid);
        }
    }
}
