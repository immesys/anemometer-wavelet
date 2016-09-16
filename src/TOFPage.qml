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
    property int axmin : 100
    property int axmax : 400

    //The six edges are 0->1 1->2 2->0 0->3 1->3 2->3
    //The reverse are   1->0 2->1 0->2 3->0 3->1 3->2
    property list<Stream> streams : [
      Stream {
          id: a0_1
          dataDensity: false
          selected: false
          alwaysConnect: false

          color: "blue"
          timeOffset: [0, 0]
          archiver: "local"
          uuid: "10000000-0000-0000-0000-000000000000"
      },
      Stream {
          id: a1_0
          dataDensity: false
          selected: false
          alwaysConnect: false

          color: "red"
          timeOffset: [0, 0]
          archiver: "local"
          uuid: "10000000-0000-0000-0000-000000000001"
      },
      Stream {
          id: a1_2
          dataDensity: false
          selected: false
          alwaysConnect: false

          color: "blue"
          timeOffset: [0, 0]
          archiver: "local"
          uuid: "10000000-0000-0000-0000-000000000010"
      },
      Stream {
          id: a2_1
          dataDensity: false
          selected: false
          alwaysConnect: false

          color: "red"
          timeOffset: [0, 0]
          archiver: "local"
          uuid: "10000000-0000-0000-0000-000000000011"
      },
      Stream {
          id: a2_0
          dataDensity: false
          selected: false
          alwaysConnect: false

          color: "blue"
          timeOffset: [0, 0]
          archiver: "local"
          uuid: "10000000-0000-0000-0000-000000000020"
      },
      Stream {
          id: a0_2
          dataDensity: false
          selected: false
          alwaysConnect: false

          color: "red"
          timeOffset: [0, 0]
          archiver: "local"
          uuid: "10000000-0000-0000-0000-000000000021"
      },
      Stream {
          id: a0_3
          dataDensity: false
          selected: false
          alwaysConnect: false

          color: "blue"
          timeOffset: [0, 0]
          archiver: "local"
          uuid: "10000000-0000-0000-0000-000000000030"
      },
      Stream {
          id: a3_0
          dataDensity: false
          selected: false
          alwaysConnect: false

          color: "red"
          timeOffset: [0, 0]
          archiver: "local"
          uuid: "10000000-0000-0000-0000-000000000031"
      },
      Stream {
          id: a1_3
          dataDensity: false
          selected: false
          alwaysConnect: false

          color: "blue"
          timeOffset: [0, 0]
          archiver: "local"
          uuid: "10000000-0000-0000-0000-000000000040"
      },
      Stream {
          id: a3_1
          dataDensity: false
          selected: false
          alwaysConnect: false

          color: "red"
          timeOffset: [0, 0]
          archiver: "local"
          uuid: "10000000-0000-0000-0000-000000000041"
      },
      Stream {
          id: a2_3
          dataDensity: false
          selected: false
          alwaysConnect: false

          color: "blue"
          timeOffset: [0, 0]
          archiver: "local"
          uuid: "10000000-0000-0000-0000-000000000050"
      },
      Stream {
          id: a3_2
          dataDensity: false
          selected: false
          alwaysConnect: false

          color: "red"
          timeOffset: [0, 0]
          archiver: "local"
          uuid: "10000000-0000-0000-0000-000000000051"
      }
    ]
    MrPlotter {
        id: gmrp
    }
    Connections {
      target: main.dsource
      onTofChanged: {
        for (var edge = 0; edge < 6; edge++) {
          for (var dir = 0; dir < 2; dir++) {
            //console.log("Data is ", JSON.stringify(main.dsource.htofz[edge][dir]));
            var uuid = "10000000-0000-0000-0000-0000000000"+edge+dir;
          //  console.log("uuid is", uuid);
            gmrp.hardcodeLocalData(uuid, main.dsource.htofz[edge][dir]);
          }
        }
        for (var i = 0; i < mrpRep.count; i++) {
          mrpRep.itemAt(i).azoom();
        }
        //gmrp.autozoom(pa.streamList);
        //p0.timeDomain = [1473949017000,1474078631000,0,0];
        //ax1.autoscale(p0.timeDomain);
      }
    }
    Component.onCompleted : {
      console.log("dsource: ",main.dsource)
    }

    GridLayout {
      columns: 3
      id: gl
      anchors.top:parent.top
      anchors.left:parent.left
      anchors.right:parent.right
      anchors.bottom:parent.bottom
      anchors.leftMargin: 10
      anchors.rightMargin: 10
      anchors.topMargin: 10
      anchors.bottomMargin: 10
      columnSpacing:10
      rowSpacing:10
      Repeater {
        id:mrpRep
        //The six edges are 0->1 1->2 2->0 0->3 1->3 2->3
        //The reverse are   1->0 2->1 0->2 3->0 3->1 3->2
        model: [
          {"sta":a0_1,"stb":a1_0},
          {"sta":a1_2,"stb":a2_1},
          {"sta":a2_0,"stb":a0_2},
          {"sta":a0_3,"stb":a3_0},
          {"sta":a1_3,"stb":a3_1},
          {"sta":a2_3,"stb":a3_2},
        ]
        delegate: View {
              function azoom() {
                mrp.autozoom(pa.streamList);
              }
              elevation: 2
              Layout.preferredWidth:gl.width/3 - 10
              Layout.preferredHeight:gl.height/2 - 10

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
              YAxis {
                  id: yaxis
                  dynamicAutoscale: false
                  name: "Reading"
                  domain: [axmin, axmax]
                  streamList: [modelData.sta, modelData.stb]
              }
              PlotArea {
                  id: pa
                  anchors.fill: parent
                  anchors.leftMargin: 50
                  scrollZoomable: false
                  yAxisAreaList: [lyaa]
                  streamList: [modelData.sta, modelData.stb]
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
