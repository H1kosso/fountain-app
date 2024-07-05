import QtQuick
import QtQuick.Controls

Drawer {
    background: Rectangle{
        anchors.fill: parent
        color: "grey"
    }
    Column{
        Repeater{
            model: ListModel{
                ListElement{ value: "home" }
                ListElement{ value: "settings" }
                ListElement{ value: "paintAnimation" }
            }

            delegate: Button{
                text: model.value
                onClicked: contentRoot.state = model.value
            }
        }
    }


}
