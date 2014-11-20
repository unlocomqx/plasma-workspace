/*
 *  Copyright 2013 Marco Martin <mart@kde.org>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  2.010-1301, USA.
 */

import QtQuick 2.0

//We need units from it
import org.kde.plasma.core 2.0 as Plasmacore
import org.kde.plasma.wallpapers.image 2.0 as Wallpaper
import org.kde.kquickcontrolsaddons 2.0
import QtQuick.Controls 1.0 as QtControls

Item {
    id: root
    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
        bottom: parent.bottom
    }
    property string cfg_Image

    Wallpaper.Image {
        id: imageWallpaper
        width: wallpaper.configuration.width
        height: wallpaper.configuration.height
    }

    //Rectangle { color: "orange"; x: formAlignment; width: formAlignment; height: 20 }

    QtControls.ScrollView {
        anchors.fill: parent

        frameVisible: true
        highlightOnFocus: true;

        Component.onCompleted: {
            //replace the current binding on the scrollbar that makes it visible when content doesn't fit

            //otherwise we adjust gridSize when we hide the vertical scrollbar and
            //due to layouting that can make everything adjust which changes the contentWidth/height which
            //changes our scrollbars and we continue being stuck in a loop

            //looks better to not have everything resize anyway.
            //BUG: 336301
            __verticalScrollBar.visible = true
        }

        GridView {
            id: wallpapersGrid
            model: imageWallpaper.wallpaperModel
            currentIndex: -1

            cellWidth: Math.floor(wallpapersGrid.width / Math.max(Math.floor(wallpapersGrid.width / (units.gridUnit*12)), 3))
            cellHeight: cellWidth / (imageWallpaper.width / imageWallpaper.height)

            anchors.margins: 4
            boundsBehavior: Flickable.StopAtBounds

            delegate: WallpaperDelegate {}
            Timer {
                id: makeCurrentTimer
                interval: 100
                repeat: false
                property string pendingIndex
                onTriggered: {
                    wallpapersGrid.currentIndex = pendingIndex
                }
            }

            Connections {
                target: imageWallpaper
                onCustomWallpaperPicked: wallpapersGrid.currentIndex = 0
            }
        }
    }
}
