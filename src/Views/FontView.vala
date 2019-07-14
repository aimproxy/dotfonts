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
                title: "Roboto",
                description: "sans-serif"
            );
        }

        construct {
            var snippet_css_title = new Gtk.Label (_("Specify in CSS"));
            snippet_css_title.margin_top = 5;
            snippet_css_title.xalign = 0;
            snippet_css_title.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);

            var snippet_html_title = new Gtk.Label (_("Embed in HTML"));
            snippet_html_title.margin_top = 5;
            snippet_html_title.xalign = 0;
            snippet_html_title.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);

            var source_buffer_css = new Gtk.SourceBuffer (null);
            source_buffer_css.highlight_syntax = true;
            source_buffer_css.language = Gtk.SourceLanguageManager.get_default ().get_language ("css");
            source_buffer_css.style_scheme = new Gtk.SourceStyleSchemeManager ().get_scheme ("solarized-light");

            var source_buffer_html = new Gtk.SourceBuffer (null);
            source_buffer_html.highlight_syntax = true;
            source_buffer_html.language = Gtk.SourceLanguageManager.get_default ().get_language ("css");
            source_buffer_html.style_scheme = new Gtk.SourceStyleSchemeManager ().get_scheme ("solarized-light");

            var source_view_css = new Gtk.SourceView ();
            source_view_css.buffer = source_buffer_css;
            source_view_css.editable = false;
            source_view_css.left_margin = source_view_css.right_margin = 6;
            source_view_css.monospace = true;
            source_view_css.pixels_above_lines = source_view_css.pixels_below_lines = 3;
            source_view_css.show_line_numbers = true;

            var source_view_html = new Gtk.SourceView ();
            source_view_html.buffer = source_buffer_html;
            source_view_html.editable = false;
            source_view_html.left_margin = source_view_html.right_margin = 6;
            source_view_html.monospace = true;
            source_view_html.pixels_above_lines = source_view_html.pixels_below_lines = 4;
            source_view_html.show_line_numbers = true;

            var snippet_css = new Gtk.Grid ();
            snippet_css.get_style_context ().add_class ("code");
            snippet_css.add (source_view_css);

            var snippet_html = new Gtk.Grid ();
            snippet_html.get_style_context ().add_class ("code");
            snippet_html.add (source_view_html);

            content_area.orientation = Gtk.Orientation.VERTICAL;
            content_area.add (snippet_html_title);
            content_area.add (snippet_html);
            content_area.add (snippet_css_title);
            content_area.add (snippet_css);

            notify["title"].connect (() => {
                var embed_font = title;
                var regex = new Regex ("[\\s]");
                var new_embed_font = regex.replace (embed_font, -1, 0, "+");

                var msg_embed_html = "To embed your selected fonts into a webpage, copy this code into the <head> of your HTML document!";
                var msg_embed_css = "Use the following CSS rules to specify these families:";

                source_buffer_html.text = "/* %s */\n<link href=\"https://fonts.googleapis.com/css?family=%s&display=swap\" rel=\"stylesheet\">".printf (msg_embed_html, new_embed_font);
                source_buffer_css.text = "/* %s */\n@import url(\'https://fonts.googleapis.com/css?family=%s&display=swap\');\nfont-family: \'%s\';".printf (msg_embed_css, new_embed_font, title);
            });
            show_all ();
        }
    }
}
