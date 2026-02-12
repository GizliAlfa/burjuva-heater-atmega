import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: servisPage
    
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
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                Text {
                    anchors.centerIn: parent
                    text: mainWindow.currentLanguage === "tr" ? "Servis Sayfası" : "Service Page"
                    font.pixelSize: 48
                    color: "#95a5a6"
                }
            }
        }
    }
}
