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
        Gtk.Grid grid;
        Gtk.SearchEntry search_entry;
        Gtk.Button filter_btn;
        Gtk.ListBox listbox;
        Gtk.Popover menu_popover;
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
            search_entry.margin_end = 4;
            search_entry.hexpand = true;
            search_entry.placeholder_text = _("Search Fonts");
            search_entry.valign = Gtk.Align.CENTER;

            filter_btn = new Gtk.Button.from_icon_name ("view-more-symbolic", Gtk.IconSize.BUTTON);
            filter_btn.margin = 8;
            filter_btn.margin_start = 4;
            filter_btn.valign = Gtk.Align.CENTER;

            Gtk.CheckButton item_option = new Gtk.CheckButton.with_label ("My Option");
            item_option.set_active (true);

            Gtk.ListBox listbox_options = new Gtk.ListBox();
            listbox_options.margin = 8;
            listbox_options.selection_mode = Gtk.SelectionMode.NONE;
            listbox_options.add (item_option);

            menu_popover = new Gtk.Popover(filter_btn);
            menu_popover.position = Gtk.PositionType.BOTTOM;
        		menu_popover.set_size_request (256, -1);
            menu_popover.add (listbox_options);

            filter_btn.clicked.connect(() => {
                menu_popover.show_all ();
                menu_popover.popup ();
            });

            grid = new Gtk.Grid ();
            grid.attach(search_entry, 0, 1);
            grid.attach(filter_btn, 1, 1);

            box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            box.pack_start (grid, false, false);
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
