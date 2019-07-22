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
using App.Widgets;
using App.Windows;

namespace App.Views {
    public class Sidebar : Gtk.ScrolledWindow {
        Gtk.Box box;
        Gtk.SearchEntry search_entry;
        Gtk.ListBox listbox;
        Gapi gapi;

        public Sidebar () {}

        construct {
            gapi = Gapi.get_instance();

            listbox = new Gtk.ListBox ();
            listbox.activate_on_single_click = true;
            listbox.selection_mode = Gtk.SelectionMode.SINGLE;
            listbox.set_filter_func (filter_function);

            search_entry = new Gtk.SearchEntry ();
            search_entry.margin = 8;
            search_entry.hexpand = true;
            search_entry.placeholder_text = _("Search Friends");
            search_entry.valign = Gtk.Align.CENTER;

            box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            box.pack_start (search_entry, false, false);
            box.pack_start (listbox, false, false);

            this.hscrollbar_policy = Gtk.PolicyType.NEVER;
            this.vexpand = true;
            this.add (box);

            search_entry.search_changed.connect (() => {
                listbox.invalidate_filter ();
            });

            try {
                gapi.load_trending ();
            } catch (Error e) {
                warning ("Error getting fonts: %s", e.message);
            }

            gapi.request_page_success.connect((fonts) => {
                foreach (var font in fonts) {
                    listbox.add (new FontListRow (font.family,
                                                  font.category,
                                                  font.variants,
                                                  font.files));
                }

                listbox.show_all ();
            });

            listbox.row_selected.connect ((row) => {
                MainWindow.font_info.family = ((FontListRow) row).font_family;
                MainWindow.font_info.category = ((FontListRow) row).font_category;
                MainWindow.font_info.variants = ((FontListRow) row).font_variants;
                MainWindow.font_info.files = ((FontListRow) row).font_files;
            });

        }

        [CCode (instance_pos = -1)]
        private bool filter_function (Gtk.ListBoxRow row) {
            var font = ((FontListRow) row).font_family;

            if (font == null) {
                return false;
            }

            var search_term = search_entry.text.down ();

            if (search_term in font.down ()) {
                return true;
            }

            return false;
        }

    }

}
