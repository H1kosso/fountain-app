import QtQuick
import QtQuick.Controls

Item{
    id: root
    width: parent.width - 100
    anchors.horizontalCenter: parent.horizontalCenter
    height: column.height


    Column{
        id: column
        spacing: 20
        width: parent.width
        topPadding: 30

    }
}
