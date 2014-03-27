package sk.yoz.ycanvas.demo.simple;

import sk.yoz.math.Matrix;
import sk.yoz.ycanvas.impl.html.Image;
import sk.yoz.ycanvas.impl.html.interfaces.IPartitionHtml;
import sk.yoz.ycanvas.interfaces.ILayer;

class Partition implements IPartitionHtml
{
	public var layer(default, null):ILayer;
	public var x(default, null):Int;
	public var y(default, null):Int;
	public var content(default, null):Image;
	public var expectedWidth(get, null):Int;
	public var expectedHeight(get, null):Int;
	public var concatenatedMatrix(get, null):Matrix;
	public var url(get, never):String;
	public var loaded(get, never):Bool = false;
	public var loading(default, null):Bool = false;

	private var error:Bool;
	private var contentLoaded:Bool;

	public function new(layer:ILayer, x:Int, y:Int)
	{
		this.layer = layer;
		this.x = x;
		this.y = y;

		content = new Image();
		content.x = x;
		content.y = y;
		content.element.addEventListener("load", onLoadComplete);
		content.element.addEventListener("error", onLoadError);
	}

	private function get_expectedWidth():Int
	{
		return 256;
	}

	private function get_expectedHeight():Int
	{
		return 256;
	}

	private function get_concatenatedMatrix():Matrix
	{
		return content.getTransformationMatrix(content.root);
	}

	private function get_loaded():Bool
	{
		return contentLoaded || error;
	}

	private function get_url():String
	{
		var level:Int = 18 - getPow(layer.level);
		var x:Int = Std.int(this.x / expectedWidth / layer.level);
		var y:Int = Std.int(this.y / expectedHeight / layer.level);
		var server:String = getServer(Std.int(Math.abs(x + y) % 3));
		var result:String = "http://" + server + ".tile.openstreetmap.org/"
		+ level + "/" + x + "/" + y + ".png";
		return result;
	}

	public function load():Void
	{
		content.src = url;
		contentLoaded = false;
		loading = true;
	}

	public function stopLoading():Void
	{
		if(!loading)
			return;

		content.src = null;
		loading = false;
		contentLoaded = false;
	}

	public function dispose():Void
	{
		stopLoading();
	}

	public function toString():String
	{
		return "Partition: [x:" + x + ", y:" + y + "]";
	}

	private function getPow(value:Int):Int
	{
		var i:Int = 0;
		while(value > 1)
		{
			value = Std.int(value / 2);
			i++;
		}
		return i;
	}

	private function getServer(value:Int):String
	{
		if(value == 1)
			return "a";
		if(value == 2)
			return "b";
		return "c";
	}

	private function onLoadComplete(event:Dynamic):Void
	{
		loading = false;
		contentLoaded = true;
	}

	private function onLoadError(event:Dynamic):Void
	{
		error = true;
		stopLoading();
	}
}