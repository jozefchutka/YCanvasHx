package sk.yoz.ycanvas.impl.html.interfaces;

import sk.yoz.ycanvas.interfaces.ILayer;

interface ILayerHtml extends ILayer
{
	var content(default, null):Sprite;
}