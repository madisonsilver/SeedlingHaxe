package net.flashpunk.graphics;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import haxe.Constraints.Function;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import net.flashpunk.FP;

/**
 * Special Spritemap object that can display blocks of animated sprites.
 */
class TiledSpritemap extends Spritemap {
	public var offsetX(get, set):Float;
	public var offsetY(get, set):Float;

	/**
	 * Constructs the tiled spritemap.
	 * @param	source			Source image.
	 * @param	frameWidth		Frame width.
	 * @param	frameHeight		Frame height.	
	 * @param	width			Width of the block to render.
	 * @param	height			Height of the block to render.
	 * @param	callback		Optional callback function for animation end.
	 */
	public function new(source:Dynamic, frameWidth:Int = 0, frameHeight:Int = 0, width:Int = 0, height:Int = 0, callback:Function = null) {
		_imageWidth = width;
		_imageHeight = height;
		super(source, frameWidth, frameHeight, callback);
	}

	/** @private Creates the buffer. */
	override private function createBuffer():Void {
		if (!_imageWidth) {
			_imageWidth = _sourceRect.width;
		}
		if (!_imageHeight) {
			_imageHeight = _sourceRect.height;
		}
		_buffer = new BitmapData(_imageWidth, _imageHeight, true, 0);
		_bufferRect = _buffer.rect;
	}

	/** @private Updates the buffer. */
	override public function updateBuffer():Void // get position of the current frame
	{
		_rect.x = _rect.width * _frame;
		_rect.y = as3hx.Compat.parseInt(_rect.x / _width) * _rect.height;
		_rect.x %= _width;
		if (_flipped) {
			_rect.x = (_width - _rect.width) - _rect.x;
		}

		// render it repeated to the buffer
		var xx:Int = as3hx.Compat.parseInt(as3hx.Compat.parseInt(_offsetX) % _imageWidth);
		var yy:Int = as3hx.Compat.parseInt(as3hx.Compat.parseInt(_offsetY) % _imageHeight);
		if (xx >= 0) {
			xx -= _imageWidth;
		}
		if (yy >= 0) {
			yy -= _imageHeight;
		}
		FP.point.x = xx;
		FP.point.y = yy;
		while (FP.point.y < _imageHeight) {
			while (FP.point.x < _imageWidth) {
				_buffer.copyPixels(_source, _sourceRect, FP.point);
				FP.point.x += _sourceRect.width;
			}
			FP.point.x = xx;
			FP.point.y += _sourceRect.height;
		}

		// tint the buffer
		if (_tint != null) {
			_buffer.colorTransform(_bufferRect, _tint);
		}
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

	/** @private */
	private var _graphics:Graphics = FP.sprite.graphics;

	/** @private */
	private var _imageWidth:Int;

	/** @private */
	private var _imageHeight:Int;

	/** @private */
	private var _offsetX:Float = 0;

	/** @private */
	private var _offsetY:Float = 0;
}
