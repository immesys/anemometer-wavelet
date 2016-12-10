import QtQuick 2.4
import Material 0.3
import Material.ListItems 0.1
import Material.Extras 0.1
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0 as Qtc
import MrPlotter 0.1
import "mr-plotter-layouts" as MrPlotterLayouts
//import BOSSWAVE 1.0

Item {
    id : main
    property var dsource
    onDsourceChanged : {
      console.log("dsource is now: ", dsource)
    }
    property real axmin : -0.5
    property real axmax : 0.5

    //The six edges are 0->1 1->2 2->0 0->3 1->3 2->3
    //The reverse are   1->0 2->1 0->2 3->0 3->1 3->2
    property list<Stream> streams : [
      Stream {
          id: vx
          dataDensity: false
          selected: false
          alwaysConnect: false

          color: "blue"
          timeOffset: [0, 0]
          archiver: "local"
          uuid: "20000000-0000-0000-0000-000000000001"
      },
      Stream {
          id: vy
          dataDensity: false
          selected: false
          alwaysConnect: false

          color: "red"
          timeOffset: [0, 0]
          archiver: "local"
          uuid: "20000000-0000-0000-0000-000000000002"
      },
      Stream {
          id: vz
          dataDensity: false
          selected: false
          alwaysConnect: false

          color: "green"
          timeOffset: [0, 0]
          archiver: "local"
          uuid: "20000000-0000-0000-0000-000000000003"
      }
    ]
    MrPlotter {
        id: gmrp
    }
    Connections {
      target: main.dsource
      onVelChanged: {
          mrpRep.itemAt(0).upd("20000000-0000-0000-0000-000000000001", main.dsource.hvelX);
          mrpRep.itemAt(1).upd("20000000-0000-0000-0000-000000000002", main.dsource.hvelY);
          mrpRep.itemAt(2).upd("20000000-0000-0000-0000-000000000003", main.dsource.hvelZ);
          for (var i = 0; i < mrpRep.count; i++) {
            mrpRep.itemAt(i).azoom();
          }
      }
    }
    Component.onCompleted : {
      console.log("dsource: ",main.dsource)
    }

    /* Shared Y Axis for all plots. */
    YAxis {
        id: yaxis
        dynamicAutoscale: true
        name: "Reading"
        domain: [axmin, axmax]
        streamList: [vx, vy, vz]
    }

    RowLayout {
      //columns: 3
      id: gl
      anchors.top:parent.top
      anchors.left:parent.left
      anchors.right:parent.right
      anchors.bottom:parent.bottom
      anchors.leftMargin: 10
      anchors.rightMargin: 10
      anchors.topMargin: 10
      anchors.bottomMargin: 10
      spacing:10
      Repeater {
        id:mrpRep
        //The six edges are 0->1 1->2 2->0 0->3 1->3 2->3
        //The reverse are   1->0 2->1 0->2 3->0 3->1 3->2
        model: [
          {"sta":vx},
          {"sta":vy},
          {"sta":vz},
        ]
        delegate: View {
              function azoom() {
                mrp.autozoom(pa.streamList);
              }
              function upd(uuid, data) {
                mrp.hardcodeLocalData(uuid, data);
              }
              elevation: 2
              Layout.fillWidth:true
              Layout.fillHeight:true

              /* Mr. Plotter components. */

              YAxisArea {
                  id: lyaa
                  anchors.left: parent.left
                  anchors.top: parent.top
                  anchors.bottom: parent.bottom
                  anchors.right: pa.left
                  height: parent.height
                  rangeStart: pa.y + pa.height
                  rangeEnd: pa.y
                  rightSide: false
                  axisList: [yaxis]
              }
              PlotArea {
                  id: pa
                  anchors.fill: parent
                  anchors.leftMargin: 50
                  scrollZoomable: false
                  yAxisAreaList: [lyaa]
                  streamList: [modelData.sta]
              }
              MrPlotter {
                  id: mrp
                  plotList: [pa]
                  timeZone: "America/Los_Angeles"
                  timeDomain: [1415643674978, 1415643674979, 469055, 469060]
              }
          }
      }
    }

}
