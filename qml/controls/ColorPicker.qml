import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: content.width
    height: content.height
    property color value

    Row {
        id: content

        Column {
            anchors.verticalCenter: parent.verticalCenter
            Row {
                Text {
                    text: "R: "
                }
                Slider {
                    from: 0
                    to: 1
                    stepSize: 0.01
                    value: root.value.r
                    onValueChanged: {
                        root.value = Qt.rgba(this.value, root.value.g, root.value.b, 1)
                    }
                }
                Text {
                    text: (Math.round(root.value.r * 100) / 100).toFixed(2)
                }
            }

            Row {
                Text {
                    text: "G: "
                }
                Slider {
                    from: 0
                    to: 1
                    stepSize: 0.01
                    value: root.value.g

                    onValueChanged: {
                        root.value = Qt.rgba(root.value.r, this.value, root.value.b, 1)
                    }
                }
                Text {
                    text: (Math.round(root.value.g * 100) / 100).toFixed(2)
                }
            }

            Row {
                Text {
                    text: "B: "
                }
                Slider {
                    from: 0
                    to: 1
                    stepSize: 0.01
                    value: root.value.b
                    // Update color value safely
                    onValueChanged: {
                        root.value = Qt.rgba(root.value.r, root.value.g, this.value, 1)
                    }
                }
                Text {
                    text: (Math.round(root.value.b * 100) / 100).toFixed(2)
                }
            }
        }

        Item {
            width: 130
            height: width

            Rectangle {
                anchors.centerIn: parent

                width: 100
                height: width
                color: root.value

                Text{
                    anchors.centerIn: parent
                    text: "Click to save"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.top
                    anchors.bottomMargin: 2
                    text: "RGB: " + (Math.round(root.value.r * 100) / 100).toFixed(2) + "," +
                          (Math.round(root.value.g * 100) / 100).toFixed(2) + "," +
                          (Math.round(root.value.b * 100) / 100).toFixed(2)
                }

                MouseArea {
                    id: rect
                    anchors.fill: parent
                    onClicked: colorsSelect.mainSelected ? config.main = root.value : config.secondary = root.value
                }
            }
        }
    }
}
