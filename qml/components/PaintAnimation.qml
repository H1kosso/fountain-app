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

        Column {
            id: paintMenu
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            property int brushMode: 1
            Row{
                spacing: 10


                ToolbarButton {
                    source: "../../assets/icons/paint-brush.png"
                    width: (content.width-10)/2
                    text: "Rysowanie"
                    onClicked: paintMenu.brushMode = 1
                    textColor: paintMenu.brushMode === 1 ? "white" : theme.textPrimary
                }

                ToolbarButton {
                    width: (content.width-10)/2
                    source: "../../assets/icons/eraser.png"
                    text: "Usuwanie"
                    onClicked: paintMenu.brushMode = 0
                    textColor: paintMenu.brushMode === 0 ? "white" : theme.textPrimary
                }

            }

            Row{
                spacing: 10


                ToolbarButton {
                    width: (content.width-10)/2
                    source: "../../assets/icons/add.png"
                    text: "Dodaj 5 wierszy"
                    onClicked: {
                        customImage.addRow(5)
                    }
                }

                Row{
                    id: brushMode
                    property int brushWidth: 1
                    spacing: 3
                    Repeater{
                        model: 3
                        delegate: ToolbarButton{
                            width: ((content.width-10)/2 - 9)/3
                            text: index + 1
                            source: "../../assets/icons/paint-brush" + (index+1) +".png"
                            onClicked: brushMode.brushWidth = index + 1
                            textColor: brushMode.brushWidth === index + 1 ? "white" : theme.textPrimary
                        }

                    }
                }
            }
            Column{
                id: colorsSelect
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 5
                property bool mainSelected: true
                onMainSelectedChanged: {
                    colorPicker.value = mainSelected ? customImage.mainColor : customImage.secondaryColor
                }
                Item{
                    width: 250
                    height: 25

                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Kolor główny"
                    }

                    Rectangle{
                        width: 100
                        height: 20
                        radius: 5
                        color: customImage.mainColor
                        border.color: "white"
                        border.width: colorsSelect.mainSelected ? 1 : 0
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right

                        MouseArea{
                            anchors.fill: parent
                            onClicked: colorsSelect.mainSelected = true
                        }
                    }
                }

                Item{
                    width: 250
                    height: 25

                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Kolor alternatywny"
                    }

                    Rectangle{
                        width: 100
                        height: 20
                        radius: 5
                        color: customImage.secondaryColor
                        border.color: "white"
                        border.width: colorsSelect.mainSelected ? 0 : 1
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right

                        MouseArea{
                            anchors.fill: parent
                            onClicked: colorsSelect.mainSelected = false
                        }
                    }
                }

                ColorPicker{
                    id: colorPicker
                    custom: true
                }
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
                    mainColor: customImage.mainColor
                    secondaryColor: customImage.secondaryColor

                    Component.onCompleted: {
                        for (var j = 0; j < customImage._rowLength ; j++) {
                            var propertyName = "valueCol" + j;
                            valueModel.append({"value": model[propertyName]})
                        }
                    }
                }
            }
        }

        ToolbarButton {
            anchors.top: column.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            width: 120
            height: 40
            pixelSize: 25
            source: "../../assets/icons/save.png"
            text: "Zapisz"
            onClicked: {

                apiManager.addPicture(customImage.size, customImage.imageToConfigImage(), customImage.mainColor, customImage.secondaryColor)
                console.log(customImage.binaryImage)
            }
        }


        MouseArea {
            anchors.fill: column
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onPositionChanged: if (containsPress) colorPixel()
            onClicked: colorPixel()
            preventStealing: true

            function colorPixel() {
                var indexX = Math.floor(mouseX/(root.width/64))
                var indexY = Math.floor(mouseY/(root.width/64))

                for( var i = 0 ; i < brushMode.brushWidth ; i++){
                    if(indexY + i >= customImage.size)
                        continue;
                    for( var j = 0 ; j < brushMode.brushWidth ; j++){
                        if(indexX + j >= customImage._rowLength)
                            break;

                        customImage.setColorAt(indexY+j, indexX+i, paintMenu.brushMode)
                        var targetRect = rowRepeater.itemAt(indexY+i).children[indexX+j]
                        targetRect.color = paintMenu.brushMode === 1 ? customImage.mainColor : customImage.secondaryColor
                    }
                }
            }
        }
    }
}
