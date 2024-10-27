import QtQuick
import com.fountain
import QtQuick.Controls

Rectangle {
    id: root
    width: parent.width - 10
    anchors.horizontalCenter: parent.horizontalCenter
    height: content.height
    color: "orange"

    SingleImage {
        id: singleImage
        property int test: 1
        image: [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,]]
    }
    Item{
        id: content
        width: parent.width
        height: column.height + paintMenu.height  + 50
        Row{
            id: paintMenu
            anchors.top: parent.top
            spacing: 8
            property int brushMode: 1
            Button {
                text: "Add new row"
                onClicked: {
                    var newRow = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,]];
                    singleImage.image = singleImage.image.concat(newRow);
                }
            }

            Button {
                text: "Add 5 rows"
                onClicked: {
                    var newRow = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,]];
                    for( var i = 0 ; i < 5 ; i++)
                        singleImage.image = singleImage.image.concat(newRow);
                }
            }

            Button{
                text: "Paint"
                onClicked: parent.brushMode = 1
            }

            Button{
                text: "Erase"
                onClicked: parent.brushMode = 0
            }

            Button{
                text: "Clear all"
                onClicked: singleImage.image = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,]]
            }
        }

        Column {
            id: column
            width: parent.width
            anchors.top: paintMenu.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                id: columnRepeater
                model: singleImage.image.length
                delegate: Row{
                    Repeater{
                        id: rowRepeater
                        property int columnIndex: index
                        model: singleImage.image[index].length

                        delegate: Rectangle {
                            id: pixel
                            width: root.width/64
                            height: width
                            color: singleImage.image[rowRepeater.columnIndex][index] !== 0 ? "red" : "black"
                        }
                    }
                }
            }
        }
        MouseArea{
            anchors.fill: column
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onMouseYChanged: if(containsPress) colorPixel()
            onMouseXChanged: if(containsPress) colorPixel()
            preventStealing: true

            function colorPixel(){
                var indexX = Math.floor(mouseX/(root.width/64))
                var indexY = Math.floor(mouseY/(root.width/64))

                singleImage.image[indexY][indexX] = paintMenu.brushMode

            }
        }

    }



}
