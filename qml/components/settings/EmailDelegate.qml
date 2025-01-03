import QtQuick

Item {
    width: 200
    height: 30

    // Alias dla tekstu i przycisku
    property alias text: label.text
    property alias button: deleteButton
    property var deleteFunction



    Text {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        x: 10
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        width: 10
        height: 10
        color: "red"

        MouseArea {
            id: deleteButton
            anchors.fill: parent
        }
    }
}
