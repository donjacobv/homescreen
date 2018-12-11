#include "toucharea.h"

TouchArea::TouchArea()
{
}

TouchArea::~TouchArea()
{

}

void TouchArea::setWindow(QQuickWindow *window)
{
    myWindow = window;
}

void TouchArea::init()
{
    bitmapNormal = QPixmap(":/images/menubar_normal_mask.png").createHeuristicMask();
    bitmapFullscreen = QPixmap(":/images/menubar_fullscreen_mask.png").createHeuristicMask();
    myWindow->setMask(QRegion(bitmapNormal));
}

void TouchArea::switchArea(int areaType)
{
    if(areaType == NORMAL) {
        myWindow->setMask(QRegion(bitmapNormal));
    } else if (areaType == FULLSCREEN) {
        myWindow->setMask(QRegion(bitmapFullscreen));
    }
}

