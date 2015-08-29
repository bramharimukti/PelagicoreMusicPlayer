/****************************************************************************
**
** Music Player Application
**
** The application offers common functionalities of a music player. The app-
** lication is created using QML elements. The application contains of 3 QML
** files:
**
**  - main.qml : Provides the application Window
**  - MusicController.qml : Provides all elements of the Music Player
**  - SongList.qml : Provides all the song information, such as music direc-
**                   tories and music albums
**
** Copyright (C) 2015 Bramastyo Harimukti Santoso
** Contact: bramastyo.harimukti.santoso@gmail.com
**
**
****************************************************************************/

import QtQuick 2.0
import QtQuick.Window 2.1

Window{
    flags: Qt.MSWindowsFixedSizeDialogHint | Qt.WindowCloseButtonHint
    visible: true
    width:1190
    height:596
    Rectangle {
        id:mainWindow
        width:1190
        height:596

        /*******************************************************************
        ** Application background
        ********************************************************************/
        Image
        {
          id: appBackground
          source: "../gfx/background.png"
          width: parent.width
          height: parent.height
          fillMode: Image.Stretch
        }

        /*******************************************************************
        ** Main Scene
        ********************************************************************/
        Rectangle {
            id: mainScene
            width: 800
            height: 186
            anchors.centerIn: parent
            color: "transparent"

            /***************************************************************
            ** Music Player background
            ****************************************************************/
            Image{
                id: musicPlayerBackground
                source: "../gfx/bar.png"
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
            }

            /***************************************************************
            ** Provides the music controller components.
            ****************************************************************/
            MusicController{
                id:musicController
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

        }
    }
}
