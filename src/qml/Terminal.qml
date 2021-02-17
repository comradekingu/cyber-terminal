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

    signal terminalClosed()

    property string path
    property alias terminal: _terminal
    property string title: _session.title

    Rectangle {
        color: Meui.Theme.secondBackgroundColor
        anchors.fill: parent
        QMLTermWidget {
            id: _terminal
            anchors.fill: parent
            anchors.margins: Meui.Units.largeSpacing
            font.family: fonts.fixedFont
            // The default is way too big.
            font.pointSize: 9
            colorScheme: Meui.Theme.darkMode ? "Meui-Dark" : "Meui-Light"

            session: QMLTermSession {
                id: _session
                onFinished: control.terminalClosed()
                initialWorkingDirectory: "$HOME"
            }

            Component.onCompleted: {
                _session.startShellProgram()
                _terminal.forceActiveFocus()
            }

            QMLTermScrollbar {
                terminal: _terminal
                width: _terminal.fontMetrics.width * 0.75

                Rectangle {
                    anchors.fill: parent
                    anchors.rightMargin: 1
                    radius: width * 0.5
                    opacity: 0.5
                    color: Meui.Theme.darkMode ? "white" : "black"
                }
            }
        }
    }
}
