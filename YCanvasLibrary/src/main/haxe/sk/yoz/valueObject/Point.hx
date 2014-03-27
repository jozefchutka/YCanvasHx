package sk.yoz.valueObject;

class Point
{
	public var x:Float;
	public var y:Float;

	public function new(x:Float=0, y:Float=0)
	{
		this.x = x;
		this.y = y;
	}

	public function clone():Point
	{
		return new Point(x, y);
	}

	public function toString():String
	{
		return "{x:" + x + ", y:" + y + "}";
	}
}