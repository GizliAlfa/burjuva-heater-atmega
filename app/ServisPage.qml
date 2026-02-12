import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore

Item {
    id: servisPage
    
    // Properties passed from parent
    property var mainWindow
    property var stackView
    property bool portListInitialized: false
    
    // Kalıcı ayarlar
    Settings {
        id: servisSettings
        category: "ServisMode"
        
        property int debugMode: 0
        property int uartPort: 0
    }
    
    Component.onCompleted: {
        // Kaydedilmiş ayarları yükle
        demoCombo.currentIndex = servisSettings.debugMode;
        updatePortList();
        // Port listesi hazırlandıktan sonra kaydedilmiş portu seç
        Qt.callLater(function() {
            if (servisSettings.uartPort < uartModel.count) {
                uartCombo.currentIndex = servisSettings.uartPort;
            }
            portListInitialized = true;
        });
    }
    
    Rectangle {
        anchors.fill: parent
        color: "#2c3e50"
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20
            
            // Header
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                color: "#34495e"
                radius: 10
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 20
                    
                    // Geri butonu
                    Button {
                        Layout.preferredWidth: 80
                        Layout.preferredHeight: 60
                        hoverEnabled: false
                        
                        background: Rectangle {
                            color: "transparent"
                        }
                        
                        contentItem: Image {
                            anchors.centerIn: parent
                            width: 40
                            height: 40
                            source: "resimler/geri.svg"
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            antialiasing: true
                        }
                        
                        onClicked: {
                            stackView.pop()
                        }
                    }
                    
                    // Başlık
                    Text {
                        Layout.fillWidth: true
                        text: mainWindow.currentLanguage === "tr" ? "SERVİS MODU" : "SERVICE MODE"
                        font.pixelSize: 32
                        font.bold: true
                        color: "#ecf0f1"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    // Servis İkonu
                    Image {
                        Layout.preferredWidth: 60
                        Layout.preferredHeight: 60
                        source: "resimler/servis.svg"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        antialiasing: true
                    }
                }
            }
            
            // İçerik Alanı
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#34495e"
                radius: 10
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 30
                    spacing: 20
                    
                    // Debug Mode Section
                    RowLayout {
                        spacing: 10
                        
                        Text {
                            text: mainWindow.currentLanguage === "tr" ? "Debug" : "Debug"
                            font.pixelSize: 28
                            font.bold: true
                            color: "#ecf0f1"
                        }
                        
                        Button {
                            Layout.preferredWidth: 32
                            Layout.preferredHeight: 32
                            hoverEnabled: false
                            
                            background: Rectangle {
                                color: "transparent"
                            }
                            
                            contentItem: Image {
                                anchors.centerIn: parent
                                width: 24
                                height: 24
                                source: "resimler/soru.svg"
                                sourceSize.width: 48
                                sourceSize.height: 48
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                antialiasing: true
                            }
                            
                            onClicked: debugInfoDialog.open()
                        }
                    }
                    
                    ComboBox {
                        id: demoCombo
                        Layout.fillWidth: true
                        Layout.preferredHeight: 60
                        font.pixelSize: 18
                        
                        model: ListModel {
                            ListElement { textTr: "Açık"; textEn: "On" }
                            ListElement { textTr: "Kapalı"; textEn: "Off" }
                            
                        }
                        
                        onCurrentIndexChanged: {
                            mainWindow.demoMode = (currentIndex === 0);
                            servisSettings.debugMode = currentIndex;
                        }
                        
                        delegate: ItemDelegate {
                            width: demoCombo.width
                            height: 50
                            
                            contentItem: Text {
                                text: mainWindow.currentLanguage === "tr" ? model.textTr : model.textEn
                                color: "#ecf0f1"
                                font.pixelSize: 16
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            background: Rectangle {
                                color: highlighted ? "#27ae60" : "#2c3e50"
                            }
                        }
                        
                        background: Rectangle {
                            color: "#2c3e50"
                            radius: 8
                            border.color: "#3498db"
                            border.width: 1
                        }
                        
                        contentItem: Text {
                            text: demoCombo.currentIndex >= 0 ? 
                                  (mainWindow.currentLanguage === "tr" ? 
                                   demoCombo.model.get(demoCombo.currentIndex).textTr : 
                                   demoCombo.model.get(demoCombo.currentIndex).textEn) : ""
                            font: demoCombo.font
                            color: "#ecf0f1"
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 10
                        }
                    }
                    
                    // UART Port Section
                    Text {
                        text: mainWindow.currentLanguage === "tr" ? "UART Port Seçimi" : "UART Port Selection"
                        font.pixelSize: 28
                        font.bold: true
                        color: "#ecf0f1"
                        Layout.topMargin: 20
                    }
                    
                    // UART Port Row with ComboBox and Buttons
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10
                        
                        ComboBox {
                            id: uartCombo
                            Layout.fillWidth: true
                            Layout.preferredHeight: 60
                            font.pixelSize: 18
                            
                            model: ListModel {
                                id: uartModel
                            }
                            
                            Component.onCompleted: {
                                updatePortList()
                            }
                            
                            onCurrentIndexChanged: {
                                // Sadece tam başlatıldıktan sonra işlem yap
                                if (!portListInitialized) return;
                                
                                if (currentIndex >= 0 && currentIndex < uartModel.count) {
                                    if (typeof serialConnection !== 'undefined' && serialConnection) {
                                        var selectedPort = uartModel.get(currentIndex).portName;
                                        console.log("Port selection changed to:", selectedPort, "(index:", currentIndex, ")");
                                        
                                        if (selectedPort === "Kapalı" || selectedPort === "Closed") {
                                            console.log("Closing serial port...");
                                            serialConnection.closePort();
                                            console.log("Port closed, isOpen:", serialConnection.isOpen());
                                        } else {
                                            console.log("Opening port:", selectedPort);
                                            var success = serialConnection.openPort(selectedPort);
                                            console.log("Port open result:", success, "isOpen:", serialConnection.isOpen());
                                        }
                                        
                                        // Ayarı kaydet
                                        servisSettings.uartPort = currentIndex;
                                        console.log("Saved port index:", currentIndex);
                                    }
                                }
                            }
                            
                            delegate: ItemDelegate {
                                width: uartCombo.width
                                height: 50
                                
                                contentItem: Text {
                                    text: mainWindow.currentLanguage === "tr" ? model.displayTr : model.displayEn
                                    color: "#ecf0f1"
                                    font.pixelSize: 16
                                    verticalAlignment: Text.AlignVCenter
                                }
                                
                                background: Rectangle {
                                    color: highlighted ? "#27ae60" : "#2c3e50"
                                }
                            }
                            
                            background: Rectangle {
                                color: "#2c3e50"
                                radius: 8
                                border.color: "#3498db"
                                border.width: 1
                            }
                            
                            contentItem: Text {
                                text: uartCombo.currentIndex >= 0 ? 
                                      (mainWindow.currentLanguage === "tr" ? 
                                       uartModel.get(uartCombo.currentIndex).displayTr : 
                                       uartModel.get(uartCombo.currentIndex).displayEn) : ""
                                font: uartCombo.font
                                color: "#ecf0f1"
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 10
                            }
                        }
                        
                        // Refresh button for UART ports
                        Button {
                            Layout.preferredWidth: 150
                            Layout.preferredHeight: 60
                            text: mainWindow.currentLanguage === "tr" ? "Yenile" : "Refresh"
                            font.pixelSize: 16
                            hoverEnabled: false
                            
                            background: Rectangle {
                                color: "#16a085"
                                radius: 8
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: "#ecf0f1"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                updatePortList()
                            }
                        }
                        
                        // Terminal button
                        Button {
                            Layout.preferredWidth: 150
                            Layout.preferredHeight: 60
                            text: "Terminal"
                            font.pixelSize: 16
                            hoverEnabled: false
                            
                            background: Rectangle {
                                color: "#3498db"
                                radius: 8
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: "#ecf0f1"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                terminalDialog.open()
                            }
                        }
                    }
                    
                    Item { Layout.fillHeight: true }
                }
            }
        }
    }
    
    // Port listesini güncelleme fonksiyonu
    function updatePortList() {
        var currentPortName = "";
        var wasConnected = false;
        
        // Mevcut bağlantıyı kaydet
        if (typeof serialConnection !== 'undefined' && serialConnection && serialConnection.isOpen()) {
            currentPortName = serialConnection.getCurrentPort();
            wasConnected = true;
            console.log("Currently connected to:", currentPortName);
        }
        
        uartModel.clear();
        
        // Kapalı seçeneği ekle
        uartModel.append({
            portName: "Kapalı",
            displayTr: "Kapalı",
            displayEn: "Closed"
        });
        
        var foundCurrentPort = false;
        var currentPortIndex = 0;
        
        // Mevcut portları al ve ekle
        if (typeof serialConnection !== 'undefined' && serialConnection) {
            var ports = serialConnection.availablePorts();
            console.log("Available serial ports:", JSON.stringify(ports));
            for (var i = 0; i < ports.length; i++) {
                uartModel.append({
                    portName: ports[i],
                    displayTr: ports[i],
                    displayEn: ports[i]
                });
                
                // Eğer bu bağlı olduğumuz port ise index'ini kaydet
                if (wasConnected && ports[i] === currentPortName) {
                    foundCurrentPort = true;
                    currentPortIndex = i + 1; // +1 çünkü ilk eleman "Kapalı"
                }
            }
            
            console.log("Found", ports.length, "serial port(s)");
            
            // Eğer bağlı port hala varsa, o index'i seç
            if (foundCurrentPort) {
                portListInitialized = false; // Geçici olarak devre dışı bırak
                uartCombo.currentIndex = currentPortIndex;
                Qt.callLater(function() {
                    portListInitialized = true;
                });
                console.log("Restored connection to:", currentPortName, "at index:", currentPortIndex);
            } else if (wasConnected) {
                console.log("Previously connected port", currentPortName, "is no longer available");
            }
        } else {
            console.log("serialConnection not available");
        }
        
        // Eğer liste boşsa veya sadece "Kapalı" varsa
        if (uartModel.count === 1) {
            console.log("No serial ports found");
        }
    }
    
    // Terminal Dialog
    Dialog {
        id: terminalDialog
        modal: true
        width: 800
        height: 600
        anchors.centerIn: parent
        title: "Serial Terminal"
        
        property bool isConnected: false
        property string currentPort: ""
        
        // Update connection status
        function updateConnectionStatus() {
            if (typeof serialConnection !== 'undefined' && serialConnection) {
                isConnected = serialConnection.isOpen()
                currentPort = serialConnection.getCurrentPort()
            } else {
                isConnected = false
                currentPort = ""
            }
        }
        
        // Timer to periodically update connection status
        Timer {
            interval: 500
            running: terminalDialog.visible
            repeat: true
            onTriggered: terminalDialog.updateConnectionStatus()
        }
        
        onOpened: {
            updateConnectionStatus()
        }
        
        background: Rectangle {
            color: "#1a1a1a"
            radius: 10
            border.color: "#3498db"
            border.width: 2
        }
        
        ListModel {
            id: terminalModel
        }
        
        Connections {
            target: serialConnection
            function onDataReceived(data) {
                terminalModel.append({
                    text: data,
                    isReceived: true,
                    timestamp: Qt.formatTime(new Date(), "HH:mm:ss")
                })
                // Auto-scroll to bottom
                terminalListView.positionViewAtEnd()
                // Limit to 1000 entries
                if (terminalModel.count > 1000) {
                    terminalModel.remove(0, terminalModel.count - 1000)
                }
            }
            
            function onConnectionStatusChanged(connected) {
                terminalDialog.updateConnectionStatus()
            }
        }
        
        header: Rectangle {
            width: parent.width
            height: 60
            color: "#2c3e50"
            
            Row {
                anchors.centerIn: parent
                spacing: 10
                
                Rectangle {
                    width: 12
                    height: 12
                    radius: 6
                    color: terminalDialog.isConnected ? "#2ecc71" : "#e74c3c"
                    anchors.verticalCenter: parent.verticalCenter
                }
                
                Text {
                    text: terminalDialog.isConnected ? 
                          ("Serial Terminal - " + terminalDialog.currentPort) : 
                          "Serial Terminal - Not Connected"
                    font.pixelSize: 20
                    font.bold: true
                    color: "#ecf0f1"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        
        contentItem: ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10
            
            // Terminal output area
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#0d0d0d"
                border.color: "#3498db"
                border.width: 1
                radius: 5
                
                ListView {
                    id: terminalListView
                    anchors.fill: parent
                    anchors.margins: 5
                    clip: true
                    model: terminalModel
                    
                    delegate: Rectangle {
                        width: terminalListView.width
                        height: textItem.height + 10
                        color: "transparent"
                        
                        Row {
                            spacing: 10
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Text {
                                text: model.timestamp
                                color: "#95a5a6"
                                font.pixelSize: 12
                                font.family: "Courier New"
                            }
                            
                            Text {
                                text: model.isReceived ? "<<" : ">>"
                                color: model.isReceived ? "#2ecc71" : "#3498db"
                                font.pixelSize: 12
                                font.bold: true
                                font.family: "Courier New"
                            }
                            
                            Text {
                                id: textItem
                                text: model.text
                                color: model.isReceived ? "#2ecc71" : "#3498db"
                                font.pixelSize: 14
                                font.family: "Courier New"
                                wrapMode: Text.WrapAnywhere
                            }
                        }
                    }
                    
                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AlwaysOn
                    }
                }
            }
            
            // Input area
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                TextField {
                    id: terminalInput
                    Layout.fillWidth: true
                    placeholderText: "Enter command..."
                    font.pixelSize: 14
                    font.family: "Courier New"
                    
                    background: Rectangle {
                        color: "#2c3e50"
                        radius: 5
                        border.color: "#3498db"
                        border.width: 1
                    }
                    
                    color: "#ecf0f1"
                    
                    onAccepted: {
                        if (text.length > 0 && serialConnection && serialConnection.isOpen()) {
                            serialConnection.sendCommand(text)
                            terminalModel.append({
                                text: text,
                                isReceived: false,
                                timestamp: Qt.formatTime(new Date(), "HH:mm:ss")
                            })
                            terminalListView.positionViewAtEnd()
                            text = ""
                        }
                    }
                }
                
                Button {
                    text: "Send"
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 40
                    
                    background: Rectangle {
                        color: "#3498db"
                        radius: 5
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 14
                        color: "#ecf0f1"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        if (terminalInput.text.length > 0 && serialConnection && serialConnection.isOpen()) {
                            serialConnection.sendCommand(terminalInput.text)
                            terminalModel.append({
                                text: terminalInput.text,
                                isReceived: false,
                                timestamp: Qt.formatTime(new Date(), "HH:mm:ss")
                            })
                            terminalListView.positionViewAtEnd()
                            terminalInput.text = ""
                        }
                    }
                }
                
                Button {
                    text: "Clear"
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 40
                    
                    background: Rectangle {
                        color: "#e74c3c"
                        radius: 5
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 14
                        color: "#ecf0f1"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        terminalModel.clear()
                    }
                }
            }
        }
    }
    
    // Debug Info Dialog
    Dialog {
        id: debugInfoDialog
        modal: true
        anchors.centerIn: parent
        width: 600
        title: mainWindow.currentLanguage === "tr" ? "Debug Mod Bilgisi" : "Debug Mode Info"
        
        background: Rectangle {
            color: "#34495e"
            radius: 10
        }
        
        header: Text {
            text: debugInfoDialog.title
            font.pixelSize: 24
            font.bold: true
            color: "#ecf0f1"
            padding: 20
        }
        
        contentItem: Text {
            text: mainWindow.demoMode ? 
                  (mainWindow.currentLanguage === "tr" ? 
                   "Debug console ve Status LED harfleri görünür. Rastgele data loglar her 2 saniyede üretilir." : 
                   "Debug console and Status LED letters are visible. Random data logs are generated every 2 seconds.") : 
                  (mainWindow.currentLanguage === "tr" ? 
                   "Debug console ve Status LED harfleri gizli. Sadece gerçek veriler gösterilir." : 
                   "Debug console and Status LED letters are hidden. Only real data is shown.")
            font.pixelSize: 16
            color: "#ecf0f1"
            wrapMode: Text.WordWrap
            padding: 20
        }
        
        footer: Item {
            implicitWidth: debugInfoDialog.width
            implicitHeight: 80
            
            Button {
                anchors.centerIn: parent
                width: 150
                height: 50
                text: mainWindow.currentLanguage === "tr" ? "Kapat" : "Close"
                font.pixelSize: 16
                hoverEnabled: false
                
                background: Rectangle {
                    color: "#3498db"
                    radius: 8
                }
                
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "#ecf0f1"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: debugInfoDialog.close()
            }
        }
    }
}
