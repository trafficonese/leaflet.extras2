/* global LeafletWidget, $, L */
LeafletWidget.methods.addSidebar = function(id, options) {
  (function(){
    var map = this;
    if (map.sidebar) {
      map.sidebar.remove();
      delete map.sidebar;
    }

    // Add css class ("sidebar-map") to map
    map._container.classList.add("sidebar-map");

    // Change CSS if fit = true.
    if (options && options.fit === true) {
      var mapheight = (parseInt(map._container.style.height.replace(/px/,"")) + 3)+"px";
      $(".sidebar").css("height", mapheight);
      $(".sidebar").css("top", map._container.offsetTop - 2);
      if (options.position === "right") {
        var right = 100 - map._container.parentElement.style.width.match(/\d*/im)[0];
        $(".sidebar").css("right", (right)+"%");
      } else {
        var left = 100 - map._container.parentElement.style.width.match(/\d*/im)[0];
        $(".sidebar").css("left", (left)+"%");
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

    map.sidebar = L.control.sidebar(id, options);
    map.controls.add(map.sidebar);

  }).call(this);
};

LeafletWidget.methods.removeSidebar = function() {
  var map = this;
  if (map.sidebar) {
    $(".sidebar").remove();
    delete map.sidebar;
  }
};

LeafletWidget.methods.closeSidebar = function() {
  var map = this;
  if (map.sidebar) {
    map.sidebar.close();
  }
};

LeafletWidget.methods.openSidebar = function(id) {
  var map = this;
  if (map.sidebar) {
    map.sidebar.open(id);
  }
};
