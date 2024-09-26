import QtQuick
import QtQuick.Controls
import "./qml/components"
import com.fountain


ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    header: Toolbar{
        id: toolbar
    }

    Menu{
        id: menu
        height: parent.height
        width: 250
    }

    Rectangle{
        color: "red"
        id: contentRoot
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
            }
        }

        state: "home"
        states: [
            State{
                name: "home"
                PropertyChanges { target: home; visible: true}
                PropertyChanges { target: settings; visible: false}
                PropertyChanges { target: paintAnimation; visible: false}
            },
            State{
                name: "settings"
                PropertyChanges { target: home; visible: false}
                PropertyChanges { target: settings; visible: true}
                PropertyChanges { target: paintAnimation; visible: false}
            },
            State{
                name: "paintAnimation"
                PropertyChanges { target: home; visible: false}
                PropertyChanges { target: settings; visible: false}
                PropertyChanges { target: paintAnimation; visible: true}
            }
        ]
    }
}
