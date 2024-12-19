import QtQuick
import QtQuick.Controls
import "../controls"

Drawer {
    background: Rectangle{
        anchors.fill: parent
        color: theme.menu
    }
    Column{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 15

        spacing: 7

        Repeater{
            model: ListModel{
                ListElement{ value: "home" }
                ListElement{ value: "settings" }
                ListElement{ value: "paintAnimation" }
                ListElement{ value: "gallery"}
            }

            delegate: MenuButton{
                text: model.value
                onClicked: {
                    contentRoot.state = model.value
                    menu.close()
                }
            }
        }
    }


}
