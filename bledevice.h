#ifndef BLEDEVICE_H
#define BLEDEVICE_H

#include <QObject>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothDeviceInfo>
#include <QLowEnergyController>
#include <QLowEnergyService>

#if QT_CONFIG(permissions)
#include <QtCore/qcoreapplication.h>
#include <QtCore/qpermissions.h>
#endif

#include "deviceinfo.h"

#pragma pack(0)

class BLEDevice : public QObject
{
    Q_OBJECT

    // Properties
    Q_PROPERTY(QStringList deviceListModel READ deviceListModel WRITE setDeviceListModel RESET resetDeviceListModel NOTIFY deviceListModelChanged)
    Q_PROPERTY(QStringList logsListModel READ logsListModel WRITE setLogsListModel RESET resetLogsListModel NOTIFY logsListModelChanged)
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
    Q_PROPERTY(bool logsActive READ logsActive WRITE setLogsActive NOTIFY logsActiveChanged)
    Q_PROPERTY(bool realTimeActive READ realTimeActive WRITE setRealTimeActive NOTIFY realTimeActiveChanged)

public:
    // Constructor and Destructor
    explicit BLEDevice(QObject *parent = nullptr);
    ~BLEDevice();

    // Public Methods
    QStringList deviceListModel();
    QStringList logsListModel();

    bool connected() const;

    bool logsActive() const;
    void setLogsActive(bool newLogsActive);

    bool realTimeActive() const;
    void setRealTimeActive(bool newRealTimeActive);

    Q_INVOKABLE void toggleLogs();
    Q_INVOKABLE void toggleRealTime();

private:
    // Private Variables
    bool notificationsEnabled = false;
    bool bFoundDevice = false;
    bool m_connected = false;
    bool m_logsActive = false;
    bool m_realTimeActive = false;

    DeviceInfo currentDevice;
    QBluetoothDeviceDiscoveryAgent *DiscoveryAgent = nullptr;
    QList<QObject*> qlDevices;
    QLowEnergyController *controller = nullptr;
    QLowEnergyService *service = nullptr;
    QLowEnergyDescriptor notificationDesc;

    QStringList m_foundDevices;
    QStringList m_deviceListModel;
    QStringList m_logsListModel;
    QString singleLog;

    // Private Slots
    void addLog(QString &);

    /* Slots for QBluetoothDeviceDiscoveryAgent */
    void addDevice(const QBluetoothDeviceInfo &);
    void scanFinished();
    void deviceScanError(QBluetoothDeviceDiscoveryAgent::Error);

    /* Slots for QLowEnergyController */
    void serviceDiscovered(const QBluetoothUuid &);
    void serviceScanDone();
    void controllerError(QLowEnergyController::Error);
    void deviceConnected();
    void deviceDisconnected();

    /* Slots for QLowEnergyService */
    void serviceStateChanged(QLowEnergyService::ServiceState);
    void updateData(const QLowEnergyCharacteristic &, const QByteArray &);
    void confirmedDescriptorWrite(const QLowEnergyDescriptor &, const QByteArray &);

public slots:
    // Slots for user interactions
    void startScan();
    void startConnect(int);
    void disconnectFromDevice();
    void writeData(QString);
    void setDeviceListModel(QStringList);
    void resetDeviceListModel();
    void setLogsListModel(QStringList);
    void resetLogsListModel();

signals:
    // Signals for user interactions
    void newTemperature(QList<QVariant>);
    void newIntermediateTemperature(QList<QVariant>);
    void scanningFinished();
    void connectionStart();
    void connectionEnd();
    void deviceListModelChanged(QStringList);

    void connectedChanged();
    void logsListModelChanged(QStringList);
    void logsActiveChanged();
    void realTimeActiveChanged();
};

#endif // BLEDEVICE_H
