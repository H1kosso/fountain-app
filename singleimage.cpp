#include "SingleImage.h"

SingleImage::SingleImage(QObject *parent)
    : QObject{parent},
    m_mainColor(Qt::red),
    m_secondaryColor(Qt::black),
    m_size(64)
{
    fillImage(m_size);
}

QVariantList SingleImage::image() const
{
    return m_image;
}

void SingleImage::setImage(const QVariantList &newImage)
{
    if (m_image != newImage) {
        m_image = newImage;
        emit imageChanged();
    }
}

QColor SingleImage::mainColor() const
{
    return m_mainColor;
}

void SingleImage::setMainColor(const QColor &newMainColor)
{
    if (m_mainColor == newMainColor)
        return;
    m_mainColor = newMainColor;
    emit mainColorChanged();
}

QColor SingleImage::secondaryColor() const
{
    return m_secondaryColor;
}

void SingleImage::setSecondaryColor(const QColor &newSecondaryColor)
{
    if (m_secondaryColor == newSecondaryColor)
        return;
    m_secondaryColor = newSecondaryColor;
    emit secondaryColorChanged();
}

unsigned int SingleImage::size() const
{
    return m_size;
}

void SingleImage::setSize(unsigned int newSize)
{
    if (m_size == newSize)
        return;
    m_size = newSize;
    emit sizeChanged();
}

void SingleImage::fillImage(unsigned int rows)
{
    setSize(rows);

    QVariantList newImage;
    for (unsigned int i = 0; i < rows; ++i) {
        QVariantList row;
        for (unsigned int j = 0; j < 64; ++j) {
            row.append(0);
        }
        newImage.append(row);
    }

    setImage(newImage);
}

QVariant SingleImage::colorAt(unsigned int row, unsigned int column) const
{
    unsigned int totalColumns = 64;

    unsigned int index = row * totalColumns + column;

    if (index < m_image.size()) {
        return m_image[index];
    }

    return QVariant();
}


void SingleImage::setColorAt(unsigned int row, unsigned int column, unsigned int value)
{
    unsigned int index = row * rowLength() + column;

    if (index < m_image.size()) {
        m_image[index] = value;
        emit imageChanged();
    }

    //qDebug() << "Color at [" << row << "," << column << "] set to" << value;
}

void SingleImage::addRow()
{
    QVariantList newRow;
    for (int i = 0; i < 64; ++i) {
        newRow.append(0);
    }

    m_image.append(newRow);
    setSize(m_size+1);
    emit imageChanged();
}
