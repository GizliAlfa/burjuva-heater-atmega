import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: settingsPage
    
    property var mainWindow
    property var stackView
    
    // Ayarları localStorage'da saklayalım
    property string notificationMode: "off" // "off", "bottomRight", "statusBar", "both"
    property bool demoMode: true
    
    Component.onCompleted: {
        notificationMode = "off"
        notificationCombo.currentIndex = 0
        demoMode = true
        demoCombo.currentIndex = 0
    }
    
    onNotificationModeChanged: {
        // Update combo box when property changes externally
        switch(notificationMode) {
            case "off": notificationCombo.currentIndex = 0; break;
            case "bottomRight": notificationCombo.currentIndex = 1; break;
            case "statusBar": notificationCombo.currentIndex = 2; break;
            case "both": notificationCombo.currentIndex = 3; break;
        }
    }
    
    onDemoModeChanged: {
        // Update combo box when property changes externally
        demoCombo.currentIndex = demoMode ? 0 : 1
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
                    
                    Text {
                        text: mainWindow.currentLanguage === "tr" ? "Ayarlar" : "Settings"
                        font.pixelSize: 32
                        font.bold: true
                        color: "#ecf0f1"
                        Layout.fillWidth: true
                    }
                    
                    Button {
                        Layout.preferredWidth: 90
                        Layout.preferredHeight: 75
                        hoverEnabled: false
                        onClicked: stackView.pop()
                        
                        background: Rectangle {
                            color: "transparent"
                        }
                        
                        contentItem: Image {
                            anchors.centerIn: parent
                            width: 60
                            height: 60
                            source: "resimler/geri.svg"
                            sourceSize.width: 64
                            sourceSize.height: 64
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            antialiasing: true
                        }
                    }
                }
            }
            
            // Settings Content
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#34495e"
                radius: 10
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 30
                    spacing: 30
                    
                    // Row 1: Uyarı Ekranı ve Dil Seçimi (yan yana)
                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        rowSpacing: 15
                        columnSpacing: 30
                        
                        // Uyarı Ekranı Section
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.preferredWidth: parent.width / 2 - 15
                            spacing: 15
                            
                            RowLayout {
                                spacing: 10
                                
                                Text {
                                    text: mainWindow.currentLanguage === "tr" ? "Uyarı Ekranı" : "Notification Screen"
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
                                    
                                    onClicked: notificationInfoDialog.open()
                                }
                            }
                            
                            ComboBox {
                                id: notificationCombo
                                Layout.fillWidth: true
                                Layout.preferredHeight: 60
                                font.pixelSize: 18
                                
                                model: ListModel {
                                    ListElement { textTr: "Kapalı"; textEn: "Off"; value: "off" }
                                    ListElement { textTr: "Sağ Alt (Animasyonlu)"; textEn: "Bottom Right (Animated)"; value: "bottomRight" }
                                    ListElement { textTr: "Status Bar (Sadece Hatalar)"; textEn: "Status Bar (Errors Only)"; value: "statusBar" }
                                    ListElement { textTr: "İkisi de"; textEn: "Both"; value: "both" }
                                }
                                
                                currentIndex: 0
                        
                                onCurrentIndexChanged: {
                                    if (currentIndex >= 0) {
                                        settingsPage.notificationMode = model.get(currentIndex).value
                                    }
                                }
                        
                                delegate: ItemDelegate {
                                    width: notificationCombo.width
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
                                    text: notificationCombo.currentIndex >= 0 ? 
                                          (mainWindow.currentLanguage === "tr" ? 
                                           notificationCombo.model.get(notificationCombo.currentIndex).textTr : 
                                           notificationCombo.model.get(notificationCombo.currentIndex).textEn) : ""
                                    font: notificationCombo.font
                                    color: "#ecf0f1"
                                    verticalAlignment: Text.AlignVCenter
                                    leftPadding: 10
                                }
                            }
                        }
                        
                        // Dil Seçimi Section (yanında)
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.preferredWidth: parent.width / 2 - 15
                            spacing: 15
                            
                            Text {
                                text: mainWindow.currentLanguage === "tr" ? "Dil" : "Language"
                                font.pixelSize: 28
                                font.bold: true
                                color: "#ecf0f1"
                            }
                            
                            ComboBox {
                                id: languageCombo
                                Layout.fillWidth: true
                                Layout.preferredHeight: 60
                                font.pixelSize: 18
                                
                                model: ListModel {
                                    ListElement { text: "Türkçe"; value: "tr"; icon: "resimler/turkce.svg" }
                                    ListElement { text: "English"; value: "en"; icon: "resimler/english.svg" }
                                }
                                
                                currentIndex: mainWindow.currentLanguage === "tr" ? 0 : 1
                                
                                onCurrentIndexChanged: {
                                    if (currentIndex >= 0) {
                                        mainWindow.currentLanguage = model.get(currentIndex).value
                                    }
                                }
                                
                                delegate: ItemDelegate {
                                    width: languageCombo.width
                                    height: 50
                                    
                                    contentItem: RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        spacing: 15
                                        
                                        Image {
                                            Layout.preferredWidth: 24
                                            Layout.preferredHeight: 24
                                            source: model.icon
                                            sourceSize.width: 32
                                            sourceSize.height: 32
                                            fillMode: Image.PreserveAspectFit
                                            smooth: true
                                            antialiasing: true
                                        }
                                        
                                        Text {
                                            text: model.text
                                            color: "#ecf0f1"
                                            font.pixelSize: 16
                                            Layout.fillWidth: true
                                            verticalAlignment: Text.AlignVCenter
                                        }
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
                                
                                contentItem: RowLayout {
                                    spacing: 10
                                    anchors.leftMargin: 10
                                    
                                    Image {
                                        Layout.preferredWidth: 24
                                        Layout.preferredHeight: 24
                                        source: languageCombo.currentIndex >= 0 ? languageCombo.model.get(languageCombo.currentIndex).icon : ""
                                        sourceSize.width: 32
                                        sourceSize.height: 32
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                        antialiasing: true
                                    }
                                    
                                    Text {
                                        text: languageCombo.currentIndex >= 0 ? languageCombo.model.get(languageCombo.currentIndex).text : ""
                                        font: languageCombo.font
                                        color: "#ecf0f1"
                                        verticalAlignment: Text.AlignVCenter
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                    }
                    

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
                        
                        currentIndex: 0
                        
                        onCurrentIndexChanged: {
                            settingsPage.demoMode = (currentIndex === 0)
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
                    
                    Item { Layout.fillHeight: true }
                }
            }
        }
    }
    
    // Notification Info Dialog
    Dialog {
        id: notificationInfoDialog
        modal: true
        anchors.centerIn: parent
        width: 600
        title: mainWindow.currentLanguage === "tr" ? "Uyarı Ekranı Bilgisi" : "Notification Screen Info"
        
        background: Rectangle {
            color: "#34495e"
            radius: 10
        }
        
        header: Text {
            text: notificationInfoDialog.title
            font.pixelSize: 24
            font.bold: true
            color: "#ecf0f1"
            padding: 20
        }
        
        contentItem: Text {
            text: getDescriptionForMode(settingsPage.notificationMode)
            font.pixelSize: 16
            color: "#ecf0f1"
            wrapMode: Text.WordWrap
            padding: 20
        }
        
        footer: Item {
            implicitWidth: notificationInfoDialog.width
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
                
                onClicked: notificationInfoDialog.close()
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
            text: settingsPage.demoMode ? 
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
    
    function getDescriptionForMode(mode) {
        var isTr = mainWindow.currentLanguage === "tr"
        switch(mode) {
            case "off": 
                return isTr ? "Hiçbir bildirim gösterilmez. Sadece Data Log sayfasında logları görebilirsiniz." 
                            : "No notifications are shown. You can only see logs on the Data Log page."
            case "bottomRight": 
                return isTr ? "Loglar sağ alt köşede animasyonlu olarak görünür. Alarmlar kalıcı, diğerleri 1.5 saniye sonra kaybolur." 
                            : "Logs appear animated in the bottom right corner. Alarms are persistent, others disappear after 1.5 seconds."
            case "statusBar": 
                return isTr ? "Sadece alarm mesajları üst status bar'da kırmızı yazı ile kayar." 
                            : "Only alarm messages scroll in red text on the top status bar."
            case "both": 
                return isTr ? "Hem sağ alt köşede animasyonlu bildirim hem de status bar'da alarm mesajları gösterilir." 
                            : "Both animated notifications in the bottom right and alarm messages on the status bar are shown."
            default: return ""
        }
    }
}
