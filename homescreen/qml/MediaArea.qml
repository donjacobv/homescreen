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
import QtQuick.Controls 2.0

StackView {
    id: root
    width: parent.width
    height: parent.height

    initialItem: blank

    Component {
        id: blank
        MediaAreaBlank {
//            MouseArea {
//                anchors.fill: parent
//                onClicked: root.push(mouse.x < 540 ? music : radio)
//            }
        }
    }

    Component {
        id: music
        MediaAreaMusic {
            MouseArea {
                anchors.fill: parent
                onClicked: root.pop()
            }
        }
    }

    Component {
        id: radio
        MediaAreaRadio {
            MouseArea {
                anchors.fill: parent
                onClicked: root.pop()
            }
        }
    }
}