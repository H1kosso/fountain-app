import QtQuick
import "../utils"

MouseArea{
    id: root

    hoverEnabled: true
    width: 200
    height: 30

    property alias text: label.text
    property alias source: icon.source

    Rectangle{
        id: rect
        anchors.fill: parent
        radius: 10
        color: theme.menuButton

        Row{
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            spacing: 10

            Image{
                id: icon
                width: rect.height - 10
                height: width
                anchors.verticalCenter: parent.verticalCenter
            }

            Text{
                id: label
                color: theme.textPrimary
                text: ""
                font.pixelSize: 17
                 anchors.verticalCenter: parent.verticalCenter

            }
        }


    }
}
