package sk.yoz.ycanvas.impl.html;

import sk.yoz.valueObject.Rectangle;
import sk.yoz.ycanvas.AbstractYCanvas;

class YCanvasHtml extends AbstractYCanvas
{
	public function new(viewPort:Rectangle)
	{
		super(viewPort);

		_root = new YCanvasRootHtml();
		centerRoot();
	}

	override function centerRoot():Void
	{
		if(root != null)
			super.centerRoot();
	}
}