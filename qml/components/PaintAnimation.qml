import QtQuick
import com.fountain
import QtQuick.Controls
import "../utils"

Rectangle {
    id: root
    width: parent.width - 10
    anchors.horizontalCenter: parent.horizontalCenter
    //height: content.height

    // ImageInfo {
    //     id: singleImage
    //     Component.onCompleted: console.log(image)
    // }

    // Item {
    //     id: content
    //     width: parent.width
    //     height: column.height + paintMenu.height + 50

    //     Row {
    //         id: paintMenu
    //         anchors.top: parent.top
    //         spacing: 8
    //         property int brushMode: 1

    //         Button {
    //             text: "Paint"
    //             onClicked: parent.brushMode = 1
    //         }

    //         Button {
    //             text: "Erase"
    //             onClicked: parent.brushMode = 0
    //         }
    //         Button {
    //             text: "add row"
    //             onClicked: {
    //                 singleImage.addRow(1)
    //                 validateColor();
    //             }
    //         }
    //         Button {
    //             text: singleImage.size
    //             onClicked: console.log(singleImage.image)
    //         }
    //     }

    //     Column {
    //         id: column
    //         width: parent.width
    //         anchors.top: paintMenu.bottom
    //         anchors.topMargin: 10
    //         anchors.horizontalCenter: parent.horizontalCenter

    //         Repeater {
    //             id: columnRepeater
    //             model: singleImage.ready ? singleImage.size : []

    //             delegate: Row {
    //                 Repeater {
    //                     id: rowRepeater
    //                     property int columnIndex: index
    //                     model: 64

    //                     delegate: Rectangle {
    //                         id: pixel
    //                         width: root.width / 64
    //                         height: width
    //                         color: singleImage.ready ? singleImage[index][rowRepeater.columnIndex] === 1 ? config.main : config.secondary : config.secondary

    //                     }
    //                 }
    //             }
    //         }
    //     }

    //     MouseArea {
    //         anchors.fill: column
    //         hoverEnabled: true
    //         cursorShape: Qt.PointingHandCursor
    //         onMouseYChanged: if (containsPress) colorPixel()
    //         onMouseXChanged: if (containsPress) colorPixel()
    //         preventStealing: true

    //         function colorPixel() {
    //             var indexX = Math.floor(mouseX/(root.width/64))
    //             var indexY = Math.floor(mouseY/(root.width/64))

    //             singleImage.setColorAt(indexY, indexX, paintMenu.brushMode)
    //             var targetRect = columnRepeater.itemAt(indexY).children[indexX]
    //             targetRect.color = paintMenu.brushMode === 1 ? config.main : config.secondary
    //         }
    //     }

    // }

    // function validateColor(){
    //     for( var i = 0 ; i < singleImage.size ; i++){
    //         for( var j = 0 ; j < 64 ; j++){
    //             var targetRect = columnRepeater.itemAt(j).children[i]
    //             targetRect.color = singleImage[i][j] === 1 ? config.main : config.secondary
    //         }
    //     }
    // }
}
