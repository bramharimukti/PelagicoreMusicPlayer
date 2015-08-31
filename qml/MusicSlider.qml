/****************************************************************************
**
** MusicSlider.qml
**
** This QML file describes Music Slider that is able to seek the current track
**
** Copyright (C) 2015 Bramastyo Harimukti Santoso
** Contact: bramastyo.harimukti.santoso@gmail.com
**
**
****************************************************************************/


import QtQuick 2.1

Rectangle {
    id: rootSlider
    color: "transparent"
    width: 444; height: 20;
    radius: 5

    property color fillColor: "#14aaff"
    property int maximumValue
    property int minimumValue
    property int currentValue
    property int originalRange : maximumValue - minimumValue
    property int newRange : 1
    property real currentTrackPosition : ((currentValue - minimumValue) * newRange) / originalRange
    property real seekvalue: 0.0
    property real handleSize: 25
    property real handleTolerance: 3.0

    Rectangle {
        id: slider
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        height: 10
        color: "transparent"

        BorderImage {
           id: sliderbackgroundimage
           source: "../gfx/slider_background.png"
           anchors {
               fill: parent;
               margins: 1
           }
           border.right: 2
           border.left: 2
        }
        Rectangle {
            id: sliderprogressbar
            height: parent.height -2
            anchors {
                left: parent.left;
                right: handle.horizontalCenter
            }
            radius: 3
            border.width: 1
            color: rootSlider.fillColor
            border.color: Qt.darker(color, 1.0)
            opacity: 0.7
        }
        Rectangle {
            id: handle
            property real value: currentTrackPosition
            x: (value * parent.width) - width/2
            anchors.verticalCenter: parent.verticalCenter
            width: rootSlider.handleTolerance * rootSlider.handleSize
            height: width
            radius: width/2
            color: "transparent"

            Image {
                id: sliderhandleimage
                source: "../gfx/slider_knob.png"
                anchors.centerIn: parent
            }
            Rectangle{
                id: handleHighlight
                anchors {
                    verticalCenter: sliderhandleimage.verticalCenter;
                    horizontalCenter: sliderhandleimage.horizontalCenter;
                }
                width: sliderhandleimage.width*0.4
                height: width
                radius: width/2
                opacity: 0.0
                color: "#14aaff"
            }

            MouseArea {
                id: mouseArea
                anchors.fill:  parent
                drag {
                    target: handle
                    axis: Drag.XAxis
                    minimumX: -parent.width/2
                    maximumX: rootSlider.width - parent.width/2
                }
                onPositionChanged:  {
                    if (drag.active)
                        updatePosition();
                    handleHighlight.opacity = 0.5;
                }
                onReleased: {
                    updatePosition();
                    handleHighlight.opacity = 0.0;
                }
                function updatePosition() {
                    seekvalue = (handle.x + handle.width/2) / slider.width;
                }
            }
        }
    }
}
