#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QQmlContext>
#include "bledevice.h"
#include <QSslSocket>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    BLEDevice bledevice;


    app.setWindowIcon(QIcon(":/assets/icons/fountain.png"));
    engine.rootContext()->setContextProperty("bledevice", &bledevice);
    qDebug() << "My build Version String is - "
             << QSslSocket::sslLibraryBuildVersionString() << "  "
                                                              " and version string is  "
             << QSslSocket::sslLibraryVersionString();

    const QUrl url(u"qrc:/main.qml"_qs);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
