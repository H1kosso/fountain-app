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

        ToolbarButton {
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

        ToolbarButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 140
            height: 30
            pixelSize: 20
            source: column.logsOn ? "../../assets/icons/on.png" : "../../assets/icons/off.png"
            text: column.logsOn ? "Wyłącz logi" : "Włącz logi"
            onClicked: column.logsOn = !column.logsOn
        }
        Column{
            id: logsData
            spacing: 3


            Repeater{
                model: ListModel{
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                    ListElement{text: "10:40:23 [DEBUG] Mode selected: Demo"}
                }

                delegate: Text{
                    text: model.text
                    color: "#3A3C3C"
                }
            }
        }
    }
}
