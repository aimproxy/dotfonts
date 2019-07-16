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
    public class FontView : Gtk.Box {

        public string family { get; set; default = "Sail"; }
        public string category { get; set; default = "display"; }
        public Array<string> variants { get; set; }

        private string snippet_color_scheme = "solarized-dark";
        private string snippet_class = "code-dark";
        private string snippet_html_text = "/* %s */\n<link href=\"https://fonts.googleapis.com/css?family=%s&display=swap\" rel=\"stylesheet\">";
        private string snippet_css_text = "/* %s */\n@import url(\'https://fonts.googleapis.com/css?family=%s&display=swap\');\nfont-family: \'%s\';";

        public FontView () {
            Object (
                orientation: Gtk.Orientation.VERTICAL
            );

            var source_buffer_css = new Gtk.SourceBuffer (null);
            source_buffer_css.highlight_syntax = true;
            source_buffer_css.language = Gtk.SourceLanguageManager.get_default ().get_language ("css");
            source_buffer_css.style_scheme = new Gtk.SourceStyleSchemeManager ().get_scheme (snippet_color_scheme);

            var source_buffer_html = new Gtk.SourceBuffer (null);
            source_buffer_html.highlight_syntax = true;
            source_buffer_html.language = Gtk.SourceLanguageManager.get_default ().get_language ("css");
            source_buffer_html.style_scheme = new Gtk.SourceStyleSchemeManager ().get_scheme (snippet_color_scheme);

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

            var snippet_css = new Gtk.Grid ();
            snippet_css.height_request = 75;
            snippet_css.width_request = 850;
            snippet_css.get_style_context ().add_class (snippet_class);
            snippet_css.add (source_view_css);

            var snippet_html = new Gtk.Grid ();
            snippet_html.height_request = 60;
            snippet_html.width_request = 850;
            snippet_html.get_style_context ().add_class (snippet_class);
            snippet_html.add (source_view_html);

            var font_family_label = new Gtk.Label (family);
            font_family_label.margin_top = 5;
            font_family_label.xalign = 0;
            font_family_label.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);

            var font_category_label = new Gtk.Label (category);
            font_category_label.xalign = 0;
            font_category_label.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);

            var font_variants_label = new Gtk.Label ("regular");
            font_variants_label.xalign = 0;
            font_variants_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);

            var snippet_css_title = new Gtk.Label (_("Specify in CSS"));
            snippet_css_title.margin_top = 5;
            snippet_css_title.xalign = 0;
            snippet_css_title.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);

            var snippet_html_title = new Gtk.Label (_("Embed in HTML"));
            snippet_html_title.margin_top = 5;
            snippet_html_title.xalign = 0;
            snippet_html_title.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);

            var fonts_grid = new Gtk.Grid ();
            fonts_grid.row_spacing = 12;
            fonts_grid.margin_start = 24;
            fonts_grid.margin_end = 24;

            fonts_grid.attach (font_family_label, 0, 0, 1, 1);
            fonts_grid.attach (font_category_label, 0, 1, 1, 1);
            fonts_grid.attach (font_variants_label, 0 , 2, 1, 1);
            fonts_grid.attach (snippet_css_title, 0, 3, 1, 1);
            fonts_grid.attach (snippet_css, 0, 4, 1, 1);
            fonts_grid.attach (snippet_html_title, 0, 5, 1, 1);
            fonts_grid.attach (snippet_html, 0, 6, 1, 1);

            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.expand = true;
            scrolled.add (fonts_grid);

            var msg_embed_html = (_("To embed your selected fonts into a webpage, copy this code into the <head> of your HTML document!"));
            var msg_embed_css = (_("Use the following CSS rules to specify these families:"));

            var regex = new Regex ("[\\s]");
            var new_embed_font = regex.replace (family, -1, 0, "+");

            source_buffer_html.text = snippet_html_text.printf (msg_embed_html, new_embed_font);
            source_buffer_css.text = snippet_css_text.printf (msg_embed_css, new_embed_font, family);

            notify["family"].connect (() => {
                font_family_label.set_label (family);

                new_embed_font = regex.replace (family, -1, 0, "+");

                source_buffer_html.text = snippet_html_text.printf (msg_embed_html, new_embed_font);
                source_buffer_css.text = snippet_css_text.printf (msg_embed_css, new_embed_font, family);
            });

            notify["category"].connect (() => {
                font_category_label.set_label (category);
            });

            notify["variants"].connect (() => {
                var builder = new StringBuilder ();
                for (var i = 0; i < variants.length; i++) {
                    if (variants.length == 1) {
                        builder.append (variants.index (i));
                    } else {
                        builder.append (variants.index (i) + ", ");
                    }
                    stdout.printf("%s\n", variants.index (i));
                }

                stdout.printf("%s\n", builder.str);
                font_variants_label.set_label (builder.str);
            });

            add (scrolled);

            show_all ();
        }
    }
}
