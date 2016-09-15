import QtQuick 2.0
import MrPlotter 0.1

Item {
    id: toplevel
    property alias timeDomain: mrp.timeDomain
    property alias scrollableDomain: mrp.scrollableDomain
    property alias timeZone: mrp.timeZone
    property alias timeTickPromotion: mrp.timeTickPromotion
    property alias axisList: yaa.axisList
    property alias streamList: pa.streamList
    property alias scrollZoomable: pa.scrollZoomable

    property var autozoom: function ()
    {
        mrp.autozoom(pa.streamList);
    }

    PlotArea {
        id: pa
        anchors.top: parent.top
        anchors.left: fyaa.right
        anchors.right: parent.right
        anchors.bottom: taa.top
        yAxisArea: yaa
    }

    Flickable {
        id: fyaa
        y: parent.y
        width: Math.min(parent.width / 5, yaa.width)
        height: parent.height
        contentWidth: yaa.width
        clip: true

        YAxisArea {
            id: yaa
            height: fyaa.height
            rangeStart: pa.y + pa.height
            rangeEnd: pa.y
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
        plotList: [pa]
        timeaxisarea: taa
    }
}
