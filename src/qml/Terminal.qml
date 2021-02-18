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
    readonly property QMLTermSession session: _session

    Rectangle {
        color: Meui.Theme.secondBackgroundColor
        anchors.fill: parent
        QMLTermWidget {
            id: _terminal
            anchors.fill: parent
            anchors.margins: Meui.Units.smallSpacing
            font.family: fonts.fixedFont
            font.pointSize: settings.fontPointSize
            colorScheme: Meui.Theme.darkMode ? "Meui-Dark" : "Meui-Light"
            blinkingCursor: settings.blinkingCursor

            session: QMLTermSession {
                id: _session
                onFinished: control.terminalClosed()
                initialWorkingDirectory: control.path
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
