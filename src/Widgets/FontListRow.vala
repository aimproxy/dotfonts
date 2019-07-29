/*
 *         _____
 *  ______ ___(_)______ ____________________________  ______  __
 *  _  __ `/_  /__  __ `__ \__  __ \_  ___/  __ \_  |/_/_  / / /
 *  / /_/ /_  / _  / / / / /_  /_/ /  /   / /_/ /_>  < _  /_/ /
 *  \__,_/ /_/  /_/ /_/ /_/_  .___//_/    \____//_/|_| _\__, /
 *                         /_/                         /____/
 *
 */

namespace App.Widgets {

    public class FontListRow : Gtk.ListBoxRow {

        public string font_family { get; construct; }
        public string font_category { get; construct; }
        public Array<string> font_variants { get; construct; }
        public Gee.HashMap<string, string> font_files { get; construct; }

        public FontListRow (string family, string category,
                            Array<string> variants,
                            Gee.HashMap<string, string> files) {
            Object (
                font_family: family,
                font_category: category,
                font_variants: variants,
                font_files: files
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
