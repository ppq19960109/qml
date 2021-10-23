#ifndef SERIALTEST_H
#define SERIALTEST_H

#include <QObject>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QString>

#include <QDebug>

class serialTest : public QSerialPort
{
    Q_OBJECT
public:
    serialTest();
    bool hex=false;
    Q_INVOKABLE void setHex(bool val);
    Q_INVOKABLE int openSerialPort(QString portName,QString baudRate);
    Q_INVOKABLE void closePort();//关闭端口;
    Q_INVOKABLE QStringList scanSerialPort();
    Q_INVOKABLE void sendto(QString sendmessage);//发送数据;
    signals:
        void receivedataChanged(QString recvdata);
    public slots:
        void receivefrom();//信号（收到数据激发的信号）响应函数
    private:
        QString m_receivedata;
};

#endif // SERIALTEST_H
