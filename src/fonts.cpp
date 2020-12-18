#include "fonts.h"

Fonts::Fonts(QObject *parent) : QObject(parent)
{
}

QString Fonts::fixedFont()
{
    QDBusInterface iface("org.cyber.Settings",
                         "/Theme",
                         "org.cyber.Theme",
                         QDBusConnection::sessionBus(), this);
    if (iface.isValid()) {
        qDebug() << "interface valid woohoo";
        return iface.property("systemFixedFont").toString();
    }
    qDebug() << "interface not valid what the fuck";
    return "Monospace";
}
