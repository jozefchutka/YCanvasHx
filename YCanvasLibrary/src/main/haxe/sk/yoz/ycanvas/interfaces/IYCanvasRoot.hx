package sk.yoz.ycanvas.interfaces;

interface IYCanvasRoot
{
	var x(null, set):Float;
	var y(null, set):Float;
	var rotation(default, set):Float;
	var scale(default, set):Float;
	var layers(default, null):Array<ILayer>;

	function addLayer(layer:ILayer):Void;
	function removeLayer(layer:ILayer):Void;
	function dispose():Void;
}