package sk.yoz.ycanvas.demo.simple;

import sk.yoz.ycanvas.impl.html.interfaces.IPartitionHtml;
import sk.yoz.ycanvas.interfaces.IPartition;
import sk.yoz.ycanvas.impl.html.Sprite;
import sk.yoz.valueObject.Point;
import sk.yoz.ycanvas.interfaces.IPartitionFactory;

import sk.yoz.ycanvas.impl.html.interfaces.ILayerHtml;

class Layer implements ILayerHtml
{
	public var center(default, set):Point;
	public var scale(default, set):Float;
	public var level(default, null):Int;
	public var content(default, null):Sprite;
	public var partitions(default, null):Array<IPartition>;
	public var partitionWidth(get, null):Int;
	public var partitionHeight(get, null):Int;

	private var partitionFactory:IPartitionFactory;

	public function new(level:Int, partitionFactory:IPartitionFactory)
	{
		this.level = level;
		this.partitionFactory = partitionFactory;
		content = new Sprite();
		partitions = [];
	}

	private function set_center(value:Point):Point
	{
		center = value;
		for(partition in partitions)
			positionPartition(partition);
		return value;
	}

	private function set_scale(value:Float):Float
	{
		content.scaleX = content.scaleY = value;
		return value;
	}

	public function get_partitionWidth():Int
	{
		return 256;
	}

	public function get_partitionHeight():Int
	{
		return 256;
	}

	public function addPartition(partition:IPartition):Void
	{
		if(Lambda.indexOf(partitions, partition) != -1)
			return;

		partitions.push(partition);
		positionPartition(partition);
		content.addChild(cast(partition, IPartitionHtml).content);
	}

	public function getPartition(x:Int, y:Int):IPartition
	{
		for(partition in partitions)
			if(partition.x == x && partition.y == y)
				return partition;
		return null;
	}

	public function removePartition(partition:IPartition):Void
	{
		var partitionHtml:IPartitionHtml = cast partition;

		if(partitionHtml.content != null)
			content.removeChild(partitionHtml.content);
		var index:Int = Lambda.indexOf(partitions, partition);
		if(index != -1)
			partitions.splice(index, 1);
	}

	public function toString():String
	{
		return "Layer: [level:" + level + "]";
	}

	public function dispose():Void
	{
		if(partitions.length == 0)
			return;

		var partition:IPartition;
		var list:Array<IPartition> = partitions.concat([]);
		for(partition in list)
		{
			removePartition(partition);
			partitionFactory.disposePartition(partition);
		}
	}

	private function positionPartition(partition:IPartition):Void
	{
		var partitionHtml:IPartitionHtml = cast partition;
		partitionHtml.content.x = (partition.x - center.x) / level;
		partitionHtml.content.y = (partition.y - center.y) / level;
	}
}