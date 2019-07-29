/*
 *         _____
 *  ______ ___(_)______ ____________________________  ______  __
 *  _  __ `/_  /__  __ `__ \__  __ \_  ___/  __ \_  |/_/_  / / /
 *  / /_/ /_  / _  / / / / /_  /_/ /  /   / /_/ /_>  < _  /_/ /
 *  \__,_/ /_/  /_/ /_/ /_/_  .___//_/    \____//_/|_| _\__, /
 *                         /_/                         /____/
 *
 */

namespace App.Services {
    public class Downloader {
        private static Downloader? instance;
        public signal void finish_download (bool status);
        public signal void finish_installation (bool status);

        public Downloader () {}

        public void download_font (string item, string uri_endpoint) {
            var folder_path = Path.build_filename (GLib.Environment.get_home_dir (), "dotfonts");
            var dest_path = Path.build_filename (GLib.Environment.get_home_dir (), "dotfonts", item + ".ttf");
            var destination = File.new_for_path (dest_path);
            var file_from_uri = File.new_for_uri (uri_endpoint);

            if (!GLib.FileUtils.test (folder_path, GLib.FileTest.IS_DIR)) {
                var folder = File.new_for_path (folder_path);
                try {
                    folder.make_directory ();
                } catch (Error e) {
                    warning ("Unable to create fonts directory: %s", e.message);
                }
            }

            file_from_uri.copy_async.begin (destination,
                FileCopyFlags.OVERWRITE | FileCopyFlags.ALL_METADATA,
                GLib.Priority.DEFAULT, null,
                (current_num_bytes, total_num_bytes) => {
                print ("%" + int64.FORMAT + " bytes of %" + int64.FORMAT + " bytes copied.\n",
                current_num_bytes, total_num_bytes);
                }, (obj, res) => {
                    try {
                        bool tmp = file_from_uri.copy_async.end (res);
                        print ("Result: %s\n", tmp.to_string ());
                        finish_download (tmp);
                    } catch (Error e) {
                        warning ("Error: %s\n", e.message);
                    }
                });

        }

        public void download_install (string item, string uri_endpoint) {
            var folder_path = Path.build_filename (GLib.Environment.get_user_data_dir (), "fonts");
            var dest_path = Path.build_filename (GLib.Environment.get_user_data_dir (), "fonts", item + ".ttf");
            var destination = File.new_for_path (dest_path);
            var file_from_uri = File.new_for_uri (uri_endpoint);

            if (!GLib.FileUtils.test (folder_path, GLib.FileTest.IS_DIR)) {
                var folder = File.new_for_path (folder_path);
                try {
                    folder.make_directory ();
                } catch (Error e) {
                    warning ("Unable to create fonts directory: %s", e.message);
                }
            }

            file_from_uri.copy_async.begin (destination,
                FileCopyFlags.OVERWRITE | FileCopyFlags.ALL_METADATA,
                GLib.Priority.DEFAULT, null,
                (current_num_bytes, total_num_bytes) => {
                print ("%" + int64.FORMAT + " bytes of %" + int64.FORMAT + " bytes copied.\n",
                current_num_bytes, total_num_bytes);
                }, (obj, res) => {
                    try {
                        bool tmp = file_from_uri.copy_async.end (res);
                        print ("Result: %s\n", tmp.to_string ());
                        finish_installation (tmp);
                    } catch (Error e) {
                        warning ("Error: %s\n", e.message);
                    }
                });
        }

        public static unowned Downloader get_instance () {
            if (instance == null) {
                instance = new Downloader ();
            }
            return instance;
        }
    }
}
