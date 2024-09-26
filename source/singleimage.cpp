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
