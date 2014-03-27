package sk.yoz.ycanvas.valueObject;

import sk.yoz.valueObject.Point;

class MarginPoints
{
	public var x1:Float;
	public var y1:Float;
	public var x2:Float;
	public var y2:Float;
	public var x3:Float;
	public var y3:Float;
	public var x4:Float;
	public var y4:Float;

	public function new()
	{
	}

	public static function min(a:Float, b:Float, c:Float, d:Float):Float
	{
		return Math.min(Math.min(a, b), Math.min(c, d));
	}

	public static function max(a:Float, b:Float, c:Float, d:Float):Float
	{
		return Math.max(Math.max(a, b), Math.max(c, d));
	}

	public function getMinX():Float
	{
		return min(x1, x2, x3, x4);
	}

	public function getMaxX():Float
	{
		return max(x1, x2, x3, x4);
	}

	public function getMinY():Float
	{
		return min(y1, y2, y3, y4);
	}

	public function getMaxY():Float
	{
		return max(y1, y2, y3, y4);
	}

	public static function fromPoints(p1:Point, p2:Point, p3:Point, p4:Point):MarginPoints
	{
		var result:MarginPoints = new MarginPoints();
		result.x1 = p1.x;
		result.y1 = p1.y;
		result.x2 = p2.x;
		result.y2 = p2.y;
		result.x3 = p3.x;
		result.y3 = p3.y;
		result.x4 = p4.x;
		result.y4 = p4.y;
		return result;
	}
}