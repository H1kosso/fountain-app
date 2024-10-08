import QtQuick
import "../utils"

MouseArea{
    id: root

    hoverEnabled: true
    width: 200
    height: 30

    property alias text: label.text

    Rectangle{
        anchors.fill: parent
        radius: 10
        color: theme.menuButton

        Text{
            id: label
            color: theme.textPrimary
            text: ""
            font.pixelSize: 17
            anchors.centerIn: parent

        }
    }
}
