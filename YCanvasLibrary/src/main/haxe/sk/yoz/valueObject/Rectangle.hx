package sk.yoz.valueObject;

class Rectangle
{
	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;

	public var left(get, set):Float;
	public var right(get, set):Float;
	public var top(get, set):Float;
	public var bottom(get, set):Float;

	public function new(x:Float=0, y:Float=0, width:Float=0, height:Float=0)
	{
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	private function get_left():Float
	{
		return x;
	}

	private function set_left(value:Float):Float
	{
		x = value;
		return x;
	}

	private function get_top():Float
	{
		return y;
	}

	private function set_top(value:Float):Float
	{
		y = value;
		return y;
	}

	private function get_right():Float
	{
		return width + x;
	}

	private function set_right(value:Float):Float
	{
		width = value - x;
		return value;
	}

	private function get_bottom():Float
	{
		return height + y;
	}

	private function set_bottom(value:Float):Float
	{
		height = value - y;
		return value;
	}

	public function clone():Rectangle
	{
		return new Rectangle(x, y, width, height);
	}

	public function toString():String
	{
		return "{x:" + x + ", y:" + y + ", width:" + width + ", height:" + height + "}";
	}
}