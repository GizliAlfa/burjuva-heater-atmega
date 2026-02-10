import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: materialPage
    
    property var mainWindow
    property var stackView
    
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
                        text: mainWindow.currentLanguage === "tr" ? "Malzeme Seçimi" : "Material Selection"
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
            
            // Selected Material Display
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                color: "#34495e"
                radius: 10
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 20
                    
                    Text {
                        text: mainWindow.currentLanguage === "tr" ? "Seçili Malzeme:" : "Selected Material:"
                        font.pixelSize: 20
                        font.bold: true
                        color: "#ecf0f1"
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        color: "#1abc9c"
                        radius: 8
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 15
                            spacing: 30
                            
                            Text {
                                text: materialManager.selectedMaterial.name || (mainWindow.currentLanguage === "tr" ? "Seçilmemiş" : "Not Selected")
                                font.pixelSize: 24
                                font.bold: true
                                color: "#ecf0f1"
                                Layout.fillWidth: true
                            }
                            
                            Row {
                                spacing: 8
                                
                                Rectangle {
                                    width: 32
                                    height: 32
                                    color: "#e74c3c"
                                    radius: 4
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Image {
                                        anchors.centerIn: parent
                                        width: 28
                                        height: 28
                                        source: "resimler/sicaklik.svg"
                                        sourceSize.width: 28
                                        sourceSize.height: 28
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                        antialiasing: true
                                        
                                        onStatusChanged: {
                                            if (status === Image.Error) {
                                                console.log("ERROR loading sicaklik.svg")
                                            } else if (status === Image.Ready) {
                                                console.log("SUCCESS loading sicaklik.svg")
                                            }
                                        }
                                    }
                                }
                                
                                Text {
                                    text: (materialManager.selectedMaterial.temperature || 0) + "°C"
                                    font.pixelSize: 20
                                    font.bold: true
                                    color: "#ecf0f1"
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            
                            Row {
                                spacing: 8
                                
                                Rectangle {
                                    width: 32
                                    height: 32
                                    color: "#3498db"
                                    radius: 4
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Image {
                                        anchors.centerIn: parent
                                        width: 28
                                        height: 28
                                        source: "resimler/flow.svg"
                                        sourceSize.width: 28
                                        sourceSize.height: 28
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                        antialiasing: true
                                        
                                        onStatusChanged: {
                                            if (status === Image.Error) {
                                                console.log("ERROR loading flow.svg")
                                            } else if (status === Image.Ready) {
                                                console.log("SUCCESS loading flow.svg")
                                            }
                                        }
                                    }
                                }
                                
                                Text {
                                    text: (materialManager.selectedMaterial.flowRate || 0) + " m³/h"
                                    font.pixelSize: 20
                                    font.bold: true
                                    color: "#ecf0f1"
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            
                            Row {
                                spacing: 8
                                
                                Rectangle {
                                    width: 32
                                    height: 32
                                    color: "#f39c12"
                                    radius: 4
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Image {
                                        anchors.centerIn: parent
                                        width: 28
                                        height: 28
                                        source: "resimler/clock.svg"
                                        sourceSize.width: 28
                                        sourceSize.height: 28
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                        antialiasing: true
                                        
                                        onStatusChanged: {
                                            if (status === Image.Error) {
                                                console.log("ERROR loading clock.svg")
                                            } else if (status === Image.Ready) {
                                                console.log("SUCCESS loading clock.svg")
                                            }
                                        }
                                    }
                                }
                                
                                Text {
                                    text: (materialManager.selectedMaterial.duration || 0) + (mainWindow.currentLanguage === "tr" ? " dk" : " min")
                                    font.pixelSize: 20
                                    font.bold: true
                                    color: "#ecf0f1"
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }
                    }
                }
            }
            
            // Material List
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#34495e"
                radius: 10
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15
                    
                    Text {
                        text: mainWindow.currentLanguage === "tr" ? "Materyal Listesi" : "Material List"
                        font.pixelSize: 24
                        font.bold: true
                        color: "#ecf0f1"
                    }
                    
                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: materialManager.materials
                        spacing: 10
                        clip: true
                        
                        ScrollBar.vertical: ScrollBar {
                            active: true
                            policy: ScrollBar.AsNeeded
                        }
                        
                        delegate: Rectangle {
                            width: ListView.view.width - 20
                            height: 100
                            radius: 10
                            color: materialManager.selectedMaterial.name === modelData.name ? "#27ae60" : "#2c3e50"
                            border.color: "#1abc9c"
                            border.width: 2
                            
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: false
                                onClicked: {
                                    materialManager.selectMaterial(index)
                                }
                            }
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 15
                                spacing: 20
                                
                                Text {
                                    text: modelData.name
                                    font.pixelSize: 22
                                    font.bold: true
                                    color: "#ecf0f1"
                                    Layout.fillWidth: true
                                }
                                
                                Column {
                                    spacing: 5
                                    Text {
                                        text: mainWindow.currentLanguage === "tr" ? "Sıcaklık" : "Temperature"
                                        font.pixelSize: 12
                                        color: "#bdc3c7"
                                    }
                                    Text {
                                        text: modelData.temperature + "°C"
                                        font.pixelSize: 18
                                        font.bold: true
                                        color: "#ecf0f1"
                                    }
                                }
                                
                                Column {
                                    spacing: 5
                                    Text {
                                        text: mainWindow.currentLanguage === "tr" ? "Debi" : "Flow Rate"
                                        font.pixelSize: 12
                                        color: "#bdc3c7"
                                    }
                                    Text {
                                        text: modelData.flowRate + " m³/h"
                                        font.pixelSize: 18
                                        font.bold: true
                                        color: "#ecf0f1"
                                    }
                                }
                                
                                Column {
                                    spacing: 5
                                    Text {
                                        text: mainWindow.currentLanguage === "tr" ? "Süre" : "Duration"
                                        font.pixelSize: 12
                                        color: "#bdc3c7"
                                    }
                                    Text {
                                        text: modelData.duration + (mainWindow.currentLanguage === "tr" ? " dk" : " min")
                                        font.pixelSize: 18
                                        font.bold: true
                                        color: "#ecf0f1"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
