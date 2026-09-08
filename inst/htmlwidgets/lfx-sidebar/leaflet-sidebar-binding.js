/* global LeafletWidget, $, L */
window.__lfxSidebarFix = '1.0.3';

var sidebarMaps = [];

function registerSidebarMap(map) {
  if (sidebarMaps.indexOf(map) === -1) {
    sidebarMaps.push(map);
  }
}

function setMapInteract(enabled) {
  for (var i = 0; i < sidebarMaps.length; i++) {
    var map = sidebarMaps[i];
    if (!map) {
      continue;
    }
    if (enabled) {
      map.dragging.enable();
      if (map.scrollWheelZoom) {
        map.scrollWheelZoom.enable();
      }
    } else {
      map.dragging.disable();
      if (map.scrollWheelZoom) {
        map.scrollWheelZoom.disable();
      }
    }
  }
}

function isSidebarUi(target) {
  return !!(target && target.closest && target.closest(
    '.leafsidebar, .selectize-dropdown, .selectize-control, .vscomp-dropbox-container, .vscomp-dropbox'
  ));
}

function uiHold() {
  document.body.classList.add('lfx-sidebar-ui-open');
  setMapInteract(false);
}

function uiRelease() {
  document.body.classList.remove('lfx-sidebar-ui-open');
  setMapInteract(true);
}

function watchDocumentUi() {
  if (window._lfxSidebarDocHook) {
    return;
  }
  window._lfxSidebarDocHook = true;
  document.addEventListener('pointerdown', function(e) {
    if (isSidebarUi(e.target)) {
      uiHold();
    }
  }, true);
  document.addEventListener('mousedown', function(e) {
    if (isSidebarUi(e.target)) {
      uiHold();
    }
  }, true);
  document.addEventListener('pointerup', uiRelease, true);
  document.addEventListener('mouseup', uiRelease, true);
}

function hookSidebarSelectize() {
  function bind(select) {
    var s = select.selectize;
    if (!s || s._lfxSidebarHooked) {
      return;
    }
    s._lfxSidebarHooked = true;
    s.settings.dropdownParent = 'body';

    s.on('dropdown_open', function() {
      if (s.$dropdown && s.$dropdown[0]) {
        s.$dropdown.appendTo(document.body);
        s.$dropdown.addClass('lfx-sidebar-dropdown');
      }
      uiHold();
    });
    s.on('dropdown_close', uiRelease);
  }

  function scan() {
    var nodes = document.querySelectorAll('.leafsidebar select');
    for (var i = 0; i < nodes.length; i++) {
      bind(nodes[i]);
    }
  }

  scan();
  if (window.jQuery) {
    $(document).on('shiny:bound shiny:value', scan);
  }
  if (window.MutationObserver) {
    var roots = document.querySelectorAll('.leafsidebar');
    var obs = new MutationObserver(scan);
    for (var i = 0; i < roots.length; i++) {
      obs.observe(roots[i], { childList: true, subtree: true });
    }
  }
}

LeafletWidget.methods.addSidebar = function(id, options) {
  (function(){
    var map = this;
    registerSidebarMap(map);
    watchDocumentUi();

    if (!map._container.classList.contains('sidebar-map')) {
      map._container.classList.add('sidebar-map');
    }

    var mapid = "#" + (map.id ? map.id : map._container.id);
    if (options && options.fit === true) {
      if ($(mapid + ' .leaflet-sidebar-container').length === 0) {
        var mapdiv = document.createElement('div');
        mapdiv.className = 'leaflet-sidebar-container';
        $(mapdiv).appendTo($(mapid));
      }
      $('#'+id).appendTo(mapid + ' .leaflet-sidebar-container');
    }

    setTimeout(function(){
      $('.leafsidebar.collapsed .leafsidebar-tabs, .leafsidebar.collapsed .leafsidebar-content').css('display','block');
      hookSidebarSelectize();
    }, 400);

    L.Control.Sidebar = L.Control.Sidebar.extend({
      _onClick: function() {
        if (L.DomUtil.hasClass(this, 'active')) {
          this._sidebar.close();
          Shiny.setInputValue(id, null);
        } else if (!L.DomUtil.hasClass(this, 'disabled')) {
          const openid = this.querySelector('a').hash.slice(1);
          this._sidebar.open(openid);
          Shiny.setInputValue(id, openid);
          $(this.firstElementChild.attributes.href.nodeValue).trigger('shown');
        }
      }
    });

    if (!map.sidebar) {
      map.sidebar = {};
    }
    map.sidebar[id] = L.control.sidebar(id, options);
    map.controls.add(map.sidebar[id]);

  }).call(this);
};

LeafletWidget.methods.removeSidebar = function(sidebar_id) {
  var map = this;
  if (map.sidebar) {
    var tid =
      typeof(sidebar_id) === "string" ?
        sidebar_id : Object.keys(map.sidebar)[0];

    Shiny.setInputValue(tid, null);

    var sidebar = $(`#${tid}`);
    if (sidebar[0]) {
      map._container.classList.remove("sidebar-map")
      sidebar.remove();
      $("#" + map.id + " .leaflet-sidebar-container").remove();
      delete map.sidebar[tid];
    }
  }
};

LeafletWidget.methods.closeSidebar = function(sidebar_id) {
  var map = this;
  if (map.sidebar) {
    var tid =
      typeof(sidebar_id) === "string" ?
        sidebar_id : Object.keys(map.sidebar)[0];

    Shiny.setInputValue(tid, null);

    if (map.sidebar[tid]) {
      map.sidebar[tid].close();
    }
  }
};

LeafletWidget.methods.openSidebar = function(x) {
  var map = this;
  if (map.sidebar) {
    var tid =
      typeof(x.sidebar_id) === "string" ?
        x.sidebar_id : Object.keys(map.sidebar)[0];

    Shiny.setInputValue(tid, x.id);

    if (map.sidebar[tid]) {
      map.sidebar[tid].open(x.id);
    }
  }
};
