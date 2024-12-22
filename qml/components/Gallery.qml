import QtQuick
import "../utils"

Rectangle {
    id: root
    width: parent.width - 10
    anchors.horizontalCenter: parent.horizontalCenter
    height: contentColumn.height + 20

    Grid{
        id: contentColumn
        y: 16
        spacing: 8
        columns: 4

        Repeater{
            id: picturesRepeater
            model: ListModel{}

            delegate: Rectangle{
                width: (root.width - 24)/4
                height: width
                color: index % 2 ? "red" : "black"

                Item{
                    id: pictureDelegate
                    anchors.fill: parent
                    property var pictureData: []
                    property var binaryMatrix: [] // Dwuwymiarowa tablica dla danych binarnych

                    Component.onCompleted:{
                        // Parsowanie JSON i konwersja liczb na binarne
                        pictureData = JSON.parse(model.data);

                        // Tworzenie dwuwymiarowej tablicy
                        binaryMatrix = pictureData.map(function(num) {
                            var binaryString = num.toString(2); // Zamiana liczby na binarną postać
                            var binaryArray = binaryString.split('').map(function(digit) {
                                return parseInt(digit);  // Zamiana na cyfry (0 lub 1)
                            });
                            return binaryArray; // Zwrócenie tablicy z cyframi binarnymi
                        });
                        //console.log("Binary Matrix: ", binaryMatrix);
                    }

                }
            }
        }
    }

    Component.onCompleted: {
        galleryApiManager.loginLocal(function(){
            galleryApiManager.getAllPictures(function(pictures){
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
