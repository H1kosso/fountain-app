import QtQuick

Row{
    id: root
    spacing: 3
    property color colorValue: "grey"
    property alias text: label.text
    height: 15

    Rectangle{
        height: 1
        width: 20
        color: root.colorValue
        anchors.verticalCenter: parent.verticalCenter
    }

    Text{
        id: label
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -1
    }

    Rectangle{
        height: 1
        width: 150
        color: root.colorValue
        anchors.verticalCenter: parent.verticalCenter
    }
}
