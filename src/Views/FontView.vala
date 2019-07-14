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
        public string snippet_color_scheme = "solarized-dark";
        public string snippet_class = "code-dark";

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

            /*
            var costumize_fonts_title = new Gtk.Label (_("Customize"));
            costumize_fonts_title.margin_top = 5;
            costumize_fonts_title.xalign = 0;
            costumize_fonts_title.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);

            var editor_title = new Gtk.Label (_("Test this font"));
            editor_title.margin_top = 5;
            editor_title.xalign = 0;
            editor_title.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
            */

            var source_buffer_css = new Gtk.SourceBuffer (null);
            source_buffer_css.highlight_syntax = true;
            source_buffer_css.language = Gtk.SourceLanguageManager.get_default ().get_language ("css");
            source_buffer_css.style_scheme = new Gtk.SourceStyleSchemeManager ().get_scheme (snippet_color_scheme);

            var source_buffer_html = new Gtk.SourceBuffer (null);
            source_buffer_html.highlight_syntax = true;
            source_buffer_html.language = Gtk.SourceLanguageManager.get_default ().get_language ("css");
            source_buffer_html.style_scheme = new Gtk.SourceStyleSchemeManager ().get_scheme (snippet_color_scheme);

            /*
            var source_buffer_editor = new Gtk.SourceBuffer (null);
            source_buffer_editor.highlight_syntax = true;
            source_buffer_editor.language = Gtk.SourceLanguageManager.get_default ().get_language ("markdown");
            source_buffer_editor.style_scheme = new Gtk.SourceStyleSchemeManager ().get_scheme (snippet_color_scheme);
            */

            var source_view_css = new Gtk.SourceView ();
            source_view_css.buffer = source_buffer_css;
            source_view_css.editable = false;
            source_view_css.left_margin = source_view_css.right_margin = 6;
            source_view_css.monospace = true;
            source_view_css.pixels_above_lines = source_view_css.pixels_below_lines = 4;
            source_view_css.show_line_numbers = true;

            var source_view_html = new Gtk.SourceView ();
            source_view_html.buffer = source_buffer_html;
            source_view_html.editable = false;
            source_view_html.left_margin = source_view_html.right_margin = 6;
            source_view_html.monospace = true;
            source_view_html.pixels_above_lines = source_view_html.pixels_below_lines = 4;
            source_view_html.show_line_numbers = true;

            /*
            var source_view_editor = new Gtk.SourceView ();
            source_view_editor.buffer = source_buffer_editor;
            source_view_editor.editable = true;
            source_view_editor.show_line_numbers = true;
            source_view_editor.left_margin = source_view_html.right_margin = 6;
            source_view_editor.pixels_above_lines = source_view_html.pixels_below_lines = 4;

            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.set_size_request (100,100);
            scrolled.get_style_context ().add_class (snippet_class);
            scrolled.add (source_view_editor);
            */

            var snippet_css = new Gtk.Grid ();
            snippet_css.get_style_context ().add_class (snippet_class);
            snippet_css.add (source_view_css);

            var snippet_html = new Gtk.Grid ();
            snippet_html.get_style_context ().add_class (snippet_class);
            snippet_html.add (source_view_html);

            content_area.orientation = Gtk.Orientation.VERTICAL;
            //content_area.add (costumize_fonts_title);
            content_area.add (snippet_html_title);
            content_area.add (snippet_html);
            content_area.add (snippet_css_title);
            content_area.add (snippet_css);
            //content_area.add (editor_title);
            //content_area.add (scrolled);

            // source_buffer_editor.text = "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z\na b c d e f g h i j k l m o p q r s t u v w x y z\n1 2 3 4 5 6 7 8 9 0\n!@#£$§%&";

            notify["title"].connect (() => {

                var embed_font = title;
                var regex = new Regex ("[\\s]");
                var new_embed_font = regex.replace (embed_font, -1, 0, "+");

                var msg_embed_html = (_("To embed your selected fonts into a webpage, copy this code into the <head> of your HTML document!"));
                var msg_embed_css = (_("Use the following CSS rules to specify these families:"));

                source_buffer_html.text = "/* %s */\n<link href=\"https://fonts.googleapis.com/css?family=%s&display=swap\" rel=\"stylesheet\">".printf (msg_embed_html, new_embed_font);
                source_buffer_css.text = "/* %s */\n@import url(\'https://fonts.googleapis.com/css?family=%s&display=swap\');\nfont-family: \'%s\';".printf (msg_embed_css, new_embed_font, title);
            });

            show_all ();
        }
    }
}
