package sk.yoz.ycanvas.interfaces;

import sk.yoz.math.Matrix;

interface IPartition
{
	var x(default, null):Int;
	var y(default, null):Int;
	var expectedWidth(get, null):Int;
	var expectedHeight(get, null):Int;
	var concatenatedMatrix(get, null):Matrix;

	function toString():String;
}