#include "serialTest.h"

serialTest::serialTest():m_receivedata("receive data")
{
    QObject::connect(this, SIGNAL(readyRead()),this, SLOT(receivefrom()));
}

void serialTest::setHex(bool val)
{
    hex=val;
}

int serialTest::openSerialPort(QString portName,QString baudRate)
{
    qDebug() << portName << baudRate;
    /* 设置串口名 */
    setPortName(portName);
    /* 设置波特率 */
    setBaudRate(baudRate.toInt());
    /* 设置数据位数 */
    switch (8) {
    case 5:
        setDataBits(QSerialPort::Data5);
        break;
    case 6:
        setDataBits(QSerialPort::Data6);
        break;
    case 7:
        setDataBits(QSerialPort::Data7);
        break;
    case 8:
        setDataBits(QSerialPort::Data8);
        break;
    default: break;
    }
    /* 设置奇偶校验 */
    switch (0) {
    case 0:
        setParity(QSerialPort::NoParity);
        break;
    case 1:
        setParity(QSerialPort::EvenParity);
        break;
    case 2:
        setParity(QSerialPort::OddParity);
        break;
    case 3:
        setParity(QSerialPort::SpaceParity);
        break;
    case 4:
        setParity(QSerialPort::MarkParity);
        break;
    default: break;
    }
    /* 设置停止位 */
    switch (1) {
    case 1:
        setStopBits(QSerialPort::OneStop);
        break;
    case 2:
        setStopBits(QSerialPort::TwoStop);
        break;
    default: break;
    }
    /* 设置流控制 */
    setFlowControl(QSerialPort::NoFlowControl);
    if (!open(QIODevice::ReadWrite))
    {
        qDebug() << "错误 串口无法打开！可能串口已经被占用！";
        return -1;
    }
    return 0;
}

void serialTest::closePort()
{
    close();
}

QStringList serialTest::scanSerialPort()
{
    QStringList ports;
    /* 查找可用串口 */
    foreach (const QSerialPortInfo &info,
             QSerialPortInfo::availablePorts()) {
        ports.append(info.portName());
    }
    qDebug() << "scanSerialPort:" << ports;
    return ports;
}

void serialTest::sendto(QString sendmessage)
{
    QByteArray data = sendmessage.toLatin1();
    if(hex)
    {
        data=QByteArray::fromHex(data);
    }
    if(isOpen())
        write(data);
}

void serialTest::receivefrom()
{
    QByteArray data = readAll();
    qDebug() << "receivefrom:" << data;
    if(hex)
    {
        qDebug() << "HEX:" << data.toHex();
        data=data.toHex();
    }
    emit receivedataChanged(QString(data));
}

