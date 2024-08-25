package net.flashpunk.graphics;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import net.flashpunk.FP;
import net.flashpunk.Graphic;

/**
 * A  multi-purpose drawing canvas, can be sized beyond the normal Flash BitmapData limits.
 */
class Canvas extends Graphic {
	public var color(get, set):Int;
	public var alpha(get, set):Float;
	public var width(get, never):Int;
	public var height(get, never):Int;

	/**
	 * Optional blend mode to use (see flash.display.BlendMode for blending modes).
	 */
	public var blend:String;

	/**
	 * Constructor.
	 * @param	width		Width of the canvas.
	 * @param	height		Height of the canvas.
	 */
	public function new(width:Int, height:Int) {
		super();
		_width = width;
		_height = height;
		_refWidth = Math.ceil(width / _maxWidth);
		_refHeight = Math.ceil(height / _maxHeight);
		_ref = new BitmapData(_refWidth, _refHeight, false, 0);
		var x:Int = 0;
		var y:Int = 0;
		var w:Int = 0;
		var h:Int = 0;
		var i:Int = 0;
		var ww:Int = Std.int(_width % _maxWidth);
		var hh:Int = Std.int(_height % _maxHeight);
		if (ww == 0) {
			ww = _maxWidth;
		}
		if (hh == 0) {
			hh = _maxHeight;
		}
		while (y < _refHeight) {
			h = (y < _refHeight - 1) ? _maxHeight : hh;
			while (x < _refWidth) {
				w = (x < _refWidth - 1) ? _maxWidth : ww;
				_ref.setPixel(x, y, i);
				_buffers[i] = new BitmapData(w, h, true, 0);
				i++;
				x++;
			}
			x = 0;
			y++;
		}
	}

	/** @private Renders the canvas. */
	override public function render(point:Point, camera:Point):Void // determine drawing location
	{
		point.x += x - camera.x * scrollX;
		point.y += y - camera.y * scrollY;

		// render the buffers
		var xx:Int = 0;
		var yy:Int = 0;
		var buffer:BitmapData;
		var px:Float = point.x;
		while (yy < _refHeight) {
			while (xx < _refWidth) {
				buffer = _buffers[_ref.getPixel(xx, yy)];
				if (_tint || blend != null) {
					_matrix.tx = point.x;
					_matrix.ty = point.y;
					FP.buffer.draw(buffer, _matrix, _tint, blend);
				} else {
					FP.buffer.copyPixels(buffer, buffer.rect, point, null, null, true);
				}
				point.x += _maxWidth;
				xx++;
			}
			point.x = px;
			point.y += _maxHeight;
			xx = 0;
			yy++;
		}
	}

	/**
	 * Draws to the canvas.
	 * @param	x			X position to draw.
	 * @param	y			Y position to draw.
	 * @param	source		Source BitmapData.
	 * @param	rect		Optional area of the source image to draw from. If null, the entire BitmapData will be drawn.
	 */
	public function draw(x:Int, y:Int, source:BitmapData, rect:Rectangle = null):Void {
		var xx:Int = 0;
		var yy:Int = 0;
		for (buffer /* AS3HX WARNING could not determine type for var: buffer exp: EIdent(_buffers) type: null */ in _buffers) {
			_point.x = x - xx;
			_point.y = y - yy;
			buffer.copyPixels(source, (rect != null) ? rect : source.rect, _point, null, null, true);
			xx += _maxWidth;
			if (xx >= _width) {
				xx = 0;
				yy += _maxHeight;
			}
		}
	}

	/**
	 * Fills the rectangular area of the canvas.
	 * @param	rect		Fill rectangle.
	 * @param	color		Fill color.
	 * @param	alpha		Fill alpha.
	 */
	public function fill(rect:Rectangle, color:Int = 0, alpha:Float = 1):Void {
		var xx:Int = 0;
		var yy:Int = 0;
		var buffer:BitmapData;
		if (alpha >= 1) {
			_rect.width = rect.width;
			_rect.height = rect.height;

			for (buffer /* AS3HX WARNING could not determine type for var: buffer exp: EIdent(_buffers) type: null */ in _buffers) {
				_rect.x = rect.x - xx;
				_rect.y = rect.y - yy;
				buffer.fillRect(_rect, 0xFF000000 | color);
				xx += _maxWidth;
				if (xx >= _width) {
					xx = 0;
					yy += _maxHeight;
				}
			}
			return;
		}
		for (buffer /* AS3HX WARNING could not determine type for var: buffer exp: EIdent(_buffers) type: null */ in _buffers) {
			_graphics.clear();
			_graphics.beginFill(color, alpha);
			_graphics.drawRect(rect.x - xx, rect.y - yy, rect.width, rect.height);
			buffer.draw(FP.sprite);
			xx += _maxWidth;
			if (xx >= _width) {
				xx = 0;
				yy += _maxHeight;
			}
		}
		_graphics.endFill();
	}

	/**
	 * Fills the rectangle area of the canvas with the texture.
	 * @param	rect		Fill rectangle.
	 * @param	texture		Fill texture.
	 */
	public function fillTexture(rect:Rectangle, texture:BitmapData):Void {
		var xx:Int = 0;
		var yy:Int = 0;
		for (buffer /* AS3HX WARNING could not determine type for var: buffer exp: EIdent(_buffers) type: null */ in _buffers) {
			_graphics.clear();
			_graphics.beginBitmapFill(texture);
			_graphics.drawRect(rect.x - xx, rect.y - yy, rect.width, rect.height);
			buffer.draw(FP.sprite);
			xx += _maxWidth;
			if (xx >= _width) {
				xx = 0;
				yy += _maxHeight;
			}
		}
		_graphics.endFill();
	}

	/**
	 * Draws the Graphic object to the canvas.
	 * @param	x			X position to draw.
	 * @param	y			Y position to draw.
	 * @param	source		Graphic to draw.
	 */
	public function drawGraphic(x:Int, y:Int, source:Graphic):Void {
		var temp:BitmapData = FP.buffer;
		var xx:Int = 0;
		var yy:Int = 0;
		for (buffer /* AS3HX WARNING could not determine type for var: buffer exp: EIdent(_buffers) type: null */ in _buffers) {
			FP.buffer = buffer;
			_point.x = x - xx;
			_point.y = y - yy;
			source.render(_point, FP.zero);
			xx += _maxWidth;
			if (xx >= _width) {
				xx = 0;
				yy += _maxHeight;
			}
		}
		FP.buffer = temp;
	}

	/**
	 * The tinted color of the Canvas. Use 0xFFFFFF to draw the it normally.
	 */
	private function get_color():Int {
		return _color;
	}

	private function set_color(value:Int):Int {
		value %= 0xFFFFFF;
		if (_color == value) {
			return value;
		}
		_color = value;
		if (_alpha == 1 && _color == 0xFFFFFF) {
			_tint = null;
			return value;
		}
		_tint = _colorTransform;
		_tint.redMultiplier = (Std.int(_color >> 16) & 0xFF) / 255;
		_tint.greenMultiplier = (Std.int(_color >> 8) & 0xFF) / 255;
		_tint.blueMultiplier = (_color & 0xFF) / 255;
		_tint.alphaMultiplier = _alpha;
		return value;
	}

	/**
	 * Change the opacity of the Canvas, a value from 0 to 1.
	 */
	private function get_alpha():Float {
		return _alpha;
	}

	private function set_alpha(value:Float):Float {
		if (value < 0) {
			value = 0;
		}
		if (value > 1) {
			value = 1;
		}
		if (_alpha == value) {
			return value;
		}
		_alpha = value;
		if (_alpha == 1 && _color == 0xFFFFFF) {
			_tint = null;
			return value;
		}
		_tint = _colorTransform;
		_tint.redMultiplier = (Std.int(_color >> 16) & 0xFF) / 255;
		_tint.greenMultiplier = (Std.int(_color >> 8) & 0xFF) / 255;
		_tint.blueMultiplier = (_color & 0xFF) / 255;
		_tint.alphaMultiplier = _alpha;
		return value;
	}

	/**
	 * Width of the canvas.
	 */
	private function get_width():Int {
		return _width;
	}

	/**
	 * Height of the canvas.
	 */
	private function get_height():Int {
		return _height;
	}

	// Buffer information.

	/** @private */
	private var _buffers:Array<BitmapData> = new Array<BitmapData>();

	/** @private */
	private var _width:Int = 0;

	/** @private */
	private var _height:Int = 0;

	/** @private */
	private var _maxWidth:Int = 4000;

	/** @private */
	private var _maxHeight:Int = 4000;

	// Color tinting information.

	/** @private */
	private var _color:Int = 0xFFFFFF;

	/** @private */
	private var _alpha:Float = 1;

	/** @private */
	private var _tint:ColorTransform;

	/** @private */
	private var _colorTransform:ColorTransform = new ColorTransform();

	/** @private */
	private var _matrix:Matrix = new Matrix();

	// Canvas reference information.

	/** @private */
	private var _ref:BitmapData;

	/** @private */
	private var _refWidth:Int = 0;

	/** @private */
	private var _refHeight:Int = 0;

	// Global objects.

	/** @private */
	private var _point:Point = FP.point;

	/** @private */
	private var _rect:Rectangle = new Rectangle();

	/** @private */
	private var _graphics:Graphics = FP.sprite.graphics;
}
