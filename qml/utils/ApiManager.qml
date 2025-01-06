import QtQuick
import com.fountain
Item {
    id: root

    // Dane logowania
    property string url: "http://at-waterscreen.ddnsking.com/api"
    property string username: "At_2024"
    property string password: "2bad_its!working."

    property string loginToken: ""
    property string loginLocalToken: ""

    function getConfig(callback) {
        const request = new XMLHttpRequest()
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    console.log("getConfig response", request.responseText)
                    var result = JSON.parse(request.responseText)

                    config.mode = result.mode
                    config.enableWeekends = result.enableWeekends
                    config.workTime = result.workTime
                    config.idleTime = result.idleTime
                    config.pictureSize = result.picture.size
                    config.pictureData = result.picture.data
                    config.mailList = result.mailList
                    config.workRangeFrom = result.workRange.from
                    config.workRangeTo = result.workRange.to
                    var mainColor = Qt.rgba(result.picture.colors.main.r / 255, result.picture.colors.main.g / 255, result.picture.colors.main.b / 255, 1);
                    var secondaryColor = Qt.rgba(result.picture.colors.secondary.r / 255, result.picture.colors.secondary.g / 255, result.picture.colors.secondary.b / 255, 1);

                    config.main = mainColor //TODO make in post multiply x255
                    config.secondary = secondaryColor
                    if (callback) callback()
                } else {
                    console.log("HTTP get:", request.status, request.statusText)
                }
            }
        }
        request.open("GET", url + "/dashboard/config", true)
        //request.setRequestHeader("Authorization", "Basic " + Qt.btoa(username + ":" + password))
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
                    console.log("HTTP post:", request.status, request.statusText);
                }
            }
        };

        request.open("POST", url + "/dashboard/config", true);

        request.setRequestHeader("Content-Type", "application/json");
        request.setRequestHeader("Authorization", "Bearer " + loginToken);
        console.log(config.mode)
        const data = {
            "mode": config.mode,
            "enableWeekends": config.enableWeekends,
            "workTime": config.workTime,
            "idleTime": config.idleTime,
            "mailList": config.mailList,
            "picture": {
                "size": config.pictureSize,
                "data": config.pictureData,
                "colors": {
                    "main":{
                        "r": config.main.r * 255,
                        "g": config.main.g * 255,
                        "b": config.main.b * 255,
                    },
                    "secondary":{
                        "r": config.secondary.r * 255,
                        "g": config.secondary.g * 255,
                        "b": config.secondary.b * 255,
                    }
                }
            },
            "workRange": {
                "from": config.workRangeFrom,
                "to": config.workRangeTo
            }
        };
        request.send(JSON.stringify(data));
        console.log(JSON.stringify(data))
    }

    function login(callback) {
        const request = new XMLHttpRequest();

        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    console.log("login response", request.responseText);
                    var result = JSON.parse(request.responseText)

                    loginToken = result.token
                    if (callback) callback()
                } else {
                    console.log("HTTP login:", request.status, request.statusText);
                }
            }
        };

        request.open("POST", url + "/dashboard/login", true);

        request.setRequestHeader("Content-Type", "application/json");

        const data = {
            "username": "at_admin",
            "password": "hF7Ya8yEPLXdzGMv4swC9Ue6fb3m5c"
        };

        request.send(JSON.stringify(data));
    }

    function loginLocal(callback) {
        const request = new XMLHttpRequest();

        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    console.log("login response LOCAL", request.responseText);
                    var result = JSON.parse(request.responseText)

                    loginLocalToken = result.token
                    if (callback) callback()
                } else {
                    console.log("HTTP login:", request.status, request.statusText);
                }
            }
        };

        request.open("POST", "http://localhost:3100/api/dashboard/login", true);

        request.setRequestHeader("Content-Type", "application/json");

        const data = {
            "username": "at_admin",
            "password": "hF7Ya8yEPLXdzGMv4swC9Ue6fb3m5c"
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
                    console.log("HTTP get:", request.status, request.statusText)
                }
            }
        }
        request.open("GET", "http://localhost:3100/api/dashboard/state", true)
        //request.setRequestHeader("Authorization", "Basic " + Qt.btoa(username + ":" + password))
        request.setRequestHeader("Authorization", "Bearer " + loginLocalToken);
        request.send()
    }

    function getAllPictures(callback){
        const request = new XMLHttpRequest()
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    //console.log("getAllPictures response", request.responseText)
                    var result = JSON.parse(request.responseText)
                    if (callback) callback(result)
                } else {
                    console.log("HTTP get:", request.status, request.statusText)
                }
            }
        }
        request.open("GET", "http://localhost:3100/api/dashboard/pictures", true)
        //request.setRequestHeader("Authorization", "Basic " + Qt.btoa(username + ":" + password))
        request.setRequestHeader("Authorization", "Bearer " + loginLocalToken);
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
                    console.log("HTTP delete:", request.status, request.statusText)
                }
            }
        }
        request.open("DELETE", "http://localhost:3100/api/dashboard/pictures/"+id, true)
        //request.setRequestHeader("Authorization", "Basic " + Qt.btoa(username + ":" + password))
        request.setRequestHeader("Authorization", "Bearer " + loginLocalToken);
        request.send()
    }

    function addPicture(size, image, mainColor, secondaryColor, callback) {
        const request = new XMLHttpRequest();

        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    var result = JSON.parse(request.responseText);
                    if (callback) callback(result);
                } else {
                    console.log("HTTP post picture:", request.status, request.statusText);
                }
            }
        };

        request.open("POST", "http://localhost:3100/api/dashboard/pictures", true);

        request.setRequestHeader("Content-Type", "application/json");
        request.setRequestHeader("Authorization", "Bearer " + loginLocalToken);

        const payload = {
            size: size,
            data: customImage.imageToConfigImage(),
            colors: {
                main: mainColor,
                secondary: secondaryColor
            }
        };
        request.send(JSON.stringify(payload));
    }

}
