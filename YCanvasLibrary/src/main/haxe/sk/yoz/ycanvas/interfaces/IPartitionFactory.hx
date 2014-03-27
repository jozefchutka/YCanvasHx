package sk.yoz.ycanvas.interfaces;

interface IPartitionFactory
{
	function create(x:Int, y:Int, layer:ILayer):IPartition;
	function disposePartition(partition:IPartition):Void;
}