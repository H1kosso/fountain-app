import QtQuick

Rectangle{
    id: root
    width: parent.width - 100
    anchors.horizontalCenter: parent.horizontalCenter
    height: column.height
    color: "yellow"

    Column{
        id: column
        spacing: 10
        Text{
            text: "Home"
        }

        Image{
            source: 'qrc:/assets/img/dog.jpg'
        }

        Repeater{
            model: 100
            delegate: Text{
                text: model.index
            }
        }
    }
}
