#ifndef SINGLEIMAGE_H
#define SINGLEIMAGE_H

#include <QObject>
#include <qqml.h>


class SingleImage : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(bool hasColors READ hasColors WRITE setHasColors NOTIFY hasColorsChanged)
    Q_PROPERTY(QVariantList image READ image WRITE setImage NOTIFY imageChanged)

public:
    explicit SingleImage(QObject *parent = nullptr);

    bool hasColors() const;
    void setHasColors(bool newHasColors);

    QVariantList image() const;
    void setImage(const QVariantList &newImage);

signals:
    void hasColorsChanged();
    void imageChanged();
private:
    bool m_hasColors;
    QVariantList m_image;
};

#endif // SINGLEIMAGE_H
