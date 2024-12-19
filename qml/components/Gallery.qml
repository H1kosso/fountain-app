import QtQuick

Rectangle {
    id: root
    width: parent.width - 10
    anchors.horizontalCenter: parent.horizontalCenter
    height: contentColumn.height + 20

    Column{
        id: contentColumn
        y: 16
        spacing: 8
        Repeater{
            model: 4

            delegate: Row{
                 spacing: 8
                Repeater{
                    model: 4

                    delegate: Rectangle{
                        width: (root.width - 24)/4
                        height: width
                        color: index % 2 ? "red" : "black"
                    }
                }
            }
        }
    }

}
