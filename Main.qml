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

    ImageInfo {
        id: imageBLEConfig
    }

    ApiManager{
        id: apiManager
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
            boundsBehavior: appRoot.state === "gallery" ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds
            contentHeight: contentColumn.height

            onFlickStarted: {
                if (verticalOvershoot <= 50)
                {
                    apiManager.getAllPictures()
                }

            }

            Column{
                id: contentColumn
                width: parent.width

                Login{
                    id: login
                    visible: false
                }

                Home{
                    id: home
                    visible: false
                }

                Settings{
                    id: settings
                    visible: false
                }

                PaintAnimation{
                    id: paintAnimation
                    visible: false
                }

                Gallery{
                    id: gallery
                    visible: false
                }

                Bluetooth{
                    id: bluetooth
                    visible: false
                }

                DeviceMemoryImage{
                    id: deviceMemoryImage
                    visible: false
                }

                Logs{
                    id: logs
                    visible: false
                }
            }
        }
        MyTheme{
            id: theme
        }

        state: "login"
        states: [
            State{
                name: "login"
                PropertyChanges { target: login; visible: true}
                PropertyChanges { target: toolbar; visible: false}
                AnchorChanges{ target: contentRoot; anchors.top: parent.top}
            },
            State{
                name: "home"
                PropertyChanges { target: home; visible: true}
            },
            State{
                name: "settings"
                PropertyChanges { target: settings; visible: true}
            },
            State{
                name: "paintAnimation"
                PropertyChanges { target: paintAnimation; visible: true}
            },
            State{
                name: "gallery"
                PropertyChanges { target: gallery; visible: true}
            },
            State{
                name: "bluetooth"
                PropertyChanges { target: bluetooth; visible: true}
            },
            State{
                name: "deviceMemoryImage"
                PropertyChanges { target: deviceMemoryImage; visible: true}
            },
            State{
                name: "logs"
                PropertyChanges { target: logs; visible: true}
            }
        ]
    }
}
