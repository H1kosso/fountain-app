#ifndef BLEDEVICE_H
#define BLEDEVICE_H

#include <QObject>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothDeviceInfo>
#include <QLowEnergyController>
#include <QLowEnergyService>
#include <QIODevice>
#include <QtEndian>
#include <QColor>

#if QT_CONFIG(permissions)
#include <QtCore/qcoreapplication.h>
#include <QtCore/qpermissions.h>
#endif

#include "deviceinfo.h"

#pragma pack( 1 )

typedef struct
{
    uint8_t  waterscreenMode;
    bool     isWorkingDuringWeekends;
    uint16_t workTimeInStandardMode;
    uint16_t idleTimeInStandardMode;
    uint8_t  workFrom;
    uint8_t  workTo;
} SerializedConfiguration_t;

#pragma pack( 0 )

#pragma pack( 1 )

typedef struct
{
    uint8_t ssidSize;
    uint8_t passwordSize;
    uint8_t ssid[100];
    uint8_t password[100];
} WifiCredentials_t;

#pragma pack( 0 )

#pragma pack( 1 )

typedef struct
{
    uint8_t r;
    uint8_t g;
    uint8_t b;
} SerializedColorRGB_t;

#pragma pack( 0 )

#pragma pack( 1 )

typedef struct
{
    SerializedColorRGB_t main;
    SerializedColorRGB_t secondary;
} SerializedPictureColors_t;

#pragma pack( 0 )

#pragma pack( 1 )

typedef struct
{
    uint32_t size;
    uint64_t picture[256];

} PictureData;

#pragma pack( 0 )

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
    Q_INVOKABLE void updateConfigOnDevice();
    Q_INVOKABLE void parseQmlConfigToBLE(uint8_t mode, bool isWorkingDruingWeekend, uint16_t workTime, uint16_t idleTime, uint8_t workFrom, uint8_t workTo);
    Q_INVOKABLE void parseQmlWifiToBLE(QString ssid, QString password);
    Q_INVOKABLE void parseQMLImageToBLE(uint32_t size, const QVariantList &pictureData, QColor main, QColor secondary);
    Q_INVOKABLE void updateWifiOnDevice();
    Q_INVOKABLE void sendImage();

private:
    // Private Variables
    bool notificationsEnabled = false;
    bool bFoundDevice = false;
    bool m_connected = false;
    bool m_logsActive = false;
    bool m_realTimeActive = false;

    SerializedConfiguration_t m_config;
    WifiCredentials_t m_wifi;
    SerializedPictureColors_t m_colors;
    PictureData m_picture;

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

    void writeWifi(const WifiCredentials_t &wifi);
    void writeConfiguration(const SerializedConfiguration_t &config);
    void writeImage(const SerializedPictureColors_t &colors, const PictureData &picture);
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
