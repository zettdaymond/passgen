#include <QGuiApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "whirlpoolhash.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
	app.setWindowIcon( QIcon{":/assets/icon.png"});

    QQmlApplicationEngine engine;

    WhirlpoolHash hash;
    engine.rootContext()->setContextProperty("whirlpool_hash", &hash);
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
