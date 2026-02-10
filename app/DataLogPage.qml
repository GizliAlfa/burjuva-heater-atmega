import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

Item {
    id: dataLogPage
    
    property var mainWindow
    property var stackView
    property var globalLogModel
    
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
                    
                    Text {
                        text: mainWindow.currentLanguage === "tr" ? "Veri Kayıtları" : "Data Log"
                        font.pixelSize: 32
                        font.bold: true
                        color: "#ecf0f1"
                        Layout.fillWidth: true
                    }
                    
                    Button {
                        Layout.preferredWidth: 90
                        Layout.preferredHeight: 75
                        hoverEnabled: false
                        onClicked: {
                            clearLogsDialog.open()
                        }
                        
                        background: Rectangle {
                            color: "transparent"
                        }
                        
                        contentItem: Image {
                            anchors.centerIn: parent
                            width: parent.width * 0.85
                            height: parent.height * 0.85
                            source: "resimler/logsilme.svg"
                            sourceSize.width: 64
                            sourceSize.height: 64
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            antialiasing: true
                        }
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
            
            // Log İçerik Alanı
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#34495e"
                radius: 10
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 10
                    
                    // Legend (açıklama)
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 60
                        color: "#2c3e50"
                        radius: 8
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 20
                            
                            Item { Layout.fillWidth: true }
                            
                            // Alarm
                            Row {
                                spacing: 5
                                Rectangle {
                                    width: 24
                                    height: 24
                                    radius: 12
                                    color: "transparent"
                                    border.color: "#e74c3c"
                                    border.width: 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Image {
                                        anchors.centerIn: parent
                                        width: 18
                                        height: 18
                                        source: "resimler/alarm.svg"
                                        sourceSize.width: 48
                                        sourceSize.height: 48
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                        antialiasing: true
                                        cache: false
                                    }
                                }
                                Text {
                                    text: mainWindow.currentLanguage === "tr" ? "Alarm" : "Alarm"
                                    color: "#ecf0f1"
                                    font.pixelSize: 14
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            
                            // Warning
                            Row {
                                spacing: 5
                                Rectangle {
                                    width: 24
                                    height: 24
                                    radius: 12
                                    color: "transparent"
                                    border.color: "#f39c12"
                                    border.width: 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Image {
                                        anchors.centerIn: parent
                                        width: 18
                                        height: 18
                                        source: "resimler/warning.svg"
                                        sourceSize.width: 48
                                        sourceSize.height: 48
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                        antialiasing: true
                                        cache: false
                                    }
                                }
                                Text {
                                    text: mainWindow.currentLanguage === "tr" ? "Uyarı" : "Warning"
                                    color: "#ecf0f1"
                                    font.pixelSize: 14
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            
                            // Running
                            Row {
                                spacing: 5
                                Rectangle {
                                    width: 24
                                    height: 24
                                    radius: 12
                                    color: "transparent"
                                    border.color: "#2ecc71"
                                    border.width: 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Image {
                                        anchors.centerIn: parent
                                        width: 18
                                        height: 18
                                        source: "resimler/running.svg"
                                        sourceSize.width: 48
                                        sourceSize.height: 48
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                        antialiasing: true
                                        cache: false
                                    }
                                }
                                Text {
                                    text: mainWindow.currentLanguage === "tr" ? "Çalışıyor" : "Running"
                                    color: "#ecf0f1"
                                    font.pixelSize: 14
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            
                            // Idle
                            Row {
                                spacing: 5
                                Rectangle {
                                    width: 24
                                    height: 24
                                    radius: 12
                                    color: "transparent"
                                    border.color: "#95a5a6"
                                    border.width: 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Image {
                                        anchors.centerIn: parent
                                        width: 18
                                        height: 18
                                        source: "resimler/idle.svg"
                                        sourceSize.width: 48
                                        sourceSize.height: 48
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                        antialiasing: true
                                        cache: false
                                    }
                                }
                                Text {
                                    text: mainWindow.currentLanguage === "tr" ? "Beklemede" : "Idle"
                                    color: "#ecf0f1"
                                    font.pixelSize: 14
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            
                            // Setting
                            Row {
                                spacing: 5
                                Rectangle {
                                    width: 24
                                    height: 24
                                    radius: 12
                                    color: "transparent"
                                    border.color: "#3498db"
                                    border.width: 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Image {
                                        anchors.centerIn: parent
                                        width: 18
                                        height: 18
                                        source: "resimler/set-edildi.svg"
                                        sourceSize.width: 48
                                        sourceSize.height: 48
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                        antialiasing: true
                                        cache: false
                                    }
                                }
                                Text {
                                    text: mainWindow.currentLanguage === "tr" ? "Ayarlanıyor" : "Setting"
                                    color: "#ecf0f1"
                                    font.pixelSize: 14
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            
                            Item { Layout.fillWidth: true }
                        }
                    }
                    
                    // Log ListView
                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: globalLogModel
                        spacing: 8
                        clip: true
                        
                        ScrollBar.vertical: ScrollBar {
                            active: true
                            policy: ScrollBar.AlwaysOn
                        }
                        
                        delegate: Rectangle {
                            width: ListView.view.width - 20
                            height: 70
                            radius: 8
                            color: getLogColor(model.type)
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 15
                                spacing: 15
                                
                                // İkon
                                Rectangle {
                                    width: 40
                                    height: 40
                                    radius: 20
                                    color: "transparent"
                                    border.color: getIconBackColor(model.type)
                                    border.width: 2
                                    
                                    Image {
                                        anchors.centerIn: parent
                                        width: 28
                                        height: 28
                                        source: getLogIconPath(model.type)
                                        sourceSize.width: 64
                                        sourceSize.height: 64
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                        antialiasing: true
                                        cache: false
                                    }
                                }
                                
                                // Mesaj
                                Text {
                                    text: model.message
                                    color: "#ecf0f1"
                                    font.pixelSize: 16
                                    font.bold: model.type === "alarm"
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                                
                                // Zaman
                                Column {
                                    spacing: 2
                                    Layout.alignment: Qt.AlignRight
                                    
                                    Text {
                                        text: model.time
                                        color: "#ecf0f1"
                                        font.pixelSize: 14
                                        font.bold: true
                                        horizontalAlignment: Text.AlignRight
                                    }
                                    
                                    Text {
                                        text: model.date
                                        color: "#bdc3c7"
                                        font.pixelSize: 12
                                        horizontalAlignment: Text.AlignRight
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Helper functions
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
    
    function getIconBackColor(type) {
        switch(type) {
            case "alarm": return "#e74c3c"
            case "warning": return "#f39c12"
            case "running": return "#2ecc71"
            case "idle": return "#95a5a6"
            case "setting": return "#3498db"
            default: return "#95a5a6"
        }
    }
    
    // Clear Logs Confirmation Dialog
    Dialog {
        id: clearLogsDialog
      //  title: "Silme Onayı"
        modal: true
        anchors.centerIn: parent
        width: 450
        
        background: Rectangle {
            color: "#34495e"
            radius: 10
            border.color: "#e74c3c"
            border.width: 2
        }
        
        contentItem: ColumnLayout {
            spacing: 20
            
            Text {
                text: mainWindow.currentLanguage === "tr" ? "Data Logları Sil" : "Delete Data Logs"
                font.pixelSize: 24
                font.bold: true
                color: "#ecf0f1"
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: mainWindow.currentLanguage === "tr" ? "Tüm data loglarını silmek istediğinizden emin misiniz?" : "Are you sure you want to delete all data logs?"
                font.pixelSize: 16
                color: "#ecf0f1"
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                Button {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    text: mainWindow.currentLanguage === "tr" ? "Hayır" : "No"
                    font.pixelSize: 16
                    hoverEnabled: false
                    
                    background: Rectangle {
                        color: "#95a5a6"
                        radius: 8
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        color: "#ecf0f1"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: clearLogsDialog.close()
                }
                
                Button {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    text: mainWindow.currentLanguage === "tr" ? "Evet" : "Yes"
                    font.pixelSize: 16
                    hoverEnabled: false
                    
                    background: Rectangle {
                        color: "#e74c3c"
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
                        globalLogModel.clear()
                        clearLogsDialog.close()
                    }
                }
            }
        }
    }
}
