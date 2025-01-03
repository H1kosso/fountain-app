import QtQuick
import "../utils"

MouseArea{
    id: root

    width: row.width + 10
    height: 25
    hoverEnabled: true

    property alias text: label.text
    property alias source: icon.source

    Rectangle{
        id: rect
        anchors.fill: parent
        radius: 6
        color: theme.toolbarButton

        Row{
            id: row
            spacing: 5
            anchors.centerIn: parent

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
                font.pixelSize: 15
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
