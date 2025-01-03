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
            }

            Text{
                text: "Wykonał Marcin Onik"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text{
                text: "kontakt: onikmarcin@wp.pl"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Column{
            spacing: 3
            anchors.horizontalCenter: parent.horizontalCenter

            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Fontanna działa obecnie w trybie:"
            }

            Text{
                text: ["Normal", "Demo", "Service"][fountainState.mode]
                anchors.horizontalCenter: parent.horizontalCenter
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
            }

            Text{
                text: ["Optymalny", "Za niski"][fountainState.fluidLevel]
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }



    }
}
