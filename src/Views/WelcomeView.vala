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

    public class WelcomeView : Granite.Widgets.Welcome {

        public signal void search_on_google_fonts ();

        public WelcomeView () {
            Object (
                title: _("DotFonts"),
                subtitle: _("Find beautiful fonts and easy install on elementaryOS")
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