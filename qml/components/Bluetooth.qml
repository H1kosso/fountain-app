import QtQuick
import QtQuick.Controls
import "../utils"
import "./gallery"
import "../controls"

Item{
    id: root
    width: parent.width - 10
    anchors.horizontalCenter: parent.horizontalCenter
    height: column.height




    Column {
        id: column
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter

        ToolbarButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 130
            height: 30
            pixelSize: 20
            source: "../../assets/icons/eye.png"
            text: "Podgląd"
            onClicked: {
                appRoot.state = "deviceMemoryImage"
            }
        }
    }
}
