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

#pragma pack (0)

class BLEDevice : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList deviceListModel READ deviceListModel WRITE setDeviceListModel RESET resetDeviceListModel NOTIFY deviceListModelChanged)
    Q_PROPERTY(QStringList logsListModel READ logsListModel WRITE setLogsListModel RESET resetLogsListModel NOTIFY logsListModelChanged)
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)

public:
    explicit BLEDevice(QObject *parent = nullptr);
    ~BLEDevice();

    QStringList deviceListModel();
    QStringList logsListModel();

    bool connected() const;





private:
    DeviceInfo currentDevice;
    QBluetoothDeviceDiscoveryAgent *DiscoveryAgent;
    QList<QObject*> qlDevices;
    QLowEnergyController *controller;
    QLowEnergyService *service;
    QLowEnergyDescriptor notificationDesc;
    bool bFoundDevice;
    QStringList m_foundDevices;
    QStringList m_deviceListModel;
    bool m_connected;

    QStringList m_logsListModel;
    unsigned int logPart;
    QString singleLog;

private slots:
    void addLog(QString &);

    /* Slots for QBluetothDeviceDiscoveryAgent */
    void addDevice(const QBluetoothDeviceInfo &);
    void scanFinished();
    void deviceScanError(QBluetoothDeviceDiscoveryAgent::Error);

    /* Slots for QLowEnergyController */
    void serviceDiscovered(const QBluetoothUuid &);
    void serviceScanDone();
    void controllerError(QLowEnergyController::Error);
    void deviceConnected();
    void deviceDisconnected();

    /* Slotes for QLowEnergyService */
    void serviceStateChanged(QLowEnergyService::ServiceState);
    void updateData(const QLowEnergyCharacteristic &, const QByteArray &);
    void confirmedDescriptorWrite(const QLowEnergyDescriptor &, const QByteArray &);

public slots:
    /* Slots for user */
    void startScan();
    void startConnect(int);
    void disconnectFromDevice();
    void writeData();
    void setDeviceListModel(QStringList);
    void resetDeviceListModel();
    void setLogsListModel(QStringList);
    void resetLogsListModel();

signals:
    /* Signals for user */
    void newTemperature(QList<QVariant>);
    void newIntermediateTemperature(QList<QVariant>);
    void scanningFinished();
    void connectionStart();
    void connectionEnd();
    void deviceListModelChanged(QStringList);

    void connectedChanged();
    void logsListModelChanged(QStringList);
};

#endif // BLEDEVICE_H
