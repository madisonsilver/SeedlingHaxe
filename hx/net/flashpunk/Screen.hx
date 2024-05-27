package net.flashpunk;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import openfl.display.Sprite;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Transform;

/**
 * Container for the main screen buffer. Can be used to transform the screen.
 */
class Screen {
	public var color(get, set):Int;
	public var x(get, set):Int;
	public var y(get, set):Int;
	public var originX(get, set):Int;
	public var originY(get, set):Int;
	public var scaleX(get, set):Float;
	public var scaleY(get, set):Float;
	public var scale(get, set):Float;
	public var angle(get, set):Float;
	public var smoothing(get, set):Bool;
	public var width(get, never):Int;
	public var height(get, never):Int;
	public var mouseX(get, never):Int;
	public var mouseY(get, never):Int;

	/**
	 * Constructor.
	 */
	public function new() // create screen buffers
	{
		Reflect.setField(_bitmap, Std.string(0), new Bitmap(new BitmapData(FP.width, FP.height, false, 0), PixelSnapping.NEVER));
		Reflect.setField(_bitmap, Std.string(1), new Bitmap(new BitmapData(FP.width, FP.height, false, 0), PixelSnapping.NEVER));
		FP.engine.addChild(_sprite);
		_sprite.addChild(Reflect.field(_bitmap, Std.string(0))).visible = true;
		_sprite.addChild(Reflect.field(_bitmap, Std.string(1))).visible = false;
		FP.buffer = Reflect.field(_bitmap, Std.string(0)).bitmapData;
		_width = FP.width;
		_height = FP.height;
		update();
	}

	/**
	 * Swaps screen buffers.
	 */
	public function swap():Void {
		_current = 1 - _current;
		FP.buffer = Reflect.field(_bitmap, Std.string(_current)).bitmapData;
	}

	/**
	 * Refreshes the screen.
	 */
	public function refresh():Void // refreshes the screen
	{
		FP.buffer.fillRect(FP.bounds, _color);
	}

	/**
	 * Redraws the screen.
	 */
	public function redraw():Void // refresh the buffers
	{
		Reflect.setField(Reflect.field(_bitmap, Std.string(_current)), "visible", true);
		Reflect.setField(Reflect.field(_bitmap, Std.string(1 - _current)), "visible", false);
	}

	/** @private Re-applies transformation matrix. */
	public function update():Void {
		_matrix.b = _matrix.c = 0;
		_matrix.a = _scaleX * _scale;
		_matrix.d = _scaleY * _scale;
		_matrix.tx = -_originX * _matrix.a;
		_matrix.ty = -_originY * _matrix.d;
		if (_angle != 0) {
			_matrix.rotate(_angle);
		}
		_matrix.tx += _originX * _scaleX * _scale + _x;
		_matrix.ty += _originY * _scaleX * _scale + _y;
		_sprite.transform.matrix = _matrix;
	}

	/**
	 * Refresh color of the screen.
	 */
	private function get_color():Int {
		return _color;
	}

	private function set_color(value:Int):Int {
		_color = 0xFF000000 | value;
		return value;
	}

	/**
	 * X offset of the screen.
	 */
	private function get_x():Int {
		return as3hx.Compat.parseInt(_x);
	}

	private function set_x(value:Int):Int {
		if (_x == value) {
			return value;
		}
		_x = value;
		update();
		return value;
	}

	/**
	 * Y offset of the screen.
	 */
	private function get_y():Int {
		return as3hx.Compat.parseInt(_y);
	}

	private function set_y(value:Int):Int {
		if (_y == value) {
			return value;
		}
		_y = value;
		update();
		return value;
	}

	/**
	 * X origin of transformations.
	 */
	private function get_originX():Int {
		return _originX;
	}

	private function set_originX(value:Int):Int {
		if (_originX == value) {
			return value;
		}
		_originX = value;
		update();
		return value;
	}

	/**
	 * Y origin of transformations.
	 */
	private function get_originY():Int {
		return _originY;
	}

	private function set_originY(value:Int):Int {
		if (_originY == value) {
			return value;
		}
		_originY = value;
		update();
		return value;
	}

	/**
	 * X scale of the screen.
	 */
	private function get_scaleX():Float {
		return _scaleX;
	}

	private function set_scaleX(value:Float):Float {
		if (_scaleX == value) {
			return value;
		}
		_scaleX = value;
		update();
		return value;
	}

	/**
	 * Y scale of the screen.
	 */
	private function get_scaleY():Float {
		return _scaleY;
	}

	private function set_scaleY(value:Float):Float {
		if (_scaleY == value) {
			return value;
		}
		_scaleY = value;
		update();
		return value;
	}

	/**
	 * Scale factor of the screen. Final scale is scaleX * scale by scaleY * scale, so
	 * you can use this factor to scale the screen both horizontally and vertically.
	 */
	private function get_scale():Float {
		return _scale;
	}

	private function set_scale(value:Float):Float {
		if (_scale == value) {
			return value;
		}
		_scale = value;
		update();
		return value;
	}

	/**
	 * Rotation of the screen, in degrees.
	 */
	private function get_angle():Float {
		return _angle * FP.DEG;
	}

	private function set_angle(value:Float):Float {
		if (_angle == value) {
			return value;
		}
		_angle = value * FP.RAD;
		update();
		return value;
	}

	/**
	 * Whether screen smoothing should be used or not.
	 */
	private function get_smoothing():Bool {
		return Reflect.field(_bitmap, Std.string(0)).smoothing;
	}

	private function set_smoothing(value:Bool):Bool {
		Reflect.setField(Reflect.field(_bitmap, Std.string(1)), "smoothing", value);
		Reflect.setField(Reflect.field(_bitmap, Std.string(1)), "smoothing", value);
		return value;
	}

	/**
	 * Width of the screen.
	 */
	private function get_width():Int {
		return _width;
	}

	/**
	 * Height of the screen.
	 */
	private function get_height():Int {
		return _height;
	}

	/**
	 * X position of the mouse on the screen.
	 */
	private function get_mouseX():Int {
		return as3hx.Compat.parseInt((FP.stage.mouseX - _x) / (_scaleX * _scale));
	}

	/**
	 * Y position of the mouse on the screen.
	 */
	private function get_mouseY():Int {
		return as3hx.Compat.parseInt((FP.stage.mouseY - _y) / (_scaleY * _scale));
	}

	// Screen infromation.

	/** @private */
	private var _sprite:Sprite = new Sprite();

	/** @private */
	private var _bitmap:Array<Bitmap> = new Array<Bitmap>();

	/** @private */
	private var _current:Int = 0;

	/** @private */
	private var _matrix:Matrix = new Matrix();

	/** @private */
	private var _x:Int;

	/** @private */
	private var _y:Int;

	/** @private */
	private var _width:Int;

	/** @private */
	private var _height:Int;

	/** @private */
	private var _originX:Int;

	/** @private */
	private var _originY:Int;

	/** @private */
	private var _scaleX:Float = 1;

	/** @private */
	private var _scaleY:Float = 1;

	/** @private */
	private var _scale:Float = 1;

	/** @private */
	private var _angle:Float = 0;

	/** @private */
	private var _color:Int = 0x202020;
}
