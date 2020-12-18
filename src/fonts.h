#ifndef FONTS_H
#define FONTS_H

#include <QObject>

class Fonts : public QObject
{
    Q_OBJECT

public:
    explicit Fonts(QObject *parent = nullptr);

    QString genernalFont() const;
    QString fixedFont() const;
};

#endif // FONTS_H
