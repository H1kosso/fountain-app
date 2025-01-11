import QtQuick

Row{
    id: root
    property ListModel valueModel: ListModel{}
    property color mainColor: "black"
    property color secondaryColor: "white"

    Repeater{
        id: repeater
        model: root.valueModel
        delegate: Rectangle{
            width: root.width/64
            height: width
            color: model.value === 1 ? mainColor : secondaryColor
        }
    }
}
