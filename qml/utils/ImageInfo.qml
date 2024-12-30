import QtQuick

Item {
    id: root
    property color mainColor: "black"
    property color secondaryColor: "red"

    property string _id
    property int size: 0
    property var image: []
    property int _rowLength: 64
    property bool ready: false
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
        ready = false;
        image = [];

        for (var i = 0; i < rows; i++) {
            var row = [];
            for (var j = 0; j < 64; j++) {
                row.push(0);
            }
            image.push(row);
        }
        size = rows;
        ready = true;
    }

    function setColorAt(row, column, value) {
        var index = row * 64 + column;
        if (index < image.length * 64) {
            var rowIndex = Math.floor(index / 64);
            var colIndex = index % 64;
            image[rowIndex][colIndex] = value;
        }
    }

    function addRow(numRows) {
        ready = false;
        for (var i = 0; i < numRows; i++) {
            var newRow = (new Array(64)).fill(0)
            image.push(newRow);
        }
        size += numRows;
        ready = true;
    }

    Component.onCompleted: {
        fillImage(32)
    }
}
