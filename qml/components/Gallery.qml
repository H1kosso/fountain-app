import QtQuick
import "../utils"
import "./gallery"

Item {
    id: root
    width: parent.width - 10
    anchors.horizontalCenter: parent.horizontalCenter
    height: contentColumn.height + contentColumn.y * 2

    Column{
        id: contentColumn
        y: 16
        spacing: 8

        Text{
            text: "Galeria"
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 19
            font.weight: Font.DemiBold
        }

        Text{
            visible: appRoot.isBTconnected
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Przycisk <b>+</b> dopisuje wybraną grafike do obrazka, który można nastepnie przesłać do pamięci urządzenia"
            wrapMode: Text.Wrap
            width: parent.width - 50
            font.pixelSize: 15
            horizontalAlignment: Text.AlignJustify
        }

        Text{
            visible: bledevice.connected && bledevice.realTimeActive
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Przycisk <b>Play</b> pozwala wyświetlić wybrany obraz w czasie rzeczywistym"
            wrapMode: Text.Wrap
            width: parent.width - 50
            font.pixelSize: 15
            horizontalAlignment: Text.AlignJustify
        }

        Image{
            source: "../../assets/icons/no-pictures.png"
            anchors.horizontalCenter: parent.horizontalCenter
            visible: picturesRepeater.model.count === 0
            width: root.width
            fillMode: Image.PreserveAspectFit
        }

        Repeater{
            id: picturesRepeater
            model: ListModel{}

            delegate: Item{
                id: delegateImage
                width: root.width
                height: column.height



                ImageInfo{
                    id: imageInfo
                }

                Column {
                    id: column
                    width: parent.width

                    Repeater {
                        id: rowRepeater
                        model: imageInfo.model

                        delegate: RowDelegate{
                            width: parent.width

                            Component.onCompleted: {
                                mainColor = imageInfo.mainColor
                                secondaryColor = imageInfo.secondaryColor

                                for (var j = 0; j < 64 ; j++) {
                                    var propertyName = "valueCol" + j;
                                    valueModel.append({"value": model[propertyName]})
                                }
                            }
                        }
                    }
                }

                Row{
                    spacing: 5
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    anchors.right: parent.right
                    anchors.rightMargin: 5


                    Rectangle{
                        id: addButton
                        visible: appRoot.isBTconnected
                        color: "green"
                        width: 22
                        height: width

                        border.width: 1
                        border.color: "black"

                        Image{
                            anchors.centerIn: parent
                            source: "../../assets/icons/add.png"
                            width: 18
                            height: width
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                config.pictureData = delegateImage.pictureData
                                imageBLEConfig.pictureData.push(...delegateImage.pictureData)
                                imageBLEConfig.size += delegateImage.pictureData.length
                                imageBLEConfig.imageToBinary();
                                imageBLEConfig.arrayToListModel(imageBLEConfig.binaryImage)
                            }
                        }
                    }

                    Rectangle{
                        id: playButton
                        color: "lightblue"
                        width: 22
                        height: width

                        border.width: 1
                        border.color: "black"
                        visible: appRoot.isBTconnected

                        Image{
                            anchors.centerIn: parent
                            source: "../../assets/icons/play-button.png"
                            width: 18
                            height: width
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                imageInfo.pictureData = delegateImage.pictureData
                                bledevice.parseQMLImageToBLE(imageInfo.size, delegateImage.pictureData, imageInfo.mainColor, imageInfo.secondaryColor)
                                bledevice.sendImage();
                            }
                        }
                    }

                    Rectangle{
                        id: deleteButton
                        color: "red"
                        width: 22
                        height: width
                        border.width: 1
                        border.color: "black"

                        Image{
                            anchors.centerIn: parent
                            source: "../../assets/icons/delete.png"
                            width: 18
                            height: width
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                apiManager.deletePicture(imageInfo._id);
                                fetchPictures();
                            }
                        }
                    }
                }

                property var pictureData: []
                property var binaryMatrix: []

                Component.onCompleted:{
                    pictureData = JSON.parse(model.data);
                    binaryMatrix = pictureData.map(function(num) {

                        var binaryString = ""
                        num = parseInt(num)
                        binaryString = num.toString(2);

                        while (binaryString.length < 64)
                            binaryString = "0" + binaryString;

                        var binaryArray = binaryString.split('').map(function(digit) {
                            return parseInt(digit);
                        });

                        return binaryArray;
                    });

                    if (imageInfo.model.count > 0) {
                        for( var i = 0 ; i  < imageInfo.model.count ; i++){
                            var listModelRow = imageInfo.model.get(i)
                            var newRow = []
                            for (var j = 0; j < 64; j++) {
                                var propertyName = "valueCol" + j;
                                newRow.push(listModelRow[propertyName]);
                            }
                            imageInfo.pictureData.push(newRow)
                        }
                    }

                    imageInfo.mainColor = model.mainColor
                    imageInfo.secondaryColor = model.secondaryColor
                    imageInfo.size = model.size
                    imageInfo._id = model._id
                    imageInfo.arrayToListModel(binaryMatrix)
                }
            }
        }
    }

    function fetchPictures(){
        apiManager.getAllPictures(function(pictures){
            picturesRepeater.model.clear();
            for(var i = 0 ; i < pictures.length ; i++){

                var pictureData = JSON.stringify(pictures[i].data);

                var main = Qt.rgba(pictures[i].colors.main.r * 255, pictures[i].colors.main.g * 255, pictures[i].colors.main.b * 255, 1);
                var secondary = Qt.rgba(pictures[i].colors.secondary.r * 255, pictures[i].colors.secondary.g * 255, pictures[i].colors.secondary.b * 255, 1);

                picturesRepeater.model.append({
                                                  "_id": pictures[i]._id,
                                                  "size": pictures[i].size,
                                                  "data": pictureData,
                                                  "mainColor": main,
                                                  "secondaryColor": secondary
                                              });
            }
        });
    }
}
