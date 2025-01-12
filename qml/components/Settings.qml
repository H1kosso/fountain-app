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
    function dupa(){
        console.log("dupa")
    }

    Column{
        id: column
        spacing: 20
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
            width: 250
            height: 25

            Text{
                text: "Tryb pracy: "
                anchors.verticalCenter: parent.verticalCenter
            }



            ComboBox{
                id: modeComboBox
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: 25
                width: 150
                textRole: "text"
                valueRole: "value"
                currentIndex: indexOfValue(config.mode)
                onCurrentIndexChanged: config.mode = currentIndex

                model: [
                    {value: 0, text: qsTr("Normal") },
                    {value: 1, text: qsTr("Demo") },
                    {value: 2, text: qsTr("Service") },
                    {value: 3, text: qsTr("BLE RealTime") },
                ]
            }
        }

        Divider{
            text: "Czas pracy"
        }

        Item{
            width: 250
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
            width: 250
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
                height: 28
                width: 110
            }
        }

        Item{
            width: 250
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
                height: 28
                width: 110
            }
        }

        Item{
            width: 250
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
                height: 28
                width: 110
            }
        }

        Item{
            width: 250
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
                height: 28
                width: 110
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
                    button.onClicked: emailRepeater.deleteEmail(model.value)
                }

                function deleteEmail(email){
                    for (var i = 0; i < emailRepeater.model.count; i++) {
                        if(email === config.mailList[i]){
                            config.mailList.splice(i, 1)
                            emailRepeater.model.remove(i)
                        }
                    }
                }
            }

            Column{
                spacing: 5

                Row{
                    spacing: 10

                    CustomTextInput{
                        id: newEmail
                        width: 190
                        height: 20
                        anchors.leftMargin: 3
                        anchors.rightMargin: 3
                    }

                    ToolbarButton{
                        text: "Dodaj"
                        source: "../../assets/icons/add.png"
                        onClicked: {
                            emailRepeater.model.append({"value": newEmail.text})
                            config.mailList.push(newEmail.text)
                            newEmail.text = ""
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
                onClicked: apiManager.getConfig(function() {
                    emailRepeater.model.clear()
                    config.mailList.forEach((element) => emailRepeater.model.append({"value": element}));
                    ;
                    modeComboBox.currentIndex = modeComboBox.indexOfValue(config.mode)

                });
            }
        }
    }

    function fetchConfig(){

        apiManager.getConfig(function() {
            emailRepeater.model.clear();
            config.mailList.forEach((element) => emailRepeater.model.append({"value": element}));
            modeComboBox.currentIndex = modeComboBox.indexOfValue(config.mode);


        });
    }
}
