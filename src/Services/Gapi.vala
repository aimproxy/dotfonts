/*
 *         _____
 *  ______ ___(_)______ ____________________________  ______  __
 *  _  __ `/_  /__  __ `__ \__  __ \_  ___/  __ \_  |/_/_  / / /
 *  / /_/ /_  / _  / / / / /_  /_/ /  /   / /_/ /_>  < _  /_/ /
 *  \__,_/ /_/  /_/ /_/ /_/_  .___//_/    \____//_/|_| _\__, /
 *                         /_/                         /____/
 *
 */

using App.Configs;
using App.Views;

namespace App.Services {
    public class Gapi {
        private static Gapi? instance;
        private Soup.Session session;

        public signal void request_page_success (List<Font?> list);
        public signal void categories_ready (Gee.HashSet<string> categories);

        public Gapi() {
            this.session = new Soup.Session();
            this.session.ssl_strict = false;
        }

        public struct Font {
            string family;
            string category;
            Array<string> variants;
            Gee.HashMap<string, string> files;
        }

        public void load_trending () {
            var uri = Constants.GAPI +
                "webfonts?key=" + Constants.GAPI_KEY +
                "&?sort=trending";

            var msg = new Soup.Message ("GET", uri);

            session.queue_message (msg, (sess, mess) => {
               if (mess.status_code == 200) {
                    try {
                        var parser = new Json.Parser ();
                        parser.load_from_data ((string) msg.response_body.flatten ().data, -1);

                        var list = get_data (parser);
                        var categories = get_categories (parser);
                        request_page_success (list);
                        categories_ready (categories);
                    } catch (Error e) {
                        show_message("Request page fail", e.message, "dialog-error");
                    }
                } else {
                    show_message("Request page fail", @"status code: $(mess.status_code)", "dialog-error");
                }
            });
        }

        public Gee.HashSet<string> get_categories (Json.Parser parser) {
          Gee.HashSet<string> categories = new Gee.HashSet<string> ();

          Json.Node root = parser.get_root ();
          assert(root.get_node_type () == Json.NodeType.OBJECT);

          Json.Object res = root.get_object ();
          Json.Array items = res.get_array_member ("items");

          foreach (unowned Json.Node font in items.get_elements ()) {
            assert(font.get_node_type () == Json.NodeType.OBJECT);

            var obj = font.get_object ();
            var category = obj.get_string_member ("category");

            /*  Categories could be duplicated, so
             *  using this method duplicates will not be added
             *  because we are using a set!
             */
            categories.add (category);
          }

          return categories;
        }

        private List<Font?> get_data (Json.Parser parser) {
            List<Font?> fonts_list = new List<Font?> ();

            Json.Node root = parser.get_root ();

            assert(root.get_node_type () == Json.NodeType.OBJECT);

            Json.Object res = root.get_object ();
            Json.Array items = res.get_array_member ("items");

            foreach (unowned Json.Node font in items.get_elements ()) {
                assert(font.get_node_type () == Json.NodeType.OBJECT);
                var obj = font.get_object ();
                var font_structure = Font();

                font_structure.family = obj.get_string_member ("family");
                font_structure.category = obj.get_string_member ("category");

                var arr_variants = new Array<string> ();
                var variants = obj.get_array_member ("variants");
                foreach (unowned Json.Node variant in variants.get_elements ()) {
                    arr_variants.append_val (variant.get_string ());
                }
                font_structure.variants = arr_variants;

                var hashmap_files = new Gee.HashMap<string, string> ();
                var files_obj = obj.get_object_member ("files");
                foreach (var file in files_obj.get_members ()) {
                    hashmap_files.set (file, files_obj.get_string_member (file));
                }
                font_structure.files = hashmap_files;

                fonts_list.append(font_structure);
            }

            return fonts_list;
        }

        public static unowned Gapi get_instance () {
            if (instance == null) {
                instance = new Gapi ();
            }
            return instance;
        }

        private void show_message (string txt_primary, string txt_secondary, string icon) {
           var message_dialog = new Granite.MessageDialog.with_image_from_icon_name (
                txt_primary,
                txt_secondary,
                icon,
                Gtk.ButtonsType.CLOSE
            );

            message_dialog.run ();
            message_dialog.destroy ();
        }
    }
}
