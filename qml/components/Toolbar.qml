import QtQuick
import QtQuick.Controls
import "../controls"
Rectangle{
    height: 40
    color: theme.toolbar

    Row{
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 15
        height: 35
        spacing: 10

        ToolbarButton{
            text: "drawer open"
            onClicked: menu.open()
            anchors.verticalCenter: parent.verticalCenter
        }

        Button{
            text: "Toggle BT connection"
            onClicked: isBTconnected = !isBTconnected
        }
    }
}
