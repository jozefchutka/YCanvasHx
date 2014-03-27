package sk.yoz.math;

import sk.yoz.valueObject.Point;

class GeometryMath
{
	public static inline function TO_RADIANS():Float
	{
		return Math.PI / 180;
	}

	public static inline function TO_DEGREEES():Float
	{
		return 180 / Math.PI;
	}

	public static function degreesToRadians(degrees:Float):Float
	{
		return degrees * TO_RADIANS();
	}

	public static function radiansToDegrees(radians:Float):Float
	{
		return radians * TO_DEGREEES();
	}

	public static function isLine(point1:Point, point2:Point,
		point3:Point, orderSensitive:Bool = true):Bool
	{
		var x1:Float = point1.x - point2.x;
		var x2:Float = point2.x - point3.x;
		var y1:Float = point1.y - point2.y;
		var y2:Float = point2.y - point3.y;

		if(orderSensitive && ((x1 > 0 && x2 < 0) || (x1 < 0 && x2 > 0)
			|| (y1 < 0 && y2 > 0) || (y1 < 0 && y2 > 0)))
			return false;
		else if(y2 == 0)
			return y1 == 0;
		else if(x2 == 0)
			return x1 == 0;
		else
			return x1 / x2 == y1 / y2;
	}

	public static function rotatePoint(source:Point, lock:Point,
		degrees:Float):Point
	{
		return rotatePointByRadians(source, lock, degrees * TO_RADIANS());
	}

	public static function rotatePointByRadians(source:Point, lock:Point,
		radians:Float):Point
	{
		var dx:Float = source.x - lock.x;
		var dy:Float = source.y - lock.y;
		var distance:Float = Math.sqrt(dx * dx + dy * dy);
		var rad:Float = radians + Math.atan2(dx, -dy);
		return new Point(
			Math.sin(rad) * distance + lock.x,
			-Math.cos(rad) * distance + lock.y);
	}

	public static function angleOf3Points(cx:Float, cy:Float,
		p0x:Float, p0y:Float, p1x:Float, p1y:Float):Float
	{
		var a:Float = Math.sqrt((cx - p0x) * (cx - p0x) + (cy - p0y) * (cy - p0y));
		var b:Float = Math.sqrt((p0x - p1x) * (p0x - p1x) + (p0y - p1y) * (p0y - p1y));
		var c:Float = Math.sqrt((p1x - cx) * (p1x - cx) + (p1y - cy) * (p1y - cy));
		return Math.acos(((a * a) + (c * c) - (b * b)) / (2 * a * c));
	}
}