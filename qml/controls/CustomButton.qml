import QtQuick
import "../utils"

MouseArea{
    id: root

    width: row.width + 10
    height: 25
    hoverEnabled: true

    property alias text: label.text
    property alias source: icon.source
    property alias textColor: label.color
    property alias pixelSize: label.font.pixelSize

    Rectangle{
        id: rect
        anchors.fill: parent
        radius: 6
        color: theme.customButton

        Row{
            id: row
            spacing: 5
            anchors.verticalCenter: parent.verticalCenter
            x: 5

            Image{
                id: icon
                width: rect.height - 10
                height: width
                anchors.verticalCenter: parent.verticalCenter
                visible: source !== ""
            }

            Text{
                id: label
                color: theme.textPrimary
                text: ""
                font.pixelSize: 15
                anchors.verticalCenter: parent.verticalCenter
                visible: text !== ""
            }
        }
    }
}
