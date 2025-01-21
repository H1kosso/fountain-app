import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: content.width
    height: content.height
    property color value
    required property bool custom

    Row {
        id: content

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5

            Row {
                spacing: 5

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
                    width: 90
                }

                Text {
                    text: (Math.round(root.value.r * 100) / 100).toFixed(2)
                }
            }

            Row {
                spacing: 5

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
                    width: 90
                }

                Text {
                    text: (Math.round(root.value.g * 100) / 100).toFixed(2)
                }
            }

            Row {
                spacing: 5

                Text {
                    text: "B: "
                }

                Slider {
                    from: 0
                    to: 1
                    stepSize: 0.01
                    value: root.value.b
                    onValueChanged: {
                        root.value = Qt.rgba(root.value.r, root.value.g, this.value, 1)
                    }
                    width: 90
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

                width: 90
                height: width
                color: root.value

                Text{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.top
                    anchors.bottomMargin: 5
                    text: "Wciśnij aby zapisać"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if(root.custom)
                                   colorsSelectPaint.mainColorSelected ? customImage.mainColor = root.value : customImage.secondaryColor = root.value
                               else
                                   colorsSelectDevice.mainSelected ? imageBLEConfig.mainColor = root.value : imageBLEConfig.secondaryColor = root.value
                }}
            }
        }
    }
}
