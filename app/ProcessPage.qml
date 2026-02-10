import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: processPage
    
    // Demo için animasyonlu değerler
    property real processTemp: 0
    property real hopperTemp: 0
    property real exhaustTemp: 0
    property real pressure: 0
    
    Timer {
        interval: 50
        running: true
        repeat: true
        property real direction: 1
        onTriggered: {
            processTemp += direction * 2
            hopperTemp += direction * 1.5
            exhaustTemp += direction * 1.8
            pressure += direction * 0.5
            
            if (processTemp >= 200) direction = -1
            if (processTemp <= 0) direction = 1
        }
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
                        text: mainWindow.currentLanguage === "tr" ? "Proses İzleme" : "Process Monitoring"
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
            
            // Gauges İçerik Alanı
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#34495e"
                radius: 10
                
                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 40
                    columns: 2
                    rows: 2
                    columnSpacing: 30
                    rowSpacing: 30
                    
                    // Process Air Gauge
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        
                        CircularGauge {
                            anchors.centerIn: parent
                            width: Math.min(parent.width, parent.height) * 0.9
                            height: width
                            value: processTemp
                            minimumValue: 0
                            maximumValue: 200
                            gaugeColor: "#e74c3c"
                            label: mainWindow.currentLanguage === "tr" ? "Proses Havası" : "Process Air"
                            unit: "°C"
                        }
                    }
                    
                    // Hopper Content Gauge
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        
                        CircularGauge {
                            anchors.centerIn: parent
                            width: Math.min(parent.width, parent.height) * 0.9
                            height: width
                            value: hopperTemp
                            minimumValue: 0
                            maximumValue: 150
                            gaugeColor: "#3498db"
                            label: mainWindow.currentLanguage === "tr" ? "Hunili İçerik" : "Hopper Content"
                            unit: "°C"
                        }
                    }
                    
                    // Exhaust Air Gauge
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        
                        CircularGauge {
                            anchors.centerIn: parent
                            width: Math.min(parent.width, parent.height) * 0.9
                            height: width
                            value: exhaustTemp
                            minimumValue: 0
                            maximumValue: 180
                            gaugeColor: "#f39c12"
                            label: mainWindow.currentLanguage === "tr" ? "Egzoz Havası" : "Exhaust Air"
                            unit: "°C"
                        }
                    }
                    
                    // Pressure Gauge
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        
                        CircularGauge {
                            anchors.centerIn: parent
                            width: Math.min(parent.width, parent.height) * 0.9
                            height: width
                            value: pressure
                            minimumValue: 0
                            maximumValue: 100
                            gaugeColor: "#1abc9c"
                            label: mainWindow.currentLanguage === "tr" ? "Basınç" : "Pressure"
                            unit: "bar"
                        }
                    }
                }
            }
        }
    }
    
    // Custom Circular Gauge Component
    component CircularGauge: Item {
        id: gauge
        
        property real value: 0
        property real minimumValue: 0
        property real maximumValue: 100
        property color gaugeColor: "#3498db"
        property string label: "Value"
        property string unit: ""
        
        property real angle: (value - minimumValue) / (maximumValue - minimumValue) * 270 - 135
        
        // Background Circle
        Rectangle {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            radius: width / 2
            color: "#2c3e50"
            border.color: "#34495e"
            border.width: 8
        }
        
        // Gauge Arc Background
        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                
                var centerX = width / 2
                var centerY = height / 2
                var radius = (width / 2) - 20
                
                // Background arc
                ctx.beginPath()
                ctx.arc(centerX, centerY, radius, Math.PI * 0.75, Math.PI * 2.25, false)
                ctx.lineWidth = 15
                ctx.strokeStyle = "#34495e"
                ctx.stroke()
            }
        }
        
        // Gauge Arc Value
        Canvas {
            id: valueCanvas
            anchors.fill: parent
            
            Connections {
                target: gauge
                function onValueChanged() {
                    valueCanvas.requestPaint()
                }
            }
            
            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                
                var centerX = width / 2
                var centerY = height / 2
                var radius = (width / 2) - 20
                
                var startAngle = Math.PI * 0.75
                var endAngle = startAngle + (gauge.value - gauge.minimumValue) / (gauge.maximumValue - gauge.minimumValue) * Math.PI * 1.5
                
                // Value arc
                ctx.beginPath()
                ctx.arc(centerX, centerY, radius, startAngle, endAngle, false)
                ctx.lineWidth = 15
                ctx.strokeStyle = gauge.gaugeColor
                ctx.lineCap = "round"
                ctx.stroke()
            }
        }
        
        // Center Value Display
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 5
            
            Text {
                text: gauge.label
                font.pixelSize: gauge.width * 0.08
                color: "#95a5a6"
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: Math.round(gauge.value)
                font.pixelSize: gauge.width * 0.2
                font.bold: true
                color: "#ecf0f1"
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: gauge.unit
                font.pixelSize: gauge.width * 0.1
                color: "#95a5a6"
                Layout.alignment: Qt.AlignHCenter
            }
        }
        
        // Min Value Label
        Text {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: parent.width * 0.15
            anchors.bottomMargin: parent.height * 0.1
            text: Math.round(gauge.minimumValue)
            font.pixelSize: gauge.width * 0.08
            color: "#7f8c8d"
        }
        
        // Max Value Label
        Text {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: parent.width * 0.15
            anchors.bottomMargin: parent.height * 0.1
            text: Math.round(gauge.maximumValue)
            font.pixelSize: gauge.width * 0.08
            color: "#7f8c8d"
        }
    }
}
