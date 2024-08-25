package net.flashpunk.graphics;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.display.BitmapData;
import openfl.geom.Point;
import net.flashpunk.FP;
import net.flashpunk.Graphic;

/**
 * A background texture that can be repeated horizontally and vertically
 * when drawn. Really useful for parallax backgrounds, textures, etc.
 */
class Backdrop extends Canvas {
	/**
	 * Constructor.
	 * @param	texture		Source texture.
	 * @param	repeatX		Repeat horizontally.
	 * @param	repeatY		Repeat vertically.
	 */
	public function new(texture:Dynamic, repeatX:Bool = true, repeatY:Bool = true) {
		if (Std.is(texture, Class)) {
			_texture = FP.getBitmap(texture);
		} else if (Std.is(texture, BitmapData)) {
			_texture = texture;
		}
		if (!_texture) {
			_texture = new BitmapData(FP.width, FP.height, true, 0);
		}
		_repeatX = repeatX;
		_repeatY = repeatY;
		_textWidth = _texture.width;
		_textHeight = _texture.height;
		super(FP.width * Std.int(repeatX) + _textWidth, FP.height * Std.int(repeatY) + _textHeight);
		FP.rect.x = FP.rect.y = 0;
		FP.rect.width = _width;
		FP.rect.height = _height;
		fillTexture(FP.rect, _texture);
	}

	/** @private Renders the Backdrop. */
	override public function render(point:Point, camera:Point):Void {
		point.x += x - camera.x * scrollX;
		point.y += y - camera.y * scrollY;

		if (_repeatX) {
			point.x %= _textWidth;
			if (point.x > 0) {
				point.x -= _textWidth;
			}
		}

		if (_repeatY) {
			point.y %= _textHeight;
			if (point.y > 0) {
				point.y -= _textHeight;
			}
		}

		_x = x;
		_y = y;
		camera.x = camera.y = x = y = 0;
		super.render(point, camera);
		x = _x;
		y = _y;
	}

	// Backdrop information.

	/** @private */
	private var _texture:BitmapData;

	/** @private */
	private var _textWidth:Int = 0;

	/** @private */
	private var _textHeight:Int = 0;

	/** @private */
	private var _repeatX:Bool;

	/** @private */
	private var _repeatY:Bool;

	/** @private */
	private var _x:Float;

	/** @private */
	private var _y:Float;
}
