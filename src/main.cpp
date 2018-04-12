#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QTranslator>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Load translations
    QTranslator translator;
    if (translator.load(QLocale(), "", "", QStringLiteral(":/translations")))
        app.installTranslator(&translator);

    // Initiate QML engine
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
