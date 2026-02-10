import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

Item {
    id: setupPage
    
    property var mainWindow
    property var stackView
    
    property int editingIndex: -1
    
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
                        text: mainWindow.currentLanguage === "tr" ? "Malzeme Ayarları" : "Material Setup"
                        font.pixelSize: 32
                        font.bold: true
                        color: "#ecf0f1"
                        Layout.fillWidth: true
                    }
                    
                    Button {
                        Layout.preferredWidth: 90
                        Layout.preferredHeight: 75
                        hoverEnabled: false
                        onClicked: addMaterialDialog.open()
                        
                        background: Rectangle {
                            color: "#27ae60"
                            radius: 8
                        }
                        
                        contentItem: Text {
                            text: "+"
                            font.pixelSize: 40
                            font.bold: true
                            color: "#ecf0f1"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
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
                        text: (mainWindow.currentLanguage === "tr" ? "Malzeme Listesi (" : "Material List (") + materialManager.materials.length + ")"
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
                            color: "#2c3e50"
                            border.color: "#3498db"
                            border.width: 2
                            
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
                                        text: "Sıcaklık"
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
                                        text: "Debi"
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
                                        text: "Süre"
                                        font.pixelSize: 12
                                        color: "#bdc3c7"
                                    }
                                    Text {
                                        text: modelData.duration + " dk"
                                        font.pixelSize: 18
                                        font.bold: true
                                        color: "#ecf0f1"
                                    }
                                }
                                
                                Button {
                                    Layout.preferredWidth: 60
                                    Layout.preferredHeight: 60
                                    hoverEnabled: false
                                    onClicked: {
                                        editingIndex = index
                                        nameField.text = modelData.name
                                        temperatureField.text = modelData.temperature
                                        flowRateField.text = modelData.flowRate
                                        durationField.text = modelData.duration
                                        editMaterialDialog.open()
                                    }
                                    
                                    background: Rectangle {
                                        color: "#f39c12"
                                        radius: 8
                                    }
                                    
                                    contentItem: Image {
                                        anchors.centerIn: parent
                                        width: 20
                                        height: 20
                                        source: "resimler/edit.svg"
                                        sourceSize.width: 64
                                        sourceSize.height: 64
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                        antialiasing: true
                                    }
                                }
                                
                                Button {
                                    Layout.preferredWidth: 60
                                    Layout.preferredHeight: 60
                                    hoverEnabled: false
                                    onClicked: {
                                        deleteConfirmDialog.materialIndex = index
                                        deleteConfirmDialog.materialName = modelData.name
                                        deleteConfirmDialog.open()
                                    }
                                    
                                    background: Rectangle {
                                        color: "#e74c3c"
                                        radius: 8
                                    }
                                    
                                    contentItem: Text {
                                        text: "✕"
                                        font.pixelSize: 28
                                        color: "#ecf0f1"
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Add Material Dialog
    Dialog {
        id: addMaterialDialog
       // title: "Yeni Materyal Ekle"
        modal: true
        anchors.centerIn: parent
        width: 500
        
        background: Rectangle {
            color: "#34495e"
            radius: 10
            border.color: "#1abc9c"
            border.width: 2
        }
        
        contentItem: ColumnLayout {
            spacing: 15
            
            Text {
                text: mainWindow.currentLanguage === "tr" ? "Yeni Malzeme Ekle" : "Add New Material"
                font.pixelSize: 24
                font.bold: true
                color: "#ecf0f1"
                Layout.alignment: Qt.AlignHCenter
            }
            
            TextField {
                id: addNameField
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                placeholderText: mainWindow.currentLanguage === "tr" ? "Malzeme Adı (örn: PET)" : "Material Name (e.g: PET)"
                placeholderTextColor: "#95a5a6"
                font.pixelSize: 16
                color: "#ecf0f1"
                background: Rectangle {
                    color: "#2c3e50"
                    radius: 5
                    border.color: "#3498db"
                    border.width: 1
                }
            }
            
            TextField {
                id: addTemperatureField
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                placeholderText: mainWindow.currentLanguage === "tr" ? "Sıcaklık (°C)" : "Temperature (°C)"
                placeholderTextColor: "#95a5a6"
                font.pixelSize: 16
                color: "#ecf0f1"
                inputMethodHints: Qt.ImhDigitsOnly
                background: Rectangle {
                    color: "#2c3e50"
                    radius: 5
                    border.color: "#3498db"
                    border.width: 1
                }
            }
            
            TextField {
                id: addFlowRateField
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                placeholderText: mainWindow.currentLanguage === "tr" ? "Debi (m³/h)" : "Flow Rate (m³/h)"
                placeholderTextColor: "#95a5a6"
                font.pixelSize: 16
                color: "#ecf0f1"
                inputMethodHints: Qt.ImhDigitsOnly
                background: Rectangle {
                    color: "#2c3e50"
                    radius: 5
                    border.color: "#3498db"
                    border.width: 1
                }
            }
            
            TextField {
                id: addDurationField
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                placeholderText: mainWindow.currentLanguage === "tr" ? "Süre (dakika)" : "Duration (minutes)"
                placeholderTextColor: "#95a5a6"
                font.pixelSize: 16
                color: "#ecf0f1"
                inputMethodHints: Qt.ImhDigitsOnly
                background: Rectangle {
                    color: "#2c3e50"
                    radius: 5
                    border.color: "#3498db"
                    border.width: 1
                }
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                Button {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    text: mainWindow.currentLanguage === "tr" ? "İptal" : "Cancel"
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
                    
                    onClicked: addMaterialDialog.close()
                }
                
                Button {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    text: mainWindow.currentLanguage === "tr" ? "Ekle" : "Add"
                    font.pixelSize: 16
                    hoverEnabled: false
                    
                    background: Rectangle {
                        color: "#27ae60"
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
                        if (addNameField.text && addTemperatureField.text && addFlowRateField.text && addDurationField.text) {
                            materialManager.addMaterial(
                                addNameField.text,
                                parseInt(addTemperatureField.text),
                                parseInt(addFlowRateField.text),
                                parseInt(addDurationField.text)
                            )
                            addNameField.text = ""
                            addTemperatureField.text = ""
                            addFlowRateField.text = ""
                            addDurationField.text = ""
                            addMaterialDialog.close()
                        }
                    }
                }
            }
        }
    }
    
    // Edit Material Dialog
    Dialog {
        id: editMaterialDialog
      //  title: "Materyal Düzenle"
        modal: true
        anchors.centerIn: parent
        width: 500
        
        background: Rectangle {
            color: "#34495e"
            radius: 10
            border.color: "#f39c12"
            border.width: 2
        }
        
        contentItem: ColumnLayout {
            spacing: 15
            
            Text {
                text: mainWindow.currentLanguage === "tr" ? "Malzeme Düzenle" : "Edit Material"
                font.pixelSize: 24
                font.bold: true
                color: "#ecf0f1"
                Layout.alignment: Qt.AlignHCenter
            }
            
            TextField {
                id: nameField
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                placeholderText: mainWindow.currentLanguage === "tr" ? "Malzeme Adı" : "Material Name"
                placeholderTextColor: "#95a5a6"
                font.pixelSize: 16
                color: "#ecf0f1"
                background: Rectangle {
                    color: "#2c3e50"
                    radius: 5
                    border.color: "#3498db"
                    border.width: 1
                }
            }
            
            TextField {
                id: temperatureField
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                placeholderText: mainWindow.currentLanguage === "tr" ? "Sıcaklık (°C)" : "Temperature (°C)"
                placeholderTextColor: "#95a5a6"
                font.pixelSize: 16
                color: "#ecf0f1"
                inputMethodHints: Qt.ImhDigitsOnly
                background: Rectangle {
                    color: "#2c3e50"
                    radius: 5
                    border.color: "#3498db"
                    border.width: 1
                }
            }
            
            TextField {
                id: flowRateField
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                placeholderText: mainWindow.currentLanguage === "tr" ? "Debi (m³/h)" : "Flow Rate (m³/h)"
                placeholderTextColor: "#95a5a6"
                font.pixelSize: 16
                color: "#ecf0f1"
                inputMethodHints: Qt.ImhDigitsOnly
                background: Rectangle {
                    color: "#2c3e50"
                    radius: 5
                    border.color: "#3498db"
                    border.width: 1
                }
            }
            
            TextField {
                id: durationField
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                placeholderText: mainWindow.currentLanguage === "tr" ? "Süre (dakika)" : "Duration (minutes)"
                placeholderTextColor: "#95a5a6"
                font.pixelSize: 16
                color: "#ecf0f1"
                inputMethodHints: Qt.ImhDigitsOnly
                background: Rectangle {
                    color: "#2c3e50"
                    radius: 5
                    border.color: "#3498db"
                    border.width: 1
                }
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                Button {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    text: mainWindow.currentLanguage === "tr" ? "İptal" : "Cancel"
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
                    
                    onClicked: editMaterialDialog.close()
                }
                
                Button {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    text: mainWindow.currentLanguage === "tr" ? "Kaydet" : "Save"
                    font.pixelSize: 16
                    hoverEnabled: false
                    
                    background: Rectangle {
                        color: "#f39c12"
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
                        if (nameField.text && temperatureField.text && flowRateField.text && durationField.text) {
                            materialManager.updateMaterial(
                                editingIndex,
                                nameField.text,
                                parseInt(temperatureField.text),
                                parseInt(flowRateField.text),
                                parseInt(durationField.text)
                            )
                            editMaterialDialog.close()
                        }
                    }
                }
            }
        }
    }
    
    // Delete Confirmation Dialog
    Dialog {
        id: deleteConfirmDialog
        modal: true
        anchors.centerIn: parent
        width: 450
        
        property int materialIndex: -1
        property string materialName: ""
        
        background: Rectangle {
            color: "#34495e"
            radius: 10
            border.color: "#e74c3c"
            border.width: 2
        }
        
        contentItem: ColumnLayout {
            spacing: 20
            
            Text {
                text: "Malzemeyi Sil"
                font.pixelSize: 24
                font.bold: true
                color: "#ecf0f1"
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: "\"" + deleteConfirmDialog.materialName + "\" malzemesini silmek istediğinizden emin misiniz?"
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
                    text: "Hayır"
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
                    
                    onClicked: deleteConfirmDialog.close()
                }
                
                Button {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    text: "Evet"
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
                        materialManager.removeMaterial(deleteConfirmDialog.materialIndex)
                        deleteConfirmDialog.close()
                    }
                }
            }
        }
    }
}
