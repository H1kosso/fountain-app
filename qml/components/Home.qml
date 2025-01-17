import QtQuick

Item{
    id: root
    width: parent.width - 100
    anchors.horizontalCenter: parent.horizontalCenter
    height: column.height

    Column{
        id: column
        spacing: 20
        width: parent.width
        topPadding: 30

        Column{
            spacing: 3
            anchors.horizontalCenter: parent.horizontalCenter
            Text{
                text: "Aplikacja do zarządzania kurtyną wodną"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 19
                font.weight: Font.DemiBold
            }

            Text{
                text: "Wykonał Marcin Onik"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 16
            }

            Text{
                text: "kontakt: onikmarcin@wp.pl"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 16
            }
        }

        Column{
            spacing: 3
            anchors.horizontalCenter: parent.horizontalCenter

            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Fontanna działa obecnie w trybie:"
                font.pixelSize: 15
            }

            Text{
                text: ["Normal", "Demo", "Service"][fountainState.mode]
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 13
                font.weight: Font.DemiBold
            }

            Rectangle{
                width: 150
                height: 1

                color: "grey"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Poziom wody w fontannie jest:"
                font.pixelSize: 15
            }

            Text{
                text: ["Optymalny", "Za niski"][fountainState.fluidLevel]
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 13
                color: text === "Za niski" ? "red" : "black"
                font.weight: Font.DemiBold
            }
        }

        Image{
            source: "../../assets/img/preview.jfif"
            width: parent.width
            height: 200
        }
    }
}
