#ifndef SINGLEIMAGE_H
#define SINGLEIMAGE_H

#include <QObject>
#include <qqml.h>
#include <QColor>
#include <QVariantList>
#include <QDebug>

class SingleImage : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QColor mainColor READ mainColor WRITE setMainColor NOTIFY mainColorChanged)
    Q_PROPERTY(QColor secondaryColor READ secondaryColor WRITE setSecondaryColor NOTIFY secondaryColorChanged)
    Q_PROPERTY(QVariantList image READ image WRITE setImage NOTIFY imageChanged)
    Q_PROPERTY(unsigned int size READ size WRITE setSize NOTIFY sizeChanged)

public:
    explicit SingleImage(QObject *parent = nullptr);

    Q_INVOKABLE int rowLength() const { return 64; }

    void setHasColors(bool newHasColors);

    QVariantList image() const;
    void setImage(const QVariantList &newImage);

    QColor mainColor() const;
    void setMainColor(const QColor &newMainColor);

    QColor secondaryColor() const;
    void setSecondaryColor(const QColor &newSecondaryColor);

    unsigned int size() const;
    void setSize(unsigned int newSize);

    Q_INVOKABLE QVariant colorAt(unsigned int row, unsigned int column) const;
    Q_INVOKABLE void setColorAt(unsigned int row, unsigned int column, unsigned int value);

    Q_INVOKABLE void fillImage(unsigned int rows);
    Q_INVOKABLE void addRow();

signals:
    void imageChanged();
    void sizeChanged();
    void mainColorChanged();
    void secondaryColorChanged();

private:
    QColor m_mainColor;
    QColor m_secondaryColor;
    QVariantList m_image; //1 Dismensional array, used as 2 dismensional
    unsigned int m_size;
};

#endif // SINGLEIMAGE_H
