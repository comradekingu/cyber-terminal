import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.12
import QMLTermWidget 1.0
import MeuiKit 1.0 as Meui
import org.cyber.Terminal 1.0

ApplicationWindow {
    width: 640
    height: 480
    minimumWidth: 300
    minimumHeight: 200
    visible: true
    id: rootWindow
    title: qsTr("Terminal")

    background: Rectangle {
        color: Meui.Theme.backgroundColor
    }

    Fonts {
        id: fonts
    }

    Action {
        onTriggered: terminal.copyClipboard();
        shortcut: "Ctrl+Shift+C"
    }

    Action {
        onTriggered: terminal.pasteClipboard();
        shortcut: "Ctrl+Shift+V"
    }
    
    Action {
        onTriggered: Qt.quit();
        shortcut: "Ctrl+Shift+Q"
    }

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
                radius: 4
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
            width: 10
            Rectangle {
                opacity: 0.4
                anchors.margins: 5
                radius: width * 0.5
                anchors.fill: parent
            }
        }
    }
}
