/*
 * Copyright (C) 2016 The Qt Company Ltd.
 * Copyright (C) 2016, 2017 Mentor Graphics Development (Deutschland) GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Layouts 1.1
import HomeScreen 1.0

Window {
    visible: true
    flags: Qt.FramelessWindowHint
    width: container.width * container.scale
    height: container.height * container.scale
    title: 'HomeScreen'
    color: "#00000000"

    Image {
        id: container
        anchors.centerIn: parent
        width: 1080
        height: 1920
        scale: screenInfo.scale_factor()
        source: './images/AGL_HMI_Blue_Background_NoCar-01.png'

        ColumnLayout {
            anchors.fill: parent
            spacing: 0
            TopArea {
                id: topArea
                Layout.fillWidth: true
                Layout.preferredHeight: 218
            }

            Item {
                id: applicationArea
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 1920 - 218 - 215

                visible: true
            }

            MediaArea {
                id: mediaArea
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 215
            }
        }

        states: [
            State {
                name: "normal"
                PropertyChanges {
                    target: topArea
                    y: 0
                }
                PropertyChanges {
                    target: applicationArea
                    y: 218
                }
                PropertyChanges {
                    target: mediaArea
                    y: 1705
                }
            },
            State {
                name: "fullscreen"
                PropertyChanges {
                    target: topArea
                    y: -220
                }
                PropertyChanges {
                    target: applicationArea
                    y: -1490
                }
                PropertyChanges {
                    target: mediaArea
                    y: 2135
                }
            }
        ]
        transitions: Transition {
            NumberAnimation {
                target: topArea
                property: "y"
                easing.type: "OutQuad"
                duration: 250
            }
            NumberAnimation {
                target: mediaArea
                property: "y"
                easing.type: "OutQuad"
                duration: 250
            }
        }
    }

    Item {
        id: switchBtn
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 25
        width: 35
        height: 35
        z: 1

        MouseArea {
            anchors.fill: parent
            property string btnState: 'normal'
            Image {
                id: image
                anchors.fill: parent
                source: './images/normal.png'
            }
            onClicked: {
                var appName = homescreenHandler.getCurrentApplication()
                if (btnState === 'normal') {
                    image.source = './images/fullscreen.png'
                    btnState = 'fullscreen'
                    container.state = 'fullscreen'
                    touchArea.switchArea(1)
                    homescreenHandler.tapShortcut(appName, true)
                    container.opacity = 0.0
                } else {
                    image.source = './images/normal.png'
                    btnState = 'normal'
                    container.state = 'normal'
                    touchArea.switchArea(0)
                    homescreenHandler.tapShortcut(appName, false)
                    container.opacity = 1.0
                }
            }
        }
    }

    Timer {
        id:informationTimer
        interval: 3000
        running: false
        repeat: true
        onTriggered: {
            bottomInformation.visible = false
        }
    }

    Item {
        id: bottomInformation
        width: parent.width
        height: 215
        anchors.bottom: parent.bottom
        visible: false
        Text {
            id: bottomText
            anchors.centerIn: parent
            font.pixelSize: 25
            font.letterSpacing: 5
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            text: ""
            z:1
        }
    }

    Connections {
        target: homescreenHandler
        onShowInformation: {
            bottomText.text = info
            bottomInformation.visible = true
            informationTimer.restart()
        }
    }

	Timer {
        id:notificationTimer
        interval: 3000
        running: false
        repeat: true
        onTriggered: notificationItem.visible = false
    }

    Item {
        id: notificationItem
        x: 0
        y: 0
        z: 1
        width: 1280
        height: 100
        opacity: 0.8
        visible: false

        Rectangle {
            width: parent.width
            height: parent.height
            anchors.fill: parent
            color: "gray"
            Image {
                id: notificationIcon
                width: 70
                height: 70
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                source: ""
            }

            Text {
                id: notificationtext
                font.pixelSize: 25
                anchors.left: notificationIcon.right
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                color: "white"
                text: qsTr("")
            }
        }
    }

    Connections {
        target: homescreenHandler
        onShowNotification: {
            notificationIcon.source = icon_path
            notificationtext.text = text
            notificationItem.visible = true
            notificationTimer.restart()
        }
    }
}
