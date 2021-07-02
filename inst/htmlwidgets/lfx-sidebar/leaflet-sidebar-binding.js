/* global LeafletWidget, $, L */
LeafletWidget.methods.addSidebar = function(id, options) {
  (function(){
    var map = this;

    // Add css class ("sidebar-map") to map
    if (!map._container.classList.contains("sidebar-map")) {
      map._container.classList.add("sidebar-map");
    }

    // Change CSS if fit = true.
    if (options && options.fit === true) {
      var mapheight = (parseInt(map._container.style.height.replace(/px/,"")) + 3)+"px";
      $(`#${id}`).css("height", mapheight);
      $(`#${id}`).css("top", map._container.offsetTop - 2);
      if (options.position === "right") {
        var right =
          100 - map._container.parentElement.style.width.match(/\d*/im)[0];
        $(`#${id}`).css("right", (right)+"%");
      } else {
        var left =
          100 - map._container.parentElement.style.width.match(/\d*/im)[0];
        $(`#${id}`).css("left", (left)+"%");
      }
    }

    // Extend onClick method to trigger "shown" event, otherwise Shiny-Inputs/Outputs are not reactive
    L.Control.Sidebar = L.Control.Sidebar.extend({
      _onClick: function() {
        if (L.DomUtil.hasClass(this, 'active')) {
          this._sidebar.close();
        } else if (!L.DomUtil.hasClass(this, 'disabled')) {
          this._sidebar.open(this.querySelector('a').hash.slice(1));
          $(this.firstElementChild.attributes.href.nodeValue).trigger("shown");
        }
      }
    });

    // initialize sidebar element of map
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
    // if no sidebar_id specified, then use the first sidebar
    var tid =
      sidebar_id === undefined ? Object.keys(map.sidebar)[0] : sidebar_id;
    $(`#${tid}`).remove();
    delete map.sidebar[tid];
  }
};

LeafletWidget.methods.closeSidebar = function(sidebar_id) {
  var map = this;
  if (map.sidebar) {
    // if no sidebar_id specified, then use the first sidebar
    var tid =
      sidebar_id === undefined ? Object.keys(map.sidebar)[0] : sidebar_id;
    map.sidebar[tid].close();
  }
};

LeafletWidget.methods.openSidebar = function(x) {
  var map = this;
  if (map.sidebar) {
    // if no sidebar_id specified, then use the first sidebar
    var tid =
      x.sidebar_id === undefined ? Object.keys(map.sidebar)[0] : x.sidebar_id;
    map.sidebar[tid].open(x.id);
  }
};
