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
    Binding{ target: musicPlayer; property: "trackAuthor"; value: currentTrack.metaData.contributingArtist }
    Binding{ target: musicPlayer; property: "trackTitle"; value: currentTrack.metaData.title }

    AlbumIcon{
        id:albumIcon
        width: 120
        height: width
        anchors {
            verticalCenter: parent.verticalCenter;
            horizontalCenter: parent.horizontalCenter;
            horizontalCenterOffset: -305;
        }
        albumSource: "../music/" + songlists.get(listIndex).albumSource
        coverFrameSource : "../gfx/cover_frame.png"
        coverOverlaySource : "../gfx/cover_overlay.png"
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
    ** Provides the tools for music player controller.
    *************************************************************************/
    Item{
        id:musicController
        anchors {
            verticalCenter: parent.verticalCenter;
            horizontalCenter: parent.horizontalCenter;
            horizontalCenterOffset: -15;
            verticalCenterOffset: -15;
        }
        Tool{
            id: toolBackward
            anchors {
                verticalCenter: parent.verticalCenter;
                horizontalCenter: parent.horizontalCenter;
                horizontalCenterOffset: -200;
            }
            width: 40
            height: width
            toolSource: "../icons/rewind.png"
            onClicked: {
                if(!musicPlayer.playing){
                    if(musicPlayer.listIndex>0)
                        musicPlayer.listIndex = musicPlayer.listIndex - 1;
                }
                else
                    gotoPrevSong();
            }
        }
        Tool{
            id: toolPlayPause
            anchors {
                verticalCenter: parent.verticalCenter;
                horizontalCenter: parent.horizontalCenter;
                horizontalCenterOffset: -140;
            }
            width: 40
            height: width
            toolSource: musicPlayer.playing ? "../icons/pause.png" : "../icons/play.png"
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
        Tool{
            id: toolForward
            anchors {
                verticalCenter: parent.verticalCenter;
                horizontalCenter: parent.horizontalCenter;
                horizontalCenterOffset: -80;
            }
            width: 40
            height: width
            toolSource: "../icons/forward.png"
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
        Tool{
            id: toolShuffle
            anchors {
                verticalCenter: parent.verticalCenter;
                horizontalCenter: parent.horizontalCenter;
                horizontalCenterOffset: 350;
                verticalCenterOffset: 30;
            }
            width: 30
            height: width
            toolSource: musicPlayer.shuffleMode ? "../icons/shuffle_pressed.png" : "../icons/shuffle.png"
            onClicked: {
                if(musicPlayer.shuffleMode)
                    musicPlayer.shuffleMode = false;
                else
                    musicPlayer.shuffleMode = true;
            }
        }
        Tool{
            id: toolVolume
            anchors {
                verticalCenter: parent.verticalCenter;
                horizontalCenter: parent.horizontalCenter;
                horizontalCenterOffset: 350;
                verticalCenterOffset: -20;
            }
            width: 30
            height: width
            toolSource: musicPlayer.muteMode ? "../icons/mute.png" : "../icons/volume.png"
            onClicked: {
                if(musicPlayer.muteMode)
                    musicPlayer.muteMode = false;
                else
                    musicPlayer.muteMode = true;
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
