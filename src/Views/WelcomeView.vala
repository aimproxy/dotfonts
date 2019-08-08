/*
 *         _____
 *  ______ ___(_)______ ____________________________  ______  __
 *  _  __ `/_  /__  __ `__ \__  __ \_  ___/  __ \_  |/_/_  / / /
 *  / /_/ /_  / _  / / / / /_  /_/ /  /   / /_/ /_>  < _  /_/ /
 *  \__,_/ /_/  /_/ /_/ /_/_  .___//_/    \____//_/|_| _\__, /
 *                         /_/                         /____/
 *
 */

namespace App.Views {

    public class WelcomeView : Granite.Widgets.Welcome {

        public signal void search_on_google_fonts ();

        public WelcomeView () {
            Object (
                title: _("DotFonts"),
                subtitle: _("Find beautiful fonts and easy install on elementary OS")
            );
        }

        construct {
            this.append ("system-search", _("Search Fonts"), _("Download and Install fonts from Google Fonts to your desktop"));

            this.activated.connect (on_welcome_view_activated);
        }

        private void on_welcome_view_activated (int index) {
            switch (index) {
                case 0:
                    print("Click\n");
                    search_on_google_fonts ();
                    break;
            }
        }
    }
}
