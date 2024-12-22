import QtQuick
import QtQuick.Controls
import "../utils"
import "../controls"

Rectangle{
    id: root
    width: parent.width - 100
    anchors.horizontalCenter: parent.horizontalCenter
    height: column.height
    color: "lightgreen"



    Column{
        id: column
        spacing: 10
        Text{
            text: "Settings"
        }
        Row{
            Text{
                text: "Mode: "
                anchors.verticalCenter: parent.verticalCenter
            }

            ComboBox{
                textRole: "text"
                valueRole: "value"
                currentIndex: indexOfValue(config.mode)
                onCurrentIndexChanged: config.mode = currentIndex

                model: [
                    {value: 0, text: qsTr("Normal") },
                    {value: 1, text: qsTr("Demo") },
                    {value: 2, text: qsTr("Servis") }
                ]
            }
        }
        Row{
            Text{
                text: "Enable weekends: "
            }
            CheckBox{
                checked: config.enableWeekends
                onClicked: config.enableWeekends = !config.enableWeekends
            }
        }

        Row{
            Text{
                text: "Work time"
            }
            SpinBox{
                stepSize: 1
                value: config.workTime
                onValueChanged: config.workTime = value
                to: 60
                from: 0
                editable: true
            }
        }

        Row{
            Text{
                text: "Idle time"
            }
            SpinBox{
                stepSize: 1
                value: config.idleTime
                onValueChanged: config.idleTime = value
                to: 60
                from: 0
                editable: true
            }
        }

        Row{
            Text{
                text: "Work range from"
            }
            SpinBox{
                stepSize: 1
                value: config.workRangeFrom
                onValueChanged: config.workRangeFrom = value
                to: 24
                from: 0
                editable: true
            }
        }

        Row{
            Text{
                text: "Work range to"
            }
            SpinBox{
                stepSize: 1
                value: config.workRangeTo
                onValueChanged: config.workRangeTo = value
                to: 24
                from: 0
                editable: true
            }
        }

        Row{
            id: colorsSelect
            spacing: 10
            property bool mainSelected: true
            onMainSelectedChanged: {
                colorPicker.value = mainSelected ? config.main : config.secondary
            }

            Rectangle{
                width: 100
                height: 20
                radius: 5
                color: config.main
                border.color: "white"
                border.width: colorsSelect.mainSelected ? 1 : 0
                Text{
                    anchors.centerIn: parent
                    text: "Main color"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: colorsSelect.mainSelected = true
                }
            }

            Rectangle{
                width: 100
                height: 20
                radius: 5
                color: config.secondary
                border.color: "white"
                border.width: colorsSelect.mainSelected ? 0 : 1
                Text{
                    anchors.centerIn: parent
                    text: "Secondary color"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: colorsSelect.mainSelected = false
                }
            }

        }

        Row{
            ColorPicker{
                id: colorPicker

            }
        }

        Row{
            Button{
                text: "Post data"
                onClicked: apiManager.postConfig()
            }
        }


    }
    Component.onCompleted: {
        apiManager.login(function() {
            apiManager.loginLocal(function(){
                apiManager.getConfig(function() {
                    apiManager.getState(function(){
                        colorPicker.value = config.main
                        console.log("All operations completed in sequence");
                    });
                });
            });
        });
    }

    ApiManager{
        id: apiManager
    }
}
