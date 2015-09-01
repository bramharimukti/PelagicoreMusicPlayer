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
    property string toolSource
    property int toolWidth : 0
    signal clicked()

    Image {
        id: toolImage

        anchors.centerIn: parent
        width: toolWidth;
        fillMode: Image.PreserveAspectFit
        source: toolSource
        MouseArea{
            anchors.fill: parent
            onClicked: rootTool.clicked()
        }
    }
}
