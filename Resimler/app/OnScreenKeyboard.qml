import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: keyboard
    modal: true
    width: 750
    height: 300
    title: "Keyboard"
    
    property string inputValue: ""
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        
        TextField {
            id: inputField
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            text: keyboard.inputValue
            font.pixelSize: 24
        }
        
        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 6
            rowSpacing: 5
            columnSpacing: 5
            
            Repeater {
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "0", "⌫"]
                
                Button {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: modelData
                    font.pixelSize: 20
                    
                    onClicked: {
                        if (modelData === "⌫") {
                            inputField.text = inputField.text.slice(0, -1)
                        } else {
                            inputField.text += modelData
                        }
                    }
                }
            }
        }
        
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                text: "Cancel"
                onClicked: keyboard.reject()
            }
            
            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                text: "Enter"
                onClicked: {
                    keyboard.inputValue = inputField.text
                    keyboard.accept()
                }
            }
        }
    }
}
