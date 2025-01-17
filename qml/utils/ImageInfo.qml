import QtQuick

Item {
    id: root
    property color mainColor: "black"
    property color secondaryColor: "white"

    property string _id
    property int size: 0
    property var pictureData: []
    property var binaryImage: []
    property int _rowLength: 64
    property ListModel model: ListModel{}
    readonly property int maxLength: 256

    function reset(){
        size = 0;
        pictureData = [];
        binaryImage = [];
        model.clear();
    }

    function arrayToListModel(array, clear=true) {

        if(clear)
            root.model.clear()

        for (var i = 0; i < array.length; i++) {
            var row = {};
            for (var j = 0; j < array[i].length; j++) {
                row["valueCol" + j] = array[i][j];
            }
            root.model.append(row);
        }
    }

    function imageToBinary(){
        binaryImage = pictureData.map(function(num) {

            var binaryString = num.toString(2);

            while (binaryString.length < 64) {
                binaryString = "0" + binaryString;
            }

            var binaryArray = binaryString.split('').map(function(digit) {
                return parseInt(digit);
            });

            return binaryArray;
        });

    }

    function fillImage(rows) {
        pictureData = [];
        model.clear()

        for (var i = 0; i < rows; i++) {
            var row = [];
            var rowModel = {};
            for (var j = 0; j < 64; j++) {
                row.push(0);
                rowModel["valueCol" + j] = 0;
            }
            pictureData.push(row);
            model.append(rowModel);
        }
        size = rows;
    }

    function setColorAt(row, column, value) {
        var index = row * 64 + column;
        if (index < pictureData.length * 64) {
            var rowIndex = Math.floor(index / 64);
            var colIndex = index % 64;
            pictureData[rowIndex][colIndex] = value;

            var rowModel = model.get(rowIndex);
            rowModel["valueCol" + colIndex] = value;
            model.set(rowIndex, rowModel);
        }
    }

    function addRow(rows) {
        if(root.size + rows < maxLength){
            for (var i = 0; i < rows; i++) {

                var row = [];
                var rowModel = {};
                for (var j = 0; j < 64; j++) {
                    row.push(0);
                    rowModel["valueCol" + j] = 0;
                }
                pictureData.push(row);
                model.append(rowModel);
            }
            size += rows;
        }
    }

    function imageToConfigImage() {
        var configImage = [];

        for (var i = 0; i < pictureData.length; i++) {
            var binaryString = "";

            for (var j = 0; j < pictureData[i].length; j++) {
                binaryString += pictureData[i][j].toString();
            }

            var decimalValue = parseInt(binaryString, 2);
            configImage.push(decimalValue);

        }
        return configImage;
    }
}
