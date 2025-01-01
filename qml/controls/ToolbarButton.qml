import QtQuick
import "../utils"

MouseArea{
    id: root

    width: label.width + 10
    height: 25
    hoverEnabled: true

    property alias text: label.text

    Rectangle{
        anchors.fill: parent
        radius: 6
        color: theme.toolbarButton

        Text{
            id: label
            color: theme.textPrimary
            text: ""
            font.pixelSize: 15
            anchors.centerIn: parent
        }
    }
}
