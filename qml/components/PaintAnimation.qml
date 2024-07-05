import QtQuick

Rectangle{
    id: root
    width: parent.width - 100
    anchors.horizontalCenter: parent.horizontalCenter
    height: column.height
    color: "orange"

    Column{
        id: column
        spacing: 10
        Text{
            text: "Paint"
        }

        Repeater{
            model: 100
            delegate: Text{
                text: model.index
            }
        }
    }
}
