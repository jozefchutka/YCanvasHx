package sk.yoz.ycanvas.impl.html;

import sk.yoz.ycanvas.impl.html.interfaces.ILayerHtml;
import sk.yoz.ycanvas.interfaces.ILayer;

import sk.yoz.ycanvas.interfaces.IYCanvasRoot;

class YCanvasRootHtml extends Sprite implements IYCanvasRoot
{
	public var layers(default, null):Array<ILayer>;
	public var scale(default, set):Float;

	public function new()
	{
		layers = [];

		super();
	}

	private function set_scale(value:Float):Float
	{
		scaleX = scaleY = value;
		return value;
	}

	public function addLayer(layer:ILayer):Void
	{
		var layerHtml:ILayerHtml = cast layer;
		var index:Int = Lambda.indexOf(layers, layer);
		if(index == -1)
		{
			addLayerChild(layerHtml.content);
			layers.push(layer);
		}
		else if(index != layers.length - 1)
		{
			setLayerChildIndex(layerHtml.content, layers.length - 1);
			layers.splice(index, 1);
			layers.push(layer);
		}
	}

	public function removeLayer(layer:ILayer):Void
	{
		var layerHtml:ILayerHtml = cast layer;
		removeLayerChild(layerHtml.content);

		var index:Int = Lambda.indexOf(layers, layer);
		layers.splice(index, 1);
	}

	public function dispose():Void
	{
	}

	private function addLayerChild(child:Sprite):Void
	{
		addChild(child);
	}

	private function setLayerChildIndex(child:Sprite, index:Int):Void
	{
		setChildIndex(child, index);
	}

	private function removeLayerChild(child:Sprite):Void
	{
		removeChild(child);
	}
}