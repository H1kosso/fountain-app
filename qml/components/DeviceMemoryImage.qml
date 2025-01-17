import QtQuick
import QtQuick.Controls
import "../utils"
import "./gallery"
import "../controls"

Item{
    id: root
    width: parent.width - 10
    anchors.horizontalCenter: parent.horizontalCenter
    height: column.height

    Column {
        id: column
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter

        Column{
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            ToolbarButton {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 130
                height: 30
                pixelSize: 20
                source: "../../assets/icons/undo.png"
                text: "Powrót"
                onClicked: {
                    appRoot.state = "bluetooth"
                }
            }

            ToolbarButton {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 130
                height: 30
                pixelSize: 20
                source: "../../assets/icons/close.png"
                text: "Wyczyść"
                onClicked: {
                    imageBLEConfig.reset();
                }
            }

            ToolbarButton {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 130
                height: 30
                pixelSize: 20
                source: "../../assets/icons/bt-upload.png"
                text: "Zapisz"
            }
        }
        Column{
            id: colorsSelect
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5
            property bool mainSelected: true
            onMainSelectedChanged: {
                colorPicker.value = mainSelected ? imageBLEConfig.mainColor : imageBLEConfig.secondaryColor
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
                    color: imageBLEConfig.mainColor
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
                    color: imageBLEConfig.secondaryColor
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
                custom: false
            }

        }

        Image{
            source: "../../assets/icons/no-pictures.png"
            anchors.horizontalCenter: parent.horizontalCenter
            visible: rowRepeater.model.count === 0
        }

        Repeater {
            id: rowRepeater
            model: imageBLEConfig.model
            delegate: RowDelegate{
                mainColor: imageBLEConfig.mainColor
                secondaryColor: imageBLEConfig.secondaryColor
                width: parent.width

                Component.onCompleted: {
                    for (var j = 0; j < imageBLEConfig._rowLength ; j++) {
                        var propertyName = "valueCol" + j;
                        valueModel.append({"value": model[propertyName]})
                    }
                }
            }
        }
    }
}
