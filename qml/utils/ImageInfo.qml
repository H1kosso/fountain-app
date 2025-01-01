import QtQuick

Item {
    id: root
    property color mainColor: "black"
    property color secondaryColor: "red"

    property string _id
    property int size: 0
    property var image: []
    property int _rowLength: 64
    property ListModel model: ListModel{}

    function arrayToListModel(array) {
        for (var i = 0; i < array.length; i++) {
            // Każdy wiersz tablicy dodajemy jako obiekt w modelu
            var row = {};
            for (var j = 0; j < array[i].length; j++) {
                row["valueCol" + j] = array[i][j]; // Dodajemy wartości do obiektu
            }
            root.model.append(row); // Dodajemy obiekt (wiersz) do modelu
        }
    }

    function fillImage(rows) {
        image = [];
        model.clear()

        for (var i = 0; i < rows; i++) {
            var row = [];
            var rowModel = {};
            for (var j = 0; j < 64; j++) {
                row.push(0);
                rowModel["valueCol" + j] = 0;
            }
            image.push(row);
            model.append(rowModel);
        }
        size = rows;
    }

    function setColorAt(row, column, value) {
        var index = row * 64 + column;
        if (index < image.length * 64) {
            var rowIndex = Math.floor(index / 64);
            var colIndex = index % 64;
            image[rowIndex][colIndex] = value;

            var rowModel = model.get(rowIndex);
            rowModel["valueCol" + colIndex] = value;
            model.set(rowIndex, rowModel);
        }
    }

    function addRow(rows) {
        for (var i = 0; i < rows; i++) {
            var row = [];
            var rowModel = {};
            for (var j = 0; j < 64; j++) {
                row.push(0);
                rowModel["valueCol" + j] = 0;
            }
            image.push(row);
            model.append(rowModel);
        }
        size += rows;
    }

    function imageToConfigImage() {
        var configImage = [];

        for (var i = 0; i < image.length; i++) {
            var binaryString = "";

            for (var j = 0; j < image[i].length; j++) {
                binaryString += image[i][j].toString();
            }

            var decimalValue = parseInt(binaryString, 2);
            configImage.push(decimalValue);
        }

        return configImage;
    }

}
