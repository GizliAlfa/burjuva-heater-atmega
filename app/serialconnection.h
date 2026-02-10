#ifndef SERIALCONNECTION_H
#define SERIALCONNECTION_H

#include <QObject>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QTimer>

class SerialConnection : public QObject
{
    Q_OBJECT

public:
    explicit SerialConnection(QObject *parent = nullptr);
    ~SerialConnection();
    
    bool openPort(const QString &portName);
    void closePort();
    bool isOpen() const;
    
    void sendCommand(const QString &command);
    QStringList availablePorts() const;
    
    QString getCurrentPort() const;

signals:
    void dataReceived(const QString &data);
    void connectionStatusChanged(bool connected);
    void errorOccurred(const QString &error);

private slots:
    void readData();
    void handleError(QSerialPort::SerialPortError error);

private:
    QSerialPort *m_serialPort;
    QString m_buffer;
};

#endif
