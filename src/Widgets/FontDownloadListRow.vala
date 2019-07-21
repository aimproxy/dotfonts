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

using App.Services;

namespace App.Widgets {

    public class FontDownloadListRow : Gtk.ListBoxRow {

        Downloader downloader;
        Gtk.Button download_btn;
        Gtk.Label download_label;
        Gtk.Grid grid;

        public string font_file_name { get; construct; }
        public string font_file_variant { get; construct; }
        public string font_file_link { get; construct; }

        public FontDownloadListRow (string file_name, string file_variant, string file_link) {
            Object (
                font_file_name: file_name,
                font_file_variant: file_variant,
                font_file_link: file_link
            );
        }

        construct {
            downloader = Downloader.get_instance ();

            download_btn = new Gtk.Button.from_icon_name ("folder-download-symbolic", Gtk.IconSize.BUTTON);
            download_btn.clicked.connect (() => {
                var file = font_file_name + "_" + font_file_variant;
                downloader.download_font (file, font_file_link);
            });

            downloader.finish_download.connect ((status) => {
            });

            download_label = new Gtk.Label (font_file_variant);
            download_label.xalign = 0;
            download_label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
            download_label.ellipsize = Pango.EllipsizeMode.MIDDLE;

            grid = new Gtk.Grid ();
            grid.column_homogeneous = true;
            grid.row_homogeneous = true;
            grid.column_spacing = 12;
            grid.row_spacing = 6;
            grid.margin = 8;
            grid.margin_start = 6;
            grid.margin_end = 6;
            grid.add (download_label);
            grid.add (download_btn);

            add(grid);
        }
    }
}
