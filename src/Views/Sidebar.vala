/*
 *         _____
 *  ______ ___(_)______ ____________________________  ______  __
 *  _  __ `/_  /__  __ `__ \__  __ \_  ___/  __ \_  |/_/_  / / /
 *  / /_/ /_  / _  / / / / /_  /_/ /  /   / /_/ /_>  < _  /_/ /
 *  \__,_/ /_/  /_/ /_/ /_/_  .___//_/    \____//_/|_| _\__, /
 *                         /_/                         /____/
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
            search_entry.placeholder_text = _("Search Fonts");
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
