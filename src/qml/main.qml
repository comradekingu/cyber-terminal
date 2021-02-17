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
    width: 900
    height: 600
    visible: true
    id: rootWindow
    title: currentItem && currentItem.terminal ? currentItem.terminal.session.title : ""

    headerBarHeight: 40 + Meui.Units.largeSpacing

    property alias currentItem: _view.currentItem
    readonly property QMLTermWidget currentTerminal: currentItem.terminal

    ObjectModel { id: tabsModel }

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
                    width: Math.min(_tabName.implicitWidth, 200)

                    property bool isCurrent: _tabView.currentIndex === index

                    MouseArea {
                        anchors.fill: parent
                        onClicked: _view.currentIndex = index
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: isCurrent ? Meui.Theme.highlightColor : "transparent"
                        radius: Meui.Theme.smallRadius
                    }

                    Item {
                        anchors.fill: parent
                        anchors.margins: Meui.Units.smallSpacing

                        Label {
                            id: _tabName
                            anchors.fill: parent
                            text: tabsModel.get(index).title
                            elide: Label.ElideRight
                            color: isCurrent ? Meui.Theme.highlightedTextColor : Meui.Theme.textColor
                        }
                    }
                }
            }

            Meui.WindowButton {
                size: 35
                source: "qrc:/images/" + (Meui.Theme.darkMode ? "dark/" : "light/") + "add.svg"
                onClicked: openNewTab("~")
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
        openNewTab("$HOME")
    }

    function openNewTab(path) {
        const component = Qt.createComponent("Terminal.qml");
        if (component.status === Component.Ready) {
            const object = component.createObject(tabsModel, {'path': path})
            tabsModel.append(object)
            _view.currentIndex = tabsModel.count - 1
        }

    }

    function closeTab(index) {
        tabsModel.remove(index)
    }
}
