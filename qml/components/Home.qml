import QtQuick

Item{
    id: root
    width: parent.width - 100
    anchors.horizontalCenter: parent.horizontalCenter
    height: column.height

    Column{
        id: column
        spacing: 10

        Text{
            text: "Home"
        }

        Repeater{
            model: 100
            delegate: Text{
                text: model.index
            }
        }
    }
}
