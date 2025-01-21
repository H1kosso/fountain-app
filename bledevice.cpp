#include "bledevice.h"

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
    logPart = 0;
}

BLEDevice::~BLEDevice()
{
    delete DiscoveryAgent;
    delete controller;
}



void BLEDevice::addDevice(const QBluetoothDeviceInfo &device)
{
    if (device.coreConfigurations() & QBluetoothDeviceInfo::LowEnergyCoreConfiguration) {
        qDebug()<<"XXX Discovered Device:"<<device.name()<<"Address: "<<device.address().toString()<<"RSSI:"<< device.rssi()<<"dBm";

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
        qDebug() << "XDX  XXX The Bluetooth adaptor is powered off.";
    else if (error == QBluetoothDeviceDiscoveryAgent::InputOutputError)
        qDebug() << "XDX  XXX Writing or reading from the device resulted in an error.";
    else
        qDebug() << "XDX  XXX An unknown error has occurred.";
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
        qDebug()<< "XXX Bluetooth permissions not granted!" ;
        return;
    case Qt::PermissionStatus::Granted:
        break; // proceed to search
    }
    //! [permissions]
#endif // QT_CONFIG(permissions)

    qDeleteAll(qlDevices);
    qlDevices.clear();
    m_foundDevices.clear();
    resetDeviceListModel();
    DiscoveryAgent->start(QBluetoothDeviceDiscoveryAgent::LowEnergyMethod);
    qDebug()<< "XXX Searching for BLE devices..." ;
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
        controller->disconnectFromDevice();
    } else {
        deviceDisconnected();
    }
}

void BLEDevice::serviceDiscovered(const QBluetoothUuid &gatt)
{
    if(gatt.toString() == "{0000ffe0-0000-1000-8000-00805f9b34fb}" ) {
        bFoundDevice =true;
        qDebug() << "XDX  XXX HM-10 service found";
    }

}

void BLEDevice::serviceScanDone()
{
    delete service;
    service=0;

    if(bFoundDevice) {
        qDebug() << "XDX  XXX Connecting to HM-10 service...";
        service = controller->createServiceObject(QBluetoothUuid("{0000ffe0-0000-1000-8000-00805f9b34fb}"),this);
    }

    if(!service) {
        qDebug()<< "XXX HM-10 service not found";
        disconnectFromDevice();
        return;
    }

    connect(service, &QLowEnergyService::stateChanged,this, &BLEDevice::serviceStateChanged);
    connect(service, &QLowEnergyService::characteristicChanged,this, &BLEDevice::updateData);
    connect(service, &QLowEnergyService::descriptorWritten,this, &BLEDevice::confirmedDescriptorWrite);
    service->discoverDetails();
    if (service->state() == QLowEnergyService::RemoteServiceDiscovered) {
        qDebug() << "XDX Service details discovered.";
    } else {
        qDebug() << "XDX Service details not fully discovered!";
        return;
    }

}

void BLEDevice::deviceDisconnected()
{
    qDebug() << "XDX  XXX Remote device disconnected";
    m_connected = false;
    emit connectedChanged();
    emit connectionEnd();
}

void BLEDevice::deviceConnected()
{
    qDebug() << "XDX  XXX Device connected";
    controller->discoverServices();
}

void BLEDevice::controllerError(QLowEnergyController::Error error)
{
    qDebug() << "XDX  XXX Controller Error:" << error;
}

void BLEDevice::serviceStateChanged(QLowEnergyService::ServiceState s)
{
    qDebug() << "XDX Service state changed:" << s;
    if (s == QLowEnergyService::RemoteServiceDiscovered) {
        qDebug() << "XDX Service discovery complete. Available characteristics:";
        for (const QLowEnergyCharacteristic &characteristic : service->characteristics()) {
            qDebug() << "XDX Characteristic UUID:" << characteristic.uuid().toString();
            if (characteristic.uuid() == QBluetoothUuid("{0000ffe1-0000-1000-8000-00805f9b34fb}")) {
                qDebug() << "XDX Found HM-10 characteristic.";
            }
            // Sprawdź wszystkie desktiptory dla charakterystyki
            for (const QLowEnergyDescriptor &descriptor : characteristic.descriptors()) {
                qDebug() << "XDX Descriptor UUID:" << descriptor.uuid().toString();
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
        qDebug() << "XDX Notification descriptor successfully written.";
        controller->disconnectFromDevice();
        delete service;
        service = nullptr;
    }
}


void BLEDevice::writeData() {
    // Definiowanie UUID charakterystyki
    const QLowEnergyCharacteristic HM10Char = service->characteristic(QBluetoothUuid("{0000ffe1-0000-1000-8000-00805f9b34fb}"));

    if (HM10Char.isValid()) {
        // Sprawdzenie, czy charakterystyka obsługuje notyfikacje
        if (HM10Char.properties() & QLowEnergyCharacteristic::Notify) {
            qDebug() << "XDX Characteristic supports notifications.";

            // Szukaj descriptoru notyfikacji
            const QLowEnergyDescriptor notificationDesc = HM10Char.descriptor(QBluetoothUuid("{00002902-0000-1000-8000-00805f9b34fb}"));
            if (notificationDesc.isValid()) {
                // Włącz notyfikacje
                service->writeDescriptor(notificationDesc, QByteArray::fromHex("0100"));
                qDebug() << "XDX Notifications enabled for characteristic";
            } else {
                qDebug() << "XDX Failed to find notification descriptor.";
            }
        } else {
            qDebug() << "XDX Characteristic does not support notifications.";
        }

        // Przesyłanie danych 0x0001 do urządzenia
        QByteArray data = QByteArray::fromHex("0001"); // Tworzenie danych 0x0001
        service->writeCharacteristic(HM10Char, data); // Wysłanie danych do charakterystyki
        qDebug() << "Dane (0x0001) zostały wysłane do urządzenia."; // Debugowanie, czy dane zostały wysłane
    } else {
        qDebug() << "XDX Characteristic is invalid."; // Jeśli charakterystyka jest nieważna
    }
}



void BLEDevice::updateData(const QLowEnergyCharacteristic &c, const QByteArray &v)
{
    QString receivedData = QString::fromUtf8(v);
    addLog(receivedData);
}



bool BLEDevice::connected() const
{
    return m_connected;
}

void BLEDevice::addLog(QString &text)
{
    if (logPart < 3) {
        logPart++;
        singleLog += text;
    } else {
        logPart = 0;
        m_logsListModel.append(singleLog);
        qDebug() << singleLog;
        singleLog.clear();
        qDebug() << m_logsListModel.count();
        emit logsListModelChanged(m_logsListModel); // Emitowanie sygnału po aktualizacji
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
