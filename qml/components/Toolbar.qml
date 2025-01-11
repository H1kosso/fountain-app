import QtQuick
import QtQuick.Controls
import "../controls"
Rectangle{
    height: 40
    color: theme.toolbar

    Row{
        id: rowLeft
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 15
        height: 35
        spacing: 10

        ToolbarButton{
            onClicked: {
                menu.open();
            }

            source: "../../assets/icons/menu.png"
            anchors.verticalCenter: parent.verticalCenter
        }

        ToolbarButton{
            text: "Odśwież"
            source: "../../assets/icons/refresh.png"
            onClicked: gallery.fetchPictures()
            visible: appRoot.state === "gallery"
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Row{
        id: rowRight
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 15
        height: 35

        ToolbarButton{
            onClicked: {
                appRoot.state = "login"
                apiManager.loginToken = ""
            }

            source: "../../assets/icons/logout.png"
            anchors.verticalCenter: parent.verticalCenter
        }

    }
}
