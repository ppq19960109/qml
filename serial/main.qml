import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    visible: true
    width: 480
    height: 640
    title: qsTr("串口调试助手")

    Rectangle{
        id:rootRectangle
        anchors.fill: parent
        SerialArea{
            anchors.fill: parent
        }
    }
}
