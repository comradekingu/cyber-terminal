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

    headerBarHeight: 40 + Meui.Units.smallSpacing

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
            anchors.rightMargin: -140
            spacing: 0
            z: -1

            Item {
                Layout.fillWidth: true
            }

            Item {
                Layout.fillHeight: true
                width: 140 + 35 + Meui.Units.largeSpacing * 2
                LinearGradient {
                    anchors.fill: parent
                    start: Qt.point(0, 0)
                    end: Qt.point(parent.width, 0)
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "transparent" }
                        GradientStop { position: 0.1; color: Meui.Theme.backgroundColor }
                    }
                }
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.topMargin: Meui.Units.smallSpacing
            anchors.bottomMargin: Meui.Units.smallSpacing
            anchors.rightMargin: Meui.Units.largeSpacing + 35
            spacing: Meui.Units.smallSpacing
            z: -20

            ListView {
                id: _tabView
                model: tabsModel.count
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: Meui.Units.smallSpacing
                orientation: ListView.Horizontal
                spacing: Meui.Units.smallSpacing
                currentIndex: _view.currentIndex
                highlightFollowsCurrentItem: true
                highlightMoveDuration: 0
                highlightResizeDuration: 0
                clip: false

                delegate: Item {
                    height: _tabView.height
                    width: Math.min(_layout.implicitWidth, 256) + Meui.Units.largeSpacing

                    property bool isCurrent: _tabView.currentIndex === index

                    MouseArea {
                        id: _mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: _view.currentIndex = index
                    }

                    Rectangle {
                        anchors.fill: parent
                        anchors.bottomMargin: -radius * 2
                        color: isCurrent ?
                            Meui.Theme.secondBackgroundColor :
                            _mouseArea.containsMouse ?
                                Meui.Theme.darkMode ?
                                    Qt.darker(Meui.Theme.backgroundColor, 0.7) :
                                    Qt.darker(Meui.Theme.backgroundColor, 1.1) :
                                Meui.Theme.backgroundColor
                        Behavior on color {
                            ColorAnimation {
                                duration: 125
                                easing.type: Easing.InOutCubic
                            }
                        }
                        radius: Meui.Theme.bigRadius
                    }

                    RowLayout {
                        id: _layout
                        anchors.fill: parent
                        anchors.margins: Meui.Units.smallSpacing
                        anchors.topMargin: Meui.Units.smallSpacing / 2
                        spacing: 0

                        Label {
                            id: _tabName
                            Layout.fillWidth: true
                            Layout.leftMargin: Meui.Units.smallSpacing
                            Layout.alignment: Qt.AlignVCenter
                            text: tabsModel.get(index).title !== "" ? tabsModel.get(index).title : `Tab #${index + 1}`
                            elide: Label.ElideRight
                            font.family: fonts.fixedFont
                            font.pointSize: 9
                            color: Meui.Theme.textColor
                        }

                        ImageButton {
                            Layout.leftMargin: Meui.Units.largeSpacing
                            Layout.alignment: Qt.AlignVCenter
                            size: _tabName.height * 2
                            source: "qrc:/images/" + (Meui.Theme.darkMode ? "dark/" : "light/") + "close.svg"
                            onClicked: closeTab(index)
                        }
                    }
                }
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.topMargin: Meui.Units.smallSpacing
            anchors.bottomMargin: Meui.Units.smallSpacing
            spacing: Meui.Units.smallSpacing

            Item {
                Layout.fillWidth: true
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
        z: 5
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
            object.terminalClosed.connect(() => closeTab(_view.currentIndex))
        }
    }

    function closeTab(index) {
        tabsModel.remove(index)
        if (tabsModel.count == 0) Qt.quit()
        if (index !== 0) _view.currentIndex = index - 1
    }

    function toggleTab() {
        var nextIndex = _view.currentIndex
        ++nextIndex
        if (nextIndex > tabsModel.count - 1)
            nextIndex = 0

        _view.currentIndex = nextIndex
    }
}
