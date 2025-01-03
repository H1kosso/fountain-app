import QtQuick
import "../utils"
import ".//gallery"

Rectangle {
    id: root
    width: parent.width - 10
    anchors.horizontalCenter: parent.horizontalCenter
    height: contentColumn.height + contentColumn.y * 2

    Grid{
        id: contentColumn
        y: 16
        spacing: 8
        columns: 2

        Repeater{
            id: picturesRepeater
            model: ListModel{}

            delegate: Item{
                id: delegateImage
                width: (root.width - 24)/2
                height: Math.min(width, column.height)

                property var pictureData: []
                property var binaryMatrix: []

                ImageInfo{
                    id: imageInfo
                }

                Column {
                    id: column
                    width: parent.width
                    anchors.top: parent.top
                    anchors.left: parent.left

                    Repeater {
                        id: rowRepeater
                        model: imageInfo.model
                        property ListModel aliasModel: model
                        delegate: RowDelegate{
                            width: parent.width

                            Component.onCompleted: {
                                for (var j = 0; j < imageInfo._rowLength ; j++) {
                                    var propertyName = "valueCol" + j;
                                    valueModel.append({"value": model[propertyName]})
                                }
                            }
                        }
                    }
                }

                Rectangle{
                    color: "red"
                    width: 10
                    height: width

                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.top: parent.top
                    anchors.topMargin: 5

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            galleryApiManager.deletePicture(imageInfo._id);
                            getPictures();
                        }
                    }
                }

                Component.onCompleted:{
                    pictureData = JSON.parse(model.data);

                    binaryMatrix = pictureData.map(function(num) {

                        var binaryString = num.toString(2); // Zamiana liczby na binarną postać

                        while (binaryString.length < 64) {
                            binaryString = "0" + binaryString;
                        }

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
                            imageInfo.image.push(newRow)
                        }
                    }

                    imageInfo.size = model.size
                    imageInfo._id = model._id
                    imageInfo.arrayToListModel(binaryMatrix)
                }

            }
        }
    }

    Component.onCompleted: {
        getPictures()
    }

    function getPictures(){
        galleryApiManager.loginLocal(function(){
            galleryApiManager.getAllPictures(function(pictures){
                picturesRepeater.model.clear();
                for(var i = 0 ; i < pictures.length ; i++){
                    var pictureData = JSON.stringify(pictures[i].data);

                    picturesRepeater.model.append({
                                                      "_id": pictures[i]._id,
                                                      "size": pictures[i].size,
                                                      "data": pictureData
                                                  });
                }
            });
        });
    }

    ApiManager{
        id: galleryApiManager
    }
}
