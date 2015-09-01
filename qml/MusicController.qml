/****************************************************************************
**
** MusicController.qml
**
** This QML file describes all elements of the Music Player. These elements
** are the following:
**
** - Information of current track including song artist, song title, and album
** - Track slider that can seek the current playing track
** - Common functions of a music player such as play, pause, rewind, forward,
**   mute, and shuffle the music
**
** Copyright (C) 2015 Bramastyo Harimukti Santoso
** Contact: bramastyo.harimukti.santoso@gmail.com
**
**
****************************************************************************/

import QtQuick 2.0
import QtMultimedia 5.0
import QtGraphicalEffects 1.0

Item{
    id:musicPlayer

    /************************************************************************
    ** Internal properties
    *************************************************************************/
    property bool playing: false
    property bool shuffleMode: false
    property bool muteMode: false


    property string trackAuthor
    property string trackTitle
    property int trackStatus : currentTrack.status
    property int trackDurationMin : (currentTrack.duration / (1000*60)) % 60
    property int trackDurationSec : (currentTrack.duration / 1000) % 60
    property int timeElapsedMin : (currentTrack.position / (1000*60)) % 60;
    property int timeElapsedSec : (currentTrack.position / 1000) % 60 ;
    property int listIndex : 0



    /************************************************************************
    ** Components required for the music player.
    *************************************************************************/
    FontLoader{
           id: openSansFont
           source: "../fonts/OpenSans-Regular.ttf"
    }
    Audio{
        id: currentTrack
        source: "../music/" + songlists.get(listIndex).musicSource
        muted: musicPlayer.muteMode
    }
    SongList {
        id:songlists
    }
    Timer {
        interval: 300; running: true; repeat: true
        onTriggered: {
            if(trackStatus == Audio.EndOfMedia)
               gotoNextSong();
        }
    }

    /************************************************************************
    ** Provides the current track information.
    *************************************************************************/
    Binding{ target: musicPlayer; property: "trackAuthor"; value: currentTrack.metaData.albumArtist }
    Binding{ target: musicPlayer; property: "trackTitle"; value: currentTrack.metaData.title }



    Item{
        id:albumIcon
        width: 120
        height: width
        anchors {
            verticalCenter: parent.verticalCenter;
            horizontalCenter: parent.horizontalCenter;
            horizontalCenterOffset: -305;
        }
        property string albumSource: "../music/" + songlists.get(listIndex).albumSource

        onAlbumSourceChanged: {
            iconAnimation.start();
        }

        Image{
            id: coverFrame
            anchors.centerIn: parent
            source: "../gfx/cover_frame.png"
            sourceSize: Qt.size(parent.width, parent.height)
            fillMode: Image.PreserveAspectFit
        }
        Image{
            id: albumImage
            anchors.centerIn: parent
            source: albumIcon.albumSource
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
            source: "../gfx/cover_overlay.png"
            sourceSize: Qt.size(parent.width, parent.height)
            fillMode: Image.PreserveAspectFit
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
    Item{
        id: trackInfo
        anchors {
            verticalCenter: parent.verticalCenter;
            horizontalCenter: parent.horizontalCenter;
            horizontalCenterOffset: -30;
            verticalCenterOffset: 10;
        }
        Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -45
                color: "white"
                text: musicPlayer.trackTitle
                font { family: openSansFont.name; pointSize: 16; }
        }
        Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -10
                color: "lightsteelblue"
                text: musicPlayer.trackAuthor
                font { family: openSansFont.name; pointSize: 12; bold: true }
        }
    }
    Item{
        id: trackTotalDuration
        anchors {
            verticalCenter: parent.verticalCenter;
            horizontalCenter: parent.horizontalCenter;
            horizontalCenterOffset: 335;
            verticalCenterOffset: 50;
        }

        property string totalMin:{
            if(musicPlayer.trackDurationMin < 10)
                "0" + musicPlayer.trackDurationMin;
            else
                musicPlayer.trackDurationMin;
        }
        property string totalSec:{
            if(musicPlayer.trackDurationSec < 10)
                "0" + musicPlayer.trackDurationSec;
            else
                musicPlayer.trackDurationSec;
        }

        Text {
                id:totalDurationInfo
                anchors.centerIn: parent
                color: "lightgrey"
                text: parent.totalMin + ":"+ parent.totalSec
                font { family: openSansFont.name; pointSize: 12; }
        }
    }
    Item{
        id: trackTimeElapsed
        anchors {
            verticalCenter: parent.verticalCenter;
            horizontalCenter: parent.horizontalCenter;
            horizontalCenterOffset: -205;
            verticalCenterOffset: 50;
        }

        property string currentMin:{
            if(musicPlayer.timeElapsedMin < 10)
                "0" + musicPlayer.timeElapsedMin;
            else
                musicPlayer.timeElapsedMin;
        }
        property string currentSec:{
            if(musicPlayer.timeElapsedSec < 10)
                "0" + musicPlayer.timeElapsedSec;
            else
                musicPlayer.timeElapsedSec;
        }

        Text {
                id:currentTimeElapsed
                anchors.centerIn: parent
                color: "lightgrey"
                text: parent.currentMin + ":"+ parent.currentSec
                font { family: openSansFont.name; pointSize: 12; }
        }
    }


    /************************************************************************
    ** Provides the music player controller.
    *************************************************************************/
    Item{
        id:musicController
        anchors {
            verticalCenter: parent.verticalCenter;
            horizontalCenter: parent.horizontalCenter;
            horizontalCenterOffset: -15;
            verticalCenterOffset: -15;
        }
        Image {
            id: backward
            anchors {
                verticalCenter: parent.verticalCenter;
                horizontalCenter: parent.horizontalCenter;
                horizontalCenterOffset: -200;
            }
            width: 40;
            fillMode: Image.PreserveAspectFit
            source: "../icons/rewind.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(!musicPlayer.playing){
                        if(musicPlayer.listIndex>0)
                            musicPlayer.listIndex = musicPlayer.listIndex - 1;
                    }
                    else
                        gotoPrevSong();
                }
            }
        }

        Image {
            id: playpause
            anchors {
                verticalCenter: parent.verticalCenter;
                horizontalCenter: parent.horizontalCenter;
                horizontalCenterOffset: -140;
            }
            width: 40;
            fillMode: Image.PreserveAspectFit
            source: musicPlayer.playing ? "../icons/pause.png" : "../icons/play.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(musicPlayer.playing) {
                        currentTrack.pause();
                        musicPlayer.playing = false;
                    } else {
                        currentTrack.play();
                        musicPlayer.playing = true;
                    }
                }
            }
        }

        Image {
            id: forward
            anchors {
                verticalCenter: parent.verticalCenter;
                horizontalCenter: parent.horizontalCenter;
                horizontalCenterOffset: -80;
            }
            width: 40;
            fillMode: Image.PreserveAspectFit
            source: "../icons/forward.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(musicPlayer.playing) {
                        gotoNextSong();
                    }
                    else{
                        if(musicPlayer.listIndex + 1 < songlists.count)
                            musicPlayer.listIndex = musicPlayer.listIndex + 1;
                    }

                }
            }

        }

        Image {
            id: shuffle
            anchors {
                verticalCenter: parent.verticalCenter;
                horizontalCenter: parent.horizontalCenter;
                horizontalCenterOffset: 350;
                verticalCenterOffset: 30;
            }
            width: 30;
            fillMode: Image.PreserveAspectFit
            source: musicPlayer.shuffleMode ? "../icons/shuffle_pressed.png" : "../icons/shuffle.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(musicPlayer.shuffleMode)
                        musicPlayer.shuffleMode = false;
                    else
                        musicPlayer.shuffleMode = true;
                }
            }
        }

        Image {
            id: volume
            anchors {
                verticalCenter: parent.verticalCenter;
                horizontalCenter: parent.horizontalCenter;
                horizontalCenterOffset: 350;
                verticalCenterOffset: -20;
            }
            width: 30;
            fillMode: Image.PreserveAspectFit
            source: musicPlayer.muteMode ? "../icons/mute.png" : "../icons/volume.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(musicPlayer.muteMode)
                        musicPlayer.muteMode = false;
                    else
                        musicPlayer.muteMode = true;
                }
            }
        }

    }
    MusicSlider{
        id:trackslider
        anchors {
            verticalCenter: parent.verticalCenter;
            horizontalCenter: parent.horizontalCenter;
            horizontalCenterOffset: 65;
            verticalCenterOffset: 50;
        }
        maximumValue: currentTrack.duration
        minimumValue: 0
        currentValue: currentTrack.position

        onSeekvalueChanged: {
            currentTrack.seek(seekvalue*maximumValue);
        }
    }

    /************************************************************************
    ** Functions required for the music control.
    *************************************************************************/
    function gotoNextSong(){
        if(shuffleMode)
            shuffleSongList();
        else{
            if(musicPlayer.listIndex + 1 < songlists.count){
                musicPlayer.listIndex += 1;
                currentTrack.play();
                musicPlayer.playing = true;
            }
        }
    }
    function gotoPrevSong(){
        if(shuffleMode)
            shuffleSongList();
        else{
            if(musicPlayer.timeElapsedSec > 3){
                currentTrack.stop();
                currentTrack.play();
            }
            else{
                if(musicPlayer.listIndex>0){
                    musicPlayer.listIndex = musicPlayer.listIndex - 1
                    currentTrack.play();
                    musicPlayer.playing = true;
                }
                else{
                    currentTrack.stop();
                    currentTrack.play();
                }
            }
        }
    }
    function shuffleSongList(){
        var indexSonglist = Math.floor((Math.random() * (songlists.count-1)) + 0);
        if(indexSonglist == musicPlayer.listIndex)
            indexSonglist = Math.floor((Math.random() * (songlists.count-1)) + 0);
        currentTrack.stop();
        musicPlayer.listIndex = indexSonglist;
        currentTrack.play();
        musicPlayer.playing = true;
    }
}
