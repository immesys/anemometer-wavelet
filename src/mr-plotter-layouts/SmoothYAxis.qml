import QtQuick 2.0
import MrPlotter 0.1

YAxis {
    Behavior on domainLo {
        NumberAnimation {
            duration: 200
        }
    }
    Behavior on domainHi {
        NumberAnimation {
            duration: 200
        }
    }
}
