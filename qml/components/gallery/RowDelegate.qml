import QtQuick

Row{
    id: root
    property ListModel valueModel: ListModel{}

    Repeater{
        id: repeater
        model: root.valueModel
        delegate: Rectangle{
            width: root.width/64
            height: width
            color: model.value === 1 ? config.main : config.secondary
        }
    }
}
