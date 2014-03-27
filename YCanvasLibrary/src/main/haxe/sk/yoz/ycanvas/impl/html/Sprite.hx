package sk.yoz.ycanvas.impl.html;

import sk.yoz.math.Matrix;

import js.Browser;
import js.html.CSSStyleDeclaration;
import js.html.Document;
import js.html.Element;

class Sprite
{
	public var element(default, null):Element;

	public var x(default, set):Float = 0;
	public var y(default, set):Float = 0;
	public var width(default, set):Int = -1;
	public var height(default, set):Int = -1;
	public var scaleX(default, set):Float = 1;
	public var scaleY(default, set):Float = 1;
	public var rotation(default, set):Float;
	public var parent(default, null):Sprite;
	public var root(get, never):Sprite;
	public var transformationMatrix(get, never):Matrix;

	public function new()
	{
		createElement();
		scaleX = 1;
	}

	private function set_x(value:Float):Float
	{
		x = value;
		render();
		return value;
	}

	private function set_y(value:Float):Float
	{
		y = value;
		render();
		return value;
	}

	private function set_width(value:Int):Int
	{
		width = value;
		render();
		return value;
	}

	private function set_height(value:Int):Int
	{
		height = value;
		render();
		return value;
	}

	private function set_scaleX(value:Float):Float
	{
		scaleX = value;
		render();
		return value;
	}

	private function set_scaleY(value:Float):Float
	{
		scaleY = value;
		render();
		return value;
	}

	private function set_rotation(value:Float):Float
	{
		rotation = value;
		render();
		return value;
	}

	private function get_root():Sprite
	{
		var current:Sprite = this;
		while(current.parent != null)
			current = current.parent;
		return current;
	}

	private function get_transformationMatrix():Matrix
	{
		var cos:Float = Math.cos(rotation);
		var sin:Float = Math.sin(rotation);
		var a:Float   = scaleX *  cos;
		var b:Float   = scaleX *  sin;
		var c:Float   = scaleY * -sin;
		var d:Float   = scaleY *  cos;
		var tx:Float  = x * a - c;
		var ty:Float  = y * b - d;
		return new Matrix(a, b, c, d, tx, ty);
	}

	public function addChild(child:Sprite):Void
	{
		element.appendChild(child.element);
		child.parent = this;
	}

	public function setChildIndex(child:Sprite, index:Int):Void
	{
		element.insertBefore(child.element, element.childNodes[index + 1]);
		child.parent = this;
	}

	public function removeChild(child:Sprite):Void
	{
		element.removeChild(child.element);
		child.parent = null;
	}

	public function getTransformationMatrix(targetSpace:Sprite):Matrix
	{
		var result:Matrix = new Matrix();
		if(targetSpace == this)
			return result;

		if(targetSpace == parent || (targetSpace == null && parent == null))
		{
			result.copyFrom(transformationMatrix);
			return result;
		}

		var current:Sprite = this;
		while(current != targetSpace)
		{
			result.concat(current.transformationMatrix);
			current = current.parent;
		}
		return result;
	}

	private function createElement():Void
	{
		element = Browser.document.createElement("div");
		element.style.position = "absolute";
	}

	private function render():Void
	{
		element.style.width = width == -1 ? null : (width + "px");
		element.style.height = height == -1 ? null : (height + "px");

		//var transform:String = "translate3d(" + x + "px, " + y + "px, 0) scale3d(" + scaleX +", " + scaleY + ", 0)";
		var transform:String = "matrix3d("
			+ scaleX + ", 0, 0, 0, "
			+ "0, " + scaleY + ", 0, 0, "
			+ "0, 0, 1, 0, "
			+ x + ", " + y + ", 0, 1)";

		var style:CSSStyleDeclaration = element.style;
		untyped style.webkitTransform = transform;
		untyped style.MozTransform = transform;
		untyped style.msTransform = transform;
		untyped style.OTransform = transform;
		style.transform = transform;
	}
}