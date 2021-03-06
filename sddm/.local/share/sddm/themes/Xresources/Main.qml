/***************************************************************************
* Copyright (c) 2013 Reza Fatahilah Shah <rshah0385@kireihana.com>
* Copyright (c) 2013 Abdurrahman AVCI <abdurrahmanavci@gmail.com>
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
* OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
* OR OTHER DEALINGS IN THE SOFTWARE.
*
***************************************************************************/

import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: root

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property alias sessionIndex: session.index
    property color background: "#2E3440"
    property color foreground: "#D8DEE9"
    property color color0: "#3B4252"
    property color color8: "#4C566A"

    property color background_active: root.background
    property color foreground_active: "#BF616A"
    property color foreground_error: "#BF616A"

    property int font_size: 12 * 1.8
    property int padding: 10
    property int spacing: 4
    property int input_height: root.font_size * 2

    TextConstants { id: textConstants }

    Connections {
        target: sddm
        onLoginSucceeded: {
            pw_entry.text = ""
            error.text = ""
        }
        onLoginFailed: {
            pw_entry.text = ""
            error.text = "Incorrect username or password"
        }
    }

    // Solid background
    Rectangle {
        id: background
        anchors.fill: root
        color: root.background
    }

    // TODO: Main monitor lock?
    Rectangle {
        id: monitor

        color: "transparent"

        anchors.fill: parent
        anchors.leftMargin:   root.padding
        anchors.rightMargin:  root.padding
        anchors.topMargin:    root.padding
        anchors.bottomMargin: root.padding

        // Switcher
        ComboBox {
            id: session

            anchors.left:       parent.left
            anchors.top:        parent.top

            width: 200
            height: root.input_height

            model: sessionModel
            index: sessionModel.lastIndex

            font.pixelSize: root.font_size

            color: root.color0
            focusColor: "transparent"
            hoverColor: root.foreground_active
            menuColor: root.color0
            textColor: root.foreground
            arrowColor: "transparent"
            borderWidth: 0

            KeyNavigation.backtab: func_shutdown; KeyNavigation.tab: user_entry
        }

        // Authentication prompt
        Column {
            anchors.left:         parent.left
            anchors.bottom:       parent.bottom

            spacing: root.spacing

            width: 300

            Rectangle {
                width: parent.width
                height: root.input_height

                color: "transparent"

                TextInput {
                    id: error

                    // Same algorithm as SDDM's TextBox
                    width: parent.width - 16
                    anchors.centerIn: parent

                    color: root.foreground_error

                    readOnly: true

                    text: ""

                    font.pixelSize: root.font_size
                }
            }

            // Username prompt
            TextBox {
                id: user_entry

                width: parent.width
                height: root.input_height

                color: root.color0
                borderColor: "transparent"
                focusColor: root.foreground_active
                hoverColor: root.foreground_active
                textColor: root.foreground
                radius: root.radius

                text: userModel.lastUser

                font.pixelSize: root.font_size

                KeyNavigation.backtab: func_shutdown; KeyNavigation.tab: pw_entry

                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        if (pw_entry.text === "") {
                            pw_entry.focus = true
                            event.accepted = true
                        } else {
                            sddm.login(user_entry.text, pw_entry.text, sessionIndex)
                            event.accepted = true
                        }
                    }
                }
            }

            // Password prompt
            PasswordBox {
                id: pw_entry

                width: parent.width
                height: root.input_height

                color: root.color0
                borderColor: "transparent"
                focusColor: root.foreground_active
                hoverColor: root.foreground_active
                textColor: root.foreground
                radius: root.radius

                font.pixelSize: root.font_size * 0.75

                KeyNavigation.backtab: user_entry; KeyNavigation.tab: func_reboot

                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        sddm.login(user_entry.text, pw_entry.text, sessionIndex)
                        event.accepted = true
                    }
                }
            }
        }

        // Power menu action buttons
        Row {
            id: actions

            anchors.right:        parent.right
            anchors.bottom:       parent.bottom

            spacing: 0

            // Reboot
            Button {
                id: func_reboot

                text: ""

                width: root.font_size * 2
                height: root.input_height

                font.family: "FontAwesome"
                font.pixelSize: root.font_size

                color: "transparent"
                textColor: root.foreground
                borderColor: "transparent"
                disabledColor: "transparent"
                activeColor: "transparent"
                pressedColor: "transparent"

                onClicked: sddm.reboot()

                KeyNavigation.backtab: session; KeyNavigation.tab: func_shutdown
            }

            // Shutdown
            Button {
                id: func_shutdown

                text: ""

                width: root.font_size * 2
                height: root.input_height

                font.family: "FontAwesome"
                font.pixelSize: root.font_size

                color: "transparent"
                textColor: root.foreground
                borderColor: root.foreground_active
                disabledColor: "transparent"
                activeColor: "transparent"
                pressedColor: "transparent"

                Rectangle {
                    border.color: "transparent"
                }

                onClicked: sddm.powerOff()

                KeyNavigation.backtab: func_reboot; KeyNavigation.tab: user_entry
            }
        }
    }

    // Auto-focus based on username present
    Component.onCompleted: {
        if (user_entry.text === "")
            user_entry.focus = true
        else
            pw_entry.focus = true
    }
}

