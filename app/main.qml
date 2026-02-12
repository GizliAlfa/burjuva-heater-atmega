import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: mainWindow
    width: 1024
    height: 768
    visible: true
  //  visibility: Window.FullScreen
    title: "Burjuva Heater Control System"
    
    Component.onCompleted: {
        Qt.application.overrideCursor(Qt.BlankCursor)
        
        // UART bağlantısını kontrol et
        Qt.callLater(checkUartConnection)
    }
    
    // UART bağlantı kontrolü
    function checkUartConnection() {
        if (typeof serialConnection !== 'undefined' && serialConnection) {
            if (!serialConnection.isOpen()) {
                console.log("UART not connected! Opening Hardware Error dialog...")
                hardwareErrorDialog.open()
            } else {
                console.log("UART connected:", serialConnection.getCurrentPort())
            }
        } else {
            console.log("SerialConnection not available! Opening Hardware Error dialog...")
            hardwareErrorDialog.open()
        }
    }
    
    // Notification settings
    property string notificationMode: "off" // "off", "bottomRight", "statusBar", "both"
    property bool demoMode: false // Demo mode on/off
    property string currentLogType: "idle" // Current status LED type
    property string debugConsole: "Program started" // Debug console output
    property string currentLanguage: "tr" // "tr" or "en"
    property string currentTime: "00:00:00" // Current time display
    property int infrastructure: 0 // 0: Atmega, 1: Pilot
    
    // Status LED color function
    function getStatusLEDColor(type) {
        switch(type) {
            case "alarm": return "#e74c3c"      // Kırmızı
            case "running": return "#2ecc71"    // Yeşil
            case "idle": return "#95a5a6"       // Gri
            case "warning": return "#95a5a6"    // Gri (varsayılan)
            case "setting": return "#95a5a6"    // Gri (varsayılan)
            default: return "#95a5a6"
        }
    }
    
    // Global Log Model
    ListModel {
        id: globalLogModel
    }
    
    // Demo log generator timer
    Timer {
        interval: 2000
        running: mainWindow.demoMode
        repeat: true
        onTriggered: {
            var types = ["alarm", "warning", "running", "idle", "setting"]
            var messages = {
                "alarm": ["High temperature! 210°C", "Pressure limit exceeded", "Emergency triggered", "Motor failure"],
                "warning": ["Temperature rising", "Low hopper level", "Maintenance due soon", "Fan speed low"],
                "running": ["Process started", "Heating active", "Normal operation", "Target temperature reached"],
                "idle": ["Standby mode activated", "Process completed", "Ready and waiting", "Paused"],
                "setting": ["Temperature set to 150°C", "Material PET selected", "Duration set to 45min", "Pressure set to 2.5bar"]
            }
            
            var randomType = types[Math.floor(Math.random() * types.length)]
            var randomMsg = messages[randomType][Math.floor(Math.random() * messages[randomType].length)]
            
            var now = new Date()
            var timeStr = Qt.formatTime(now, "HH:mm:ss")
            var dateStr = Qt.formatDate(now, "dd.MM.yyyy")
            
            globalLogModel.insert(0, {
                "type": randomType,
                "message": randomMsg,
                "time": timeStr,
                "date": dateStr
            })
            
            // Update status LED
            mainWindow.currentLogType = randomType
           // mainWindow.debugConsole = "Log added - Type: " + randomType + " Color: " + mainWindow.getStatusLEDColor(randomType)
            console.log("New log added - Type:", randomType, "LED Color:", mainWindow.getStatusLEDColor(randomType))
            
            // Maksimum 100 kayıt tut
            if (globalLogModel.count > 100) {
                globalLogModel.remove(100, globalLogModel.count - 100)
            }
        }
    }
    
    // Timer for current time update
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var now = new Date()
            mainWindow.currentTime = Qt.formatTime(now, "HH:mm:ss")
        }
    }
    
    // Helper functions for log colors and icons
    function getLogIconPath(type) {
        switch(type) {
            case "alarm": return "resimler/alarm.svg"
            case "warning": return "resimler/warning.svg"
            case "running": return "resimler/running.svg"
            case "idle": return "resimler/idle.svg"
            case "setting": return "resimler/set-edildi.svg"
            default: return "resimler/idle.svg"
        }
    }
    
    function getLogColor(type) {
        switch(type) {
            case "alarm": return "#c0392b"
            case "warning": return "#d68910"
            case "running": return "#27ae60"
            case "idle": return "#7f8c8d"
            case "setting": return "#2980b9"
            default: return "#34495e"
        }
    }
    
    function getIconBorderColor(type) {
        switch(type) {
            case "alarm": return "#e74c3c"
            case "warning": return "#f39c12"
            case "running": return "#2ecc71"
            case "idle": return "#95a5a6"
            case "setting": return "#3498db"
            default: return "#95a5a6"
        }
    }
    
    // Background
    Rectangle {
        anchors.fill: parent
        color: "#34495e"
    }
    
    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: mainPage
    }
    
    Component {
        id: mainPage
        
        Item {
        
        GridLayout {
            anchors.fill: parent
            anchors.leftMargin: 0
            anchors.topMargin: 10
            anchors.rightMargin: 10
            anchors.bottomMargin: 10
            columns: 10
            rows: 10
            columnSpacing: 10
            rowSpacing: 10
        
        // Status Bar - Row 0, Starts from Column 1
        Rectangle {
            Layout.row: 0
            Layout.column: 1
            Layout.columnSpan: 9
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: "#2c3e50"
            clip: true
            
            // Sabit LED
            Rectangle {
                id: statusLED
                width: 36
                height: 36
                radius: 18
                color: getStatusLEDColor(mainWindow.currentLogType)
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                z: 1
                
                // Debug: show current type
                Text {
                    anchors.centerIn: parent
                    text: mainWindow.currentLogType.substring(0,1).toUpperCase()
                    font.pixelSize: 14
                    font.bold: true
                    color: "#ffffff"
                    visible: mainWindow.demoMode
                }
                
                Behavior on color {
                    ColorAnimation { duration: 300 }
                }
            }
            
            Row {
                id: scrollingRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: 50
                x: parent.width
                
                SequentialAnimation on x {
                    loops: Animation.Infinite
                    running: true
                    NumberAnimation {
                        from: scrollingRow.parent.width
                        to: -scrollingRow.width
                        duration: 20000
                        easing.type: Easing.Linear
                    }
                }
                
                // Alarm messages from logs (if statusBar or both mode)
                Repeater {
                    model: (mainWindow.notificationMode === "statusBar" || mainWindow.notificationMode === "both") && globalLogModel.count > 0 ? 
                           (function() {
                               var alarms = [];
                               for (var i = 0; i < Math.min(globalLogModel.count, 10); i++) {
                                   if (globalLogModel.get(i).type === "alarm") {
                                       alarms.push(globalLogModel.get(i));
                                   }
                               }
                               return alarms;
                           })() : []
                    
                    Row {
                        spacing: 10
                        Text {
                            text: "\u26a0 " + modelData.message
                            color: "#e74c3c"
                            font.pixelSize: 16
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
                
                Row {
                    spacing: 20
                    anchors.verticalCenter: parent.verticalCenter
                    
                    Text {
                        text: mainWindow.currentLanguage === "tr" ? "Proses Havası" : "Actual Process Air"
                        color: "white"
                        font.pixelSize: 14
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    Text {
                        id: tempValue
                        text: "0.0°C"
                        color: "white"
                        font.pixelSize: 16
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    Text {
                        text: "Current Time"
                        color: "white"
                        font.pixelSize: 14
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    Text {
                        id: currentTimeValue
                        text: mainWindow.currentTime
                        color: "white"
                        font.pixelSize: 16
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    Text {
                        text: "Hopper Content"
                        color: "white"
                        font.pixelSize: 14
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    Text {
                        id: hopperContentValue
                        text: "0%"
                        color: "white"
                        font.pixelSize: 16
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    Text {
                        text: "Exhaust Air"
                        color: "white"
                        font.pixelSize: 14
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    Text {
                        id: exhaustAirValue
                        text: "0.0°C"
                        color: "white"
                        font.pixelSize: 16
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
        
        // Left Control Panel - Row 0-9, Column 0 (Full Height, 4 Buttons Only)
        Rectangle {
            Layout.row: 0
            Layout.column: 0
            Layout.rowSpan: 10
            Layout.preferredWidth: 150
            Layout.fillHeight: true
            color: "#34495e"
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 0
                spacing: 5
                
                Button {
                    id: button1
                    Layout.fillWidth: true
                    Layout.preferredHeight: 140
                    checkable: true
                    checked: true
                    hoverEnabled: false
                    background: Rectangle {
                        color: "transparent"
                    }
                    contentItem: Image {
                        anchors.centerIn: parent
                        width: parent.width * 0.6
                        height: parent.height * 0.6
                        source: button1.checked ? "resimler/asama2-green.svg" : "resimler/asama1.svg"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        antialiasing: true
                    }
                }
                
                Item { Layout.fillHeight: true }
                
                Button {
                    id: button3
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    checkable: true
                    hoverEnabled: false
                    background: Rectangle {
                        color: "transparent"
                    }
                    contentItem: Image {
                        anchors.centerIn: parent
                        width: parent.width * 0.6
                        height: parent.height * 0.6
                        source: button3.checked ? "resimler/arttir-green.svg" : "resimler/arttir.svg"
                        sourceSize.width: 256
                        sourceSize.height: 256
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        antialiasing: true
                    }
                }
                
                Button {
                    id: button4
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    checkable: true
                    hoverEnabled: false
                    background: Rectangle {
                        color: "transparent"
                    }
                    contentItem: Image {
                        anchors.centerIn: parent
                        width: parent.width * 0.6
                        height: parent.height * 0.6
                        source: button4.checked ? "resimler/azalt-green.svg" : "resimler/azalt.svg"
                        sourceSize.width: 256
                        sourceSize.height: 256
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        antialiasing: true
                    }
                }
            }
        }
        
        // Center Display with Image and Overlay Buttons - Row 1-8, Column 1-9
        Item {
            Layout.row: 1
            Layout.column: 1
            Layout.rowSpan: 8
            Layout.columnSpan: 9
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            // Background Image
            Image {
                anchors.fill: parent
                anchors.margins: 40
                source: "resimler/main-device.png"
                fillMode: Image.PreserveAspectFit
                
                Text {
                    anchors.centerIn: parent
                    text: "Device Image"
                    color: "#7f8c8d"
                    font.pixelSize: 24
                    visible: parent.status !== Image.Ready
                }
            }
            
            // Left Overlay Buttons
            Button {
                id: dashboardButton
                anchors.left: parent.left
                anchors.leftMargin: 140
                anchors.top: parent.top
                anchors.topMargin: 60
                width: 140
                height: 100
                hoverEnabled: false
                background: Rectangle {
                    color: "transparent"
                }
                contentItem: Image {
                    anchors.centerIn: parent
                    width: parent.width * 0.6
                    height: parent.height * 0.6
                    source: dashboardButton.pressed ? "resimler/dashboard-green.svg" : "resimler/dashboard.svg"
                    sourceSize.width: 256
                    sourceSize.height: 256
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    antialiasing: true
                }
                
                onClicked: {
                    stackView.push("DashboardPage.qml", {
                        mainWindow: mainWindow,
                        stackView: stackView
                    })
                }
            }
            
            Button {
                id: setupButton
                anchors.left: parent.left
                anchors.leftMargin: 80
                anchors.verticalCenter: parent.verticalCenter
                width: 140
                height: 100
                hoverEnabled: false
                background: Rectangle {
                    color: "transparent"
                }
                contentItem: Image {
                    anchors.centerIn: parent
                    width: parent.width * 0.6
                    height: parent.height * 0.6
                    source: setupButton.pressed ? "resimler/setup-green.svg" : "resimler/setup.svg"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    antialiasing: true
                }
                
                onClicked: {
                    stackView.push("SetupPage.qml", {
                        mainWindow: mainWindow,
                        stackView: stackView
                    })
                }
            }
            
            Button {
                id: settingsButton
                anchors.left: parent.left
                anchors.leftMargin: 140
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 60
                width: 140
                height: 100
                hoverEnabled: false
                background: Rectangle {
                    color: "transparent"
                }
                contentItem: Image {
                    anchors.centerIn: parent
                    width: parent.width * 0.6
                    height: parent.height * 0.6
                    source: settingsButton.pressed ? "resimler/settings-green.svg" : "resimler/settings.svg"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    antialiasing: true
                }
                
                onClicked: {
                   // mainWindow.debugConsole = "Settings button clicked"
                    console.log("Settings button clicked")
                    var component = Qt.createComponent("SettingsPage.qml")
                    if (component.status === Component.Error) {
                  //      mainWindow.debugConsole = "Error: " + component.errorString()
                        console.error("Error loading SettingsPage:", component.errorString())
                        return
                    }
                    var settingsPage = component.createObject(stackView, {
                        mainWindow: mainWindow,
                        stackView: stackView
                    })
                    if (!settingsPage) {
                   //     mainWindow.debugConsole = "Failed to create SettingsPage object"
                        console.error("Failed to create SettingsPage object")
                        return
                    }
                  //  mainWindow.debugConsole = "SettingsPage created successfully"
                    console.log("SettingsPage created successfully")
                    settingsPage.notificationMode = mainWindow.notificationMode
                    settingsPage.demoMode = mainWindow.demoMode
                    settingsPage.notificationModeChanged.connect(function() {
                        mainWindow.notificationMode = settingsPage.notificationMode
                    })
                    settingsPage.demoModeChanged.connect(function() {
                        mainWindow.demoMode = settingsPage.demoMode
                    })
                    stackView.push(settingsPage)
                  //  mainWindow.debugConsole = "SettingsPage pushed to stack"
                    console.log("SettingsPage pushed to stack")
                }
            }
            
            // Right Overlay Buttons
            Button {
                id: rightButton1
                anchors.right: parent.right
                anchors.rightMargin: 140
                anchors.top: parent.top
                anchors.topMargin: 60
                width: 140
                height: 100
                hoverEnabled: false
                background: Rectangle {
                    color: "transparent"
                }
                contentItem: Image {
                    anchors.centerIn: parent
                    width: parent.width * 0.6
                    height: parent.height * 0.6
                    source: rightButton1.pressed ? "resimler/material-green.svg" : "resimler/material.svg"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    antialiasing: true
                }
                
                onClicked: {
                    stackView.push("MaterialPage.qml", {
                        mainWindow: mainWindow,
                        stackView: stackView
                    })
                }
            }
            
            Button {
                id: rightButton2
                anchors.right: parent.right
                anchors.rightMargin: 80
                anchors.verticalCenter: parent.verticalCenter
                width: 140
                height: 100
                hoverEnabled: false
                background: Rectangle {
                    color: "transparent"
                }
                contentItem: Image {
                    anchors.centerIn: parent
                    width: parent.width * 0.6
                    height: parent.height * 0.6
                    source: rightButton2.pressed ? "resimler/data-log-green.svg" : "resimler/data-log.svg"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    antialiasing: true
                }
                
                onClicked: {
                    stackView.push("DataLogPage.qml", {
                        mainWindow: mainWindow,
                        stackView: stackView,
                        globalLogModel: globalLogModel
                    })
                }
            }
            
            Button {
                id: rightButton3
                anchors.right: parent.right
                anchors.rightMargin: 140
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 60
                width: 140
                height: 100
                hoverEnabled: false
                background: Rectangle {
                    color: "transparent"
                }
                contentItem: Image {
                    anchors.centerIn: parent
                    width: parent.width * 0.6
                    height: parent.height * 0.6
                    source: rightButton3.pressed ? "resimler/process-green.svg" : "resimler/process.svg"
                    sourceSize.width: 256
                    sourceSize.height: 256
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    antialiasing: true
                }
                
                onClicked: {
                    stackView.push("ProcessPage.qml", {
                        mainWindow: mainWindow,
                        stackView: stackView
                    })
                }
            }
        }
        
        // Bottom Set Bar - Row 9, Column 1-6
        Rectangle {
            Layout.row: 9
            Layout.column: 1
            Layout.columnSpan: 6
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: "#34495e"
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 30
                
                // Process Air Field
                Column {
                    spacing: 5
                    
                    Text {
                        text: "Process Air"
                        color: "white"
                        font.pixelSize: 14
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    
                    Row {
                        spacing: 5
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        Text {
                            id: processAirValue
                            text: materialManager.selectedMaterial.temperature ? materialManager.selectedMaterial.temperature.toString() : "100"
                            color: "white"
                            font.pixelSize: 20
                            font.bold: true
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("Process Air clicked")
                            }
                        }
                        
                        Text {
                            text: "°C"
                            color: "white"
                            font.pixelSize: 16
                        }
                    }
                }
                
                // Session Time Field
                Column {
                    spacing: 5
                    
                    Text {
                        text: "Session Time"
                        color: "white"
                        font.pixelSize: 14
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    
                    Row {
                        spacing: 5
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        Text {
                            id: sessionTimeValue
                            text: materialManager.selectedMaterial.duration ? materialManager.selectedMaterial.duration.toString() : "60"
                            color: "white"
                            font.pixelSize: 20
                            font.bold: true
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("Session Time clicked")
                            }
                        }
                        
                        Text {
                            text: "min"
                            color: "white"
                            font.pixelSize: 16
                        }
                    }
                }
                
                // Material Field
                Column {
                    spacing: 5
                    
                    Text {
                        text: "Material"
                        color: "white"
                        font.pixelSize: 14
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    
                    Text {
                        id: materialValue
                        text: materialManager.selectedMaterial.name ? materialManager.selectedMaterial.name : "PET"
                        color: "white"
                        font.pixelSize: 20
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: console.log("Material clicked")
                        }
                    }
                }
                
                Item { Layout.fillWidth: true }
            }
        }
        
        // Debug Console Label - Row 9, Column 1-6
        Rectangle {
            Layout.column: 1
            Layout.row: 9 
            Layout.columnSpan: 6
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: "#1a1a1a"
            radius: 10
            border.color: "#3498db"
            border.width: 2
            visible: mainWindow.demoMode
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5
                
                Text {
                    text: "Debug Console:"
                    color: "#3498db"
                    font.pixelSize: 14
                    font.bold: true
                }
                
                Text {
                    text: mainWindow.debugConsole
                    color: "#00ff00"
                    font.pixelSize: 12
                    font.family: "Courier New"
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                }
                
                Text {
                    text: "Status LED: " + mainWindow.currentLogType + " | Color: " + getStatusLEDColor(mainWindow.currentLogType)
                    color: "#ffff00"
                    font.pixelSize: 11
                    font.family: "Courier New"
                }
            }
        }
        
        // Latest Log Display - Row 9, Column 7-9
        Rectangle {
            id: latestLogDisplay
            Layout.row: 9
            Layout.column: 7
            Layout.columnSpan: 3
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: globalLogModel.count > 0 ? getLogColor(globalLogModel.get(0).type) : "#34495e"
            radius: 8
            opacity: 0.25
            visible: mainWindow.notificationMode === "bottomRight" || mainWindow.notificationMode === "both"
            
            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }
            
            property string currentLogMessage: ""
            
            onVisibleChanged: {
                if (visible && globalLogModel.count > 0) {
                    slideInAnimation.start()
                }
            }
            
            Connections {
                target: globalLogModel
                function onCountChanged() {
                    if (globalLogModel.count > 0 && latestLogDisplay.currentLogMessage !== globalLogModel.get(0).message) {
                        latestLogDisplay.currentLogMessage = globalLogModel.get(0).message
                        slideInAnimation.restart()
                        latestLogDisplay.opacity = 0.25
                        
                        // Sadece alarm değilse 1.5 saniye sonra silinsin
                        if (globalLogModel.get(0).type !== "alarm") {
                            fadeOutTimer.restart()
                        } else {
                            fadeOutTimer.stop()
                        }
                    }
                }
            }
            
            // 1.5 saniye sonra opacity düşür ve sil
            Timer {
                id: fadeOutTimer
                interval: 1500
                running: false
                repeat: false
                onTriggered: {
                    fadeOutAnimation.start()
                }
            }
            
            NumberAnimation {
                id: fadeOutAnimation
                target: latestLogDisplay
                property: "opacity"
                from: 0.25
                to: 0
                duration: 500
                // Sadece opacity düşür, data log'dan silme
            }
            
            transform: Translate {
                id: slideTransform
                x: 0
            }
            
            NumberAnimation {
                id: slideInAnimation
                target: slideTransform
                property: "x"
                from: 300
                to: 0
                duration: 500
                easing.type: Easing.OutCubic
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    stackView.push("DataLogPage.qml", {
                        mainWindow: mainWindow,
                        stackView: stackView,
                        globalLogModel: globalLogModel
                    })
                }
            }
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10
                
                // İkon
                Rectangle {
                    width: 40
                    height: 40
                    radius: 20
                    color: "transparent"
                    border.color: globalLogModel.count > 0 ? getIconBorderColor(globalLogModel.get(0).type) : "#95a5a6"
                    border.width: 2
                    
                    Image {
                        anchors.centerIn: parent
                        width: 28
                        height: 28
                        source: globalLogModel.count > 0 ? getLogIconPath(globalLogModel.get(0).type) : "resimler/idle.svg"
                        sourceSize.width: 64
                        sourceSize.height: 64
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        antialiasing: true
                    }
                }
                
                // Mesaj
                Text {
                    text: globalLogModel.count > 0 ? globalLogModel.get(0).message : "No logs yet"
                    color: "#ecf0f1"
                    font.pixelSize: 14
                    font.bold: globalLogModel.count > 0 && globalLogModel.get(0).type === "alarm"
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                }
                
                // Zaman
                Text {
                    text: globalLogModel.count > 0 ? globalLogModel.get(0).time : ""
                    color: "#ecf0f1"
                    font.pixelSize: 12
                    font.bold: true
                    Layout.alignment: Qt.AlignRight
                }
            }
        }
    } // GridLayout kapanışı
    } // Item kapanışı
} // Component kapanışı

    // Hardware Error Dialog
    Dialog {
        id: hardwareErrorDialog
        modal: true
        closePolicy: Popup.NoAutoClose  // Kapatma butonunu devre dışı bırak
        width: 600
        height: 400
        anchors.centerIn: parent
        
        background: Rectangle {
            color: "#2c3e50"
            radius: 15
            border.color: "#e74c3c"
            border.width: 3
        }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 30
            spacing: 20
            
            // Error Icon
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 100
                height: 100
                radius: 50
                color: "#e74c3c"
                
                Text {
                    anchors.centerIn: parent
                    text: "!"
                    font.pixelSize: 72
                    font.bold: true
                    color: "#ecf0f1"
                }
            }
            
            // Error Title
            Text {
                Layout.fillWidth: true
                text: "HARDWARE ERROR"
                font.pixelSize: 32
                font.bold: true
                color: "#e74c3c"
                horizontalAlignment: Text.AlignHCenter
            }
            
            // Error Message
            Text {
                Layout.fillWidth: true
                text: mainWindow.currentLanguage === "tr" ? 
                      "UART bağlantısı bulunamadı!\nLütfen servis modundan bağlantı yapınız." :
                      "UART connection not found!\nPlease configure connection in service mode."
                font.pixelSize: 18
                color: "#ecf0f1"
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                Layout.preferredHeight: 80
            }
            
            Item { Layout.fillHeight: true }
            
            // Service Button
            Button {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 200
                Layout.preferredHeight: 80
                hoverEnabled: false
                
                background: Rectangle {
                    color: "#e67e22"
                    radius: 10
                    border.color: "#d35400"
                    border.width: 2
                }
                
                contentItem: RowLayout {
                    spacing: 10
                    
                    Image {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 40
                        source: "resimler/servis.svg"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        antialiasing: true
                    }
                    
                    Text {
                        text: mainWindow.currentLanguage === "tr" ? "SERVİS" : "SERVICE"
                        font.pixelSize: 24
                        font.bold: true
                        color: "#ecf0f1"
                    }
                }
                
                onClicked: {
                    hardwareErrorDialog.close()
                    stackView.push("ServisPage.qml", {
                        mainWindow: mainWindow,
                        stackView: stackView
                    })
                }
            }
        }
        
        // UART bağlantısını periyodik kontrol et
        Timer {
            interval: 1000
            running: hardwareErrorDialog.visible
            repeat: true
            onTriggered: {
                if (typeof serialConnection !== 'undefined' && serialConnection && serialConnection.isOpen()) {
                    console.log("UART connection established! Closing Hardware Error dialog...")
                    hardwareErrorDialog.close()
                }
            }
        }
    }
} // ApplicationWindow kapanışı
