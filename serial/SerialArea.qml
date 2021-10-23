import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

Item {
    property int serialStatus: 0
    Rectangle{
        id:serialContent
        width: parent.width
        height: parent.height*0.7
        anchors.top:parent.top

        Rectangle{
            id: rectReceive
            width: parent.width
            height: parent.height*0.6
            anchors.top: parent.top
            border.color: "black"
            Flickable {
                id:flickRecv
                anchors.fill: parent

                contentWidth: editReceive.paintedWidth
                contentHeight: editReceive.paintedHeight
                clip: true
                focus: true
                function ensureVisible(r)
                {
                    if (contentX >= r.x)
                        contentX = r.x;
                    else if (contentX+width <= r.x+r.width)
                        contentX = r.x+r.width-width;
                    if (contentY >= r.y)
                        contentY = r.y;
                    else if (contentY+height <= r.y+r.height)
                        contentY = r.y+r.height-height;
                }
                TextEdit {
                    id: editReceive
                    width: flickRecv.width
                    height: flickRecv.height
                    activeFocusOnPress: true
                    selectByMouse: true
                    focus: true
                    wrapMode: TextEdit.Wrap
                    onCursorRectangleChanged: flickRecv.ensureVisible(cursorRectangle)
                    //                text: "editReceive"
                }
            }
        }
        Rectangle{
            width: parent.width
            height: parent.height*0.4
            anchors.top: rectReceive.bottom
            border.color: "black"
            Flickable {
                id:flickSend
                anchors.fill: parent

                contentWidth: editSend.paintedWidth
                contentHeight: editSend.paintedHeight
                clip: true

                function ensureVisible(r)
                {
                    if (contentX >= r.x)
                        contentX = r.x;
                    else if (contentX+width <= r.x+r.width)
                        contentX = r.x+r.width-width;
                    if (contentY >= r.y)
                        contentY = r.y;
                    else if (contentY+height <= r.y+r.height)
                        contentY = r.y+r.height-height;
                }

                TextEdit {
                    id: editSend
                    width: flickSend.width
                    height: flickSend.height
                    //                    anchors.fill: parent
                    activeFocusOnPress: true
                    selectByMouse: true
                    focus: true

                    wrapMode: TextEdit.Wrap
                    onCursorRectangleChanged: flickSend.ensureVisible(cursorRectangle)
                    text: "editSend"
                }
                Component.onCompleted: {
                    console.log("content",contentWidth,contentHeight,editSend.paintedWidth,editSend.paintedHeight)
                    console.log("editSend",editSend.width,editSend.height)
                }
            }
        }
    }
    Rectangle{
        id:serialSet
        width: parent.width
        anchors.top: serialContent.bottom
        anchors.bottom: parent.bottom
        border.color: "red"
        Row{
            id:set
            anchors.fill: parent
            anchors.margins: 5
            spacing: 10
            Column{
                //串口设置
                enabled: openButton.text==="打开串口"
                Label{
                    text: qsTr("串口设置")
                    color: "#000000"
                }
                GridLayout {
                    id: grid
                    columns: 2
                    rowSpacing: 0
                    Label {
                        text: qsTr("串  口")
                    }
                    ComboBox {
                        id:serialName
                        model: serialTest.scanSerialPort()//[ "Banana", "Apple", "Coconut" ]
                    }

                    Label {
                        text: qsTr("波特率")
                    }
                    ComboBox {
                        id:baud
                        model: [ "9600", "19200", "38400", "57600","115200"]
                        currentIndex: 4
                    }
                }
            }
            Column{
                Label{
                    text: qsTr("显示设置")
                    color: "#000000"
                }
                RowLayout{
                    RadioButton { text: qsTr("ASCII"); checked: true }
                    RadioButton {
                        text: qsTr("Hex")
                        onCheckedChanged: {
                            if(checked)
                            {
                                serialTest.setHex(true)
                            }
                            else
                            {
                                serialTest.setHex(false)
                            }
                        }
                    }
                }
                Button{
                    text: qsTr("保存文件")
                    onClicked: {

                    }
                }
            }
            ColumnLayout{

                Button{
                    id: openButton
                    text: "打开串口"
                    onClicked: {
                        if(openButton.text==="打开串口")
                        {
                            console.log(serialName.currentText,baud.currentText);
                            serialStatus=serialTest.openSerialPort(serialName.currentText,baud.currentText);
                            console.log("ret:",serialStatus);
                            if(serialStatus==0)
                                openButton.text="关闭串口"

                        }
                        else
                        {
                            openButton.text="打开串口"
                            serialTest.closePort();
                        }
                    }
                }
                Button{
                    text: "发送"
                    enabled: openButton.text==="关闭串口"
                    onClicked: {
                        console.log("send:"+editSend.text)
                        serialTest.sendto(editSend.text);
                    }
                }
                Button{
                    text: "清空"
                    onClicked: {
                        editReceive.clear();
                        editSend.clear();
                    }
                }
            }
        }
    }
    Connections{
        target: serialTest
        onReceivedataChanged:{
            editReceive.append(recvdata)
            console.log("receive:"+recvdata)
        }
    }

}

