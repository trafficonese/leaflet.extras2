// UMD initialization to work with CommonJS, AMD and basic browser script include
(function (factory) {
	var L;
	if (typeof define === 'function' && define.amd) {
		// AMD
		define(['leaflet'], factory);
	} else if (typeof module === 'object' && typeof module.exports === "object") {
		// Node/CommonJS
		L = require('leaflet');
		module.exports = factory(L);
	} else {
		// Browser globals
		if (typeof window.L === 'undefined')
			throw 'Leaflet must be loaded first';
		factory(window.L);
	}
}(function (L) {

L.Playback = L.Playback || {};

L.Playback.Util = L.Class.extend({
  statics: {
    DateStr: function(time, locale) {
      return new Date(time).toLocaleDateString(locale.locale, locale.options);
    },
    TimeStr: function(time, locale) {
      return new Date(time).toLocaleTimeString(locale.locale, locale.options);
    },
    ParseGPX: function(gpx) {
      var geojson = {
        type: 'Feature',
        geometry: {
          type: 'MultiPoint',
          coordinates: []
        },
        properties: {
          time: [],
          speed: [],
          altitude: []
        },
        bbox: []
      };
      var xml = $.parseXML(gpx);
      var pts = $(xml).find('trkpt');
      for (var i = 0, len = pts.length; i < len; i++) {
        var p = pts[i];
        var lat = parseFloat(p.getAttribute('lat'));
        var lng = parseFloat(p.getAttribute('lon'));
        var timeStr = $(p).find('time').text();
        var eleStr = $(p).find('ele').text();
        var t = new Date(timeStr).getTime();
        var ele = parseFloat(eleStr);

        var coords = geojson.geometry.coordinates;
        var props = geojson.properties;
        var time = props.time;
        var altitude = geojson.properties.altitude;

        coords.push([lng, lat]);
        time.push(t);
        altitude.push(ele);
      }
      return geojson;
    }
  }
});

L.Playback = L.Playback || {};

L.Playback.MoveableMarker = L.Marker.extend({
    initialize: function(startLatLng, options, feature) {
      this.index = 0;
      this.feature = feature;
      this.marker_options = options.marker || {};

      if (jQuery.isFunction(this.marker_options)) {
            this.marker_options = this.marker_options(this.feature, this.index);
        }

      L.Marker.prototype.initialize.call(this, startLatLng, this.marker_options);

      this.popupContent = '';
      this.tooltipContent = '';

      if (this.marker_options.getPopup) {
          this.getPopupContent = this.marker_options.getPopup;
      }

      // Adds popups to the Markers
      if (options.popups) {
        this.options.transitionpopup = options.transitionpopup;
        // This shows marker-popups at wrong locations
        // this.bindPopup(this.getPopupContent(), options.popupOptions)

        // So we use this method and open the popup in the bindings in the clickCallback
        this._popup = L.popup(options.popupOptions)
                        .setLatLng(startLatLng)
                        .setContent(this.getPopupContent())
      }

      // Adds tooltips to the Markers
      if (options.labels) {
        this.options.transitionlabel = options.transitionlabel;
        this.bindTooltip(this.getTooltipContent(), options.labelOptions)
      }
    },
    getPopupContent: function() {
      if (this.feature.popupContent && this.feature.popupContent[this.index] !== '') {
        this.popupContent = this.feature.popupContent[this.index]
        return this.popupContent + '';
      }
    },
    getTooltipContent: function() {
      if (this.feature.tooltipContent && this.feature.tooltipContent[this.index] !== '') {
        this.tooltipContent = this.feature.tooltipContent[this.index]
        return this.tooltipContent + '';
      }
    },
    move: function(latLng, transitionTime, index) {
        if (index > -1) this.index = index;
        // Only if CSS3 transitions are supported
        if (L.DomUtil.TRANSITION) {
            if (this._icon) {
                this._icon.style[L.DomUtil.TRANSITION] = 'all ' + transitionTime + 'ms linear';
            }
            if (this._shadow) {
                this._shadow.style[L.DomUtil.TRANSITION] = 'all ' + transitionTime + 'ms linear';
            }

            if (this.options.transitionpopup) {
              if (this._popup && this._popup._wrapper) {
                  this._popup._wrapper.style[L.DomUtil.TRANSITION] = 'all ' + transitionTime + 'ms linear';
                  this._popup._wrapper.parentNode.style[L.DomUtil.TRANSITION] = 'all ' + transitionTime + 'ms linear';
              }
            }
            if (this.options.transitionlabel) {
              if (this._tooltip && this._tooltip._container && $(this._tooltip._container).is(":visible")) {
                  this._tooltip._container.style[L.DomUtil.TRANSITION] = 'all ' + transitionTime + 'ms linear';
              }
            }
        }

        this.setLatLng(latLng);

        if (this._tooltip) {
          this._tooltip.setContent(
            this.getTooltipContent()
          )
        }
        if (this._popup) {
          this._popup.setLatLng(latLng).setContent(
              this.getPopupContent()
          )
        }
    },
    // modify leaflet markers to add our rotation code
    /*
     * Based on comments by @runanet and @coomsie
     * https://github.com/CloudMade/Leaflet/issues/386
     *
     * Wrapping function is needed to preserve L.Marker.update function
     */
    _old__setPos:L.Marker.prototype._setPos,

    _updateImg: function (i, a, s) {
        a = L.point(s).divideBy(2)._subtract(L.point(a));
        a = L.point(s);
        var transform = '';
        transform += ' translate(' + -a.x + 'px, ' + -a.y + 'px)';
        transform += ' rotate(' + this.options.iconAngle + 'deg)';
        transform += ' translate(' + a.x + 'px, ' + a.y + 'px)';
        i.style.transformOrigin = '50% 50% 0';
        i.style[L.DomUtil.TRANSFORM] += transform;
    },
    setIconAngle: function (iconAngle) {
        this.options.iconAngle = iconAngle;
        if (this._map)
            this.update();
    },
    _setPos: function (pos) {
        if (this._icon) {
            this._icon.style[L.DomUtil.TRANSFORM] = "";
        }
        if (this._shadow) {
            this._shadow.style[L.DomUtil.TRANSFORM] = "";
        }
        this._old__setPos.apply(this, [pos]);
        if (this.options.iconAngle) {
            var a = this.options.icon.options.iconAnchor;
            var s = this.options.icon.options.iconSize;
            var i;
            if (this._icon) {
                i = this._icon;
                this._updateImg(i, a, s);
            }
            if (this._shadow) {
                // Rotate around the icons anchor.
                s = this.options.icon.options.shadowSize;
                i = this._shadow;
                this._updateImg(i, a, s);
            }
        }
    }
});

L.Playback = L.Playback || {};
L.Playback.Track = L.Class.extend({
    initialize : function(geoJSON, options) {
        options = options || {};
        var tickLen = options.tickLen || 250;
        this._staleTime = options.staleTime || 60*60*1000;
        this._fadeMarkersWhenStale = options.fadeMarkersWhenStale || false;

        this._geoJSON = geoJSON;
        this._tickLen = tickLen;
        this._ticks = [];
        this._marker = null;
	      this._orientations = [];

        var sampleTimes = geoJSON.properties.time;

        this._orientIcon = options.orientIcons;
        var previousOrientation;

        var samples = geoJSON.geometry.coordinates;
        var currSample = samples[0];
        var nextSample = samples[1];

        var currSampleTime = sampleTimes[0];
        var t = currSampleTime;  // t is used to iterate through tick times
        var nextSampleTime = sampleTimes[1];
        var tmod = t % tickLen; // ms past a tick time
        var rem, ratio;

        // handle edge case of only one t sample
        if (sampleTimes.length === 1) {
          if (tmod !== 0)
                t += tickLen - tmod;
          this._ticks[t] = samples[0];
          this._orientations[t] = 0;
          this._startTime = t;
          this._endTime = t;
          return;
        }

        // interpolate first tick if t not a tick time
        if (tmod !== 0) {
          rem = tickLen - tmod;
          ratio = rem / (nextSampleTime - currSampleTime);
          t += rem;
          this._ticks[t] = this._interpolatePoint(currSample, nextSample, ratio);
          this._orientations[t] = this._directionOfPoint(currSample,nextSample);
          previousOrientation = this._orientations[t];
        } else {
          this._ticks[t] = currSample;
          this._orientations[t] = this._directionOfPoint(currSample,nextSample);
          previousOrientation = this._orientations[t];
        }

        this._startTime = t;
        t += tickLen;
        while (t < nextSampleTime) {
          ratio = (t - currSampleTime) / (nextSampleTime - currSampleTime);
          this._ticks[t] = this._interpolatePoint(currSample, nextSample, ratio);
          this._orientations[t] = this._directionOfPoint(currSample,nextSample);
          previousOrientation = this._orientations[t];
          t += tickLen;
        }

        // iterating through the rest of the samples
        for (var i = 1, len = samples.length; i < len; i++) {
            currSample = samples[i];
            nextSample = samples[i + 1];
            t = currSampleTime = sampleTimes[i];
            nextSampleTime = sampleTimes[i + 1];

            tmod = t % tickLen;
            if (tmod !== 0 && nextSampleTime) {
                rem = tickLen - tmod;
                ratio = rem / (nextSampleTime - currSampleTime);
                t += rem;
                this._ticks[t] = this._interpolatePoint(currSample, nextSample, ratio);
			          if (nextSample) {
                    this._orientations[t] = this._directionOfPoint(currSample,nextSample);
                    previousOrientation = this._orientations[t];
                } else {
                    this._orientations[t] = previousOrientation;
                }
            } else {
                this._ticks[t] = currSample;
                if (nextSample) {
                    this._orientations[t] = this._directionOfPoint(currSample,nextSample);
                    previousOrientation = this._orientations[t];
                } else {
                    this._orientations[t] = previousOrientation;
                }
            }

            t += tickLen;
            while (t < nextSampleTime) {
                ratio = (t - currSampleTime) / (nextSampleTime - currSampleTime);
                if (nextSampleTime - currSampleTime > options.maxInterpolationTime) {
                    this._ticks[t] = currSample;
                    if (nextSample){
                      this._orientations[t] = this._directionOfPoint(currSample,nextSample);
                      previousOrientation = this._orientations[t];
                    } else {
                      this._orientations[t] = previousOrientation;
                    }
                } else {
                  this._ticks[t] = this._interpolatePoint(currSample, nextSample, ratio);
                  if (nextSample) {
                    this._orientations[t] = this._directionOfPoint(currSample,nextSample);
                    previousOrientation = this._orientations[t];
                  } else {
                    this._orientations[t] = previousOrientation;
                  }
                }
                t += tickLen;
            }
        }
        // the last t in the while would be past bounds
        this._endTime = t - tickLen;
        this._lastTick = this._ticks[this._endTime];
    },
    _interpolatePoint: function(start, end, ratio) {
        try {
            var delta = [end[0] - start[0], end[1] - start[1]];
            var offset = [delta[0] * ratio, delta[1] * ratio];
            return [start[0] + offset[0], start[1] + offset[1]];
        } catch (e) {
            console.log('err: cant interpolate a point');
            console.log(['start', start]);
            console.log(['end', end]);
            console.log(['ratio', ratio]);
        }
    },
    _directionOfPoint: function(start,end) {
        return this._getBearing(start[1],start[0],end[1],end[0]);
    },
    _getBearing: function(startLat,startLong,endLat,endLong) {
          startLat = this._radians(startLat);
          startLong = this._radians(startLong);
          endLat = this._radians(endLat);
          endLong = this._radians(endLong);

          var dLong = endLong - startLong;

          var dPhi = Math.log(Math.tan(endLat/2.0+Math.PI/4.0)/Math.tan(startLat/2.0+Math.PI/4.0));
          if (Math.abs(dLong) > Math.PI) {
            if (dLong > 0.0)
               dLong = -(2.0 * Math.PI - dLong);
            else
               dLong = (2.0 * Math.PI + dLong);
          }

          return (this._degrees(Math.atan2(dLong, dPhi)) + 360.0) % 360.0;
    },
    _radians: function(n) {
      return n * (Math.PI / 180);
    },
    _degrees: function(n) {
      return n * (180 / Math.PI);
    },

    getFirstTick: function() {
        return this._ticks[this._startTime];
    },
    getLastTick: function() {
        return this._ticks[this._endTime];
    },
    getStartTime: function() {
        return this._startTime;
    },
    getEndTime: function() {
        return this._endTime;
    },
    getTickMultiPoint: function() {
        var t = this.getStartTime();
        var endT = this.getEndTime();
        var coordinates = [];
        var time = [];
        while (t <= endT) {
            time.push(t);
            coordinates.push(this.tick(t));
            t += this._tickLen;
        }

        return {
            type : 'Feature',
            geometry : {
                type : 'MultiPoint',
                coordinates : coordinates
            },
            properties : {
                time : time
            }
        };
    },
    trackPresentAtTick: function(timestamp) {
        return (timestamp >= this._startTime);
    },
    trackStaleAtTick: function(timestamp) {
        return ((this._endTime + this._staleTime) <= timestamp);
    },
    tick: function(timestamp) {
        if (timestamp > this._endTime)
            timestamp = this._endTime;
        if (timestamp < this._startTime)
            timestamp = this._startTime;
        return this._ticks[timestamp];
    },
    courseAtTime: function(timestamp) {
        //return 90;
        if (timestamp > this._endTime)
           timestamp = this._endTime;
        if (timestamp < this._startTime)
           timestamp = this._startTime;
        return this._orientations[timestamp];
    },
    setMarker: function(timestamp, options) {
        var lngLat = null;

        // if time stamp is not set, then get first tick
        if (timestamp) {
          lngLat = this.tick(timestamp);
        } else {
          lngLat = this.getFirstTick();
        }
        if (lngLat) {
            var latLng = new L.LatLng(lngLat[1], lngLat[0]);
            this._marker = new L.Playback.MoveableMarker(latLng, options, this._geoJSON);
				    if (options.mouseOverCallback) {
				      this._marker.on('mouseover', options.mouseOverCallback);
            }
				    if (options.clickCallback) {
              this._marker.on('click', options.clickCallback);
              this._marker.on('click', options.clickCallback);
            }

    				//hide the marker if its not present yet and fadeMarkersWhenStale is true
    				if (this._fadeMarkersWhenStale && !this.trackPresentAtTick(timestamp)) {
    					this._marker.setOpacity(0);
    				}
        }
        return this._marker;
    },
    moveMarker: function(latLng, transitionTime, timestamp) {
        if (this._marker) {
            if (this._fadeMarkersWhenStale) {
                //show the marker if its now present
                if(this.trackPresentAtTick(timestamp)) {
                    this._marker.setOpacity(1);
                } else {
                    this._marker.setOpacity(0);
                }

                if(this.trackStaleAtTick(timestamp)) {
                    this._marker.setOpacity(0.25);
                }
            }
            if (this._orientIcon) {
                this._marker.setIconAngle(this.courseAtTime(timestamp));
            }
            const index = this._geoJSON.geometry.coordinates.findIndex((f, i) => {
              let currLatLng = new L.LatLng(f[1], f[0]);
              return currLatLng.equals(latLng);
            });
            this._marker.move(latLng, transitionTime, index);
        }
    },
    getMarker: function() {
        return this._marker;
    }
});

L.Playback = L.Playback || {};
L.Playback.TrackController = L.Class.extend({
    initialize : function(map, tracks, options) {
        this.options = options || {};
        this._map = map;
        this._tracks = [];
        // initialize tick points
        this.setTracks(tracks);
    },
    clearTracks: function() {
        while (this._tracks.length > 0) {
            var track = this._tracks.pop();
            var marker = track.getMarker();

            if (marker){
                this._map.removeLayer(marker);
            }
        }
    },
    setTracks : function(tracks) {
        // reset current tracks
        this.clearTracks();
        this.addTracks(tracks);
    },
    addTracks : function(tracks) {
        // return if nothing is set
        if (!tracks) {
            return;
        }

        if (tracks instanceof Array) {
            for (var i = 0, len = tracks.length; i < len; i++) {
                this.addTrack(tracks[i]);
            }
        } else {
            this.addTrack(tracks);
        }
    },
    addTrack : function(track, timestamp) {
        if (!track) {
            return;
        }
        var marker = track.setMarker(timestamp, this.options);
        if (marker) {
            marker.addTo(this._map);
            this._tracks.push(track);
        }
    },
    tock : function(timestamp, transitionTime) {
        for (var i = 0, len = this._tracks.length; i < len; i++) {
            var lngLat = this._tracks[i].tick(timestamp);
            var latLng = new L.LatLng(lngLat[1], lngLat[0]);
            this._tracks[i].moveMarker(latLng, transitionTime, timestamp);
        }
    },
    getStartTime : function() {
        var earliestTime = 0;

        if (this._tracks.length > 0) {
            earliestTime = this._tracks[0].getStartTime();
            for (var i = 1, len = this._tracks.length; i < len; i++) {
                var t = this._tracks[i].getStartTime();
                if (t < earliestTime) {
                    earliestTime = t;
                }
            }
        }

        return earliestTime;
    },
    getEndTime : function() {
        var latestTime = 0;

        if (this._tracks.length > 0){
            latestTime = this._tracks[0].getEndTime();
            for (var i = 1, len = this._tracks.length; i < len; i++) {
                var t = this._tracks[i].getEndTime();
                if (t > latestTime) {
                    latestTime = t;
                }
            }
        }

        return latestTime;
    },
    getTracks : function() {
        return this._tracks;
    }
});

L.Playback = L.Playback || {};
L.Playback.Clock = L.Class.extend({
  initialize: function (trackController, callback, options) {
    this._trackController = trackController;
    this._callbacksArry = [];
    if (callback) this.addCallback(callback);
    L.setOptions(this, options);
    this._speed = this.options.speed;
    this._tickLen = this.options.tickLen;
    this._cursor = this._trackController.getStartTime();
    this._transitionTime = this._tickLen / this._speed;
  },
  _tick: function (self) {
    self._trackController.tock(self._cursor, self._transitionTime);
    if (self._cursor >= self._trackController.getEndTime()) {
      self.setCursor(self._trackController.getEndTime());
      self.stop();
    } else {
      self._cursor += self._tickLen;
    }
    self._callbacks(self._cursor);
  },
  _callbacks: function(cursor) {
    var arry = this._callbacksArry;
    for (var i=0, len=arry.length; i<len; i++) {
      arry[i](cursor);
    }
  },

  addCallback: function(fn) {
    this._callbacksArry.push(fn);
  },
  start: function () {
    if (this.isPlaying()) return;
    if (this._cursor >= this._trackController.getEndTime())
        this.setCursor(this._trackController.getStartTime());
    this.playControl._button.innerHTML = this.options.stopCommand ? this.options.stopCommand : this.playControl.options.stopCommand;
    this._intervalID = window.setInterval(
      this._tick,
      this._transitionTime,
      this);
  },
  stop: function () {
    if (!this.isPlaying()) return;
    clearInterval(this._intervalID);
    this._intervalID = null;
    this.playControl._button.innerHTML = this.options.playCommand ? this.options.playCommand : this.playControl.options.playCommand;
  },
  getSpeed: function() {
    return this._speed;
  },
  isPlaying: function() {
    return this._intervalID ? true : false;
  },
  setSpeed: function (speed) {
    this._speed = speed;
    this._transitionTime = this._tickLen / speed;
    if (this.isPlaying()) {
      this.stop();
      this.start();
    }
  },
  setCursor: function (ms) {
    var time = parseInt(ms);
    if (!time) return;
    var mod = time % this._tickLen;
    if (mod !== 0) {
      time += this._tickLen - mod;
    }
    this._cursor = time;
    this._trackController.tock(this._cursor, 0);
    this._callbacks(this._cursor);
  },
  getTime: function() {
    return this._cursor;
  },
  getStartTime: function() {
    return this._trackController.getStartTime();
  },
  getEndTime: function() {
    return this._trackController.getEndTime();
  },
  getTickLen: function() {
    return this._tickLen;
  }
});

// Simply shows all of the track points as circles.
// TODO: Associate circle color with the marker color.

L.Playback = L.Playback || {};
L.Playback.TracksLayer = L.Class.extend({
    initialize : function (map, options) {
        var layer_options = options.layer || {};

        if (jQuery.isFunction(layer_options)){
            layer_options = layer_options(feature);
        }

        options.tracksLayerCaption = options.tracksLayerCaption || 'GPS Tracks';

        if (!layer_options.pointToLayer) {
            layer_options.pointToLayer = function (featureData, latlng) {
                return new L.CircleMarker(latlng, { radius : 5 });
            };
        }

        this.layer = new L.GeoJSON(null, layer_options);

        var overlayControl = {};
        overlayControl[options.tracksLayerCaption] = this.layer;

        L.control.layers(null, overlayControl, {
            collapsed : false
        }).addTo(map);
    },
    // clear all geoJSON layers
    clearLayer : function(){
        for (var i in this.layer._layers) {
            this.layer.removeLayer(this.layer._layers[i]);
        }
    },
    // add new geoJSON layer
    addLayer : function(geoJSON) {
        this.layer.addData(geoJSON);
    }
});

L.Playback = L.Playback || {};
L.Playback.DateControl = L.Control.extend({
    options: {
        position: 'bottomleft',
        locale: {
          locale: 'US-en',
          options: {}
        },
        dateFormatFn: L.Playback.Util.DateStr,
        timeFormatFn: L.Playback.Util.TimeStr
    },

    initialize: function (playback, options) {
      L.setOptions(this, options);
      this.playback = playback;
    },
    onAdd: function (map) {
        this._container = L.DomUtil.create('div', 'leaflet-control-layers leaflet-control-layers-expanded');

        var self = this;
        var playback = this.playback;
        var time = playback.getTime();

        var datetime = L.DomUtil.create('div', 'datetimeControl', this._container);

        // date time
        this._date = L.DomUtil.create('p', '', datetime);
        this._time = L.DomUtil.create('p', '', datetime);

        this._date.innerHTML = this.options.dateFormatFn(time, this.options.locale);
        this._time.innerHTML = this.options.timeFormatFn(time, this.options.locale);

        // setup callback
        playback.addCallback(function (ms) {
            self._date.innerHTML = self.options.dateFormatFn(ms, self.options.locale);
            self._time.innerHTML = self.options.timeFormatFn(ms, self.options.locale);
        });

        return this._container;
    }
});
L.Playback.PlayControl = L.Control.extend({
    options : {
        position : 'bottomright',
        playCommand : 'Play',
        stopCommand : 'Stop'
    },
    initialize : function (playback, options) {
        L.setOptions(this, options);
        this.playback = playback;
    },
    onAdd : function (map) {
        this._container = L.DomUtil.create('div', 'leaflet-control-layers leaflet-control-layers-expanded');

        var self = this;
        var playback = this.playback;
        playback.setSpeed(this.playback._speed);

        var playControl = L.DomUtil.create('div', 'playControl', this._container);

        this._button = L.DomUtil.create('button', '', playControl);
        this._button.innerHTML = this.options.playCommand;

        var stop = L.DomEvent.stopPropagation;
        L.DomEvent
          .on(this._button, 'click', stop)
          .on(this._button, 'mousedown', stop)
          .on(this._button, 'dblclick', stop)
          .on(this._button, 'click', L.DomEvent.preventDefault)
          .on(this._button, 'click', play, this);

        function play(){
            if (playback.isPlaying()) {
                playback.stop();
            }
            else {
                playback.start();
            }
        }

        return this._container;
    }
});
L.Playback.SliderControl = L.Control.extend({
    options : {
        position : 'bottomleft'
    },
    initialize : function (playback) {
        this.playback = playback;
    },
    onAdd : function (map) {
        this._container = L.DomUtil.create('div', 'leaflet-control-layers leaflet-control-layers-expanded');

        var self = this;
        var playback = this.playback;

        // slider
        this._slider = L.DomUtil.create('input', 'slider', this._container);
        this._slider.type = 'range';
        this._slider.min = playback.getStartTime();
        this._slider.max = playback.getEndTime();
        this._slider.value = playback.getTime();

        var stop = L.DomEvent.stopPropagation;
        L.DomEvent
          .on(this._slider, 'click', stop)
          .on(this._slider, 'mousedown', stop)
          .on(this._slider, 'dblclick', stop)
          .on(this._slider, 'click', L.DomEvent.preventDefault)
          .on(this._slider, 'change', onSliderChange, this)
          .on(this._slider, 'mousedown', L.DomEvent.stopPropagation)

        mouseMoveWhilstDown(this._slider, onSliderChange)

        function onSliderChange(e) {
          var val = Number(e.target.value);
          playback.setCursor(val);
        }
        function mouseMoveWhilstDown(target, whileMove) {
            var endMove = function () {
              map.dragging.enable();
              window.removeEventListener('mousemove', whileMove);
              window.removeEventListener('mouseup', endMove);
            };

            target.addEventListener('mousedown', function (event) {
                map.dragging.disable()
                event.stopPropagation(); // remove if you do want it to propagate ..
                window.addEventListener('mousemove', whileMove);
                window.addEventListener('mouseup', endMove);
            });
        }

        playback.addCallback(function (ms) {
            self._slider.value = ms;
        });

        map.on('playback:add_tracks', function() {
            self._slider.min = playback.getStartTime();
            self._slider.max = playback.getEndTime();
            self._slider.value = playback.getTime();
        });

        return this._container;
    }
});

L.Playback = L.Playback.Clock.extend({
        statics : {
            MoveableMarker : L.Playback.MoveableMarker,
            Track : L.Playback.Track,
            TrackController : L.Playback.TrackController,
            Clock : L.Playback.Clock,
            Util : L.Playback.Util,

            TracksLayer : L.Playback.TracksLayer,
            PlayControl : L.Playback.PlayControl,
            DateControl : L.Playback.DateControl,
            SliderControl : L.Playback.SliderControl
        },
        options : {
            tickLen: 250,
            speed: 1,
            maxInterpolationTime: 5*60*1000, // 5 minutes

            tracksLayer : true,

            playControl: false,
            dateControl: false,
            sliderControl: false,

            // options
            layer: {
                // pointToLayer(featureData, latlng)
            },

            marker : {
                // getPopup(feature)
            }
        },
        initialize : function (map, geoJSON, callback, options) {
            L.setOptions(this, options);

            this._map = map;
            this._trackController = new L.Playback.TrackController(map, null, this.options);
            L.Playback.Clock.prototype.initialize.call(this, this._trackController, callback, this.options);

            if (this.options.tracksLayer) {
                this._tracksLayer = new L.Playback.TracksLayer(map, options);
            }

            this.setData(geoJSON);

            if (this.options.playControl) {
                this.playControl = new L.Playback.PlayControl(this, options);
                this.playControl.addTo(map);
            }

            if (this.options.sliderControl) {
                this.sliderControl = new L.Playback.SliderControl(this);
                this.sliderControl.addTo(map);
            }

            if (this.options.dateControl) {
                this.dateControl = new L.Playback.DateControl(this, options);
                this.dateControl.addTo(map);
            }
        },
        clearData : function(){
            this._trackController.clearTracks();
            if (this._tracksLayer) {
                this._tracksLayer.clearLayer();
            }
        },
        setData : function (geoJSON) {
            this.clearData();
            this.addData(geoJSON, this.getTime());
            this.setCursor(this.getStartTime());
        },
        // TODO - bad implementation
        addData : function (geoJSON, ms) {
            // return if data not set
            if (!geoJSON) {
                return;
            }

            if (geoJSON instanceof Array) {
                for (var i = 0, len = geoJSON.length; i < len; i++) {
                    this._trackController.addTrack(new L.Playback.Track(geoJSON[i], this.options), ms);
                }
            } else {
                this._trackController.addTrack(new L.Playback.Track(geoJSON, this.options), ms);
            }

            this._map.fire('playback:add_tracks');

            if (this.options.tracksLayer) {
                this._tracksLayer.addLayer(geoJSON);
            }
        },
        destroy: function() {
            this.clearData();
            if (this.playControl) {
                this._map.removeControl(this.playControl);
            }
            if (this.sliderControl) {
                this._map.removeControl(this.sliderControl);
            }
            if (this.dateControl) {
                this._map.removeControl(this.dateControl);
            }
        }
});

L.Map.addInitHook(function () {
    if (this.options.playback) {
        this.playback = new L.Playback(this);
    }
});

L.playback = function (map, geoJSON, callback, options) {
    return new L.Playback(map, geoJSON, callback, options);
};
return L.Playback;

}));
