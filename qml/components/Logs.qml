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


        CustomButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 140
            height: 30
            pixelSize: 20
            source: bledevice.logsActive ? "../../assets/icons/on.png" : "../../assets/icons/off.png"
            text: bledevice.logsActive  ? "Wyłącz logi" : "Włącz logi"
            onClicked: bledevice.toggleLogs();

        }

        Column{
            id: logsData
            spacing: 5


            Repeater{
                model: bledevice.logsListModel

                delegate: Text{
                    text: modelData
                    color: "#3A3C3C"
                }
            }
        }
    }
}
