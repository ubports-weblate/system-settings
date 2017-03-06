/*
 * This file is part of system-settings
 *
 * Copyright (C) 2017 Canonical Ltd.
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 3, as published
 * by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranties of
 * MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
 * PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import SystemSettings 1.0
import Ubuntu.Components 1.3
import SystemSettings.ListItems 1.0 as SettingsListItems

Column {
    property alias host: hostField.text
    property bool enabled: true
    SettingsListItems.Standard {
        text: i18n.tr("Host")
        anchors {
            left: parent.left
            right: parent.right
        }

        TextField {
            id: hostField
            enabled: parent.enabled
        }
    }
}
