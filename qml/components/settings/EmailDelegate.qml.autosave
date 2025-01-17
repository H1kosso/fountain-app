import QtQuick

Item {
    width: 270
    height: 30

    property alias text: label.text
    property alias button: deleteButton
    property var deleteFunction

    Text {
        id: label
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        width: 20
        height: width
        color: "transparent"
        border.width: 1
        border.color: "black"
        radius: 4

        Image{
            width: 16
            height: 16
            anchors.centerIn: parent
            source: "../../../assets/icons/delete.png"
        }

        MouseArea {
            id: deleteButton
            anchors.fill: parent
        }
    }
}
