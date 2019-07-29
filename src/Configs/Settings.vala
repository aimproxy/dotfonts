/*
 *         _____
 *  ______ ___(_)______ ____________________________  ______  __
 *  _  __ `/_  /__  __ `__ \__  __ \_  ___/  __ \_  |/_/_  / / /
 *  / /_/ /_  / _  / / / / /_  /_/ /  /   / /_/ /_>  < _  /_/ /
 *  \__,_/ /_/  /_/ /_/ /_/_  .___//_/    \____//_/|_| _\__, /
 *                         /_/                         /____/
 *
 */

namespace App.Configs {

    public class Settings : Granite.Services.Settings {

        private static Settings? instance;

        public int window_x { get; set; }
        public int window_y { get; set; }
        public int window_width { get; set; }
        public int window_height { get; set; }
        public bool use_dark_theme {get; set;}

        private Settings () {
            base (Constants.ID);
        }

        public static unowned Settings get_instance () {
            if (instance == null) {
                instance = new Settings ();
            }

            return instance;
        }
    }
}
