package sk.yoz.ycanvas.interfaces;

import sk.yoz.valueObject.Point;

interface ILayer
{
	var center(default, set):Point;
	var scale(default, set):Float;
	var level(default, null):Int;
	var partitions(default, null):Array<IPartition>;
	var partitionWidth(get, null):Int;
	var partitionHeight(get, null):Int;

	function addPartition(partition:IPartition):Void;
	function getPartition(x:Int, y:Int):IPartition;
	function removePartition(partition:IPartition):Void;
	function toString():String;
}