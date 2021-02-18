import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import MeuiKit 1.0 as Meui

Item {
    id: control

    property var size: 32
    height: size
    width: size

    property color hoveredColor: Meui.Theme.darkMode ? Qt.lighter(Meui.Theme.backgroundColor, 1.5)
                                                   : Qt.darker(Meui.Theme.backgroundColor, 1.2)
    property color pressedColor: Meui.Theme.darkMode ? Qt.lighter(Meui.Theme.backgroundColor, 1.3)
                                                     : Qt.darker(Meui.Theme.backgroundColor, 1.3)
    property alias source: image.source
    signal clicked()

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: control.clicked()
    }

    Image {
        id: image
        objectName: "image"
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(width, height)
        cache: true
        asynchronous: false
    }
}
