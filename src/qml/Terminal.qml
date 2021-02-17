import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

import MeuiKit 1.0 as Meui
import Cyber.TermWidget 1.0
import org.cyber.Terminal 1.0

Item {
    id: control

    height: _view.height
    width: _view.width
    focus: true

    Keys.forwardTo: _terminal

    property string path
    property alias terminal: _terminal
    property string title: _session.title

    QMLTermWidget {
        id: _terminal
        anchors.fill: parent
        font.family: fonts.fixedFont
        colorScheme: Meui.Theme.darkMode ? "Meui-Dark" : "Meui-Light"

        session: QMLTermSession {
            id: _session
            onFinished: Qt.callLater(Qt.quit)
        }

        Component.onCompleted: {
            _session.startShellProgram()
            _terminal.forceActiveFocus()
        }

        QMLTermScrollbar {
            terminal: _terminal
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
