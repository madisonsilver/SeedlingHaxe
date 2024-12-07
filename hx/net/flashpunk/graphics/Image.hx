package net.flashpunk.graphics;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.utils.Dictionary;
import openfl.errors.Error;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import net.flashpunk.utils.Draw;
import net.flashpunk.*;

/**
 * Performance-optimized non-animated image. Can be drawn to the screen with transformations.
 */
class Image extends Graphic {
	public var alpha(get, set):Float;
	public var color(get, set):Int;
	public var flipped(get, set):Bool;
	public var width(get, never):Int;
	public var height(get, never):Int;
	public var clipRect(get, never):Rectangle;

	private var source(get, never):BitmapData;

	/**
	 * Rotation of the image, in degrees.
	 */
	public var angle:Float = 0;

	/**
	 * Scale of the image, effects both x and y scale.
	 */
	public var scale:Float = 1;

	/**
	 * X scale of the image.
	 */
	public var scaleX:Float = 1;

	/**
	 * Y scale of the image.
	 */
	public var scaleY:Float = 1;

	/**
	 * X origin of the image, determines transformation point.
	 */
	public var originX:Int = 0;

	/**
	 * Y origin of the image, determines transformation point.
	 */
	public var originY:Int = 0;

	/**
	 * Optional blend mode to use when drawing this image.
	 * Use constants from the flash.display.BlendMode class.
	 */
	public var blend:String;

	/**
	 * If the image should be drawn transformed with pixel smoothing.
	 * This will affect drawing performance, but look less pixelly.
	 */
	public var smooth:Bool;

	/**
	 * Constructor.
	 * @param	source		Source image.  (Class or BitmapData)
	 * @param	clipRect	Optional rectangle defining area of the source image to draw.
	 */
	public function new(source:Dynamic = null, clipRect:Rectangle = null) {
		super();
		if (Std.isOfType(source, Class)) {
			_source = FP.getBitmap(source);
			_class = Std.string(source);
		} else if (Std.isOfType(source, BitmapData)) {
			_source = source;
		}
		if (_source == null) {
			throw new Error("Invalid source image.");
		}
		_sourceRect = _source.rect;
		if (clipRect != null) {
			if (clipRect.width == 0 || Math.isNaN(clipRect.width)) {
				clipRect.width = _sourceRect.width;
			}
			if (clipRect.height == 0 || Math.isNaN(clipRect.height)) {
				clipRect.height = _sourceRect.height;
			}
			_sourceRect = clipRect;
		}
		createBuffer();
		updateBuffer();
	}

	/** @private Creates the buffer. */
	private function createBuffer():Void {
		_buffer = new BitmapData(Std.int(_sourceRect.width), Std.int(_sourceRect.height), true, 0);
		_bufferRect = _buffer.rect;
	}

	/** @private Renders the image. */
	override public function render(point:Point, camera:Point):Void // quit if no graphic is assigned
	{
		if (_buffer == null) {
			return;
		}

		// determine drawing location
		point.x += x - camera.x * scrollX;
		point.y += y - camera.y * scrollY;

		// render without transformation
		if (angle == 0 && scaleX * scale == 1 && scaleY * scale == 1 && blend == null) {
			Draw._target.copyPixels(_buffer, _bufferRect, point, null, null, true);
			return;
		}

		// render with transformation
		_matrix.b = _matrix.c = 0;
		_matrix.a = scaleX * scale;
		_matrix.d = scaleY * scale;
		_matrix.tx = -originX * _matrix.a;
		_matrix.ty = -originY * _matrix.d;
		if (angle != 0) {
			_matrix.rotate(angle * FP.RAD);
		}
		_matrix.tx += originX + point.x;
		_matrix.ty += originY + point.y;
		Draw._target.draw(_buffer, _matrix, null, blend, null, smooth);
	}

	/**
	 * Creates a new rectangle Image.
	 * @param	width		Width of the rectangle.
	 * @param	height		Height of the rectangle.
	 * @param	color		Color of the rectangle.
	 * @return	A new Image object.
	 */
	public static function createRect(width:Int, height:Int, color:Int = 0xFFFFFF):Image {
		var source:BitmapData = new BitmapData(width, height, true, 0xFF000000 | color);
		return new Image(source);
	}

	/**
	 * Updates the image buffer.
	 */
	public function updateBuffer():Void {
		if (_source == null) {
			return;
		}
		_buffer.copyPixels(_source, _sourceRect, FP.zero);
		if (_tint != null) {
			_buffer.colorTransform(_bufferRect, _tint);
		}
	}

	/**
	 * Clears the image buffer.
	 */
	public function clear():Void {
		_buffer.fillRect(_bufferRect, 0);
	}

	/**
	 * Change the opacity of the Image, a value from 0 to 1.
	 */
	private function get_alpha():Float {
		return _alpha;
	}

	private function set_alpha(value:Float):Float {
		value = (value < 0) ? 0 : ((value > 1) ? 1 : value);
		if (_alpha == value) {
			return value;
		}
		_alpha = value;
		if (_alpha == 1 && _color == 0xFFFFFF) {
			/* 
			TODO: Something is wrong with setting the tint to null here (BossTotem won't display)
			Commenting it is a workaround but will require more investigation later
			_tint = null;  
			return value;
			*/
		}
		_tint = _colorTransform;
		_tint.redMultiplier = ((_color >> 16) & 0xFF) / 255;
		_tint.greenMultiplier = ((_color >> 8) & 0xFF) / 255;
		_tint.blueMultiplier = (_color & 0xFF) / 255;
		_tint.alphaMultiplier = _alpha;
		updateBuffer();
		return value;
	}

	/**
	 * The tinted color of the Image. Use 0xFFFFFF to draw the Image normally.
	 */
	private function get_color():Int {
		return _color;
	}

	private function set_color(value:Int):Int {
		value = value & 0xFFFFFF;
		if (_color == value) {
			return value;
		}
		_color = value;
		if (_alpha == 1 && _color == 0xFFFFFF) {
			_tint = null;
			updateBuffer();
			return value;
		}
		_tint = _colorTransform;
		_tint.redMultiplier = (Std.int(_color >> 16) & 0xFF) / 255;
		_tint.greenMultiplier = (Std.int(_color >> 8) & 0xFF) / 255;
		_tint.blueMultiplier = (_color & 0xFF) / 255;
		_tint.alphaMultiplier = _alpha;
		updateBuffer();
		return value;
	}

	/**
	 * If you want to draw the Image horizontally flipped. This is
	 * faster than setting scaleX to -1 if your image isn't transformed.
	 */
	private function get_flipped():Bool {
		return _flipped;
	}

	private function set_flipped(value:Bool):Bool {
		if (_flipped == value || _class == null || _class == "") {
			return value;
		}
		_flipped = value;
		var temp:BitmapData = _source;
		if (!value || _flip != null) {
			_source = _flip;
			_flip = temp;
			return value;
		}
		if (_flips[_class] != null) {
			_source = _flips[_class];
			_flip = temp;
			return value;
		}
		_source = _flips[_class] = new BitmapData(_source.width, _source.height, true, 0);
		_flip = temp;
		FP.matrix.identity();
		FP.matrix.a = -1;
		FP.matrix.tx = _source.width;
		_source.draw(temp, FP.matrix);
		updateBuffer();
		return value;
	}

	/**
	 * Centers the Image's originX/Y to its center.
	 */
	public function centerOrigin():Void {
		originX = Std.int(_bufferRect.width / 2);
		originY = Std.int(_bufferRect.height / 2);
	}

	/**
	 * Centers the Image's originX/Y to its center, and negates the offset by the same amount.
	 */
	public function centerOO():Void {
		x += originX;
		y += originY;
		centerOrigin();
		x -= originX;
		y -= originY;
	}

	/**
	 * Width of the image.
	 */
	private function get_width():Int {
		return Std.int(_bufferRect.width);
	}

	/**
	 * Height of the image.
	 */
	private function get_height():Int {
		return Std.int(_bufferRect.height);
	}

	/**
	 * Clipping rectangle for the image.
	 */
	private function get_clipRect():Rectangle {
		return _sourceRect;
	}

	/** @private Source BitmapData image. */
	private function get_source():BitmapData {
		return _source;
	}

	// Source and buffer information.

	/** @private */
	private var _source:BitmapData;

	/** @private */
	private var _sourceRect:Rectangle;

	/** @private */
	private var _buffer:BitmapData;

	/** @private */
	private var _bufferRect:Rectangle;

	// Color and alpha information.

	/** @private */
	private var _alpha:Float = 1;

	/** @private */
	private var _color:Int = 0x00FFFFFF;

	/** @private */
	private var _tint:ColorTransform;

	/** @private */
	private var _colorTransform:ColorTransform = new ColorTransform();

	/** @private */
	private var _matrix:Matrix = FP.matrix;

	// Flipped image information.

	/** @private */
	private var _class:String;

	/** @private */
	private var _flipped:Bool;

	/** @private */
	private var _flip:BitmapData;

	/** @private */
	private static var _flips:Dictionary<String, BitmapData> = new Dictionary();
}
