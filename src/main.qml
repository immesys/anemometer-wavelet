import QtQuick 2.4
import Material 0.3
import Material.ListItems 0.1
import Material.Extras 0.1
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.1

WaveletWindow {

  theme {
      primaryColor: "#003262"
      accentColor: "#FDB515"
      tabHighlightColor: "#FF0000"//"#DCEDC8"
  }

  initialPage : TabbedPage {
    id : overview
    title : "SASC Anemometer app"
    Tab {
      title : "Time of flight"
      TOFPage {
        anchors.fill:parent
      }

    }
    Tab {
      title : "Velocity"
      //AboutPage {
      //}
    }
  }
}
