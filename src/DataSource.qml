import QtQml 2.2
import BOSSWAVE 1.0

QtObject {
  id : dsource
  // assigned 'vendor:algorithm'
  property string vendorAlgorithm
  property string sensor
  property var availableVendorAlgorithm
  property var availableSensor
  //The six edges are 0->1 1->2 2->0 0->3 1->3 2->3
  property var tofz  //an [6][2]
  property var htofz //an [6][2][1024][3]
  property var velX
  property var velY
  property var velZ
  property var hvelX
  property var hvelY
  property var hvelZ
  property int correctable
  property int uncorrectable
  property int total
  onHtofzChanged : {
    console.log("got event")
  }
  signal extradata(string msg)
  signal velChanged()
  signal tofChanged()
  signal optChanged()
  function updateAvailable() {
    dsource.availableVendorAlgorithm = []
    dsource.availableSensor = []
    BW.queryMsgPack({
      "URI":"ucberkeley/anemometer/data/+/+/s.anemometer/+/i.anemometerdata/signal/feed",
      "AutoChain":true},
      function(err, ponum, po, hasmsg, finished) {
        if (err != "") {
          console.log("Got query error: ", err)
          return;
        }
        if (hasmsg) {
          var v = po["vendor"];
          var a = po["algorithm"];
          var s = po["sensor"];
          var va = v+":"+a;
          var hasva = false;
          for (var vi = 0; vi < dsource.availableVendorAlgorithm.length; vi++) {
            if (dsource.availableVendorAlgorithm[vi] == va) {
              hasva = true;
              break;
            }
          }
          if (!hasva) {
            dsource.availableVendorAlgorithm.push(va);
          }
          var hass = false;
          for (var si = 0; si < dsource.availableSensor.length; si++) {
            if (dsource.availableSensor[si] == s) {
              hass = true;
              break;
            }
          }
          if (!hass) {
            dsource.availableSensor.push(s);
          }
        } else {
          console.log("no has message");
        }
        if (finished) {
          console.log("as: ", JSON.stringify(dsource.availableSensor));
          console.log("av: ", JSON.stringify(dsource.availableVendorAlgorithm));
          dsource.optChanged();
        }
      })
  }
  property var subhandle : "none"
  function updateSubscription() {
    console.log("Updating subscription")
    if (subhandle != "none") {
      console.log("Doing unsub")
      BW.unsubscribe(subhandle, function(err) {
        if (err != ""){
          console.log("unsubscribe error: ",err)
        }
      })
      subhandle = "none"
    }
    if (vendorAlgorithm == "") {
      console.log("no vendor/alg")
      return
    }
    var parts = vendorAlgorithm.split(":")
    if (parts.length != 2) {
      console.log("bad split ", vendorAlgorithm)
      return
    }
    if (parts[0] == "" || parts[1] == "") {
      console.log("missing vendor or algorithm")
      return
    }
    if (sensor == "") {
      console.log("no sensor")
      return
    }
    console.log("Actually invoking subscribe")
    BW.subscribeMsgPack({
      "URI":"ucberkeley/anemometer/data/"+parts[0]+"/"+parts[1]+"/s.anemometer/"+sensor+"/i.anemometerdata/signal/feed",
      "AutoChain":true},
      function(ponum, payload) {
        if (payload["tofs"] != undefined) {
          for (var tofi = 0; tofi < payload["tofs"].length; tofi++) {
            var tof = payload["tofs"][tofi];
              //The six edges are 0->1 1->2 2->0 0->3 1->3 2->3
              //The reverse are   1->0 2->1 0->2 3->0 3->1 3->2
            switch(tof["src"]) {
            case 0:
              switch(tof["dst"]) {
              case 1:
                dsource.tofz[0][0] = tof.val;
                dsource.htofz[0][0].push([0,payload["time"], tof.val]);
                if (dsource.htofz[0][0].length > 1024) dsource.htofz[0][0].shift();
                break;
               case 2:
                 dsource.tofz[2][1] = tof.val;
                 dsource.htofz[2][1].push([0,payload["time"], tof.val]);
                 if (dsource.htofz[2][1].length > 1024) dsource.htofz[2][1].shift();
                 break;
               case 3:
                 dsource.tofz[3][0] = tof.val;
                 dsource.htofz[3][0].push([0,payload["time"], tof.val]);
                 if (dsource.htofz[3][0].length > 1024) dsource.htofz[3][0].shift();
                 break;
              }
              break;
            case 1:
              switch(tof["dst"]) {
              case 0:
                dsource.tofz[0][1] = tof.val;
                dsource.htofz[0][1].push([0,payload["time"], tof.val]);
                if (dsource.htofz[0][1].length > 1024) dsource.htofz[0][1].shift();
                break;
              case 2:
                dsource.tofz[1][0] = tof.val;
                dsource.htofz[1][0].push([0,payload["time"], tof.val]);
                if (dsource.htofz[1][0].length > 1024) dsource.htofz[1][0].shift();
                break;
              case 3:
                dsource.tofz[4][0] = tof.val;
                dsource.htofz[4][0].push([0,payload["time"], tof.val]);
                if (dsource.htofz[4][0].length > 1024) dsource.htofz[4][0].shift();
                break;
              }
              break;
            case 2:
              switch(tof["dst"]) {
              case 0:
                dsource.tofz[2][0] = tof.val;
                dsource.htofz[2][0].push([0,payload["time"], tof.val]);
                if (dsource.htofz[2][0].length > 1024) dsource.htofz[2][0].shift();
                break;
              case 1:
                 dsource.tofz[1][1] = tof.val;
                 dsource.htofz[1][1].push([0,payload["time"], tof.val]);
                if (dsource.htofz[1][1].length > 1024) dsource.htofz[1][1].shift();
                break;
              case 3:
                dsource.tofz[5][0] = tof.val;
                dsource.htofz[5][0].push([0,payload["time"], tof.val]);
                if (dsource.htofz[5][0].length > 1024) dsource.htofz[5][0].shift();
                break;
              }
              break;
            case 3:
              switch(tof["dst"]) {
              case 0:
                dsource.tofz[3][1] = tof.val;
                dsource.htofz[3][1].push([0,payload["time"], tof.val]);
                if (dsource.htofz[3][1].length > 1024) dsource.htofz[3][1].shift();
                break;
              case 1:
                dsource.tofz[4][1] = tof.val;
                dsource.htofz[4][1].push([0,payload["time"], tof.val]);
                if (dsource.htofz[4][1].length > 1024) dsource.htofz[4][1].shift();
                break;
              case 2:
                dsource.tofz[5][1] = tof.val;
                dsource.htofz[5][1].push([0,payload["time"], tof.val]);
                if (dsource.htofz[5][1].length > 1024) dsource.htofz[5][1].shift();
                break;
              }
              break;
            }
          }
          dsource.tofChanged()
        }
        if (payload["velocities"] != undefined) {
          for (var veli = 0; veli < payload["velocities"].length; veli++) {
            var vel = payload["velocities"][veli];
            dsource.velX = vel["x"];
            dsource.velY = vel["y"];
            dsource.velZ = vel["z"];
            dsource.hvelX.push([0,payload["time"],velX]);
            if (dsource.hvelX.length > 1024) dsource.hvelX.shift();
            dsource.hvelY.push([0,payload["time"],velY]);
            if (dsource.hvelY.length > 1024) dsource.hvelY.shift();
            dsource.hvelZ.push([0,payload["time"],velZ]);
            if (dsource.hvelZ.length > 1024) dsource.hvelZ.shift();
          }
          dsource.velChanged()
        }
        if (payload["extradata"] != undefined) {
          for (var msgi = 0; msgi < payload["extradata"].length; msgi++) {
            dsource.extradata(payload["extradata"][msgi]);
          }
        }
        if (payload["total"] != undefined) {
          dsource.total = payload["total"]
        }
        if (payload["uncorrectable"] != undefined) {
          dsource.uncorrectable = payload["uncorrectable"]
        }
        if (payload["correctable"] != undefined) {
          dsource.correctable = payload["correctable"]
        }
      //  for (var edge = 0; edge < 6; edge++) {
      //    for (var dir = 0; dir < 2; dir++) {
      //      console.log("htofz ",edge, dir, " - ",htofz[edge][dir].length);
      //    }
      //  }
      //  console.log("hvelX ", hvelX.length)
      //  console.log("hvelY ", hvelY.length)
      //  console.log("hvelZ ", hvelZ.length)
      },
      function(err, subhandle) {
        if (err != "") {
          console.log("subscription error: ", err)
        } else {
          dsource.subhandle = subhandle
        }
      })
  }
  Component.onCompleted : {
    dsource.tofz = []
    dsource.htofz = []
    dsource.hvelX = []
    dsource.hvelY = []
    dsource.hvelZ = []
    for (var edge = 0; edge < 6; edge++) {
      dsource.tofz.push([])
      dsource.htofz.push([])
      for (var dir = 0; dir < 2; dir++) {
        dsource.tofz[edge].push(0)
        dsource.htofz[edge].push([])
      }
    }
    updateAvailable()
    console.log("Did data source onComplete")
    updateSubscription()
  }
}
