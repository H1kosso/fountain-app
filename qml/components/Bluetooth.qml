import QtQuick
import QtQuick.Controls
import "../utils"
import "./gallery"
import "../controls"
import "./settings"

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
            width: 200
            height: 30
            pixelSize: 20
            source: "../../assets/icons/eye.png"
            text: "Podgląd obrazu"
            onClicked: {
                appRoot.state = "deviceMemoryImage"
            }
        }

        CustomButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 200
            height: 30
            pixelSize: 20
            source: "../../assets/icons/log.png"
            text: "Logi systemowe"
            onClicked: {
                appRoot.state = "logs"
            }
        }

        CustomButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 200
            height: 30
            pixelSize: 17
            source: bledevice.realTimeActive ? "../../assets/icons/on.png" : "../../assets/icons/off.png"
            text: bledevice.realTimeActive  ? "Wyłącz tryb Real Time" : "Włącz tryb Real Time"
            onClicked: bledevice.toggleRealTime();

        }
    }

    Column{
        width: parent.width
        anchors.top: column.bottom
        anchors.topMargin: 50

        spacing: 10

        Text{
            font.pixelSize: 18
            text: "Sieć wifi"
            font.weight: Font.DemiBold
            color: "#3A3C3C"
        }

        Column{
            width: parent.width
            spacing: 5

            Text{
                text: "Nazwa"
                color: "#3A3C3C"
            }
            CustomTextInput{
                id: ssid
                width: parent.width
                text: "XDXD"
            }
        }

        Column{
            width: parent.width
            spacing: 5

            Text{
                text: "Hasło"
                color: "#3A3C3C"
            }
            CustomTextInput{
                id: password
                width: parent.width
                text: "DOMCIA"
            }
        }

        CustomButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 100
            height: 30
            pixelSize: 20
            source: "../../assets/icons/save.png"
            text: "Zapisz"
            onClicked: {
                bledevice.parseQmlWifiToBLE(ssid.text, password.text)
                bledevice.updateWifiOnDevice()
            }
        }
    }
}
