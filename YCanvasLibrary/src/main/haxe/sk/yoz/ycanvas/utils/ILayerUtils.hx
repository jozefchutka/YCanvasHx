package sk.yoz.ycanvas.utils;

import sk.yoz.ycanvas.AbstractYCanvas;
import sk.yoz.ycanvas.interfaces.ILayer;

class ILayerUtils
{
	public static function disposeDeep(canvas:AbstractYCanvas, depth:Int = 1):Void
	{
		var layers:Array<ILayer> = canvas.layers.concat([]);
		var length:Int = Std.int(Math.max(layers.length - depth, 0));
		for(i in 0...length)
			canvas.disposeLayer(layers[i]);
	}

	public static function disposeEmpty(canvas:AbstractYCanvas):Void
	{
		var layers:Array<ILayer> = canvas.layers.concat([]);
		for(i in 0...layers.length)
			if(layers[i].partitions.length == 0)
				canvas.disposeLayer(layers[i]);
	}
}