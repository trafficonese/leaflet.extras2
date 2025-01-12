L.LayerGroup.Conditional = L.LayerGroup.extend({

    initialize: function (layers, options) {
		this._conditionalLayers = {};
        L.LayerGroup.prototype.initialize.call(this, layers, options);
	},

	// @method addConditionalLayer(conditionFunction: (object) => boolean, layer: Layer): this
	// Adds the given layer to the group with a condition.
	addConditionalLayer: function (conditionFunction, layer) {
		var id = this.getLayerId(layer);

		this._conditionalLayers[id] = {
            "condition": conditionFunction,
            "layer": layer,
            "active": false,
        }

        return this;
	},

	// @method removeConditionalLayer(layer: Layer): this
	// Removes the given conditional layer from the group.
	// @alternative
	// @method removeConditionalLayer(id: Number): this
	// Removes the conditional layer with the given internal ID from the group.
	removeConditionalLayer: function (layer) {
		var id = layer in this._conditionalLayers ? layer : this.getLayerId(layer);

		if (this._conditionalLayers[id] && this._conditionalLayers[id].active) {
			this.removeLayer(id);
		}

		delete this._conditionalLayers[id];

		return this;
	},

	// @method hasConditionalLayer(layer: Layer): Boolean
	// Returns `true` if the given layer is currently added to the group with a condition, regardless of whether it is active
	// @alternative
	// @method hasConditionalLayer(id: Number): Boolean
	// Returns `true` if the given internal ID is currently added to the group with a condition, regardless of whether it is active.
	hasConditionalLayer: function (layer) {
		if (!layer) { return false; }
		var layerId = typeof layer === 'number' ? layer : this.getLayerId(layer);
		return layerId in this._conditionalLayers;
	},

	// @method isConditionalLayerActive(layer: Layer): Boolean
	// Returns `true` if the given layer is currently added to the group with a condition, and is currently active
	// @alternative
	// @method hasConditionalLayer(id: Number): Boolean
	// Returns `true` if the given internal ID is currently added to the group with a condition, and is currently active.
	isConditionalLayerActive: function (layer) {
		if (!layer) { return false; }
		var layerId = typeof layer === 'number' ? layer : this.getLayerId(layer);
		return (layerId in this._conditionalLayers) && this._conditionalLayers[layerId].active;
	},


	// @method clearConditionalLayers(): this
	// Removes all the conditional layers from the group.
	clearConditionalLayers: function () {
        for (var i in this._conditionalLayers) {
    		this.removeConditionalLayer(i);
        }
		return this;
	},

    // @method getConditionalLayers(): Layer[]
	// Returns an array of all the conditional layers added to the group.
	getConditionalLayers: function () {
        var layers = [];
        for (var i in this._conditionalLayers) {
    		layers.push(this._conditionalLayers[i].layer);
        }
		return layers;
	},

    // @method updateConditionalLayers(o: object): this
	// Update the status of all conditional layers, passing an optional argument to each layer's condition function. 
    updateConditionalLayers: function(o) {
        for (var i in this._conditionalLayers) {
            var condLayer = this._conditionalLayers[i];
            var active = condLayer.condition(o);
            if (active && !condLayer.active) {
                this.addLayer(condLayer.layer);
            } else if (condLayer.active && !active) {
                this.removeLayer(condLayer.layer);
            }
            condLayer.active = active;
        }

        return this;
    }
});


// @factory L.layerGroup.Conditional(layers?: Layer[], options?: Object)
// Create a conditional layer group, optionally given an initial set of non-conditinoal layers and an `options` object.
L.layerGroup.conditional = function (layers, options) {
	return new L.LayerGroup.Conditional(layers, options);
};