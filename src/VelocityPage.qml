import QtQuick 2.4
import Material 0.3
import Material.ListItems 0.1
import Material.Extras 0.1
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.1
//import BOSSWAVE 1.0

Item {
  id : main
  property var data
  ColumnLayout {
    anchors.fill: parent
    Button {
      text: "setvensrc"
    }
    Text {
      text: "uncorrectable: "+main.data.uncorrectable
    }
    Text {
      text: "tof1F: "+main.data.tofz
    }
    Text {
      text: "Htof1F: "+main.data.velz
    }
  }

}
