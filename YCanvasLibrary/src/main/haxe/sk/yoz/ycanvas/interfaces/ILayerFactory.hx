package sk.yoz.ycanvas.interfaces;

import sk.yoz.valueObject.Point;

interface ILayerFactory
{
	function create(scale:Float, center:Point):ILayer;
	function disposeLayer(layer:ILayer):Void;
}