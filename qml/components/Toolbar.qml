import QtQuick
import QtQuick.Controls
Rectangle{
    height: 40
    color: "blue"

    Row{
        anchors.fill: parent
        height: 35
        spacing: 10

        ToolButton{
            text: "drawer open"
            onClicked: menu.open()
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
