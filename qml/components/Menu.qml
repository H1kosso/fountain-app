import QtQuick
import QtQuick.Controls
import "../controls"

Drawer {
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
                ListElement{ text: "Bluetooth"; value: "bluetooth"; source: "../../assets/icons/terminal.png" }
            }

            delegate: MenuButton{
                text: model.text
                source: model.source
                onClicked: {
                    contentRoot.state = model.value
                    menu.close()
                }
            }
        }
    }


}
