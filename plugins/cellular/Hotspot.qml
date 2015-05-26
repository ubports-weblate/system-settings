/*
 * This file is part of system-settings
 *
 * Copyright (C) 2014 Canonical Ltd.
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

import QtQuick 2.0
import SystemSettings 1.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import Ubuntu.Settings.Components 0.1 as USC
import Ubuntu.SystemSettings.Cellular 1.0

ItemPage {

    id: hotspot
    objectName: "hotspotPage"

    title: i18n.tr("Wi-Fi hotspot")

    // We disable the back action while a hotspot is in the process of either
    // being enabled or disabled.
    head.backAction: Action {
        iconName: "back"
        enabled: hotspotSwitch.enabled
        onTriggered: {
            pageStack.pop();
        }
    }

    HotspotManager {
        id: hotspotManager
    }

    Loader {
        id: setup
        asynchronous: false
    }

    Column {

        anchors.fill: parent
        spacing: units.gu(2)

        ListItem.Standard {
            text: i18n.tr("Hotspot")
            enabled: hotspotManager.stored
            control: Switch {
                id: hotspotSwitch
                objectName: "hotspotSwitch"
                enabled: !switchSync.syncWaiting

                USC.ServerPropertySynchroniser {
                    id: switchSync
                    userTarget: hotspotSwitch
                    userProperty: "checked"
                    serverTarget: hotspotManager
                    serverProperty: "enabled"
                    useWaitBuffer: true

                    // Since this blocks the UI thread, we wait until
                    // the UI has completed the checkbox animation before we
                    // ask the server to uipdate.
                    onSyncTriggered: {
                        triggerTimer.value = value;
                        triggerTimer.start();
                    }
                }

                Timer {
                    id: triggerTimer
                    property bool value
                    interval: 250; repeat: false
                    onTriggered: hotspotManager.enabled = value
                }
            }
        }

        ListItem.Caption {
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: units.gu(2)
                rightMargin: units.gu(2)
            }
            text : hotspotSwitch.stored ?
              i18n.tr("When hotspot is on, other devices can use your cellular data connection over Wi-Fi. Normal data charges apply.")
              : i18n.tr("Other devices can use your cellular data connection over the Wi-Fi network. Normal data charges apply.")
        }

        Button {
            objectName: "hotspotSetupEntry"
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - units.gu(4)
            text: hotspotManager.stored ?
                i18n.tr("Change password/setup…") : i18n.tr("Set up hotspot…")

            onClicked: {
                setup.setSource(Qt.resolvedUrl("HotspotSetup.qml"));
                PopupUtils.open(setup.item, hotspot, {
                    hotspotManager: hotspotManager
                });
            }
        }
    }
}
