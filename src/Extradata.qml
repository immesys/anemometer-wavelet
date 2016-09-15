import QtQuick 2.4
import Material 0.3
import Material.ListItems 0.1
import Material.Extras 0.1
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0 as Qtc

View {
  elevation:1

  anchors.fill:parent
  anchors.leftMargin: 10
  anchors.rightMargin: 10
  anchors.topMargin: 10
  anchors.bottomMargin: 10

  property var dsource

  Connections {
        target: dsource
        onExtradata: function(msg) {
            ta.insert(0, msg+"\n")
        }
    }

  Flickable {
    clip : true
    id : flickable
    anchors.fill:parent
    contentHeight: ta.contentHeight
    Qtc.TextArea {
      id: ta
      readOnly: true
      text: ""
      wrapMode: Qtc.TextArea.Wrap
    }
   //TODO add text at top of this box
  }


}

// View {
//   elevation: 1
//   anchors.fill:parent
//   anchors.leftMargin: 10
//   anchors.rightMargin: 10
//   anchors.topMargin: 10
//   anchors.bottomMargin: 10
//   property var data
//   ColumnLayout {
//     anchors.leftMargin: 10
//     anchors.rightMargin: 10
//     anchors.topMargin: 10
//     anchors.bottomMargin: 10
//     anchors.fill:parent
//     Rectangle {
//       Layout.fillWidth: true
//       Layout.fillHeight: true
//       color: "red"
//     }
//
//     Label {
//       style: "menu"
//       Layout.fillWidth: true
//       text: "Algorithm extra data"
//     }
//     Flickable {
//       clip : true
//       id : flickable
//       Layout.fillHeight: true
//       Layout.fillWidth: true
//       contentHeight: ta.contentHeight
//       Qtc.TextArea {
//         id: ta
//         readOnly: true
//         text: "foo0\nfoo1\nfoo2\nfoo3\nfoo4\nfoo5\nfoo6\nfoo7\nfoo8\nfoo9\nfoo10\nfoo11\nfoo12\nfoo13\nfoo14\nfoo15\nfoo16\nfoo17\nfoo18\nfoo19\nfoo20\nfoo21\nfoo22\nfoo23\nfoo24\nfoo25\nfoo26\nfoo27\nfoo28\nfoo29\nfoo30\nfoo31\nfoo32\nfoo33\nfoo34\nfoo35\nfoo36\nfoo37\nfoo38\nfoo39\nfoo40\nfoo41\nfoo42\nfoo43\nfoo44\nfoo45\nfoo46\nfoo47\nfoo48\nfoo49\nfoo50\nfoo51\nfoo52\nfoo53\nfoo54\nfoo55\nfoo56\nfoo57\nfoo58\nfoo59\nfoo60\nfoo61\nfoo62\nfoo63\nfoo64\nfoo65\nfoo66\nfoo67\nfoo68\nfoo69\nfoo70\nfoo71\nfoo72\nfoo73\nfoo74\nfoo75\nfoo76\nfoo77\nfoo78\nfoo79\nfoo80\nfoo81\nfoo82\nfoo83\nfoo84\nfoo85\nfoo86\nfoo87\nfoo88\nfoo89\nfoo90\nfoo91\nfoo92\nfoo93\nfoo94\nfoo95\nfoo96\nfoo97\nfoo98\nfoo99\nfoo100\nfoo101\nfoo102\nfoo103\nfoo104\nfoo105\nfoo106\nfoo107\nfoo108\nfoo109\nfoo110\nfoo111\nfoo112\nfoo113\nfoo114\nfoo115\nfoo116\nfoo117\nfoo118\nfoo119\nfoo120\nfoo121\nfoo122\nfoo123\nfoo124\nfoo125\nfoo126\nfoo127\nfoo128\nfoo129\nfoo130\nfoo131\nfoo132\nfoo133\nfoo134\nfoo135\nfoo136\nfoo137\nfoo138\nfoo139\nfoo140\nfoo141\nfoo142\nfoo143\nfoo144\nfoo145\nfoo146\nfoo147\nfoo148\nfoo149\nfoo150\nfoo151\nfoo152\nfoo153\nfoo154\nfoo155\nfoo156\nfoo157\nfoo158\nfoo159\nfoo160\nfoo161\nfoo162\nfoo163\nfoo164\nfoo165\nfoo166\nfoo167\nfoo168\nfoo169\nfoo170\nfoo171\nfoo172\nfoo173\nfoo174\nfoo175\nfoo176\nfoo177\nfoo178\nfoo179\nfoo180\nfoo181\nfoo182\nfoo183\nfoo184\nfoo185\nfoo186\nfoo187\nfoo188\nfoo189\nfoo190\nfoo191\nfoo192\nfoo193\nfoo194\nfoo195\nfoo196\nfoo197\nfoo198\nfoo199\n"
//         wrapMode: Qtc.TextArea.Wrap
//       }
//       //TODO add text at top of this box
//     }
//   }
// }
