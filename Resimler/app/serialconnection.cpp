#include "serialconnection.h"
#include <QDebug>

SerialConnection::SerialConnection(QObject *parent)
    : QObject(parent)
    , m_serialPort(new QSerialPort(this))
{
    connect(m_serialPort, &QSerialPort::readyRead, this, &SerialConnection::readData);
    connect(m_serialPort, &QSerialPort::errorOccurred, this, &SerialConnection::handleError);
}

SerialConnection::~SerialConnection()
{
    closePort();
}

bool SerialConnection::openPort(const QString &portName)
{
    closePort();
    
    m_serialPort->setPortName(portName);
    m_serialPort->setBaudRate(QSerialPort::Baud115200);
    m_serialPort->setDataBits(QSerialPort::Data8);
    m_serialPort->setParity(QSerialPort::NoParity);
    m_serialPort->setStopBits(QSerialPort::OneStop);
    m_serialPort->setFlowControl(QSerialPort::NoFlowControl);
    
    if (m_serialPort->open(QIODevice::ReadWrite)) {
        qDebug() << "Serial port opened:" << portName;
        emit connectionStatusChanged(true);
        return true;
    }
    else {
        QString error = m_serialPort->errorString();
        qDebug() << "Failed to open serial port:" << error;
        emit errorOccurred(error);
        emit connectionStatusChanged(false);
        return false;
    }
}

void SerialConnection::closePort()
{
    if (m_serialPort->isOpen()) {
        m_serialPort->close();
        emit connectionStatusChanged(false);
        qDebug() << "Serial port closed";
    }
}

bool SerialConnection::isOpen() const
{
    return m_serialPort->isOpen();
}

void SerialConnection::sendCommand(const QString &command)
{
    if (!m_serialPort->isOpen()) {
        qDebug() << "Cannot send command, port not open";
        return;
    }
    
    QString cmd = command;
    if (!cmd.endsWith('\n')) {
        cmd += '\n';
    }
    
    qint64 bytesWritten = m_serialPort->write(cmd.toUtf8());
    m_serialPort->flush();
    
    qDebug() << "Sent command:" << command.trimmed() << "(" << bytesWritten << "bytes)";
}

QStringList SerialConnection::availablePorts() const
{
    QStringList ports;
    const auto infos = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo &info : infos) {
        ports.append(info.portName());
    }
    return ports;
}

QString SerialConnection::getCurrentPort() const
{
    return m_serialPort->portName();
}

void SerialConnection::readData()
{
    QByteArray data = m_serialPort->readAll();
    m_buffer.append(QString::fromUtf8(data));
    
    int newlineIndex;
    while ((newlineIndex = m_buffer.indexOf('\n')) != -1) {
        QString line = m_buffer.left(newlineIndex).trimmed();
        m_buffer.remove(0, newlineIndex + 1);
        
        if (!line.isEmpty()) {
            qDebug() << "Received:" << line;
            emit dataReceived(line);
        }
    }
}

void SerialConnection::handleError(QSerialPort::SerialPortError error)
{
    if (error == QSerialPort::ResourceError) {
        qDebug() << "Serial port disconnected";
        closePort();
        emit errorOccurred("Device disconnected");
    }
    else if (error != QSerialPort::NoError) {
        QString errorStr = m_serialPort->errorString();
        qDebug() << "Serial port error:" << errorStr;
        emit errorOccurred(errorStr);
    }
}
