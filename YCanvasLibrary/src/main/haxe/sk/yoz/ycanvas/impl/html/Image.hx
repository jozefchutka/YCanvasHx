package sk.yoz.ycanvas.impl.html;

import js.Browser;

class Image extends Sprite
{
	public var src(default, set):String;

	private function set_src(value:String):String
	{
		cast(element, js.html.ImageElement).src = value;
		return value;
	}

	override function createElement():Void
	{
		element = Browser.document.createElement("img");
		element.style.position = "absolute";
	}
}