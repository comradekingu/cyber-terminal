import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.12
import QMLTermWidget 1.0
import MeuiKit 1.0 as Meui
import org.cyber.Terminal 1.0

Meui.Window {
    minimumWidth: 400
    minimumHeight: 300
    width: 650
    height: 526
    visible: true
    id: rootWindow
    //title: qsTr("Terminal")
    title: session.title + qsTr(" - Terminal")

    Fonts {
        id: fonts
    }

    Action {
        onTriggered: terminal.copyClipboard()
        shortcut: "Ctrl+Shift+C"
    }

    Action {
        onTriggered: terminal.pasteClipboard()
        shortcut: "Ctrl+Shift+V"
    }
    
    Action {
        onTriggered: Qt.quit()
        shortcut: "Ctrl+Shift+Q"
    }

    headerBar: Label {
        Layout.fillWidth: true
        Layout.margins: Meui.Units.largeSpacing
        leftPadding: Meui.Units.largeSpacing * 1.5
        text: session.title
        font.family: fonts.fixedFont
        font.pointSize: 9
    }

    content: Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true 
        Layout.margins: Meui.Units.smallSpacing
        Layout.rightMargin: 3
        Layout.topMargin: 0
        color: "transparent"
        QMLTermWidget {
            id: terminal
            anchors.fill: parent
            font.family: fonts.fixedFont
            font.pointSize: 9
            colorScheme: "Linux"

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: terminal.width
                    height: terminal.height
                    radius: Meui.Units.largeSpacing
                }
            }

            session: QMLTermSession {
                id: session
                onFinished: Qt.callLater(Qt.quit)
            }

            Component.onCompleted: {
                session.startShellProgram()
                terminal.forceActiveFocus()
            }

            QMLTermScrollbar {
                terminal: terminal
                width: 16 + 8
                Rectangle {
                    opacity: 0.4
                    anchors.margins: 8
                    radius: width * 0.5
                    anchors.fill: parent
                }
            }
        }
    }
}
