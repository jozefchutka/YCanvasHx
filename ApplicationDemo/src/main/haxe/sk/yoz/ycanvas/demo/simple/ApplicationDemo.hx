package sk.yoz.ycanvas.demo.simple;

import js.html.MouseEvent;
import sk.yoz.ycanvas.utils.TransformationUtils;
import js.Browser;

import sk.yoz.ycanvas.interfaces.IPartition;
import sk.yoz.ycanvas.utils.ILayerUtils;
import sk.yoz.ycanvas.utils.IPartitionUtils;
import sk.yoz.valueObject.Point;
import sk.yoz.ycanvas.impl.html.YCanvasRootHtml;
import sk.yoz.ycanvas.interfaces.IYCanvasRoot;
import sk.yoz.valueObject.Rectangle;
import sk.yoz.ycanvas.impl.html.YCanvasHtml;

class ApplicationDemo
{
	private var canvas:YCanvasHtml;
	private var position:Point;
	private var viewPort(get, never):Rectangle;

	public static function main()
	{
		new ApplicationDemo();
	}

	private function new()
	{
		canvas = new YCanvasHtml(viewPort);
		canvas.partitionFactory = new PartitionFactory();
		canvas.layerFactory = new LayerFactory(canvas.partitionFactory);

		var root = cast(canvas.root, YCanvasRootHtml);
		Browser.document.body.appendChild(root.element);

		canvas.center = new Point(35e6, 25e6);
		canvas.scale = 1 / 16384;
		render();

		Browser.document.addEventListener("mousedown", onMouseDown);
		Browser.document.addEventListener("mousewheel", onMouseWheel);
		Browser.document.addEventListener("DOMMouseScroll", onMouseWheel);
		Browser.window.addEventListener("resize", onResize);
	}

	private function get_viewPort():Rectangle
	{
		return new Rectangle(0, 0, Browser.document.body.clientWidth, Browser.document.body.clientHeight);
	}

	private function render():Void
	{
		canvas.render();
		IPartitionUtils.disposeInvisible(canvas);
		ILayerUtils.disposeEmpty(canvas);

		var main:Layer = cast canvas.layers[canvas.layers.length - 1];
		for(layer in canvas.layers)
			(layer == main) ? startLoading(cast layer) : stopLoading(cast layer);
	}

	private function startLoading(layer:Layer):Void
	{
		var list:Array<IPartition> = layer.partitions;
		for(i in 0...list.length)
		{
			var partition:Partition = cast list[i];
			if(!partition.loaded && !partition.loaded)
				partition.load();
		}
	}

	private function stopLoading(layer:Layer):Void
	{
		var list:Array<IPartition> = layer.partitions;
		for(i in 0...list.length)
		{
			var partition:Partition = cast list[i];
			if(partition.loading)
				partition.stopLoading();
		}
	}

	private function onResize(event:Dynamic):Void
	{
		canvas.viewPort = viewPort;
		render();
	}

	private function onMouseDown(event:Dynamic):Void
	{
		var mouseEvent:MouseEvent = cast event;
		Browser.document.addEventListener("mousemove", onMouseMove);
		Browser.document.addEventListener("mouseup", onMouseUp);
		position = canvas.globalToCanvas(new Point(mouseEvent.clientX, mouseEvent.clientY));
	}

	private function onMouseMove(event:Dynamic):Void
	{
		var mouseEvent:MouseEvent = cast event;
		var current:Point = canvas.globalToCanvas(new Point(mouseEvent.clientX, mouseEvent.clientY));
		var center:Point = new Point(
			canvas.center.x - current.x + position.x,
			canvas.center.y - current.y + position.y);
		TransformationUtils.moveTo(canvas, center);
		position = canvas.globalToCanvas(new Point(mouseEvent.clientX, mouseEvent.clientY));
		render();
	}

	private function onMouseUp(event:Dynamic):Void
	{
		Browser.document.removeEventListener("mousemove", onMouseMove);
		Browser.document.removeEventListener("mouseup", onMouseUp);
	}

	private function onMouseWheel(event:Dynamic):Void
	{
		var mouseEvent:MouseEvent = cast event;
		var mouseWheelDelta:Float = untyped mouseEvent.wheelDelta;
		if(mouseWheelDelta == null || mouseWheelDelta == 0)
			mouseWheelDelta = -mouseEvent.detail;
		var delta:Float = Math.max(-1, Math.min(1, mouseWheelDelta));

		TransformationUtils.scaleTo(canvas, canvas.scale * (delta > 0 ? 1.5 : 0.7),
		canvas.globalToCanvas(new Point(mouseEvent.clientX, mouseEvent.clientY)));
		render();
	}
}