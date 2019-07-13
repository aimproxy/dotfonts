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

namespace App.Views {
    public class FontView : Granite.SimpleSettingsPage {

        public FontView () {
            Object (
                title: "",
                description: ""
            );
        }

        construct {
            var snippet_css_title = new Gtk.Label (_("Specify in CSS"));
            snippet_css_title.margin_top = 5;
            snippet_css_title.xalign = 0;
            snippet_css_title.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);

            var source_buffer = new Gtk.SourceBuffer (null);
            source_buffer.highlight_syntax = true;
            source_buffer.language = Gtk.SourceLanguageManager.get_default ().get_language ("css");
            source_buffer.style_scheme = new Gtk.SourceStyleSchemeManager ().get_scheme ("solarized-light");

            var source_view_css = new Gtk.SourceView ();
            source_view_css.buffer = source_buffer;
            source_view_css.editable = false;
            source_view_css.left_margin = source_view_css.right_margin = 6;
            source_view_css.monospace = true;
            source_view_css.pixels_above_lines = source_view_css.pixels_below_lines = 3;
            source_view_css.show_line_numbers = true;

            var snippet_css = new Gtk.Grid ();
            snippet_css.get_style_context ().add_class ("code");
            snippet_css.add (source_view_css);

            content_area.orientation = Gtk.Orientation.VERTICAL;
            content_area.add (snippet_css_title);
            content_area.add (snippet_css);

            notify["title"].connect (() => {
                source_buffer.text = "font-family: \'%s\'".printf (title);
            });
            show_all ();
        }
    }
}
