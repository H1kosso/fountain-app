import QtQuick
import com.fountain
Item {
    id: root

    property string url: "http://at-waterscreen.ddnsking.com/api"

    property string loginToken: ""

    function getConfig(callback) {
        const request = new XMLHttpRequest()

        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    console.log("Get Config response", request.responseText)
                    var result = JSON.parse(request.responseText)

                    config.mode = result.mode
                    config.enableWeekends = result.enableWeekends
                    config.workTime = result.workTime
                    config.idleTime = result.idleTime
                    config.mailList = result.mailList
                    config.workRangeFrom = result.workRange.from
                    config.workRangeTo = result.workRange.to

                    if (callback) callback()
                } else {
                    console.log("HTTP getConfig:", request.status, request.statusText)
                }
            }
        }
        request.open("GET", url + "/dashboard/config", true)
        request.setRequestHeader("Authorization", "Bearer " + loginToken);
        request.send()
    }

    function postConfig(callback) {
        const request = new XMLHttpRequest();

        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    console.log("postConfig response", request.responseText);
                    if (callback) callback()
                } else {
                    console.log("HTTP postConfig:", request.status, request.statusText);
                }
            }
        };

        request.open("POST", url + "/dashboard/config", true);

        request.setRequestHeader("Content-Type", "application/json");
        request.setRequestHeader("Authorization", "Bearer " + loginToken);

        const data = {
            "mode": config.mode,
            "enableWeekends": config.enableWeekends,
            "workTime": config.workTime,
            "idleTime": config.idleTime,
            "mailList": config.mailList,
            "workRange": {
                "from": config.workRangeFrom,
                "to": config.workRangeTo
            }
        };

        request.send(JSON.stringify(data));
        console.log(JSON.stringify(data))
    }

    function login(username, password, callback) {
        const request = new XMLHttpRequest();

        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    console.log("Login response", request.responseText);
                    var result = JSON.parse(request.responseText)

                    loginToken = result.token
                    appRoot.state = "home"
                    if (callback) callback()
                } else {
                    console.log("HTTP login:", request.status, request.statusText);
                }
            }
        };

        request.open("POST", url + "/dashboard/login", true);

        request.setRequestHeader("Content-Type", "application/json");
        const data = {
            "username": username,
            "password": password
        };

        request.send(JSON.stringify(data));
    }

    function getState(callback){
        const request = new XMLHttpRequest()
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    console.log("getState response", request.responseText)
                    var result = JSON.parse(request.responseText)

                    fountainState.mode = result.mode
                    fountainState.fluidLevel = result.fluidLevel
                    fountainState.isPresenting = result.isPresenting

                    if (callback) callback()
                } else {
                    console.log("HTTP getState:", request.status, request.statusText)
                }
            }
        }
        request.open("GET", url + "/dashboard/state", true)
        request.setRequestHeader("Authorization", "Bearer " + loginToken);
        request.send()
    }

    function getAllPictures(callback){
        const request = new XMLHttpRequest()
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    var result = JSON.parse(request.responseText)
                    console.log("getAllPictures response", request.responseText)
                    if (callback) callback(result)
                } else {
                    console.log("HTTP getAllPictures:", request.status, request.statusText)
                }
            }
        }
        request.open("GET", url + "/dashboard/pictures", true)
        request.setRequestHeader("Authorization", "Bearer " + loginToken);

        request.send()
    }

    function deletePicture(id, callback){
        const request = new XMLHttpRequest()
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    var result = JSON.parse(request.responseText)
                    if (callback) callback(result)
                } else {
                    console.log("HTTP deletePicrure:", request.status, request.statusText)
                }
            }
        }
        request.open("DELETE", url + "/dashboard/pictures/"+id, true)
        request.setRequestHeader("Authorization", "Bearer " + loginToken);
        request.send()
    }

    function addPicture(size, image, mainColor, secondaryColor, callback) {
        const request = new XMLHttpRequest();

        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    var result = JSON.parse(request.responseText);
                    if (callback) callback();
                } else {
                    console.log("HTTP post picture:", request.status, request.statusText);
                }
            }
        };

        request.open("POST", url + "/dashboard/pictures", true);

        request.setRequestHeader("Content-Type", "application/json");
        request.setRequestHeader("Authorization", "Bearer " + loginToken);

        const payload = {
            size: size,
            data: image,
            "colors": {
                "main":{
                    "r": mainColor.r / 255,
                    "g": mainColor.g / 255,
                    "b": mainColor.b / 255,
                },
                "secondary":{
                    "r": secondaryColor.r / 255,
                    "g": secondaryColor.g / 255,
                    "b": secondaryColor.b / 255,
                }
            }
        };
        request.send(JSON.stringify(payload));
    }

}
