import QtQuick
import QtQuick.Controls


Rectangle{
    height: 30
    width: 290
    border.width: 1
    border.color: "black"
    radius :8
    property alias text: input.text
    clip: true

    TextInput{
        id: input
        anchors.fill: parent
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        verticalAlignment: TextInput.AlignVCenter
        font.pixelSize: 16
    }
}
