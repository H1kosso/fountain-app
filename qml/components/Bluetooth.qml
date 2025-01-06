import QtQuick
import QtQuick.Controls

Item{
    id: root
    width: parent.width - 100
    anchors.horizontalCenter: parent.horizontalCenter
    height: column.height
    property bool disconnect: true

    Column{
        id: column
        spacing: 20
        width: parent.width
        topPadding: 30


        Button {
            id: scanButton
            anchors.horizontalCenter: parent.horizontalCenter
            width: 100
            text: "Scan"
            onClicked: {
                listView.enabled=false
                if(disconnect) {
                    text="Scanning..."
                    enabled = false
                    busyIndicator.running=true
                    bledevice.startScan()
                } else {
                    bledevice.disconnectFromDevice()
                }
            }
        }
        ListView {
            id: listView
            width: parent.width
            clip: true
            model: bledevice.deviceListModel
            delegate: RadioDelegate {
                id: radioDelegate
                text: (index+1)+". "+modelData
                width: listView.width
                onCheckedChanged: {
                    console.log("checked", modelData, index)
                    scanButton.enabled=false;
                    scanButton.text="Connecting to "+modelData
                    listView.enabled = false;
                    bledevice.startConnect(index)
                }
            }
        }
        BusyIndicator {
            id: busyIndicator
            anchors.horizontalCenter: parent.horizontalCenter
            running: false
        }

    }

    Connections {
        target: bledevice

        function onScanningFinished() {
            listView.enabled = true
            scanButton.enabled = true
            scanButton.text = "Scan"
            listView.enabled = true
            busyIndicator.running = false
            scanButton.enabled = true
            console.log("ScanningFinished")
        }
        function onConnectionStart() {
            disconnect = false
            busyIndicator.running = false
            console.log("ConnectionStart")
        }
        function onConnectionEnd() {
            disconnect = true
            scanButton.text = "Connection End - Scan again"
            scanButton.enabled = true
            bledevice.resetDeviceListModel()
            console.log("ConnectionEnd")
        }
    }
}
