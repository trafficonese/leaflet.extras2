/*!
 * leaflet.wms.js
 * A collection of Leaflet utilities for working with Web Mapping services.
 * (c) 2014-2016, Houston Engineering, Inc.
 * MIT License
 */

(function (factory) {
    // Module systems magic dance, Leaflet edition
    if (typeof define === 'function' && define.amd) {
        // AMD
        define(['leaflet'], factory);
    } else if (typeof module !== 'undefined') {
        // Node/CommonJS
        module.exports = factory(require('leaflet'));
    } else {
        // Browser globals
        if (typeof this.L === 'undefined')
            throw 'Leaflet must be loaded first!';
        // Namespace
        this.L.WMS = this.L.wms = factory(this.L);
    }
}(function (L) {

// Module object
var wms = {};

// Quick shim for Object.keys()
if (!('keys' in Object)) {
    Object.keys = function(obj) {
        var result = [];
        for (var i in obj) {
            if (obj.hasOwnProperty(i)) {
                result.push(i);
            }
        }
        return result;
    };
}

/*
 * wms.Source
 * The Source object manages a single WMS connection.  Multiple "layers" can be
 * created with the getLayer function, but a single request will be sent for
 * each image update.  Can be used in non-tiled "overlay" mode (default), or
 * tiled mode, via an internal wms.Overlay or wms.TileLayer, respectively.
 */
wms.Source = L.Layer.extend({
    'options': {
        'untiled': true,
        'identify': true
    },

    'initialize': function(url, options) {
        L.setOptions(this, options);
        if (this.options.tiled) {
            this.options.untiled = false;
        }
        this._url = url;
        this._subLayers = {};
        this._overlay = this.createOverlay(this.options.untiled);
    },

    'createOverlay': function(untiled) {
        // Create overlay with all options other than untiled & identify
        var overlayOptions = {};
        for (var opt in this.options) {
            if (opt != 'untiled' && opt != 'identify' &&
                opt != 'checkempty' && opt != 'popupOptions') {
                overlayOptions[opt] = this.options[opt];
            }
        }
        overlayOptions.attribution = '';
        if (untiled) {
            return wms.overlay(this._url, overlayOptions);
        }
        var tileOpts = L.extend({}, overlayOptions);
        var hdrs = tileOpts.headers;
        delete tileOpts.headers;
        if (hasHeaders(hdrs)) {
            return wms.tileLayerHeader(this._url, tileOpts, hdrs);
        }
        return wms.tileLayer(this._url, tileOpts);
    },

    'onAdd': function() {
        this.refreshOverlay();
    },

    'onRemove': function() {
        if (this._overlay) {
            this._overlay.remove();
        }
    },

    'getAttribution': function() {
        return null;
    },

    'getEvents': function() {
        if (this.options.identify) {
            return {
                'click': this.identify
            };
        } else {
            return {};
        }
    },

    'setOpacity': function(opacity) {
         this.options.opacity = opacity;
         if (this._overlay) {
             this._overlay.setOpacity(opacity);
         }
    },

    'bringToBack': function() {
         this.options.isBack = true;
         if (this._overlay) {
             this._overlay.bringToBack();
         }
    },

    'bringToFront': function() {
         this.options.isBack = false;
         if (this._overlay) {
             this._overlay.bringToFront();
         }
    },

    'getLayer': function(name) {
        return wms.layer(this, name);
    },

    'addSubLayer': function(name) {
        this._subLayers[name] = true;
        this.refreshOverlay();
    },

    'removeSubLayer': function(name) {
        delete this._subLayers[name];
        this.refreshOverlay();
    },

    'refreshOverlay': function() {
        var subLayers = Object.keys(this._subLayers).join(",");
        if (!this._map) {
            return;
        }
        if (!subLayers) {
            this._overlay.remove();
        } else {
            this._overlay.setParams({'layers': subLayers});
            this._overlay.addTo(this._map);
        }
    },

    'identify': function(evt) {
        // Identify map features in response to map clicks. To customize this
        // behavior, create a class extending wms.Source and override one or
        // more of the following hook functions.
        var layers = this.getIdentifyLayers();
        if (!layers.length) {
            return;
        }
        this.getFeatureInfo(
            evt.containerPoint, evt.latlng, layers,
            this.showFeatureInfo
        );
    },

    'getFeatureInfo': function(point, latlng, layers, callback) {
        // Request WMS GetFeatureInfo and call callback with results
        // (split from identify() to faciliate use outside of map events)
        var params = this.getFeatureInfoParams(point, layers),
            url = upgradeInsecureUrl(
                this._url + L.Util.getParamString(params, this._url)
            );

        this.showWaiting();
        this.ajax(url, done);

        function done(result, status) {
            this.hideWaiting();
            var text = this.parseFeatureInfo(result, url, status);
            callback.call(this, latlng, text);
        }
    },

    'ajax': function(url, callback) {
        ajax.call(this, url, callback);
    },

    'getIdentifyLayers': function() {
        // Hook to determine which layers to identify
        if (this.options.identifyLayers)
            return this.options.identifyLayers;
        return Object.keys(this._subLayers);
     },

    'getFeatureInfoParams': function(point, layers) {
        // Hook to generate parameters for WMS service GetFeatureInfo request
        var wmsParams, overlay;
        if (this.options.untiled) {
            // Use existing overlay
            wmsParams = this._overlay.wmsParams;
        } else {
            // Create overlay instance to leverage updateWmsParams
            overlay = this.createOverlay(true);
            overlay.updateWmsParams(this._map);
            wmsParams = overlay.wmsParams;
            wmsParams.layers = layers.join(',');
        }
        var infoParams = {
            'request': 'GetFeatureInfo',
            'query_layers': layers.join(','),
            'X': Math.round(point.x),
            'Y': Math.round(point.y)
        };
        return L.extend({}, wmsParams, infoParams);
    },

    'parseFeatureInfo': function(result, url, status) {
        if (result == "error") {
            if (status === 401 || status === 403) {
                return "WMS GetFeatureInfo: unauthorized (" + status + ")";
            }
            result = "<iframe src='" + upgradeInsecureUrl(url) + "' style='border:none'>";
        }
        return result;
    },

    'showFeatureInfo': function(latlng, info) {
        // Hook to handle displaying parsed AJAX response to the user
        if (!this._map) {
            return;
        }
        this._map.openPopup(info, latlng);
    },

    'showWaiting': function() {
        // Hook to customize AJAX wait animation
        if (!this._map)
            return;
        this._map._container.style.cursor = "progress";
    },

    'hideWaiting': function() {
        // Hook to remove AJAX wait animation
        if (!this._map)
            return;
        this._map._container.style.cursor = "default";
    }
});

wms.source = function(url, options) {
    return new wms.Source(url, options);
};

/*
 * Layer
 * Leaflet "layer" with all actual rendering handled via an underlying Source
 * object.  Can be called directly with a URL to automatically create or reuse
 * an existing Source.  Note that the auto-source feature doesn't work well in
 * multi-map environments; so for best results, create a Source first and use
 * getLayer() to retrieve wms.Layer instances.
 */

wms.Layer = L.Layer.extend({
    'initialize': function(source, layerName, options) {
        L.setOptions(this, options);
        if (!source.addSubLayer) {
            // Assume source is a URL
            source = wms.getSourceForUrl(source, options);
        }
        this._source = source;
        this._name = layerName;
    },
    'getAttribution': function() {
        return this._source && this._source.options
            ? this._source.options.attribution
            : null;
    },
    'onAdd': function() {
        this._source.addSubLayer(this._name);
        if (!this._source._map)
            this._source.addTo(this._map);
    },
    'onRemove': function() {
        this._source.removeSubLayer(this._name);
    },
    'setOpacity': function(opacity) {
        this._source.setOpacity(opacity);
    },
    'bringToBack': function() {
        this._source.bringToBack();
    },
    'bringToFront': function() {
        this._source.bringToFront();
    }
});

wms.layer = function(source, options) {
    return new wms.Layer(source, options);
};

// Cache of sources for use with wms.Layer auto-source option
var sources = {};
wms.getSourceForUrl = function(url, options) {
    if (!sources[url]) {
        sources[url] = wms.source(url, options);
    }
    return sources[url];
};


// Copy tiled WMS layer from leaflet core, in case we need to subclass it later
wms.TileLayer = L.TileLayer.WMS;
wms.tileLayer = L.tileLayer.wms;

wms.TileLayerHeader = L.TileLayer.WMS.extend({
    initialize: function(url, options, headers) {
        L.TileLayer.WMS.prototype.initialize.call(this, url, options);
        this.headers = headers || [];
    },
    createTile: function(coords, done) {
        var url = this.getTileUrl(coords);
        var img = document.createElement('img');
        img.setAttribute('role', 'presentation');
        fetchBlob(url, this.headers, function(blob) {
            if (!blob) {
                done(new Error('WMS tile request failed'), img);
                return;
            }
            var objUrl = URL.createObjectURL(blob);
            img.onload = function() {
                URL.revokeObjectURL(objUrl);
            };
            img.src = objUrl;
            done(null, img);
        });
        return img;
    }
});

wms.tileLayerHeader = function(url, options, headers) {
    return new wms.TileLayerHeader(url, options, headers);
};

/*
 * wms.Overlay:
 * "Single Tile" WMS image overlay that updates with map changes.
 * Portions of wms.Overlay are directly extracted from L.TileLayer.WMS.
 * See Leaflet license.
 */
wms.Overlay = L.Layer.extend({
    'defaultWmsParams': {
        'service': 'WMS',
        'request': 'GetMap',
        'version': '1.1.1',
        'layers': '',
        'styles': '',
        'format': 'image/jpeg',
        'transparent': false
    },

    'options': {
        'crs': null,
        'uppercase': false,
        'attribution': '',
        'opacity': 1,
        'isBack': false,
        'minZoom': 0,
        'maxZoom': 18,
        'headers': null
    },

    'initialize': function(url, options) {
        this._url = url;

        // Move WMS parameters to params object
        var params = {}, opts = {};
        for (var opt in options) {
             if (opt in this.options) {
                 opts[opt] = options[opt];
             } else {
                 params[opt] = options[opt];
             }
        }
        L.setOptions(this, opts);
        this.wmsParams = L.extend({}, this.defaultWmsParams, params);
    },

    'setParams': function(params) {
        L.extend(this.wmsParams, params);
        this.update();
    },

    'getAttribution': function() {
        return this.options.attribution;
    },

    'onAdd': function() {
        this.update();
    },

    'onRemove': function(map) {
        if (this._currentOverlay && map && map.removeLayer) {
            map.removeLayer(this._currentOverlay);
            delete this._currentOverlay;
        }
        if (this._currentUrl) {
            delete this._currentUrl;
        }
    },

    'getEvents': function() {
        return {
            'moveend': this.update
        };
    },

    'update': function() {
        if (!this._map || !this._map._loaded) {
            return;
        }
        // Determine image URL and whether it has changed since last update
        this.updateWmsParams();
        var url = this.getImageUrl();
        if (this._currentUrl == url) {
            return;
        }
        this._currentUrl = url;

        // Keep current image overlay in place until new one loads
        // (inspired by esri.leaflet)
        var bounds = this._map.getBounds();

        // Update - Included PR 58 - (Update leaflet.wms.js)
        // https://github.com/heigeo/leaflet.wms/pull/58/commits/3508426a7c20f13c6bbce0ba0fedfb21b2d90f5a
        var opt= {'opacity': 0};
        if (this.options.zIndex)
            opt.zIndex=this.options.zIndex;
        if (this.options.pane)
            opt.pane=this.options.pane;

        var requestUrl = url;
        var self = this;
        function attachOverlay(src) {
            var overlay = L.imageOverlay(src, bounds, opt);
            overlay._wmsUrl = requestUrl;
            overlay.addTo(self._map);
            overlay.once('load', function() {
                if (!self._map) {
                    return;
                }
                if (overlay._wmsUrl != self._currentUrl) {
                    self._map.removeLayer(overlay);
                    if (src.indexOf('blob:') === 0) {
                        URL.revokeObjectURL(src);
                    }
                    return;
                } else if (self._currentOverlay) {
                    self._map.removeLayer(self._currentOverlay);
                }
                self._currentOverlay = overlay;
                overlay.setOpacity(
                    self.options.opacity ? self.options.opacity : 1
                );
                if (self.options.isBack === true) {
                    overlay.bringToBack();
                }
                if (self.options.isBack === false) {
                    overlay.bringToFront();
                }
            });
            if ((self._map.getZoom() < self.options.minZoom) ||
                (self._map.getZoom() > self.options.maxZoom)){
                self._map.removeLayer(overlay);
            }
        }
        if (hasHeaders(this.options.headers)) {
            fetchBlob(url, this.options.headers, function(blob) {
                if (!blob || requestUrl !== self._currentUrl) {
                    return;
                }
                attachOverlay(URL.createObjectURL(blob));
            });
        } else {
            attachOverlay(url);
        }
    },

    'setOpacity': function(opacity) {
         this.options.opacity = opacity;
         if (this._currentOverlay) {
             this._currentOverlay.setOpacity(opacity);
         }
    },

    'bringToBack': function() {
        this.options.isBack = true;
        if (this._currentOverlay) {
            this._currentOverlay.bringToBack();
        }
    },

    'bringToFront': function() {
        this.options.isBack = false;
        if (this._currentOverlay) {
            this._currentOverlay.bringToFront();
        }
    },

    // See L.TileLayer.WMS: onAdd() & getTileUrl()
    'updateWmsParams': function(map) {
        if (!map) {
            map = this._map;
        }
        // Compute WMS options
        var bounds = map.getBounds();
        var size = map.getSize();
        var wmsVersion = parseFloat(this.wmsParams.version);
        var crs = this.options.crs || map.options.crs;
        var projectionKey = wmsVersion >= 1.3 ? 'crs' : 'srs';
        var nw = crs.project(bounds.getNorthWest());
        var se = crs.project(bounds.getSouthEast());

        // Assemble WMS parameter string
        var params = {
            'width': size.x,
            'height': size.y
        };
        params[projectionKey] = crs.code;
        params.bbox = (
            wmsVersion >= 1.3 && crs === L.CRS.EPSG4326 ?
            [se.y, nw.x, nw.y, se.x] :
            [nw.x, se.y, se.x, nw.y]
        ).join(',');

        L.extend(this.wmsParams, params);
    },

    'getImageUrl': function() {
        var uppercase = this.options.uppercase || false;
        var pstr = L.Util.getParamString(this.wmsParams, this._url, uppercase);
        return this._url + pstr;
    }
});

wms.overlay = function(url, options) {
    return new wms.Overlay(url, options);
};

function headerList(headers) {
    if (!headers) {
        return [];
    }
    if (Object.prototype.toString.call(headers) === '[object Array]') {
        return headers;
    }
    var out = [];
    for (var key in headers) {
        if (Object.prototype.hasOwnProperty.call(headers, key)) {
            out.push({ header: key, value: headers[key] });
        }
    }
    return out;
}

function hasHeaders(headers) {
    return headerList(headers).length > 0;
}

function applyXhrHeaders(request, headers) {
    headerList(headers).forEach(function(h) {
        if (h && h.header && h.value != null) {
            request.setRequestHeader(h.header, String(h.value));
        }
    });
}

function fetchBlob(url, headers, callback) {
    var request = new XMLHttpRequest();
    request.open('GET', url);
    request.responseType = 'blob';
    applyXhrHeaders(request, headers);
    request.onreadystatechange = function() {
        if (request.readyState !== 4) {
            return;
        }
        if (request.status >= 200 && request.status < 300 && request.response) {
            callback(request.response);
        } else {
            callback(null);
        }
    };
    request.send();
}

function upgradeInsecureUrl(url) {
    if (typeof window !== 'undefined' &&
        window.location &&
        window.location.protocol === 'https:' &&
        /^http:\/\//i.test(url)) {
        return 'https://' + url.substring(7);
    }
    return url;
}

function absoluteUrl(base, loc) {
    try {
        return new URL(loc, base).toString();
    } catch (err) {
        return loc;
    }
}

function isSameHostRedirect(fromUrl, toUrl) {
    try {
        var from = new URL(fromUrl);
        var to = new URL(toUrl, fromUrl);
        if (to.protocol !== 'http:' && to.protocol !== 'https:') {
            return false;
        }
        return to.hostname === from.hostname;
    } catch (err) {
        return false;
    }
}

function ajax(url, callback, redirectCount) {
    var context = this,
        request = new XMLHttpRequest(),
        hops = redirectCount || 0;
    request.onreadystatechange = change;
    request.open('GET', url);
    if (context && context.options) {
        applyXhrHeaders(request, context.options.headers);
    }
    request.send();

    function change() {
        if (request.readyState !== 4) {
            return;
        }
        var status = request.status;
        if (status >= 200 && status < 300) {
            callback.call(context, request.responseText);
            return;
        }
        if (status >= 300 && status < 400 && hops < 5) {
            var loc = request.getResponseHeader('Location');
            if (loc) {
                var next = absoluteUrl(url, loc);
                if (!isSameHostRedirect(url, next)) {
                    callback.call(context, 'error', status);
                    return;
                }
                ajax.call(context, next, callback, hops + 1);
                return;
            }
            if (request.responseText) {
                callback.call(context, request.responseText);
                return;
            }
        }
        callback.call(context, 'error', status);
    }
}

return wms;

}));
