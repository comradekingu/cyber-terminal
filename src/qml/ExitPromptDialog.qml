import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import MeuiKit 1.0 as Meui

Window {
    id: control
    flags: Qt.Dialog
    modality: Qt.WindowModal

    width: _mainLayout.implicitWidth + Meui.Units.largeSpacing * 4
    height: _mainLayout.implicitHeight + Meui.Units.largeSpacing * 4

    minimumWidth: width
    minimumHeight: height
    maximumHeight: height
    maximumWidth: width

    signal okBtnClicked

    Rectangle {
        anchors.fill: parent
        color: Meui.Theme.backgroundColor
    }

    ColumnLayout {
        id: _mainLayout
        anchors.fill: parent

        Label {
            text: qsTr("Process is running, are you sure you want to quit?")
            Layout.alignment: Qt.AlignHCenter
        }

        DialogButtonBox {
            Layout.alignment: Qt.AlignHCenter

            Button {
                text: qsTr("OK")
                onClicked: {
                    control.visible = false
                    control.okBtnClicked()
                }
            }

            Button {
                text: qsTr("Cancel")
                onClicked: control.visible = false
            }
        }
    }
}
