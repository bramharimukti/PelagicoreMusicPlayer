#include <QGuiApplication>
#include <QtQml>
#include <QQuickWindow>
#include <QtQuickWidgets/QQuickWidget>


int main(int argc, char* argv[])
{
    std::string passedPath;
    for(int i = 1; i < argc; i++)
        passedPath += argv[i];

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    engine.load(QUrl("../projectFiles/qml/main.qml"));

    QObject *topLevel = engine.rootObjects().value(0);
    QQuickWindow *viewWin = qobject_cast<QQuickWindow *>(topLevel);

    viewWin->resize(1000, 200);
    viewWin->show();

    return app.exec();
}



