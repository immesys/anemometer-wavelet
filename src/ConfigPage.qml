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
    //Top controls
    View {
      id:topcontrols
      elevation: 1
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.leftMargin: 10
      anchors.rightMargin: 10
      anchors.topMargin: 10
      anchors.bottomMargin: 10
      height: grid.implicitHeight+20
      GridLayout {
        columnSpacing: 10
        rowSpacing: 10
        id: grid
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        anchors.fill:parent
        columns: 4
        Label {
          style: "menu"
          text: "Algorithm"
          Layout.preferredWidth:grid.width*0.2 - 10
        }
        Qtc.ComboBox {
          id:vacombo
          Layout.preferredWidth:grid.width*0.3 - 10
          model: main.dsource.availableVendorAlgorithm
          onActivated: {
            main.dsource.vendorAlgorithm = vacombo.currentText
          }
        }
        Label {
          style: "menu"
          text: "Sensor"
          Layout.preferredWidth:grid.width*0.2 - 10
        }
        Qtc.ComboBox {
          id:scombo
          Layout.preferredWidth:grid.width*0.3 - 10
          model: main.dsource.availableSensor
          onActivated: {
            main.dsource.sensor = scombo.currentText
          }
        }
        Label {
          style: "menu"
          text: "Correctable losses"
        }
        Label {
          style: "title"
          text: main.dsource.correctable
        }
        Label {
          style: "menu"
          text: "Uncorrectable losses"
        }
        Label {
          style: "title"
          text: main.dsource.uncorrectable
        }
        Label {
          style: "menu"
          text: "Total"
        }
        Label {
          style: "title"
          text: main.dsource.total
        }
        Rectangle {
          Layout.columnSpan: 2
          Layout.fillWidth: true
          Layout.fillHeight: true
          color: "transparent"
        }
      }
    }
    View {
      elevation: 1
      anchors.leftMargin: 10
      anchors.rightMargin: 10
      anchors.topMargin: 10
      anchors.bottomMargin: 10
      anchors.top:topcontrols.bottom
      anchors.left:parent.left
      anchors.right:parent.right
      anchors.bottom:parent.bottom
      Flickable {
        clip : true
        id : flickable
        anchors.fill:parent
        contentHeight: ta.contentHeight
        Qtc.TextArea {
          id: ta
          readOnly: true
          text: "Algorithm extradata"
          wrapMode: Qtc.TextArea.Wrap
        }
      }
    }
    Connections {
      target: main.dsource
      onOptChanged: {
        vacombo.model = main.dsource.availableVendorAlgorithm
        scombo.model = main.dsource.availableSensor
      }
    }
    Component.onCompleted : {
      console.log("dsource: ",main.dsource)
    }
}
