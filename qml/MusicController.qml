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
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
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

    property int trackStatus: currentTrack.status
    property int trackDurationMin : 0
    property int trackDurationSec : 0
    property int timeElapsedMin : 0
    property int timeElapsedSec : 0

    property string trackAuthor
    property string trackTitle


    /************************************************************************
    ** Components required for the music player.
    *************************************************************************/
    FontLoader{
           id: openSansFont
           source: "../fonts/OpenSans-Regular.ttf"
    }
    Audio{
        id: currentTrack
        source: "../music/" + songListDelegated.currentItem.songData.musicSource
        muted: musicPlayer.muteMode
        property string currentStatus : currentTrack.status
    }  
    Item{
        id: songListComponentItem
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: 130
        anchors.verticalCenterOffset: 100

        Component{
            id: songListComponent
            Item{
                property variant songData: model
                width: 250; height: 40
                Column {
                    Text { text: '<b>Track Number:</b> ' + model.trackID }
                    Text { text: '<b>Music Source:</b> ' + model.musicSource }
                }
                visible: false
            }
        }
        ListView{
            id: songListDelegated
            anchors.fill: parent
            model: SongList {}
            delegate: songListComponent
            focus: true
        }
    }
    Timer{
        id: getTrackInfo
        interval: 100;
        running: true
        repeat: true
        onTriggered: {
            if(trackStatus == 7)
                gotoNextSong();
            getTrackInformation();
            getTrackTotalDuration();
        }
    }


    /************************************************************************
    ** Provides the current track information.
    *************************************************************************/
    Item{
        id:albumIcon
        width: 120
        height: width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: -305
        property string albumSource: "../music/" + songListDelegated.currentItem.songData.albumSource

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
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: -30
        anchors.verticalCenterOffset: 10
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
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: 330
        anchors.verticalCenterOffset: 50

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
                anchors.centerIn: parent
                color: "lightgrey"
                text: parent.totalMin + ":"+ parent.totalSec
                font { family: openSansFont.name; pointSize: 12; }
        }
    }
    Item{
        id: trackTimeElapsed
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: -205
        anchors.verticalCenterOffset: 50

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
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: -15
        anchors.verticalCenterOffset: -15
        Image {
            id: backward
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenterOffset: -200
            width: 40;
            fillMode: Image.PreserveAspectFit
            source: "../icons/rewind.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(!musicPlayer.playing){
                        if(songListDelegated.currentIndex>0)
                            songListDelegated.currentIndex = songListDelegated.currentIndex - 1
                    }
                    else{
                        gotoPrevSong()
                    }
                }
            }
        }

        Image {
            id: playpause
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenterOffset: -140
            width: 40;
            fillMode: Image.PreserveAspectFit
            source: musicPlayer.playing ? "../icons/pause.png" : "../icons/play.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(musicPlayer.playing) {
                        currentTrack.pause()
                        musicPlayer.playing = false
                    } else {
                        currentTrack.play()
                        musicPlayer.playing = true
                    }
                }
            }
        }

        Image {
            id: forward
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenterOffset: -80
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
                        if(songListDelegated.currentIndex + 1 < songListDelegated.count)
                            songListDelegated.currentIndex = songListDelegated.currentIndex + 1
                    }

                }
            }

        }

        Image {
            id: shuffle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenterOffset: 350
            anchors.verticalCenterOffset: 30
            width: 30;
            fillMode: Image.PreserveAspectFit
            source: musicPlayer.shuffleMode ? "../icons/shuffle_pressed.png" : "../icons/shuffle.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(musicPlayer.shuffleMode)
                        musicPlayer.shuffleMode = false
                    else
                        musicPlayer.shuffleMode = true
                }
            }
        }

        Image {
            id: volume
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenterOffset: 350
            anchors.verticalCenterOffset: -20
            width: 30;
            fillMode: Image.PreserveAspectFit
            source: musicPlayer.muteMode ? "../icons/mute.png" : "../icons/volume.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(musicPlayer.muteMode)
                        musicPlayer.muteMode = false
                    else
                        musicPlayer.muteMode = true
                }
            }
        }

    }
    Slider{
        id:musicSlider
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: 60
        anchors.verticalCenterOffset: 52
        width: 460
        maximumValue: currentTrack.duration
        value: currentTrack.position
        onPressedChanged: {
             if (!pressed)
                currentTrack.seek(value)
        }
        onValueChanged: {
            musicPlayer.getTrackTimeElapsed();
        }
        stepSize: 1.0
        style: SliderStyle {
            handle: Rectangle {
                        anchors.centerIn: parent
                        border.width: 2
                        implicitWidth: 25
                        implicitHeight: 25
                        radius: 20
                        Image
                        {
                          id: handleBackground
                          source: "../gfx/slider_knob.png"
                          width: parent.width
                          height: parent.height
                          fillMode: Image.Stretch
                        }
                    }
        }
    }


    /************************************************************************
    ** Functions required for the control.
    *************************************************************************/
    function gotoNextSong(){
        if(shuffleMode)
            shuffleSongList();
        else{
            if(songListDelegated.currentIndex + 1 < songListDelegated.count){
                songListDelegated.currentIndex = songListDelegated.currentIndex + 1;
                currentTrack.play();
                musicPlayer.playing = true;
            }
        }
    }
    function gotoPrevSong(){
        if(shuffleMode)
            shuffleSongList();
        else{
            if(musicPlayer.timeElapsedSec > 5){
                currentTrack.stop();
                currentTrack.play();
            }
            else{
                if(songListDelegated.currentIndex>0){
                    songListDelegated.currentIndex = songListDelegated.currentIndex - 1
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
    function getTrackInformation(){
        trackAuthor = currentTrack.metaData.author;
        trackTitle = currentTrack.metaData.title;

    }
    function getTrackTotalDuration(){
        trackDurationMin = (currentTrack.duration / (1000*60)) % 60;
        trackDurationSec   = (currentTrack.duration / 1000) % 60 ;
    }
    function getTrackTimeElapsed(){
        timeElapsedMin = (currentTrack.position / (1000*60)) % 60;
        timeElapsedSec   = (currentTrack.position / 1000) % 60 ;
    }
    function shuffleSongList(){
        var indexSonglist = Math.floor((Math.random() * (songListDelegated.count-1)) + 0);
        if(indexSonglist == songListDelegated.currentIndex)
            indexSonglist = Math.floor((Math.random() * (songListDelegated.count-1)) + 0);
        currentTrack.stop();
        songListDelegated.currentIndex = indexSonglist;
        currentTrack.play();
        musicPlayer.playing = true;
    }
}
