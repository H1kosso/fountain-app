import QtQuick
import QtQuick.Controls
import "../controls"

Item {
    id: root
    width: parent.width - 10
    height: 800
    anchors.horizontalCenter: parent.horizontalCenter

    Image{
        id: kiLogo
        source: "../../assets/img/ki.jpg"
        anchors.horizontalCenter: parent.horizontalCenter

        anchors.top: parent.top
        anchors.topMargin: 40

        width: 200
        height: width

    }

    Text{
        id: appName
        anchors.top: kiLogo.bottom
        anchors.topMargin: 20
        text: "Aplikacja do zarządzania kurtyną wodną"
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 19
        font.weight: Font.DemiBold
    }

    Column{
        anchors.top: appName.bottom
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 8

        Text{
            text: "Login:"
            font.pixelSize: 18
        }

        CustomTextInput{
            id: username
            text: "at_admin"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text{
            text: "Hasło:"
            font.pixelSize: 18
        }

        CustomTextInput{
            id: password
            text: "hF7Ya8yEPLXdzGMv4swC9Ue6fb3m5c"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button{
            text: "Zaloguj"
            width: 130
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 16
            onClicked: {
                apiManager.login(username.text, password.text, function(){
                    apiManager.getState();
                    apiManager.getConfig();

                    apiManager.getAllPictures()

                });
            }
        }
    }


}
