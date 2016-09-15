import QtQuick 2.0
import MrPlotter 0.1

Item {
    id: toplevel
    property alias timeDomain: mrp.timeDomain
    property alias scrollableDomain: mrp.scrollableDomain
    property alias timeZone: mrp.timeZone
    property alias timeTickPromotion: mrp.timeTickPromotion
    property alias leftAxisList: lyaa.axisList
    property alias rightAxisList: ryaa.axisList
    property alias streamList: pa.streamList
    property alias scrollZoomable: pa.scrollZoomable
    property alias leftDataDensityAxisList: ddyaa.axisList
    property alias dataDensityStreamList: ddpa.streamList
    property alias dataDensityScrollZoomable: ddpa.scrollZoomable
    property var autozoom: function ()
    {
        return mrp.autozoom(pa.streamList);
    }

    property var hardcodeLocalData: function (uuid, data)
    {
        return mrp.hardcodeLocalData(uuid, data);
    }

    property var dropHardcodedLocalData: function (uuid)
    {
        return mrp.dropHardcodedLocalData(uuid);
    }

    Rectangle {
        id: topspacing
        color: "transparent"
        y: 0
        height: 10
    }

    PlotArea {
        id: ddpa
        anchors.top: topspacing.bottom
        anchors.left: pa.left
        anchors.right: pa.right
        anchors.bottom: spacing.top
        yAxisAreaList: [ddyaa]
    }

    Flickable {
        id: fddyaa
        y: parent.y
        width: Math.min(parent.width / 5, ddyaa.width)
        height: spacing.y + spacing.height
        contentWidth: ddyaa.width
        clip: true

        YAxisArea {
            id: ddyaa
            height: fddyaa.height
            rangeStart: ddpa.y + ddpa.height
            rangeEnd: ddpa.y
            rightSide: false
        }
    }

    Rectangle {
        id: spacing
        color: "transparent"
        x: 0
        y: 70
        width: parent.width
        height: 10
    }

    PlotArea {
        id: pa
        anchors.top: spacing.bottom
        anchors.left: flyaa.right
        anchors.right: fryaa.left
        anchors.bottom: taa.top
        yAxisAreaList: [lyaa, ryaa]
    }

    Flickable {
        id: flyaa
        y: spacing.y
        width: Math.min(parent.width / 5, lyaa.width)
        height: parent.height - spacing.y
        contentWidth: lyaa.width
        clip: true

        YAxisArea {
            id: lyaa
            height: flyaa.height
            rangeStart: spacing.height + pa.height
            rangeEnd: spacing.height
            rightSide: false
        }
    }

    Flickable {
        id: fryaa
        x: parent.width - fryaa.width
        y: spacing.y
        width: Math.min(parent.width / 5, ryaa.width)
        height: parent.height - spacing.y
        contentWidth: ryaa.width
        clip: true

        YAxisArea {
            id: ryaa
            height: fryaa.height
            rangeStart: spacing.height + pa.height
            rangeEnd: spacing.height
            rightSide: true
        }
    }

    TimeAxisArea {
        id: taa
        x: 0
        y: parent.height - taa.height
        width: parent.width
        height: 60
        rangeStart: pa.x
        rangeEnd: pa.x + pa.width
    }

    MrPlotter {
        id: mrp
        plotList: [pa, ddpa]
        timeaxisarea: taa
    }
}
