(function () {
    L.HistoryControl = L.Control.extend({
        options: {
            position: 'topright',
            maxMovesToSave: 10, //set to 0 for unlimited
            useExternalControls: false, //set to true to hide buttons on map and use your own. Can still use goBack, goForward, and allow this to take care of storing history.
            backImage: 'fa fa-caret-left',
            backText: '',
            backTooltip: 'Go to Previous Extent',
            backImageBeforeText: true,
            forwardImage: 'fa fa-caret-right',
            forwardText: '',
            forwardTooltip: 'Go to Next Extent',
            forwardImageBeforeText: false,
            orientation: 'horizontal',
            shouldSaveMoveInHistory: function(zoomCenter) { return true; } //by default save everything
        },
        initialize: function(options) {
            L.Util.setOptions(this, options);

            this._state.maxMovesToSave = this.options.maxMovesToSave;
        },
        onAdd: function(map) {
            this._map = map;

            var container = L.DomUtil.create('div', 'history-control leaflet-bar leaflet-control ' + this.options.orientation);
            if(!this.options.useExternalControls) {
                this._backButton = this._createButton('back', container, this.goBack, this);
                this._forwardButton = this._createButton('forward', container, this.goForward, this);
            }
            this._updateDisabled();
            this._addMapListeners();

            return container;
        },
        onRemove: function(map) {
            map.off('movestart');
        },
        performActionWithoutTriggeringEvent: function(action) {
            this._state.ignoringEvents = true;
            if(typeof (action) === 'function') {
                action();
            }
        },
        moveWithoutTriggeringEvent: function(zoomCenter) {
            var _this = this;
            this.performActionWithoutTriggeringEvent(function() {
                _this._map.setView(zoomCenter.centerPoint, zoomCenter.zoom);
            });
        },
        goBack: function() {
            return this._invokeBackOrForward('historyback', this._state.history, this._state.future);
        },
        goForward: function() {
            return this._invokeBackOrForward('historyforward', this._state.future, this._state.history);
        },
        clearHistory: function() {
            this._state.history.items = [];
            this._updateDisabled();
        },
        clearFuture: function() {
            this._state.future.items = [];
            this._updateDisabled();
        },
        _map: null,
        _backButton: null,
        _forwardButton: null,
        _state: {
            backDisabled: null,
            forwardDisabled: null,
            ignoringEvents: false,
            maxMovesToSave: 0,
            history: {
                items: []
            },
            future: {
                items: []
            }
        },
        _createButton: function (name, container, action, _this) {
            var text = this.options[name + 'Text'] || '';
            var imageClass = this.options[name + 'Image'] || '';
            var tooltip = this.options[name + 'Tooltip'] || '';
            var button = L.DomUtil.create('a', 'history-' + name + '-button', container);
            if(imageClass) {
                var imageElement = '<i class="' + imageClass + '"></i>';
                if(this.options[name + 'ImageBeforeText']) {
                    text = imageElement + ' ' + text;
                }
                else {
                    text += ' ' + imageElement;
                }
            }
            button.innerHTML = text;
            button.href = '#';
            button.title = tooltip;

            var stop = L.DomEvent.stopPropagation;

            L.DomEvent
                .on(button, 'click', stop)
                .on(button, 'mousedown', stop)
                .on(button, 'dblclick', stop)
                .on(button, 'click', L.DomEvent.preventDefault)
                .on(button, 'click', action, _this)
                .on(button, 'click', this._refocusOnMap, _this);

            return button;
        },
        _updateDisabled: function () {
            var backDisabled = (this._state.history.items.length === 0);
            var forwardDisabled = (this._state.future.items.length === 0);
            if(backDisabled !== this._state.backDisabled) {
                this._state.backDisabled = backDisabled;
                this._map.fire('historyback' + (backDisabled ? 'disabled' : 'enabled'));
            }
            if(forwardDisabled !== this._state.forwardDisabled) {
                this._state.forwardDisabled = forwardDisabled;
                this._map.fire('historyforward' + (forwardDisabled ? 'disabled' : 'enabled'));
            }
            if(!this.options.useExternalControls) {
                this._setButtonDisabled(this._backButton, backDisabled);
                this._setButtonDisabled(this._forwardButton, forwardDisabled);
            }
        },
        _setButtonDisabled: function(button, condition) {
            var className = 'leaflet-disabled';
            if(condition) {
                L.DomUtil.addClass(button, className);
            }
            else {
                L.DomUtil.removeClass(button, className);
            }
        },
        _pop: function(stack) {
            stack = stack.items;
            if(L.Util.isArray(stack) && stack.length > 0) {
                return stack.splice(stack.length - 1, 1)[0];
            }
            return undefined;
        },
        _push: function(stack, value) {
            var maxLength = this._state.maxMovesToSave;
            stack = stack.items;
            if(L.Util.isArray(stack)) {
                stack.push(value);
                if(maxLength > 0 && stack.length > maxLength) {
                    stack.splice(0, 1);
                }
            }
        },
        _invokeBackOrForward: function(eventName, stackToPop, stackToPushCurrent) {
            var response = this._popStackAndUseLocation(stackToPop, stackToPushCurrent);
            if(response) {
                this._map.fire(eventName, response);
                return true;
            }
            return false;
        },
        _popStackAndUseLocation : function(stackToPop, stackToPushCurrent) {
            //check if we can pop
            if(L.Util.isArray(stackToPop.items) && stackToPop.items.length > 0) {
                var current = this._buildZoomCenterObjectFromCurrent(this._map);
                //get most recent
                var previous =  this._pop(stackToPop);
                //save where we currently are in the 'other' stack
                this._push(stackToPushCurrent, current);
                this.moveWithoutTriggeringEvent(previous);

                return {
                    previousLocation: previous,
                    currentLocation: current
                };
            }
        },
        _buildZoomCenterObjectFromCurrent:function(map) {
            return new L.ZoomCenter(map.getZoom(), map.getCenter());
        },
        _addMapListeners: function() {
            var _this = this;
            this._map.on('movestart', function(e) {
                if(!_this._state.ignoringEvents) {
                    var current = _this._buildZoomCenterObjectFromCurrent(e.target);
                    if(_this.options.shouldSaveMoveInHistory(current)) {
                        _this._state.future.items = [];
                        _this._push(_this._state.history, current);
                    }
                } else {
                    _this._state.ignoringEvents = false;
                }

                _this._updateDisabled();
            });
        }
    });
}());
