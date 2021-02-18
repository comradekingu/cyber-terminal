import QtQuick 2.15
import QtQml.Models 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.12

import Cyber.TermWidget 1.0
import MeuiKit 1.0 as Meui
import org.cyber.Terminal 1.0

Meui.Window {
    minimumWidth: 400
    minimumHeight: 300
    width: settings.width
    height: settings.height
    visible: true
    id: rootWindow
    title: currentItem && currentItem.terminal ? currentItem.terminal.session.title : ""

    headerBarHeight: 40 + Meui.Units.largeSpacing

    property alias currentItem: _view.currentItem
    readonly property QMLTermWidget currentTerminal: currentItem.terminal

    onClosing: {
        settings.width = rootWindow.width
        settings.height = rootWindow.height

        // Exit prompt.
        for (var i = 0; i < tabsModel.count; ++i) {
            var obj = tabsModel.get(i)
            if (obj.session.hasActiveProcess) {
                exitPrompt.visible = true
                close.accepted = false
                break
            }
        }
    }

    GlobalSettings { id: settings }
    ObjectModel { id: tabsModel }

    ExitPromptDialog {
        id: exitPrompt
        onOkBtnClicked: Qt.quit()
    }

    Fonts {
        id: fonts
    }

    Action {
        onTriggered: currentTerminal.copyClipboard()
        shortcut: "Ctrl+Shift+C"
    }

    Action {
        onTriggered: currentTerminal.pasteClipboard()
        shortcut: "Ctrl+Shift+V"
    }

    Action {
        onTriggered: Qt.quit()
        shortcut: "Ctrl+Shift+Q"
    }

    Action {
        onTriggered: rootWindow.openNewTab()
        shortcut: "Ctrl+Shift+T"
    }

    Action {
        onTriggered: rootWindow.closeTab(_view.currentIndex)
        shortcut: "Ctrl+Shift+W"
    }

    Action {
        onTriggered: rootWindow.toggleTab()
        shortcut: "Ctrl+Tab"
    }

    headerBar: Item {
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Meui.Units.smallSpacing
            anchors.topMargin: Meui.Units.smallSpacing
            anchors.bottomMargin: Meui.Units.smallSpacing
            spacing: Meui.Units.smallSpacing

            ListView {
                id: _tabView
                model: tabsModel.count
                Layout.fillWidth: true
                Layout.fillHeight: true
                orientation: ListView.Horizontal
                spacing: Meui.Units.largeSpacing
                currentIndex: _view.currentIndex
                highlightFollowsCurrentItem: true
                highlightMoveDuration: 0
                highlightResizeDuration: 0
                clip: true

                delegate: Item {
                    height: _tabView.height
                    width: Math.min(_tabName.implicitWidth, 200) + Meui.Units.largeSpacing

                    property bool isCurrent: _tabView.currentIndex === index

                    MouseArea {
                        id: _mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: _view.currentIndex = index
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: isCurrent ?
                            Meui.Theme.highlightColor :
                            Qt.rgba(
                                Meui.Theme.textColor.r,
                                Meui.Theme.textColor.g,
                                Meui.Theme.textColor.b,
                                0.1
                            )
                        radius: Meui.Theme.smallRadius
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Meui.Units.smallSpacing
                        spacing: 0

                        Label {
                            id: _tabName
                            Layout.fillWidth: true
                            text: tabsModel.get(index).title
                            elide: Label.ElideRight
                            font.family: fonts.fixedFont
                            font.pointSize: 9
                            color: isCurrent ? Meui.Theme.highlightedTextColor : Meui.Theme.textColor
                        }

                        ImageButton {
                            Layout.fillHeight: true
                            size: height
                            source: "qrc:/images/" + (Meui.Theme.darkMode || isCurrent ? "dark/" : "light/") + "close.svg"
                            onClicked: closeTab(index)
                            visible: _mouseArea.containsMouse
                        }
                    }
                }
            }

            Meui.WindowButton {
                size: 35
                source: "qrc:/images/" + (Meui.Theme.darkMode ? "dark/" : "light/") + "add.svg"
                onClicked: rootWindow.openNewTab()
            }
        }
    }

    ListView {
        id: _view
        anchors.fill: parent
        clip: true
        focus: true
        orientation: ListView.Horizontal
        model: tabsModel
        snapMode: ListView.SnapOneItem
        spacing: 0
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 0
        highlightResizeDuration: 0
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: 0
        preferredHighlightEnd: width
        highlight: Item {}
        highlightMoveVelocity: -1
        highlightResizeVelocity: -1
        onMovementEnded: _view.currentIndex = indexAt(contentX, contentY)
        boundsBehavior: Flickable.StopAtBounds
        onCurrentItemChanged: currentItem.forceActiveFocus()
        interactive: false
    }

    Component.onCompleted: {
        openTab("$HOME")
    }

    function openNewTab() {
        if (currentTerminal) {
            openTab(currentTerminal.session.currentDir)
        } else {
            openTab("$HOME")
        }
    }

    function openTab(path) {
        const component = Qt.createComponent("Terminal.qml");
        if (component.status === Component.Ready) {
            const object = component.createObject(tabsModel, {'path': path})
            tabsModel.append(object)
            const index = tabsModel.count - 1
            _view.currentIndex = index
            object.terminalClosed.connect(() => closeTab(index))
        }

    }

    function closeTab(index) {
        tabsModel.remove(index)
        if (tabsModel.count == 0) Qt.quit()
    }

    function toggleTab() {
        var nextIndex = _view.currentIndex
        ++nextIndex
        if (nextIndex > tabsModel.count - 1)
            nextIndex = 0

        _view.currentIndex = nextIndex
    }
}
