import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: dashboardPage
    
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
                        text: mainWindow.currentLanguage === "tr" ? "Gösterge Paneli" : "Dashboard"
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
                            width: backButton.width * 0.85
                            height: backButton.height * 0.85
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
            
            // Dashboard İçerik Alanı
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#34495e"
                radius: 10
                
                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 30
                    columns: 3
                    rows: 2
                    columnSpacing: 20
                    rowSpacing: 20
                    
                    // Sıcaklık Kartı
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#1abc9c"
                        radius: 15
                        
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 10
                            
                            Text {
                                text: mainWindow.currentLanguage === "tr" ? "Proses Havası" : "Process Air"
                                font.pixelSize: 24
                                color: "#ecf0f1"
                                Layout.alignment: Qt.AlignHCenter
                            }
                            
                            Text {
                                text: "100°C"
                                font.pixelSize: 48
                                font.bold: true
                                color: "#ecf0f1"
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                    
                    // Süre Kartı
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#3498db"
                        radius: 15
                        
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 10
                            
                            Text {
                                text: mainWindow.currentLanguage === "tr" ? "Oturum Süresi" : "Session Duration"
                                font.pixelSize: 24
                                color: "#ecf0f1"
                                Layout.alignment: Qt.AlignHCenter
                            }
                            
                            Text {
                                text: materialManager.selectedMaterial.duration ? materialManager.selectedMaterial.duration.toString() + " dk" : "60 dk"
                                font.pixelSize: 48
                                font.bold: true
                                color: "#ecf0f1"
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                    
                    // Kalan Zaman Kartı
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#16a085"
                        radius: 15
                        
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 10
                            
                            Text {
                                text: mainWindow.currentLanguage === "tr" ? "Kalan Zaman" : "Remaining Time"
                                font.pixelSize: 24
                                color: "#ecf0f1"
                                Layout.alignment: Qt.AlignHCenter
                            }
                            
                            Text {
                                text: "45 dk"
                                font.pixelSize: 48
                                font.bold: true
                                color: "#ecf0f1"
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                    
                    // Malzeme Kartı
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#9b59b6"
                        radius: 15
                        
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 10
                            
                            Text {
                                text: mainWindow.currentLanguage === "tr" ? "Malzeme" : "Material"
                                font.pixelSize: 24
                                color: "#ecf0f1"
                                Layout.alignment: Qt.AlignHCenter
                            }
                            
                            Text {
                                text: materialManager.selectedMaterial.name ? materialManager.selectedMaterial.name : "PET"
                                font.pixelSize: 48
                                font.bold: true
                                color: "#ecf0f1"
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                    
                    // Debi Kartı
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#2ecc71"
                        radius: 15
                        
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 10
                            
                            Text {
                                text: mainWindow.currentLanguage === "tr" ? "Debi" : "Flow Rate"
                                font.pixelSize: 24
                                color: "#ecf0f1"
                                Layout.alignment: Qt.AlignHCenter
                            }
                            
                            Text {
                                text: materialManager.selectedMaterial.flowRate ? materialManager.selectedMaterial.flowRate.toString() + " m³/h" : "45 m³/h"
                                font.pixelSize: 48
                                font.bold: true
                                color: "#ecf0f1"
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                    
                    // Egzoz Havası Kartı
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#e67e22"
                        radius: 15
                        
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 10
                            
                            Text {
                                text: mainWindow.currentLanguage === "tr" ? "Egzoz Havası" : "Exhaust Air"
                                font.pixelSize: 24
                                color: "#ecf0f1"
                                Layout.alignment: Qt.AlignHCenter
                            }
                            
                            Text {
                                text: "85°C"
                                font.pixelSize: 48
                                font.bold: true
                                color: "#ecf0f1"
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
