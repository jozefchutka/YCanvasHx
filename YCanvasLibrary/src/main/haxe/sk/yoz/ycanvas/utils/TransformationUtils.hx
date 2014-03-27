package sk.yoz.ycanvas.utils;

import sk.yoz.math.GeometryMath;
import sk.yoz.valueObject.Point;
import sk.yoz.ycanvas.AbstractYCanvas;

class TransformationUtils
{
	public static function moveTo(canvas:AbstractYCanvas, center:Point):Void
	{
		canvas.center = center;
	}

	public static function scaleTo(canvas:AbstractYCanvas, scale:Float, lock:Point=null):Void
	{
		if(lock == null)
			lock = canvas.center;

		var c:Float = 1 - canvas.scale / scale;
		canvas.center = new Point(
			canvas.center.x + (lock.x - canvas.center.x) * c,
			canvas.center.y + (lock.y - canvas.center.y) * c
		);
		canvas.scale = scale;
	}

	public static function rotateTo(canvas:AbstractYCanvas, rotation:Float, lock:Point=null):Void
	{
		if(lock == null)
			lock = canvas.center;

		var delta:Float = canvas.rotation - rotation;
		canvas.center = GeometryMath.rotatePointByRadians(canvas.center, lock, delta);
		canvas.rotation = rotation;
	}

	public static function moveRotateTo(canvas:AbstractYCanvas, center:Point, rotation:Float):Void
	{
		canvas.center = center;
		canvas.rotation = rotation;
	}

	public static function rotateScaleTo(canvas:AbstractYCanvas, rotation:Float, scale:Float, lock:Point=null):Void
	{
		if(lock == null)
			lock = canvas.center;

		var delta:Float = canvas.rotation - rotation;
		var center:Point = GeometryMath.rotatePointByRadians(
			canvas.center, lock, delta);
		var c:Float = 1 - canvas.scale / scale;
		center.x += (lock.x - center.x) * c;
		center.y += (lock.y - center.y) * c;

		canvas.center = center;
		canvas.rotation = rotation;
		canvas.scale = scale;
	}
}