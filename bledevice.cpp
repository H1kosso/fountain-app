#include "bledevice.h"
#include "qcolor.h"

BLEDevice::BLEDevice(QObject *parent) : QObject(parent),
    currentDevice(QBluetoothDeviceInfo()),
    controller(0),
    service(0)
{
    DiscoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);
    DiscoveryAgent->setLowEnergyDiscoveryTimeout(2000);

    connect(DiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered, this, &BLEDevice::addDevice);
    connect(DiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::errorOccurred, this, &BLEDevice::deviceScanError);
    connect(DiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::finished, this, &BLEDevice::scanFinished);
    connect(DiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::canceled, this, &BLEDevice::scanFinished);
}

BLEDevice::~BLEDevice()
{
    delete DiscoveryAgent;
    delete controller;
    if(m_realTimeActive)
        toggleRealTime();
}



void BLEDevice::addDevice(const QBluetoothDeviceInfo &device)
{
    if (device.coreConfigurations() & QBluetoothDeviceInfo::LowEnergyCoreConfiguration) {
        qDebug()<<"Discovered Device:"<<device.name()<<"Address: "<<device.address().toString()<<"RSSI:"<< device.rssi()<<"dBm";

        //if(!m_foundDevices.contains(device.name(), Qt::CaseSensitive) && device.name().contains("HTS", Qt::CaseSensitive)) {
        if(true){
            m_foundDevices.append(device.name());

            DeviceInfo *dev = new DeviceInfo(device);
            qlDevices.append(dev);
        }
    }
}

void BLEDevice::scanFinished()
{
    setDeviceListModel(m_foundDevices);
    emit scanningFinished();
}

void BLEDevice::deviceScanError(QBluetoothDeviceDiscoveryAgent::Error error)
{
    if (error == QBluetoothDeviceDiscoveryAgent::PoweredOffError)
        qDebug() << " The Bluetooth adaptor is powered off.";
    else if (error == QBluetoothDeviceDiscoveryAgent::InputOutputError)
        qDebug() << " Writing or reading from the device resulted in an error.";
    else
        qDebug() << " An unknown error has occurred.";
}

void BLEDevice::startScan()
{

#if QT_CONFIG(permissions)
    //! [permissions]
    QBluetoothPermission permission{};
    permission.setCommunicationModes(QBluetoothPermission::Access);
    switch (qApp->checkPermission(permission)) {
    case Qt::PermissionStatus::Undetermined:
        qApp->requestPermission(permission, this, &BLEDevice::startScan);
        return;
    case Qt::PermissionStatus::Denied:
        qDebug()<< "Bluetooth permissions not granted!" ;
        return;
    case Qt::PermissionStatus::Granted:
        break;
    }
    //! [permissions]
#endif // QT_CONFIG(permissions)

    qDeleteAll(qlDevices);
    qlDevices.clear();
    m_foundDevices.clear();
    resetDeviceListModel();
    DiscoveryAgent->start(QBluetoothDeviceDiscoveryAgent::LowEnergyMethod);
    qDebug()<< "Searching for BLE devices..." ;
}

void BLEDevice::startConnect(int i)
{
    currentDevice.setDevice(((DeviceInfo*)qlDevices.at(i))->getDevice());
    if (controller) {
        controller->disconnectFromDevice();
        delete controller;
        controller = 0;

    }

    controller = QLowEnergyController::createCentral(currentDevice.getDevice());
    controller ->setRemoteAddressType(QLowEnergyController::RandomAddress);

    connect(controller, &QLowEnergyController::serviceDiscovered, this, &BLEDevice::serviceDiscovered);
    connect(controller, &QLowEnergyController::discoveryFinished, this, &BLEDevice::serviceScanDone);
    connect(controller, &QLowEnergyController::errorOccurred,  this, &BLEDevice::controllerError);
    connect(controller, &QLowEnergyController::connected, this, &BLEDevice::deviceConnected);
    connect(controller, &QLowEnergyController::disconnected, this, &BLEDevice::deviceDisconnected);
    controller->connectToDevice();

}

void BLEDevice::disconnectFromDevice()
{

    if (controller->state() != QLowEnergyController::UnconnectedState) {
        if(m_realTimeActive)
            toggleRealTime();
        controller->disconnectFromDevice();
    } else {
        deviceDisconnected();
    }
}

void BLEDevice::serviceDiscovered(const QBluetoothUuid &gatt)
{
    if(gatt.toString() == "{0000ffe0-0000-1000-8000-00805f9b34fb}" ) {
        bFoundDevice =true;
        qDebug() << " HM-10 service found";
    }

}

void BLEDevice::serviceScanDone()
{
    delete service;
    service=0;

    if(bFoundDevice) {
        qDebug() << " Connecting to HM-10 service...";
        service = controller->createServiceObject(QBluetoothUuid("{0000ffe0-0000-1000-8000-00805f9b34fb}"),this);
    }

    if(!service) {
        qDebug()<< "HM-10 service not found";
        disconnectFromDevice();
        return;
    }

    connect(service, &QLowEnergyService::stateChanged,this, &BLEDevice::serviceStateChanged);
    connect(service, &QLowEnergyService::characteristicChanged,this, &BLEDevice::updateData);
    connect(service, &QLowEnergyService::descriptorWritten,this, &BLEDevice::confirmedDescriptorWrite);
    service->discoverDetails();
}

void BLEDevice::deviceDisconnected()
{
    qDebug() << " Remote device disconnected";
    m_connected = false;
    emit connectedChanged();
    emit connectionEnd();
}

void BLEDevice::deviceConnected()
{
    qDebug() << " Device connected";
    controller->discoverServices();
}

void BLEDevice::controllerError(QLowEnergyController::Error error)
{
    qDebug() << " Controller Error:" << error;
}

void BLEDevice::serviceStateChanged(QLowEnergyService::ServiceState s)
{
    qDebug() << "Service state changed:" << s;
    if (s == QLowEnergyService::RemoteServiceDiscovered) {
        qDebug() << "Service discovery complete. Available characteristics:";
        for (const QLowEnergyCharacteristic &characteristic : service->characteristics()) {
            qDebug() << "Characteristic UUID:" << characteristic.uuid().toString();
            if (characteristic.uuid() == QBluetoothUuid("{0000ffe1-0000-1000-8000-00805f9b34fb}")) {
                qDebug() << "Found HM-10 characteristic.";
            }
            // Sprawdź wszystkie desktiptory dla charakterystyki
            for (const QLowEnergyDescriptor &descriptor : characteristic.descriptors()) {
                qDebug() << "Descriptor UUID:" << descriptor.uuid().toString();
            }
        }
    }
    emit connectionStart();
    m_connected = true;
    emit connectedChanged();
}




void BLEDevice::confirmedDescriptorWrite(const QLowEnergyDescriptor &d, const QByteArray &value)
{
    if (d.isValid() && d == notificationDesc && value == QByteArray::fromHex("0100")) {
        qDebug() << "Notification descriptor successfully written.";
        controller->disconnectFromDevice();
        delete service;
        service = nullptr;
    }
}





void BLEDevice::writeData(QString dataString) {
    const QLowEnergyCharacteristic HM10Char = service->characteristic(QBluetoothUuid("{0000ffe1-0000-1000-8000-00805f9b34fb}"));

    if (HM10Char.isValid()) {
        // Sprawdzenie notyfikacji
        if (!notificationsEnabled) {
            const QLowEnergyDescriptor notificationDesc = HM10Char.descriptor(QBluetoothUuid("{00002902-0000-1000-8000-00805f9b34fb}"));
            if (notificationDesc.isValid()) {
                service->writeDescriptor(notificationDesc, QByteArray::fromHex("0100"));
                notificationsEnabled = true;
                qDebug() << "Notifications enabled for characteristic";
            } else {
                qDebug() << "Failed to find notification descriptor.";
            }
        }

        // Konwersja QString na QByteArray w formacie hex
        QByteArray data = QByteArray::fromHex(dataString.toUtf8());
        if (!data.isEmpty()) {
            service->writeCharacteristic(HM10Char, data);
            qDebug() << "Dane zostały wysłane do urządzenia:" << data.toHex();
        } else {
            qDebug() << "Nieprawidłowy ciąg znaków. Nie można przekonwertować na dane hex.";
        }
    } else {
        qDebug() << "Characteristic is invalid.";
    }
}

void BLEDevice::updateData(const QLowEnergyCharacteristic &c, const QByteArray &v)
{
    QString receivedData = QString::fromUtf8(v);
    singleLog += receivedData; // Append incoming data to singleLog

    // Process complete messages
    while (singleLog.contains("\r\n")) {
        int index = singleLog.indexOf("\r\n"); // Find the end of the first complete message
        QString completeMessage = singleLog.left(index); // Extract the complete message
        singleLog.remove(0, index + 2); // Remove the processed message and "\r\n"

        addLog(completeMessage); // Pass the complete message to addLog
    }
}


bool BLEDevice::connected() const
{
    return m_connected;
}

void BLEDevice::addLog(QString &text)
{
    if (!text.isEmpty()) {
        m_logsListModel.insert(0, text); // Insert the log into the list
        emit logsListModelChanged(m_logsListModel); // Emit the signal
    }
}



QStringList BLEDevice::deviceListModel()
{
    return m_deviceListModel;
}

void BLEDevice::setDeviceListModel(QStringList deviceListModel)
{
    if (m_deviceListModel == deviceListModel)
        return;

    m_deviceListModel = deviceListModel;
    emit deviceListModelChanged(m_deviceListModel);
}

void BLEDevice::resetDeviceListModel()
{
    m_deviceListModel.clear();
    emit deviceListModelChanged(m_deviceListModel);
}

QStringList BLEDevice::logsListModel()
{
    return m_logsListModel;
}

void BLEDevice::setLogsListModel(QStringList logsListModel)
{
    if (m_logsListModel == logsListModel)
        return;
    m_logsListModel = logsListModel;
    emit logsListModelChanged(m_logsListModel);
}

void BLEDevice::resetLogsListModel()
{
    m_logsListModel.clear();
    emit logsListModelChanged(m_logsListModel);
}

bool BLEDevice::logsActive() const
{
    return m_logsActive;
}

void BLEDevice::setLogsActive(bool newLogsActive)
{
    if (m_logsActive == newLogsActive)
        return;
    m_logsActive = newLogsActive;
    emit logsActiveChanged();
}


void BLEDevice::toggleLogs()
{
    writeData(m_logsActive ? "0000" : "0001");
    setLogsActive(!m_logsActive);
}

void BLEDevice::toggleRealTime()
{
    writeData(m_realTimeActive ? "0300" : "0301");
    setRealTimeActive(!m_realTimeActive);
}

void BLEDevice::updateConfigOnDevice()
{
    writeConfiguration(m_config);
}

void BLEDevice::writeConfiguration(const SerializedConfiguration_t &config) {
    const QLowEnergyCharacteristic HM10Char = service->characteristic(QBluetoothUuid("{0000ffe1-0000-1000-8000-00805f9b34fb}"));

    if (HM10Char.isValid()) {
        if (!notificationsEnabled) {
            const QLowEnergyDescriptor notificationDesc = HM10Char.descriptor(QBluetoothUuid("{00002902-0000-1000-8000-00805f9b34fb}"));
            if (notificationDesc.isValid()) {
                service->writeDescriptor(notificationDesc, QByteArray::fromHex("0100"));
                notificationsEnabled = true;
                qDebug() << "Notifications enabled for characteristic";
            } else {
                qDebug() << "Failed to find notification descriptor.";
            }
        }

        QByteArray data;
        QDataStream stream(&data, QIODevice::WriteOnly);
        stream.setByteOrder(QDataStream::LittleEndian);

        stream << static_cast<uint8_t>(0x01);

        stream << config.waterscreenMode;
        stream << static_cast<uint8_t>(config.isWorkingDuringWeekends ? 1 : 0); // bool jako uint8_t
        stream << config.workTimeInStandardMode;
        stream << config.idleTimeInStandardMode;
        stream << config.workFrom;
        stream << config.workTo;

        // Wysłanie danych do urządzenia
        if (!data.isEmpty()) {
            service->writeCharacteristic(HM10Char, data);
            qDebug() << "Dane zostały wysłane do urządzenia (little-endian):" << data.toHex();
        } else {
            qDebug() << "Błąd serializacji danych.";
        }
    } else {
        qDebug() << "Characteristic is invalid.";
    }
}

void BLEDevice::writeImage(const SerializedPictureColors_t &colors, const PictureData &picture)
{
    const QLowEnergyCharacteristic HM10Char = service->characteristic(QBluetoothUuid("{0000ffe1-0000-1000-8000-00805f9b34fb}"));

    if (HM10Char.isValid()) {
        if (!notificationsEnabled) {
            const QLowEnergyDescriptor notificationDesc = HM10Char.descriptor(QBluetoothUuid("{00002902-0000-1000-8000-00805f9b34fb}"));
            if (notificationDesc.isValid()) {
                service->writeDescriptor(notificationDesc, QByteArray::fromHex("0100"));
                notificationsEnabled = true;
                qDebug() << "Notifications enabled for characteristic";
            } else {
                qDebug() << "Failed to find notification descriptor.";
            }
        }

        QByteArray data;
        QDataStream stream(&data, QIODevice::WriteOnly);
        stream.setByteOrder(QDataStream::LittleEndian);

        // Serialize the data
        stream << static_cast<uint8_t>(0x02);
        stream << colors.main.r;
        stream << colors.main.g;
        stream << colors.main.b;
        stream << colors.secondary.r;
        stream << colors.secondary.g;
        stream << colors.secondary.b;
        stream << picture.size;
        stream.writeRawData(reinterpret_cast<const char*>(picture.picture), picture.size * sizeof(uint64_t));

        if (!data.isEmpty()) {
            // Split data into chunks of 20 bytes or less
            const int maxPacketSize = 20;
            int totalSize = data.size();
            int offset = 0;

            while (offset < totalSize) {
                int chunkSize = qMin(maxPacketSize, totalSize - offset);
                QByteArray chunk = data.mid(offset, chunkSize);

                // Write the chunk
                service->writeCharacteristic(HM10Char, chunk);
                qDebug() << "Sent chunk of data, size:" << chunk.size();

                // Wait for confirmation or handle success/failure of the write operation here
                // (Optionally handle acknowledgment and retries if needed)

                offset += chunkSize;
            }

            qDebug() << "All picture data sent to the device.";
        } else {
            qDebug() << "Error serializing picture.";
        }
    } else {
        qDebug() << "Characteristic is invalid.";
    }
}


void BLEDevice::writeWifi(const WifiCredentials_t &wifi) {
    const QLowEnergyCharacteristic HM10Char = service->characteristic(QBluetoothUuid("{0000ffe1-0000-1000-8000-00805f9b34fb}"));

    if (HM10Char.isValid()) {
        if (!notificationsEnabled) {
            const QLowEnergyDescriptor notificationDesc = HM10Char.descriptor(QBluetoothUuid("{00002902-0000-1000-8000-00805f9b34fb}"));
            if (notificationDesc.isValid()) {
                service->writeDescriptor(notificationDesc, QByteArray::fromHex("0100"));
                notificationsEnabled = true;
                qDebug() << "Notifications enabled for characteristic";
            } else {
                qDebug() << "Failed to find notification descriptor.";
            }
        }

        QByteArray data;
        QDataStream stream(&data, QIODevice::WriteOnly);
        stream.setByteOrder(QDataStream::LittleEndian);

        stream << static_cast<uint8_t>(0x04);
        stream << wifi.ssidSize;
        stream.writeRawData(reinterpret_cast<const char *>(wifi.ssid), wifi.ssidSize);
        stream << wifi.passwordSize;
        stream.writeRawData(reinterpret_cast<const char *>(wifi.password), wifi.passwordSize);

        QString readableText = QString::fromUtf8(data);
        qDebug() << "Data as text:" << readableText;

        if (!data.isEmpty()) {
            service->writeCharacteristic(HM10Char, data);
            qDebug() << "WiFi credentials sent to the device.";
        } else {
            qDebug() << "Error serializing WiFi credentials.";
        }
    } else {
        qDebug() << "Characteristic is invalid.";
    }
}





void BLEDevice::parseQmlConfigToBLE(uint8_t mode, bool isWorkingDruingWeekend, uint16_t workTime, uint16_t idleTime, uint8_t workFrom, uint8_t workTo)
{
    m_config.waterscreenMode = mode;
    m_config.isWorkingDuringWeekends = isWorkingDruingWeekend;
    m_config.workTimeInStandardMode = workTime;
    m_config.idleTimeInStandardMode = idleTime;
    m_config.workFrom = workFrom;
    m_config.workTo = workTo;
}

void BLEDevice::parseQmlWifiToBLE(QString ssid, QString password)
{
    QByteArray ssidArray = ssid.toUtf8();
    QByteArray passwordArray = password.toUtf8();

    m_wifi.ssidSize = static_cast<uint8_t>(qMin(ssidArray.size(), 100));
    m_wifi.passwordSize = static_cast<uint8_t>(qMin(passwordArray.size(), 100));

    memcpy(m_wifi.ssid, ssidArray.constData(), m_wifi.ssidSize);
    memcpy(m_wifi.password, passwordArray.constData(), m_wifi.passwordSize);

    if (m_wifi.ssidSize < 100) {
        memset(m_wifi.ssid + m_wifi.ssidSize, 0, 100 - m_wifi.ssidSize);
    }
    if (m_wifi.passwordSize < 100) {
        memset(m_wifi.password + m_wifi.passwordSize, 0, 100 - m_wifi.passwordSize);
    }
}

void BLEDevice::parseQMLImageToBLE(uint32_t size, const QVariantList &pictureData, QColor main, QColor secondary)
{
    m_picture.size = size;

    for (int i = 0; i < pictureData.size() && i < 256; ++i) {
        uint64_t value = pictureData[i].toULongLong();
        m_picture.picture[i] = value;
    }
    m_colors.main.r = main.red()/255;
    m_colors.main.g = main.green()/255;
    m_colors.main.b = main.blue()/255;
    m_colors.secondary.r = secondary.red()/255;
    m_colors.secondary.g = secondary.green()/255;
    m_colors.secondary.b = secondary.blue()/255;
}


void BLEDevice::updateWifiOnDevice()
{
    writeWifi(m_wifi);
}

void BLEDevice::sendImage()
{
    writeImage(m_colors, m_picture);
}

bool BLEDevice::realTimeActive() const
{
    return m_realTimeActive;
}

void BLEDevice::setRealTimeActive(bool newRealTimeActive)
{
    if (m_realTimeActive == newRealTimeActive)
        return;
    m_realTimeActive = newRealTimeActive;
    emit realTimeActiveChanged();
}
