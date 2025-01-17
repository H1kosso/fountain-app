#include "bledevice.h"

BLEDevice::BLEDevice(QObject *parent) : QObject(parent),
    currentDevice(QBluetoothDeviceInfo()),
    controller(0),
    service(0)
{
    DiscoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);
    DiscoveryAgent->setLowEnergyDiscoveryTimeout(5000);

    connect(DiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered, this, &BLEDevice::addDevice);
    connect(DiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::errorOccurred, this, &BLEDevice::deviceScanError);
    connect(DiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::finished, this, &BLEDevice::scanFinished);
    connect(DiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::canceled, this, &BLEDevice::scanFinished);
}

BLEDevice::~BLEDevice()
{
    delete DiscoveryAgent;
    delete controller;
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

void BLEDevice::addDevice(const QBluetoothDeviceInfo &device)
{
    if (device.coreConfigurations() & QBluetoothDeviceInfo::LowEnergyCoreConfiguration) {
        qDebug()<<"Discovered Device:"<<device.name()<<"Address: "<<device.address().toString()<<"RSSI:"<< device.rssi()<<"dBm";

        if(/*!m_foundDevices.contains(device.name(), Qt::CaseSensitive) && device.name().contains("HTS", Qt::CaseSensitive)*/true) {
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
        qDebug() << "The Bluetooth adaptor is powered off.";
    else if (error == QBluetoothDeviceDiscoveryAgent::InputOutputError)
        qDebug() << "Writing or reading from the device resulted in an error.";
    else
        qDebug() << "An unknown error has occurred.";
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
        break; // proceed to search
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
        controller->disconnectFromDevice();
    } else {
        deviceDisconnected();
    }
}

void BLEDevice::serviceDiscovered(const QBluetoothUuid &gatt)
{
    qDebug() << "GATT " << gatt;
    bFoundDevice = true;

    if(gatt==QBluetoothUuid(QBluetoothUuid::ServiceClassUuid::GenericAccess)) {
        bFoundDevice =true;
        qDebug() << "GENERIC ACCESS service found";
    }
}

void BLEDevice::serviceScanDone()
{
    delete service;
    service=0;

    if(bFoundDevice) {
        qDebug() << "Connecting to Generic Access service...";
        service = controller->createServiceObject(QBluetoothUuid(QBluetoothUuid::ServiceClassUuid::GenericAccess),this);
    }

    if(!service) {
        qDebug() <<"Generic Access service not found";
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
    qDebug() << "Remote device disconnected";
    emit connectionEnd();
}

void BLEDevice::deviceConnected()
{
    qDebug() << "Device connected";
    controller->discoverServices();
}

void BLEDevice::controllerError(QLowEnergyController::Error error)
{
    qDebug() << "Controller Error:" << error;
}

void BLEDevice::serviceStateChanged(QLowEnergyService::ServiceState s)
{
    qDebug() << "service : " << s;
    emit connectionStart();


}

void BLEDevice::confirmedDescriptorWrite(const QLowEnergyDescriptor &d, const QByteArray &value)
{
    if (d.isValid() && d == notificationDesc && value == QByteArray("0000")) {
        controller->disconnectFromDevice();
        delete service;
        service = nullptr;
    }
}

void BLEDevice::writeData(QByteArray v)
{
    const QLowEnergyCharacteristic  TempMeasChar = service->characteristic(QBluetoothUuid(QBluetoothUuid::CharacteristicType::TemperatureMeasurement));
    service->writeCharacteristic(TempMeasChar, v, QLowEnergyService::WriteWithoutResponse);
}

void BLEDevice::updateData(const QLowEnergyCharacteristic &c, const QByteArray &v)
{




}void BLEDevice::sendHexData(const QByteArray &data)
{

        qDebug() << "XXXB";
        // Konwertujemy ciąg hex na QByteArray
        QByteArray byteArray = QByteArray::fromHex(data);


            // Wybieramy odpowiednią charakterystykę, którą będziemy pisać
            const QLowEnergyCharacteristic charToWrite = service->characteristic(QBluetoothUuid(QBluetoothUuid::CharacteristicType::TemperatureMeasurement)); // Zmień UUID na odpowiednią charakterystykę
            // Wysyłamy dane do urządzenia
            service->writeCharacteristic(charToWrite, byteArray, QLowEnergyService::WriteWithoutResponse);
            qDebug() << "XXX Sent data:" << byteArray.toHex();

}


