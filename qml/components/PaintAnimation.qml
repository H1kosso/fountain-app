import QtQuick
import com.fountain
import QtQuick.Controls
import "../utils"
import "../controls"
import "./gallery"

Item {
    id: root
    width: parent.width - 10
    anchors.horizontalCenter: parent.horizontalCenter
    height: content.height

    ImageInfo {
        id: customImage
        Component.onCompleted: fillImage(32);
    }

    Item {
        id: content
        width: parent.width
        height: column.height + paintMenu.height + 50

        Grid {
            id: paintMenu
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            rows: 2
            columns: 2

            property int brushMode: 1

            ToolbarButton {
                source: "../../assets/icons/paint-brush.png"
                text: "Rysowanie"
                onClicked: parent.brushMode = 1
            }

            ToolbarButton {
                source: "../../assets/icons/eraser.png"
                text: "Usuwanie"
                onClicked: parent.brushMode = 0
            }
            ToolbarButton {
                source: "../../assets/icons/add.png"
                text: "Dodaj wiersz"
                onClicked: {
                    customImage.addRow(1)
                }
            }
            ToolbarButton {
                source: "../../assets/icons/save.png"
                text: "Zapisz"
                onClicked: paintApiManager.loginLocal(function(){
                    paintApiManager.addPicture(customImage.size, customImage.image, config.main, config.secondary, function(){
                        gallery.refresh = true;
                    })
                })
            }
        }

        Column {
            id: column
            width: parent.width
            anchors.top: paintMenu.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                id: rowRepeater
                model: customImage.model
                delegate: RowDelegate{
                    width: parent.width

                    Component.onCompleted: {
                        for (var j = 0; j < customImage._rowLength ; j++) {
                            var propertyName = "valueCol" + j;
                            valueModel.append({"value": model[propertyName]})
                        }
                    }
                }

            }
        }

        MouseArea {
            anchors.fill: column
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onMouseYChanged: if (containsPress) colorPixel()
            onMouseXChanged: if (containsPress) colorPixel()
            preventStealing: true

            function colorPixel() {
                var indexX = Math.floor(mouseX/(root.width/64))
                var indexY = Math.floor(mouseY/(root.width/64))

                customImage.setColorAt(indexY, indexX, paintMenu.brushMode)
                var targetRect = rowRepeater.itemAt(indexY).children[indexX]
                targetRect.color = paintMenu.brushMode === 1 ? config.main : config.secondary
            }
        }
    }

    ApiManager{
        id: paintApiManager
    }
}
