/****************************************************************************
**
** Tool.qml
**
** This QML file describes the tool template to be used in the Music Player
**
** Copyright (C) 2015 Bramastyo Harimukti Santoso
** Contact: bramastyo.harimukti.santoso@gmail.com
**
**
****************************************************************************/


import QtQuick 2.0

Item{
    id:rootTool
    width: 40
    height: width
    property string toolSource
    signal clicked()

    Image {
        id: toolImage
        anchors.centerIn: parent
        width: parent.width;
        fillMode: Image.PreserveAspectFit
        source: toolSource
        MouseArea{
            anchors.fill: parent
            onClicked: rootTool.clicked()
        }
    }
}
