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
        spacing: 10

        CustomButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 140
            height: 30
            pixelSize: 20
            source: "../../assets/icons/undo.png"
            text: "Powrót"
            onClicked: {
                appRoot.state = "bluetooth"
            }
        }

        property bool logsOn: true

        CustomButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 140
            height: 30
            pixelSize: 20
            source: column.logsOn ? "../../assets/icons/on.png" : "../../assets/icons/off.png"
            text: column.logsOn ? "Wyłącz logi" : "Włącz logi"
            onClicked: {
                bledevice.writeData();
                column.logsOn = !column.logsOn

            }
        }
        Column{
            id: logsData
            spacing: 3


            Repeater{
                model: bledevice.logsListModel

                delegate: Text{
                    text: model.count
                    color: "#3A3C3C"
                }
            }
        }
    }
}
