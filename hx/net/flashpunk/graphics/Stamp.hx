package net.flashpunk.graphics;

import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import net.flashpunk.*;

/**
 * A simple non-transformed, non-animated graphic.
 */
class Stamp extends Graphic {
	public var source(get, set):BitmapData;

	/**
	 * Constructor.
	 * @param	source		Source image.
	 * @param	x			X offset.
	 * @param	y			Y offset.
	 */
	public function new(source:Dynamic, x:Int = 0, y:Int = 0) {
		super();
		// set the origin
		this.x = x;
		this.y = y;

		// set the graphic
		if (source == null) {
			return;
		}
		if (Std.is(source, Class)) {
			_source = FP.getBitmap(source);
		} else if (Std.is(source, BitmapData)) {
			_source = source;
		}
		if (_source != null) {
			_sourceRect = _source.rect;
		}
	}

	/** @private Renders the Graphic. */
	override public function render(point:Point, camera:Point):Void {
		if (_source == null) {
			return;
		}
		point.x += x - camera.x * scrollX;
		point.y += y - camera.y * scrollY;
		FP.buffer.copyPixels(_source, _sourceRect, point, null, null, true);
	}

	/**
	 * Source BitmapData image.
	 */
	private function get_source():BitmapData {
		return _source;
	}

	private function set_source(value:BitmapData):BitmapData {
		_source = value;
		if (_source != null) {
			_sourceRect = _source.rect;
		}
		return value;
	}

	// Stamp information.

	/** @private */
	private var _source:BitmapData;

	/** @private */
	private var _sourceRect:Rectangle;

	/** @private */
	private var _point:Point = FP.point;
}
