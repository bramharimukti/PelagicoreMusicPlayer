/****************************************************************************
**
** SongList.qml
**
** This QML file describes the List Model that contains all the song informa-
** tion
**
** Copyright (C) 2015 Bramastyo Harimukti Santoso
** Contact: bramastyo.harimukti.santoso@gmail.com
**
**
****************************************************************************/


import QtQuick 2.0

ListModel {
    id:songLists
    /************************************************************************
    ** Adele - Daydreamer
    *************************************************************************/
    ListElement {
        trackID: 1
        musicSource: "01 Daydreamer.mp3"
        albumSource: "adele_19.png"
    }
    /************************************************************************
    ** Alicia Keys - Go Ahead
    *************************************************************************/
    ListElement {
        trackID: 2
        musicSource: "02 Go Ahead.mp3"
        albumSource: "alicia_keys_as_i_am.png"
    }
    /************************************************************************
    ** Alesha Dixon - Let's Get Excited
    *************************************************************************/
    ListElement {
        trackID: 3
        musicSource: "02 Let's Get Excited.mp3"
        albumSource: "alesha_dixon_the_alesha_show.png"
    }
    /************************************************************************
    ** Adele - Chasing Pavements
    *************************************************************************/
    ListElement {
        trackID: 4
        musicSource: "03 Chasing Pavements.mp3"
        albumSource: "adele_19.png"
    }
    /************************************************************************
    ** Alicia Keys - Superwoman
    *************************************************************************/
    ListElement {
        trackID: 5
        musicSource: "03 Superwoman.mp3"
        albumSource: "alicia_keys_as_i_am.png"
    }
    /************************************************************************
    ** Alesha Dixon - Cinderella Shoe
    *************************************************************************/
    ListElement {
        trackID: 6
        musicSource: "04 Cinderella Shoe.mp3"
        albumSource: "alesha_dixon_the_alesha_show.png"
    }
}
