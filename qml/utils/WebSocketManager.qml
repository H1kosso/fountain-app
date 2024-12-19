import QtQuick 2.15
import QtWebSockets

Item {
    id: root

    property string socketUrl: "https://at-waterscreen.ddnsking.com"
    property string token: apiManager.loginToken
    property var state: {
        "fluidLevel": 0,
        "isPresenting": false,
        "mode": 0
    }

    WebSocket {
        id: socket
        url: socketUrl
        active: false
        protocol: "Bearer " + token // Pass the Authorization token as a protocol or in headers.

        onStatusChanged: {
            if (socket.status === WebSocket.Connected) {
                console.log("Connected to WebSocket server");
                socket.sendTextMessage(JSON.stringify({ event: "getState" }));
            } else if (socket.status === WebSocket.Closed || socket.status === WebSocket.Error) {
                console.error("WebSocket error or disconnected");
            }
        }

        onTextMessageReceived: function (message) {
            console.log("Message received:", message);
            try {
                let parsedMessage = JSON.parse(message);
                if (parsedMessage.event === "state") {
                    state = parsedMessage.data;
                    console.log("State updated:", state);
                }
            } catch (error) {
                console.error("Error parsing message:", error);
            }
        }

        function connectSocket() {
            if (socket.status !== WebSocket.Connected) {
                socket.open();
            }
        }

        function disconnectSocket() {
            if (socket.status === WebSocket.Connected) {
                socket.close();
            }
        }
    }

    Component.onCompleted: {
        // Ensure the token is available before connecting
        if (token) {
            socket.connectSocket();
        }
    }


}
