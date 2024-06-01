package net.flashpunk.graphics;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.Dictionary;
import net.flashpunk.FP;
import net.flashpunk.Graphic;

/**
 * Creates a pre-rotated Image strip to increase runtime performance for rotating graphics.
 */
class PreRotation extends Image {
	/**
	 * Current angle to fetch the pre-rotated frame from.
	 */
	public var frameAngle:Float = 0;

	/**
	 * Constructor.
	 * @param	source			The source image to be rotated.
	 * @param	frameCount		How many frames to use. More frames result in smoother rotations.
	 * @param	smooth			Make the rotated graphic appear less pixelly.
	 */
	public function new(source:Class<Dynamic>, frameCount:Int = 36, smooth:Bool = false) {

		var r:BitmapData = Reflect.field(_rotated, Std.string(source));
		_frame = new Rectangle(0, 0, Reflect.field(_size, Std.string(source)), Reflect.field(_size, Std.string(source)));
		if (r == null)
			// produce a rotated bitmap strip
		{
			var temp:BitmapData = (Type.createInstance(source, [])).bitmapData;
			var size:Int = Reflect.setField(_size, Std.string(source), Math.ceil(FP.distance(0, 0, temp.width, temp.height)));
			_frame.width = _frame.height = size;
			var width:Int = as3hx.Compat.parseInt(_frame.width * frameCount);
			var height:Int = _frame.height;
			if (width > _MAX_WIDTH) {
				width = as3hx.Compat.parseInt(_MAX_WIDTH - (_MAX_WIDTH % _frame.width));
				height = as3hx.Compat.parseInt(Math.ceil(frameCount / (width / _frame.width)) * _frame.height);
			}
			r = new BitmapData(width, height, true, 0);
			var m:Matrix = FP.matrix;
			var a:Float = 0;
			var aa:Float = (Math.PI * 2) / -frameCount;
			var ox:Int = as3hx.Compat.parseInt(temp.width / 2);
			var oy:Int = as3hx.Compat.parseInt(temp.height / 2);
			var o:Int = as3hx.Compat.parseInt(_frame.width / 2);
			var x:Int = 0;
			var y:Int = 0;
			while (y < height) {
				while (x < width) {
					m.identity();
					m.translate(-ox, -oy);
					m.rotate(a);
					m.translate(o + x, o + y);
					r.draw(temp, m, null, null, null, smooth);
					x += _frame.width;
					a += aa;
				}
				x = 0;
				y += _frame.height;
			}
		}
		_source = r;
		_width = r.width;
		_frameCount = frameCount;
		super(_source, _frame);
	}

	/** @private Renders the PreRotated graphic. */
	override public function render(point:Point, camera:Point):Void {
		frameAngle %= 360;
		if (frameAngle < 0) {
			frameAngle += 360;
		}
		_current = as3hx.Compat.parseInt(_frameCount * (frameAngle / 360));
		if (_last != _current) {
			_last = _current;
			_frame.x = _frame.width * _last;
			_frame.y = as3hx.Compat.parseInt(_frame.x / _width) * _frame.height;
			_frame.x %= _width;
			updateBuffer();
		}
		super.render(point, camera);
	}

	// Rotation information.

	/** @private */
	private var _width:Int;

	/** @private */
	private var _frame:Rectangle;

	/** @private */
	private var _frameCount:Int;

	/** @private */
	private var _last:Int = -1;

	/** @private */
	private var _current:Int = -1;

	// Global information.

	/** @private */
	private static var _rotated:Dictionary = new Dictionary();

	/** @private */
	private static var _size:Dictionary = new Dictionary();

	/** @private */
	private static inline var _MAX_WIDTH:Int = 4000;

	/** @private */
	private static inline var _MAX_HEIGHT:Int = 4000;
}
