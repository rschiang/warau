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

    // Set up global preferences
#ifdef Q_OS_MACOS
    QQuickWindow::setTextRenderType(QQuickWindow::NativeTextRendering);
#endif

    // Initiate QML engine
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
