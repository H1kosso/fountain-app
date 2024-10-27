#include "SingleImage.h"

SingleImage::SingleImage(QObject *parent)
    : QObject{parent}
{}

bool SingleImage::hasColors() const
{
    return m_hasColors;
}

void SingleImage::setHasColors(bool newHasColors)
{
    if (m_hasColors == newHasColors)
        return;
    m_hasColors = newHasColors;
    emit hasColorsChanged();
}

QVariantList SingleImage::image() const
{
    return m_image;
}

void SingleImage::setImage(const QVariantList &newimage)
{
    if (m_image != newimage) {
        m_image = newimage;
        emit imageChanged();
    }
}
