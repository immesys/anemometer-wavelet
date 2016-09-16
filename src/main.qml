import QtQuick 2.4
import Material 0.3
import Material.ListItems 0.1
import Material.Extras 0.1
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.1

WaveletWindow {

  id : mwindow
  theme {
      primaryColor: "#003262"
      accentColor: "#FDB515"
      tabHighlightColor: "#FF0000"//"#DCEDC8"
  }

  property var dsource : DataSource {
    vendorAlgorithm: "mpa:reference_1_0"
    sensor:"5a461e59c577aa2a"
  }
  initialPage : TabbedPage {
    id : overview
    title : "SASC Anemometer app"
    Tab {
      title : "Config"
      ConfigPage {
        anchors.fill: parent
        dsource: mwindow.dsource
      }

    }
    Tab {
      title : "Time of flight"
      TOFPage {
        anchors.fill: parent
        dsource: mwindow.dsource
      }

    }
    Tab {
      title : "Velocity"
      VelocityPage {
        anchors.fill: parent
        data: mwindow.dsource
      }
    }
  }
}
