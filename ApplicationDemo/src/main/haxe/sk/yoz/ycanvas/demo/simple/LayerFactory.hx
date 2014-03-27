package sk.yoz.ycanvas.demo.simple;

import sk.yoz.ycanvas.interfaces.ILayer;
import sk.yoz.valueObject.Point;
import sk.yoz.ycanvas.interfaces.IPartitionFactory;
import sk.yoz.ycanvas.interfaces.ILayerFactory;

class LayerFactory implements ILayerFactory
{
	private var layers:Array<Layer>;

	public function new(partitionFactory:IPartitionFactory)
	{
		layers = [];

		var level:Int = 1;
		while(level <= 32768)
		{
			layers.push(new Layer(level, partitionFactory));
			level *= 2;
		}
	}

	public function create(scale:Float, center:Point):ILayer
	{
		return getLayerByScale(scale);
	}

	public function disposeLayer(layer:ILayer):Void
	{
		cast(layer, Layer).dispose();
	}

	private function getLayerByScale(scale:Float):Layer
	{
		return layers[getLayerIndex(scale)];
	}

	private function getLayerIndex(scale:Float):Int
	{
		var zoom:Float = 1 / scale;
		var length:Int = layers.length;
		var i:Int = 0;
		while(i < length)
		{
			if(zoom < 1.5 * (1<<i))
				break;
			i++;
		}
		return Std.int(Math.min(length - 1, i));
	}
}