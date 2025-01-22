import QtQuick
import QtQuick.Controls
import "../controls"

Drawer {
    id: root

    background: Rectangle{
        anchors.fill: parent
        color: theme.menu
    }
    MenuButton{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        text: "O aplikacji"
        source: "../../assets/icons/info.png"
        onClicked: {
            contentRoot.state = "about"
            menu.close()
        }
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
                ListElement{ text: "Konfiguracja BLE"; value: "bluetooth"; source: "../../assets/icons/terminal.png"}
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

        Column {
            id: bleDevicesView
            width: parent.width
            spacing: 5
            Repeater{
                model: bledevice.deviceListModel
                delegate: Rectangle{
                    color: "transparent"
                    border.width: 2
                    border.color: "#6C757D"
                    width: 200
                    height: 30
                    radius: 8

                    Text{
                        anchors.centerIn: parent
                        text: modelData
                        font.pixelSize: 21

                    }

                    MouseArea{
                        onClicked: {
                            scanButton.enabled=false;
                            scanButton.text="Connecting to "+modelData
                            bledevice.startConnect(index)
                        }
                        anchors.fill: parent
                    }
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
            scanButton.text = "Połączono"
        }
        function onConnectionEnd() {
            appRoot.isBTconnected = false
            scanButton.text = "Rozłączono"
            scanButton.enabled = true
            bledevice.resetDeviceListModel()
            console.log("ConnectionEnd")
        }
    }
}
