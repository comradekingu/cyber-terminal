#include "fonts.h"
#include <QFontDatabase>

Fonts::Fonts(QObject *parent) : QObject(parent)
{

}

QString Fonts::genernalFont() const
{
    return QFontDatabase::systemFont(QFontDatabase::GeneralFont).family();
}

QString Fonts::fixedFont() const
{
    return QFontDatabase::systemFont(QFontDatabase::FixedFont).family();
}
