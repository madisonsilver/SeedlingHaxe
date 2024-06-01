package net.flashpunk.graphics;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.geom.Rectangle;
import net.flashpunk.FP;

/**
 * Special Image object that can display blocks of tiles.
 */
class TiledImage extends Image {
	public var offsetX(get, set):Float;
	public var offsetY(get, set):Float;

	/**
	 * Constructs the TiledImage.
	 * @param	texture		Source texture.
	 * @param	width		The width of the image (the texture will be drawn to fill this area).
	 * @param	height		The height of the image (the texture will be drawn to fill this area).
	 * @param	clipRect	An optional area of the source texture to use (eg. a tile from a tileset).
	 */
	public function new(texture:Dynamic, width:Int = 0, height:Int = 0, clipRect:Rectangle = null) {
		_width = width;
		_height = height;
		super(texture, clipRect);
	}

	/** @private Creates the buffer. */
	override private function createBuffer():Void {
		if (_width == 0) {
			_width = _sourceRect.width;
		}
		if (_height == 0) {
			_height = _sourceRect.height;
		}
		_buffer = new BitmapData(_width, _height, true, 0);
		_bufferRect = _buffer.rect;
	}

	/** @private Updates the buffer. */
	override public function updateBuffer():Void {
		if (_source == null) {
			return;
		}
		if (_texture == null) {
			_texture = new BitmapData(_sourceRect.width, _sourceRect.height, true, 0);
			_texture.copyPixels(_source, _sourceRect, FP.zero);
		}
		_buffer.fillRect(_bufferRect, 0);
		_graphics.clear();
		if (_offsetX != 0 || _offsetY != 0) {
			FP.matrix.identity();
			FP.matrix.tx = Math.round(_offsetX);
			FP.matrix.ty = Math.round(_offsetY);
			_graphics.beginBitmapFill(_texture, FP.matrix);
		} else {
			_graphics.beginBitmapFill(_texture);
		}
		_graphics.drawRect(0, 0, _width, _height);
		_buffer.draw(FP.sprite, null, _tint);
	}

	/**
	 * The x-offset of the texture.
	 */
	private function get_offsetX():Float {
		return _offsetX;
	}

	private function set_offsetX(value:Float):Float {
		if (_offsetX == value) {
			return value;
		}
		_offsetX = value;
		updateBuffer();
		return value;
	}

	/**
	 * The y-offset of the texture.
	 */
	private function get_offsetY():Float {
		return _offsetY;
	}

	private function set_offsetY(value:Float):Float {
		if (_offsetY == value) {
			return value;
		}
		_offsetY = value;
		updateBuffer();
		return value;
	}

	/**
	 * Sets the texture offset.
	 * @param	x		The x-offset.
	 * @param	y		The y-offset.
	 */
	public function setOffset(x:Float, y:Float):Void {
		if (_offsetX == x && _offsetY == y) {
			return;
		}
		_offsetX = x;
		_offsetY = y;
		updateBuffer();
	}

	// Drawing information.

	/** @private */
	private var _graphics:Graphics = FP.sprite.graphics;

	/** @private */
	private var _texture:BitmapData;

	/** @private */
	private var _width:Int;

	/** @private */
	private var _height:Int;

	/** @private */
	private var _offsetX:Float = 0;

	/** @private */
	private var _offsetY:Float = 0;
}
