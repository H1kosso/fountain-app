import QtQuick
import QtQuick.Controls
Rectangle{
    height: 40
    color: "blue"

    Row{
        anchors.verticalCenter: parent.verticalCenter
        height: 35

        Button{
            text: "drawer open"
            onClicked: menu.open()
        }
    }
}
