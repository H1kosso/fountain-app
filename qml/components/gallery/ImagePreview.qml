import QtQuick
import com.fountain

Item{
    id: root
    property bool loaded: false

    Column {
        id: column
        width: parent.width
        anchors.top: parent.top

        Repeater {
            id: columnRepeater
            model: 64
            delegate: Row {
                Repeater {
                    id: rowRepeater
                    property int columnIndex: index
                    model: 64

                    delegate: Rectangle {



                        id: pixel
                        width: root.width / 64
                        height: width
                        //color: loaded ?  root.preview[index * rowRepeater.columnIndex] === 1 ? config.main : config.secondary : "black"
                    }
                }
            }
        }
    }
}
