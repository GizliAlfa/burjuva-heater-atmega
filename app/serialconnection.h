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
    
    Q_INVOKABLE bool openPort(const QString &portName);
    Q_INVOKABLE void closePort();
    Q_INVOKABLE bool isOpen() const;
    
    Q_INVOKABLE void sendCommand(const QString &command);
    Q_INVOKABLE QStringList availablePorts() const;
    
    Q_INVOKABLE QString getCurrentPort() const;

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
