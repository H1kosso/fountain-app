import QtQuick
import QtQuick.Controls
import "../controls"

Drawer {
    id: root

    background: Rectangle{
        anchors.fill: parent
        color: theme.menu
    }
    Column{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 15

        spacing: 7

        Repeater{
            model: ListModel{
                ListElement{ text: "Ekran Główny"; value: "home"; source: "../../assets/icons/home.png" }
                ListElement{ text: "Ustawienia"; value: "settings"; source: "../../assets/icons/settings.png" }
                ListElement{ text: "Własna animacja"; value: "paintAnimation"; source: "../../assets/icons/paint.png" }
                ListElement{ text: "Galeria"; value: "gallery"; source: "../../assets/icons/gallery.png" }
                ListElement{ text: "Bluetooth"; value: "bluetooth"; source: "../../assets/icons/terminal.png"}
            }

            delegate: MenuButton{
                visible: value !== "bluetooth" || appRoot.isBTconnected
                text: model.text
                source: model.source
                onClicked: {
                    contentRoot.state = model.value
                    menu.close()

                    switch(model.value){
                    case "settings":
                        settings.fetchConfig()
                        break;
                    case "gallery":
                        gallery.fetchPictures()
                        break;
                    }
                }
            }
        }

        MenuButton{
            id: scanButton
            text: "Wyszukaj urządzenie"
            source: "../../assets/icons/bluetooth.png"
            onClicked: {
                bleDevicesView.enabled=false
                if(!appRoot.isBTconnected) {
                    text="Wyszukiwanie..."
                    enabled = false
                    busyIndicator.running=true
                    bledevice.startScan()
                } else {
                    bledevice.disconnectFromDevice()
                }
            }
        }

        BusyIndicator {
            id: busyIndicator
            anchors.horizontalCenter: parent.horizontalCenter
            running: false
        }


        ListView {
            id: bleDevicesView
            width: parent.width
            clip: true
            //model: bledevice.deviceListModel
            delegate: RadioDelegate {
                id: radioDelegate
                text: (index+1)+". "+modelData
                width: bleDevicesView.width
                onCheckedChanged: {
                    console.log("checked", modelData, index)
                    scanButton.enabled=false;
                    scanButton.text="Łączenie z "+modelData
                    bleDevicesView.enabled = false;
                    bledevice.startConnect(index)
                }
            }
        }
    }

    Connections {
        target: bledevice

        function onScanningFinished() {
            bleDevicesView.enabled = true
            scanButton.enabled = true
            scanButton.text = "Wyszukaj urządzenie"
            bleDevicesView.enabled = true
            busyIndicator.running = false
            scanButton.enabled = true
            console.log("ScanningFinished")
        }
        function onConnectionStart() {
            appRoot.isBTconnected = true
            busyIndicator.running = false
            console.log("ConnectionStart")
        }
        function onConnectionEnd() {
            appRoot.isBTconnected = false
            scanButton.text = "Rozłączono - wyszukaj ponownie"
            scanButton.enabled = true
            bledevice.resetDeviceListModel()
            console.log("ConnectionEnd")
        }
    }
}
