/****************************************************************************
**
** AlbumIcon.qml
**
** This QML file will create the album icon based on the current track
**
** Copyright (C) 2015 Bramastyo Harimukti Santoso
** Contact: bramastyo.harimukti.santoso@gmail.com
**
**
****************************************************************************/

import QtQuick 2.0
import QtGraphicalEffects 1.0

Item{
    id:rootAlbumIcon
    width: 120
    height: width

    property alias albumSource : albumImage.source
    property alias coverFrameSource : coverFrame.source
    property alias coverOverlaySource : coverOverlay.source

    onAlbumSourceChanged: {
        iconAnimation.start();
    }

    Image{
        id: coverFrame
        anchors.centerIn: parent
        sourceSize: Qt.size(parent.width, parent.height)
    }
    Image{
        id: albumImage
        anchors.centerIn: parent
        sourceSize: Qt.size(parent.width-10, parent.height-10)
        fillMode: Image.PreserveAspectFit
        smooth: true
        visible: false
    }
    Rectangle{
        id: albumImagemask
        anchors.centerIn: parent
        width:parent.width-10
        height: parent.height-10
        radius: 10
        visible: false

    }
    OpacityMask{
        id:albumOpacityMask
        anchors.fill: albumImage
        source: albumImage
        maskSource: albumImagemask
    }
    Image{
        id: coverOverlay
        anchors.centerIn: parent
        sourceSize: Qt.size(parent.width, parent.height)
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            iconClickedAnimation.start();
        }
    }
    ParallelAnimation{
        id:iconAnimation
        NumberAnimation {
            target: albumImage
            property: "width"
            from:80
            to:120
            duration: 1000
            easing.type: Easing.InCurve
        }
        PropertyAnimation{
            target: albumOpacityMask
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: 2000
        }
    }
    SequentialAnimation{
        id:iconClickedAnimation
        NumberAnimation {
            target: albumImage
            property: "width"
            from:80
            to:120
            duration: 1000
            easing.type: Easing.InCurve
        }
    }
}
