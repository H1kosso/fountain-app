#ifndef SINGLEIMAGE_H
#define SINGLEIMAGE_H

#include <QObject>
#include <qqml.h>


class SingleImage : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(bool hasColors READ hasColors WRITE setHasColors NOTIFY hasColorsChanged)  
public:
    explicit SingleImage(QObject *parent = nullptr);

    bool hasColors() const;
    void setHasColors(bool newHasColors);

signals:
    void hasColorsChanged();
private:
    bool m_hasColors;
};

#endif // SINGLEIMAGE_H
