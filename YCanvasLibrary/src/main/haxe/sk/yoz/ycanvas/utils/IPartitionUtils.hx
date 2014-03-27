package sk.yoz.ycanvas.utils;

import sk.yoz.valueObject.Point;
import sk.yoz.ycanvas.AbstractYCanvas;
import sk.yoz.ycanvas.interfaces.ILayer;
import sk.yoz.ycanvas.interfaces.IPartition;
import sk.yoz.ycanvas.valueObject.LayerPartitions;

class IPartitionUtils
{
	private static inline var OVERLAP_ALL:Int = 0;
	private static inline var OVERLAP_LOWER:Int = 1;
	private static inline var OVERLAP_UPPER:Int = 2;

	public static function getOverlaping(canvas:AbstractYCanvas,
		layer:ILayer, partition:IPartition):Array<LayerPartitions>
	{
		return getOverlapingByMode(canvas, layer, partition, OVERLAP_ALL);
	}

	public static function getLower(canvas:AbstractYCanvas, layer:ILayer,
		partition:IPartition):Array<LayerPartitions>
	{
		return getOverlapingByMode(canvas, layer, partition, OVERLAP_LOWER);
	}

	public static function getUpper(canvas:AbstractYCanvas, layer:ILayer,
		partition:IPartition):Array<LayerPartitions>
	{
		return getOverlapingByMode(canvas, layer, partition, OVERLAP_UPPER);
	}

	private static  function getOverlapingByMode(canvas:AbstractYCanvas,
		layer:ILayer, partition:IPartition, mode:Int):Array<LayerPartitions>
	{
		var layers:Array<ILayer> = canvas.layers;
		var iLayer:ILayer;
		var iLength:Int;
		var iPartition:IPartition;
		var iPartitions:Array<IPartition>;
		var isLower:Bool = mode == OVERLAP_LOWER;
		var isUpper:Bool = mode == OVERLAP_UPPER;
		var list:Array<LayerPartitions> = [];
		var layerPartitions:LayerPartitions;
		for(i in 0...layers.length)
		{
			iLayer = layers[i];
			if(iLayer == layer
				|| (isLower && iLayer.level > layer.level)
				|| (isUpper && iLayer.level < layer.level))
				continue;

			iPartitions = iLayer.partitions.concat([]);
			iLength = iPartitions.length;
			layerPartitions = new LayerPartitions();
			layerPartitions.layer = iLayer;
			layerPartitions.partitions = [];
			list.push(layerPartitions);

			for(j in 0...iLength)
				{
				iPartition = iPartitions[j];
				if(isOverlaping(layer, partition, iLayer, iPartition))
					layerPartitions.partitions.push(iPartition);
			}
		}
		return list;
	}

	public static function disposeInvisible(canvas:AbstractYCanvas):Void
	{
		var layers:Array<ILayer> = canvas.layers;
		var layer:ILayer, partitions:Array<IPartition>;
		for(i in 0...layers.length)
		{
			layer = layers[i];
			partitions = getInvisible(canvas, layer);
			dispose(canvas, layer, partitions);
		}
	}

	public static function dispose(canvas:AbstractYCanvas, layer:ILayer, partitions:Array<IPartition>):Void
	{
		for(i in 0...partitions.length)
			canvas.disposePartition(layer, partitions[i]);
	}

	public static function diposeLayerPartitionsList(canvas:AbstractYCanvas,
		layerPartitions:Array<LayerPartitions>):Void
	{
		for(i in 0...layerPartitions.length)
			dispose(canvas, layerPartitions[i].layer, layerPartitions[i].partitions);
	}

	public static function getAt(canvas:AbstractYCanvas, point:Point):Array<LayerPartitions>
	{
		var layers:Array<ILayer> = canvas.layers;
		var layer:ILayer, partition:IPartition;
		var partitionsLength:Int;
		var layerPartitions:LayerPartitions;
		var list:Array<LayerPartitions> = [];
		for(i in 0...layers.length)
		{
			layer = layers[i];
			partitionsLength = layer.partitions.length;

			layerPartitions = new LayerPartitions();
			layerPartitions.layer = layers[i];
			layerPartitions.partitions = [];
			list.push(layerPartitions);

			for(j in 0...partitionsLength)
			{
				partition = layer.partitions[j];
				if(isOverlapingPoint(point, layer, partition))
					layerPartitions.partitions.push(partition);
			}
		}
		return list;
	}

	private static function isOverlaping(layer1:ILayer,
		partition1:IPartition, layer2:ILayer, partition2:IPartition):Bool
	{
		var lowLayer:ILayer = layer1;
		var lowPartition:IPartition = partition1;
		var upLayer:ILayer = layer2;
		var upPartition:IPartition = partition2;

		if(layer1.level > layer2.level)
		{
			lowLayer = layer2;
			lowPartition = partition2;
			upLayer = layer1;
			upPartition = partition1;
		}

		return lowPartition.x >= upPartition.x
			&& lowPartition.x < upPartition.x
				+ upPartition.expectedWidth * upLayer.level
			&& lowPartition.y >= upPartition.y
			&& lowPartition.y < upPartition.y
				+ upPartition.expectedHeight * upLayer.level;
	}

	private static function isOverlapingPoint(point:Point, layer:ILayer,
		partition:IPartition):Bool
	{
		return point.x >= partition.x
			&& point.x < partition.x
			+ partition.expectedWidth * layer.level
			&& point.y >= partition.y
			&& point.y < partition.y
			+ partition.expectedHeight * layer.level;
	}

	private static function getInvisible(canvas:AbstractYCanvas, layer:ILayer):Array<IPartition>
	{
		var w:Int = layer.partitionWidth * layer.level;
		var h:Int = layer.partitionHeight * layer.level;
		var partitions:Array<IPartition> = layer.partitions.concat([]);
		var partition:IPartition;
		var result:Array<IPartition> = [];
		for(i in 0...partitions.length)
		{
			partition = partitions[i];
			if(!canvas.isCollision(
				canvas.marginPoints, partition.x, partition.y, w, h))
				result.push(partition);
		}

		return result;
	}
}