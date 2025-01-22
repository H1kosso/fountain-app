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

        Image{
            id: kiLogo
            source: "../../assets/img/ki.jpg"
            anchors.horizontalCenter: parent.horizontalCenter


            width: 200
            height: width
        }

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Aplikacja jest częścią systemu sterowania inteligentną kurtyną wodną. Umożliwia ustawianie czasu pracu, odczytywanie logów przy pomocy BLE, oraz wyświetlanie obrazków w czasie rzeczywistym"
            wrapMode: Text.Wrap
            width: parent.width - 20
            font.pixelSize: 15
            horizontalAlignment: Text.AlignJustify
        }
    }

    Column{
        y: 400
        width: parent.width
        spacing: 1

        Text{
            text: "Twórcy ikon: "
            wrapMode: Text.Wrap
            font.pixelSize: 15
            horizontalAlignment: Text.AlignJustify
        }

        Repeater{
            model: ["Flaticon", "Tempo_doloe", "iconsmind",
                "heisenberg_jr", "Lizel Arina", "juicy_fish", "Febrian Hidayat", "Creative Avenue",  "Freepik", "bqlqn", "Royyan Wijaya",
               "Good Ware", "Those Icons", "Afian Rochmah Afif", "Icon.doit", "Arkinasi", "Yogi Aprelliyanto", "Google", "Smashicons" ]
            delegate: Text{
                 font.pixelSize: 10
                 text: modelData
            }
        }
    }
}
