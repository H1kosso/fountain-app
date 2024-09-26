import QtQuick
import QmlFountainApp

Rectangle{
    id: root
    width: parent.width - 10
    anchors.horizontalCenter: parent.horizontalCenter
    height: column.height
    color: "orange"

    Column{
        id: column
        width: parent.width
        spacing: 3

        Repeater{
            id: columnRepeater

            model: 10
            delegate: Row{
                Repeater{
                    id: rowRepeater
                    model: 64

                    delegate: Rectangle {
                        color: index % 2 ? "black" : "white"
                        height: 10
                        width: column.width / rowRepeater.count
                    }
                }
            }
        }
    }
}
