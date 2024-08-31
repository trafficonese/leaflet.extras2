LeafletWidget.methods.addLeafletsync = function(ids, synclist, options) {
  for (let map in synclist) {
    let m = HTMLWidgets.find("#"+map);
    if (m && m.getMap()) {
      let m2sync = synclist[map]
      m2sync = Array.isArray(m2sync) ? m2sync : [m2sync]
      for (let i = 0; i < m2sync.length; i++) {
        let ms = HTMLWidgets.find("#"+m2sync[i]);
        if (ms && ms.getMap()) {
          if (!m.getMap().isSynced(ms.getMap())) {
            //console.log("Sync the map " + m2sync[i] + " to " + map)
            var opts = options[m2sync[i]];
            m.getMap().sync(ms.getMap(), opts)
          } else {
            //console.log("Maps are already synced. " + m2sync[i] + " to " + map)
          }
        }
      }
    } else {
      console.log("No map with id '" + map + "' found.")
    }
  }
};

LeafletWidget.methods.unsyncLeaflet = function(id, unsync) {
  unsync = Array.isArray(unsync) ? unsync : [unsync]
  let m = HTMLWidgets.find("#"+id);
  if (m && m.getMap()) {
    for (let i = 0; i < unsync.length; i++) {
      let ms = HTMLWidgets.find("#"+unsync[i]);
      if (ms && ms.getMap()) {
        if (m.getMap().isSynced(ms.getMap())) {
          //console.log("Unsync " + unsync[i] + " from " + id)
          m.getMap().unsync(ms.getMap())
        }
      }
    }
  } else {
    console.log("No map with id '" + id + "' found.")
  }
};

LeafletWidget.methods.isSyncedLeaflet = function(id, syncwith) {
  let m = HTMLWidgets.find("#"+id);
  if (m && m.getMap()) {
    var bool;
    if (syncwith !== null && syncwith !== undefined) {
        let m1 = HTMLWidgets.find("#"+syncwith);
        if (m1 && m1.getMap()) {
          bool = m.getMap().isSynced(m1.getMap());
        } else {
          bool = false;
        }
    } else {
      bool = m.getMap().isSynced();
    }
    Shiny.setInputValue(id + "_synced", bool, {priority: "event"})
  } else {
    console.log("No map with id '" + id + "' found.")
  }
};
