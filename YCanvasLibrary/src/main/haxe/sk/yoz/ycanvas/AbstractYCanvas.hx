package sk.yoz.ycanvas;

import sk.yoz.math.FastCollisions;
import sk.yoz.math.Matrix;
import sk.yoz.valueObject.Point;
import sk.yoz.valueObject.Rectangle;
import sk.yoz.ycanvas.interfaces.ILayer;
import sk.yoz.ycanvas.interfaces.ILayerFactory;
import sk.yoz.ycanvas.interfaces.IPartition;
import sk.yoz.ycanvas.interfaces.IPartitionFactory;
import sk.yoz.ycanvas.interfaces.IYCanvasRoot;
import sk.yoz.ycanvas.valueObject.MarginPoints;

class AbstractYCanvas
{
	public var partitionFactory:IPartitionFactory;
	public var layerFactory:ILayerFactory;

	public var root(get, never):IYCanvasRoot;
	public var center(default, set):Point;
	public var rotation(default, set):Float = 0;
	public var scale(default, set):Float = 1;
	public var viewPort(default, set):Rectangle;
	public var layers(get, never):Array<ILayer>;

	public var conversionMatrix(get, never):Matrix;
	public var marginPoints(get, never):MarginPoints;

	private var marginOffset:Int = 0;
	private var cachedConversionMatrix:Matrix;
	private var cachedMarginPoints:MarginPoints;

	private var _root:IYCanvasRoot;

	public function new(viewPort:Rectangle)
	{
		center = new Point(0, 0);
		this.viewPort = viewPort;
	}

	private function set_viewPort(value:Rectangle):Rectangle
	{
		viewPort = value;
		invalidateTransformationCache();
		centerRoot();
		return value;
	}

	private function set_center(value:Point):Point
	{
		center = value;
		if(layers != null)
			for(layer in layers)
				centerLayer(layer);
		invalidateTransformationCache();
		return value;
	}

	private function set_rotation(value:Float):Float
	{
		rotation = root.rotation = value;
		invalidateTransformationCache();
		return value;
	}

	private function set_scale(value:Float):Float
	{
		scale = root.scale = value;
		for(layer in layers)
			scaleLayer(layer);
		invalidateTransformationCache();
		return value;
	}

	private function get_root():IYCanvasRoot
	{
		return _root;
	}

	private function get_layers():Array<ILayer>
	{
		return root == null ? null : root.layers;
	}

	private function get_conversionMatrix():Matrix
	{
		if(cachedConversionMatrix != null)
			return cachedConversionMatrix;

		cachedConversionMatrix = getConversionMatrix(center, scale, rotation, viewPort);
		return cachedConversionMatrix;
	}

	private function get_marginPoints():MarginPoints
	{
		if(cachedMarginPoints != null)
			return cachedMarginPoints;

		cachedMarginPoints = getMarginPoints(viewPort, marginOffset);
		return cachedMarginPoints;
	}

	public function globalToCanvas(globalPoint:Point):Point
	{
		var point:Point = globalToViewPort(globalPoint);
		var matrix:Matrix = conversionMatrix.clone();
		matrix.invert();
		return matrix.transformPoint(point);
	}

	public function globalToViewPort(globalPoint:Point):Point
	{
		return new Point(globalPoint.x - viewPort.x, globalPoint.y - viewPort.y);
	}

	public function canvasToGlobal(canvasPoint:Point):Point
	{
		var matrix:Matrix = conversionMatrix.clone();
		var viewPortPoint:Point = matrix.transformPoint(canvasPoint);
		return viewPortToGlobal(viewPortPoint);
	}

	public function canvasToViewPort(canvasPoint:Point):Point
	{
		return globalToViewPort(canvasToGlobal(canvasPoint));
	}

	public function viewPortToCanvas(viewPortPoint:Point):Point
	{
		return globalToCanvas(viewPortToGlobal(viewPortPoint));
	}

	public function viewPortToGlobal(viewPortPoint:Point):Point
	{
		return new Point(viewPortPoint.x + viewPort.x, viewPortPoint.y + viewPort.y);
	}

	public function render():Void
	{
		var layer:ILayer = layerFactory.create(scale, center);
		scaleLayer(layer);
		centerLayer(layer);
		root.addLayer(layer);
		addPartitions(layer, getVisiblePartitions(layer));
	}

	public function dispose():Void
	{
		while(root.layers.length > 0)
			disposeLayer(root.layers[0]);
		root.dispose();
		_root = null;
		partitionFactory = null;
		layerFactory = null;
	}

	public function disposeLayer(layer:ILayer):Void
	{
		root.removeLayer(layer);
		layerFactory.disposeLayer(layer);
	}

	public function disposePartition(layer:ILayer, partition:IPartition):Void
	{
		layer.removePartition(partition);
		partitionFactory.disposePartition(partition);
	}

	public function getConversionMatrix(center:Point, scale:Float, rotation:Float, viewPort:Rectangle):Matrix
	{
		var result:Matrix = new Matrix();
		result.translate(-center.x, -center.y);
		result.scale(scale, scale);
		result.rotate(rotation % (Math.PI * 2));
		result.translate(viewPort.width / 2, viewPort.height / 2);
		return result;
	}

	public function getVisiblePartitions(layer:ILayer):Array<IPartition>
	{
		return getVisiblePartitionsByMarginPoints(layer, marginPoints);
	}

	public function getVisiblePartitionsByMarginPoints(layer:ILayer, marginPoints:MarginPoints):Array<IPartition>
	{
		var w:Int = layer.partitionWidth * layer.level;
		var h:Int = layer.partitionHeight * layer.level;
		var x0:Int = Math.floor(marginPoints.getMinX() / w) * w;
		var x1:Int = Math.floor(marginPoints.getMaxX() / w) * w;
		var y0:Int = Math.floor(marginPoints.getMinY() / h) * h;
		var y1:Int = Math.floor(marginPoints.getMaxY() / h) * h;
		var result:Array<IPartition> = new Array<IPartition>();

		var x:Int = x0;
		while(x <= x1)
		{
			var y:Int = y0;
			while(y <= y1)
			{
				if(isCollision(marginPoints, x, y, w, h))
				{
					var item:IPartition = layer.getPartition(x, y);
					if(item == null)
						item = partitionFactory.create(x, y, layer);
					result.push(item);
				}
				y += h;
			}
			x += w;
		}
		return result;
	}

	public function getMarginPoints(globalPoints:Rectangle, offset:Int=0):MarginPoints
	{
		var x0:Float = globalPoints.left - offset;
		var x1:Float = globalPoints.right + offset;
		var y0:Float = globalPoints.top - offset;
		var y1:Float = globalPoints.bottom + offset;
		return MarginPoints.fromPoints(
			globalToCanvas(new Point(x0, y0)),
			globalToCanvas(new Point(x1, y0)),
			globalToCanvas(new Point(x1, y1)),
			globalToCanvas(new Point(x0, y1)));
	}

	public function isCollision(marginPoints:MarginPoints, x:Float, y:Float, width:Float, height:Float):Bool
	{
		return FastCollisions.rectangles(
			marginPoints.x1, marginPoints.y1, marginPoints.x2, marginPoints.y2,
			marginPoints.x3, marginPoints.y3, marginPoints.x4, marginPoints.y4,
			x, y, x + width, y, x + width, y + height, x, y + height);
	}

	private function centerRoot():Void
	{
		root.x = viewPort.width / 2;
		root.y = viewPort.height / 2;
	}

	private function centerLayer(layer:ILayer):Void
	{
		layer.center = center;
	}

	private function scaleLayer(layer:ILayer):Void
	{
		layer.scale = layer.level;
	}

	private function addPartitions(layer:ILayer, partitions:Array<IPartition>):Void
	{
		for(partition in partitions)
			layer.addPartition(partition);
	}

	private function invalidateTransformationCache():Void
	{
		cachedConversionMatrix = null;
		cachedMarginPoints = null;
	}
}