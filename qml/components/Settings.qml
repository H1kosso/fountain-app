import QtQuick
import QtQuick.Controls
import "../utils"
import "../controls"
import "./settings"
import "./gallery"

Item{
    id: root
    width: parent.width - 100
    anchors.horizontalCenter: parent.horizontalCenter
    height: column.height + 10

    Column{
        id: column
        spacing: 10
        width: parent.width

        Item{
            width: 1
            height: 1
        }

        Text{
            text: "Ustawienia ekranu wodnego"
            font.pixelSize: 25
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item{
            width: 1
            height: 2
        }

        Item{
            width: 240
            height: 25

            Text{
                text: "Tryb pracy: "
                anchors.verticalCenter: parent.verticalCenter
            }



            ComboBox{
                id: modeComboBox
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                textRole: "text"
                valueRole: "value"
                currentIndex: indexOfValue(config.mode)
                onCurrentIndexChanged: config.mode = currentIndex

                model: [
                    {value: 0, text: qsTr("Normal") },
                    {value: 1, text: qsTr("Demo") },
                    {value: 2, text: qsTr("Service") }
                ]
            }
        }

        Divider{
            text: "Czas pracy"
        }

        Item{
            width: 240
            height: 25

            Text{
                text: "Aktywny w weekend:"
                anchors.verticalCenter: parent.verticalCenter
            }
            CheckBox{
                checked: config.enableWeekends
                onClicked: config.enableWeekends = !config.enableWeekends
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Item{
            width: 240
            height: 25
            Text{
                text: "Czas prezentowania (min)"
                anchors.verticalCenter: parent.verticalCenter
            }
            SpinBox{
                stepSize: 1
                value: config.workTime
                onValueChanged: config.workTime = value
                to: 60
                from: 0
                editable: true
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Item{
            width: 240
            height: 25
            Text{
                text: "Czas nieaktywności (min)"
                anchors.verticalCenter: parent.verticalCenter
            }
            SpinBox{
                stepSize: 1
                value: config.idleTime
                onValueChanged: config.idleTime = value
                to: 60
                from: 0
                editable: true
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Item{
            width: 240
            height: 25
            Text{
                text: "Aktywna od godziny"
                anchors.verticalCenter: parent.verticalCenter
            }
            SpinBox{
                stepSize: 1
                value: config.workRangeFrom
                onValueChanged: config.workRangeFrom = value
                to: 24
                from: 0
                editable: true
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Item{
            width: 240
            height: 25
            Text{
                text: "Aktywna do godziny"
                anchors.verticalCenter: parent.verticalCenter
            }
            SpinBox{
                stepSize: 1
                value: config.workRangeTo
                onValueChanged: config.workRangeTo = value
                to: 24
                from: 0
                editable: true
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Divider{
            text: "Kolor oświetlenia"
        }

        Column{
            id: colorsSelect
            spacing: 5
            property bool mainSelected: true
            onMainSelectedChanged: {
                colorPicker.value = mainSelected ? config.main : config.secondary
            }
            Item{
                width: 240
                height: 25

                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Kolor główny"
                }

                Rectangle{
                    width: 100
                    height: 20
                    radius: 5
                    color: config.main
                    border.color: "white"
                    border.width: colorsSelect.mainSelected ? 1 : 0
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right

                    MouseArea{
                        anchors.fill: parent
                        onClicked: colorsSelect.mainSelected = true
                    }
                }
            }

            Item{
                width: 240
                height: 25

                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Kolor alternatywny"
                }

                Rectangle{
                    width: 100
                    height: 20
                    radius: 5
                    color: config.secondary
                    border.color: "white"
                    border.width: colorsSelect.mainSelected ? 0 : 1
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right

                    MouseArea{
                        anchors.fill: parent
                        onClicked: colorsSelect.mainSelected = false
                    }
                }
            }

            ColorPicker{
                id: colorPicker

            }
        }

        Divider{
            text: "Lista kontaktowa"
        }

        Column{
            spacing: 5
            Repeater{
                id: emailRepeater
                model: ListModel{}
                delegate: EmailDelegate{
                    text: model.value
                    button.onClicked: emailRepeater.deleteEmail()
                }

                function deleteEmail(){
                    for (var i = 0; i < emailRepeater.model.count; i++) {
                        if(emailRepeater.model.get(i).value === config.mailList[i]){
                            config.mailList.splice(i, 1)
                            emailRepeater.model.remove(i)
                        }
                    }
                }
            }

            Column{
                spacing: 5

                Row{


                    TextInput{
                        id: newEmail
                        width: 200
                        height: 20
                    }

                    ToolbarButton{
                        text: "Dodaj"
                        source: "../../assets/icons/add.png"
                        onClicked: {
                            emailRepeater.model.append({"value": newEmail.text})
                            config.mailList.push(newEmail.text)
                            newEmail.clear()
                        }
                    }
                }
            }
        }


        Row{
            spacing: 10
            ToolbarButton{
                source: "../../../assets/icons/save.png"
                text: "Potwierdź"
                onClicked: apiManager.postConfig()
            }

            ToolbarButton{
                source: "../../../assets/icons/close.png"
                text: "Anuluj"
                onClicked: console.log("TODO")
            }
        }


    }
    Component.onCompleted: {
        apiManager.login(function() {
            apiManager.loginLocal(function(){
                apiManager.getConfig(function() {
                    // Przekształcamy dane na model
                    colorPicker.value = config.main;
                    config.mailList.forEach((element) => emailRepeater.model.append({"value": element}));
                    modeComboBox.currentIndex = modeComboBox.indexOfValue(config.mode);

                    apiManager.getState(function(){
                        ;
                    });
                });
            });
        });
    }

    ApiManager{
        id: apiManager
    }
}
