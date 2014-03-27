package sk.yoz.ycanvas.demo.simple;

import sk.yoz.ycanvas.interfaces.ILayer;
import sk.yoz.ycanvas.interfaces.IPartition;
import sk.yoz.ycanvas.interfaces.IPartitionFactory;

class PartitionFactory implements IPartitionFactory
{
	public function new()
	{
	}

	public function create(x:Int, y:Int, layer:ILayer):IPartition
	{
		return new Partition(layer, x, y);
	}

	public function disposePartition(partition:IPartition):Void
	{
		cast(partition, Partition).dispose();
	}
}