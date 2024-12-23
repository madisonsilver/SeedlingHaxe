package net.flashpunk.utils;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.LineScaleMode;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import net.flashpunk.Entity;
import net.flashpunk.FP;

/**
 * Static class with access to miscellanious drawing functions.
 * These functions are not meant to replace Graphic components
 * for Entities, but rather to help with testing and debugging.
 */
class Draw {
	/**
	 * The blending mode used by Draw functions. This will not
	 * apply to Draw.line(), but will apply to Draw.linePlus().
	 */
	public static var blend:String;

	/**
	 * Sets the drawing target for Draw functions.
	 * @param	target		The buffer to draw to.
	 * @param	camera		The camera offset (use null for none).
	 * @param	blend		The blend mode to use.
	 */
	public static function setTarget(target:BitmapData, camera:Point = null, blend:String = null):Void {
		_target = target;
		_camera = (camera != null) ? camera : FP.zero;
		Draw.blend = blend;
	}

	/**
	 * Resets the drawing target to the default. The same as calling Draw.setTarget(FP.buffer, FP.camera).
	 */
	public static function resetTarget():Void {
		_target = FP.buffer;
		_camera = FP.camera;
		Draw.blend = null;
	}

	/**
	 * Draws a pixelated, non-antialiased line.
	 * @param	x1		Starting x position.
	 * @param	y1		Starting y position.
	 * @param	x2		Ending x position.
	 * @param	y2		Ending y position.
	 * @param	color	Color of the line.
	 */
	public static function line(x1:Int, y1:Int, x2:Int, y2:Int, color:Int = 0xFFFFFF):Void {
		if (color >= 0xFF000000) {
			color = color & 0xFFFFFF;
		}

		// get the drawing positions
		x1 -= Std.int(_camera.x);
		y1 -= Std.int(_camera.y);
		x2 -= Std.int(_camera.x);
		y2 -= Std.int(_camera.y);

		// get the drawing difference
		var screen:BitmapData = _target;
		var X:Float = Math.abs(x2 - x1);
		var Y:Float = Math.abs(y2 - y1);
		var xx:Int = 0;
		var yy:Int = 0;

		// draw a single pixel
		if (X == 0) {
			if (Y == 0) {
				screen.setPixel32(x1, y1, color);
				return;
			}
			// draw a straight vertical line
			yy = (y2 > y1) ? 1 : -1;
			while (y1 != y2) {
				screen.setPixel32(x1, y1, color);
				y1 += yy;
			}
			screen.setPixel32(x2, y2, color);
			return;
		}

		if (Y == 0)
			// draw a straight horizontal line
		{
			xx = (x2 > x1) ? 1 : -1;
			while (x1 != x2) {
				screen.setPixel32(x1, y1, color);
				x1 += xx;
			}
			screen.setPixel32(x2, y2, color);
			return;
		}

		xx = (x2 > x1) ? 1 : -1;
		yy = (y2 > y1) ? 1 : -1;
		var c:Float = 0;
		var slope:Float;

		if (X > Y) {
			slope = Y / X;
			c = .5;
			while (x1 != x2) {
				screen.setPixel32(x1, y1, color);
				x1 += xx;
				c += slope;
				if (c >= 1) {
					y1 += yy;
					c -= 1;
				}
			}
			screen.setPixel32(x2, y2, color);
		} else {
			slope = X / Y;
			c = .5;
			while (y1 != y2) {
				screen.setPixel32(x1, y1, color);
				y1 += yy;
				c += slope;
				if (c >= 1) {
					x1 += xx;
					c -= 1;
				}
			}
			screen.setPixel32(x2, y2, color);
		}
	}

	/**
	 * Draws a smooth, antialiased line with optional alpha and thickness.
	 * @param	x1		Starting x position.
	 * @param	y1		Starting y position.
	 * @param	x2		Ending x position.
	 * @param	y2		Ending y position.
	 * @param	color	Color of the line.
	 * @param	alpha	Alpha of the line.
	 * @param	thick	The thickness of the line.
	 */
	public static function linePlus(x1:Int, y1:Int, x2:Int, y2:Int, color:Int = 0xFF000000, alpha:Float = 1, thick:Float = 1):Void {
		_graphics.clear();
		_graphics.lineStyle(thick, color, alpha, false, LineScaleMode.NONE);
		_graphics.moveTo(x1 - _camera.x, y1 - _camera.y);
		_graphics.lineTo(x2 - _camera.x, y2 - _camera.y);
		_target.draw(FP.sprite, null, null, blend);
	}

	/**
	 * Draws a filled rectangle.
	 * @param	x			X position of the rectangle.
	 * @param	y			Y position of the rectangle.
	 * @param	width		Width of the rectangle.
	 * @param	height		Height of the rectangle.
	 * @param	color		Color of the rectangle.
	 * @param	alpha		Alpha of the rectangle.
	 */
	public static function rect(x:Int, y:Int, width:Int, height:Int, color:Int = 0xFFFFFF, alpha:Float = 1):Void {
		if (alpha >= 1 && blend == null) {
			if (color < 0xFF000000) {
				color = 0xFF000000 | color;
			}
			_rect.x = x - _camera.x;
			_rect.y = y - _camera.y;
			_rect.width = width;
			_rect.height = height;
			_target.fillRect(_rect, color);
			return;
		}
		if (color >= 0xFF000000) {
			color = 0xFFFFFF & color;
		}
		_graphics.clear();
		_graphics.beginFill(color, alpha);
		_graphics.drawRect(x - _camera.x, y - _camera.y, width, height);
		_target.draw(FP.sprite, null, null, blend);
	}

	/**
	 * Draws a non-filled, pixelated circle.
	 * @param	x			Center x position.
	 * @param	y			Center y position.
	 * @param	radius		Radius of the circle.
	 * @param	color		Color of the circle.
	 */
	public static function circle(x:Int, y:Int, radius:Int, color:Int = 0xFFFFFF):Void {
		if (color < 0xFF000000) {
			color = 0xFF000000 | color;
		}
		x -= Std.int(_camera.x);
		y -= Std.int(_camera.y);
		var f:Int = Std.int(1 - radius);
		var fx:Int = 1;
		var fy:Int = Std.int(-2 * radius);
		var xx:Int = 0;
		var yy:Int = radius;
		_target.setPixel(x, y + radius, color);
		_target.setPixel(x, y - radius, color);
		_target.setPixel(x + radius, y, color);
		_target.setPixel(x - radius, y, color);
		while (xx < yy) {
			if (f >= 0) {
				yy--;
				fy += 2;
				f += fy;
			}
			xx++;
			fx += 2;
			f += fx;
			_target.setPixel(x + xx, y + yy, color);
			_target.setPixel(x - xx, y + yy, color);
			_target.setPixel(x + xx, y - yy, color);
			_target.setPixel(x - xx, y - yy, color);
			_target.setPixel(x + yy, y + xx, color);
			_target.setPixel(x - yy, y + xx, color);
			_target.setPixel(x + yy, y - xx, color);
			_target.setPixel(x - yy, y - xx, color);
		}
	}

	/**
	 * Draws a circle to the screen.
	 * @param	x			X position of the circle's center.
	 * @param	y			Y position of the circle's center.
	 * @param	radius		Radius of the circle.
	 * @param	color		Color of the circle.
	 * @param	alpha		Alpha of the circle.
	 * @param	fill		If the circle should be filled with the color (true) or just an outline (false).
	 * @param	thick		How thick the outline should be (only applicable when fill = false).
	 */
	public static function circlePlus(x:Int, y:Int, radius:Float, color:Int = 0xFFFFFF, alpha:Float = 1, fill:Bool = true, thick:Int = 1):Void {
		_graphics.clear();
		if (fill) {
			_graphics.beginFill(color & 0xFFFFFF, alpha);
			_graphics.drawCircle(x - _camera.x, y - _camera.y, radius);
			_graphics.endFill();
		} else {
			_graphics.lineStyle(thick, color & 0xFFFFFF, alpha);
			_graphics.drawCircle(x - _camera.x, y - _camera.y, radius);
		}
		_target.draw(FP.sprite, null, null, blend);
	}

	/**
	 * Draws the Entity's hitbox.
	 * @param	e			The Entity whose hitbox is to be drawn.
	 * @param	outline		If just the hitbox's outline should be drawn.
	 * @param	color		Color of the hitbox.
	 * @param	alpha		Alpha of the hitbox.
	 */
	public static function hitbox(e:Entity, outline:Bool = true, color:Int = 0xFFFFFF, alpha:Float = 1):Void {
		if (outline) {
			if (color < 0xFF000000) {
				color += 0xFF000000;
			}
			var x:Int = Std.int(e.x - e.originX - _camera.x);
			var y:Int = Std.int(e.y - e.originY - _camera.y);
			_rect.x = x;
			_rect.y = y;
			_rect.width = e.width;
			_rect.height = 1;
			_target.fillRect(_rect, color);
			_rect.y += e.height - 1;
			_target.fillRect(_rect, color);
			_rect.y = y;
			_rect.width = 1;
			_rect.height = e.height;
			_target.fillRect(_rect, color);
			_rect.x += e.width - 1;
			_target.fillRect(_rect, color);
			return;
		}
		if (alpha >= 1) {
			if (color < 0xFF000000) {
				color += 0xFF000000;
			}
			_rect.x = e.x - e.originX - _camera.x;
			_rect.y = e.y - e.originY - _camera.y;
			_rect.width = e.width;
			_rect.height = e.height;
			_target.fillRect(_rect, color);
			return;
		}
		_graphics.clear();
		_graphics.beginFill(color, alpha);
		_graphics.drawRect(e.x - e.originX - _camera.x, e.y - e.originY - _camera.y, e.width, e.height);
		_target.draw(FP.sprite, null, null, blend);
	}

	/**
	 * Draws a quadratic curve.
	 * @param	x1		X start.
	 * @param	y1		Y start.
	 * @param	x2		X control point, used to determine the curve.
	 * @param	y2		Y control point, used to determine the curve.
	 * @param	x3		X finish.
	 * @param	y3		Y finish.
	 */
	public static function curve(x1:Int, y1:Int, x2:Int, y2:Int, x3:Int, y3:Int):Void {
		_graphics.clear();
		_graphics.lineStyle(1, 0xFF0000);
		_graphics.moveTo(x1, y1);
		_graphics.curveTo(x2, y2, x3, y3);
		_target.draw(FP.sprite, null, null, blend);
	}

	// Drawing information.

	/** @private */
	public static var _target:BitmapData;

	/** @private */
	private static var _camera:Point;

	/** @private */
	private static var _graphics:Graphics = FP.sprite.graphics;

	/** @private */
	private static var _rect:Rectangle = FP.rect;

	/** @private */
	private static var _matrix:Matrix = new Matrix();

	public function new() {}
}
