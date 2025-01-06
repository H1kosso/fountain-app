import QtQuick
import QtQuick.Controls.Imagine
import QtQuick.Controls
import com.fountain

import "./qml/components"
import "./qml/utils"



ApplicationWindow {
    id: appRoot
    width: 1080/3
    height: 2340/3
    visible: true
    title: qsTr("Fountain app")
    property alias state: contentRoot.state

    property bool isBTconnected: true

    header: Toolbar{
        id: toolbar
    }

    Menu{
        id: menu
        height: parent.height
        width: 250
    }

    Item{
        id: config

        property int mode: 0
        property bool enableWeekends: false
        property int workTime: 0
        property int idleTime: 0
        property var mailList: []
        property int pictureSize: 0
        property var pictureData: []
        property int workRangeFrom: 0
        property int workRangeTo: 0
        property color main
        property color secondary : "red"
    }

    Item{
        id: fountainState
        property int mode: 0
        property int fluidLevel: 0
        property bool isPresenting: false
    }

    Rectangle{
        id: contentRoot

        color: theme.appBackground
        anchors {
            left: parent.left
            right: parent.right
            top: toolbar.bottom
            bottom: parent.bottom
        }

        Flickable{
            id: contentFlickable
            anchors.fill: parent
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            contentHeight: contentColumn.height

            Column{
                id: contentColumn
                width: parent.width

                Home{
                    id: home
                }

                Settings{
                    id: settings
                }

                PaintAnimation{
                    id: paintAnimation
                }

                Gallery{
                    id: gallery
                }

                Bluetooth{
                    id: bluetooth
                }
            }
        }
        MyTheme{
            id: theme
        }

        state: "home"
        states: [
            State{
                name: "home"
                PropertyChanges { target: home; visible: true}
                PropertyChanges { target: settings; visible: false}
                PropertyChanges { target: paintAnimation; visible: false}
                PropertyChanges { target: gallery; visible: false}
                PropertyChanges { target: bluetooth; visible: false}
            },
            State{
                name: "settings"
                PropertyChanges { target: home; visible: false}
                PropertyChanges { target: settings; visible: true}
                PropertyChanges { target: paintAnimation; visible: false}
                PropertyChanges { target: gallery; visible: false}
                PropertyChanges { target: bluetooth; visible: false}
            },
            State{
                name: "paintAnimation"
                PropertyChanges { target: home; visible: false}
                PropertyChanges { target: settings; visible: false}
                PropertyChanges { target: paintAnimation; visible: true}
                PropertyChanges { target: gallery; visible: false}
                PropertyChanges { target: bluetooth; visible: false}
            },
            State{
                name: "gallery"
                PropertyChanges { target: home; visible: false}
                PropertyChanges { target: settings; visible: false}
                PropertyChanges { target: paintAnimation; visible: false}
                PropertyChanges { target: bluetooth; visible: false}
                PropertyChanges { target: gallery; visible: true}
            },
            State{
                name: "bluetooth"
                PropertyChanges { target: home; visible: false}
                PropertyChanges { target: settings; visible: false}
                PropertyChanges { target: paintAnimation; visible: false}
                PropertyChanges { target: gallery; visible: false}
                PropertyChanges { target: bluetooth; visible: true}
            }
        ]
    }
}
