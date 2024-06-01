package net.flashpunk.tweens.misc;
import openfl.utils.Assets;import openfl.display.BitmapData;

import haxe.Constraints.Function;
import net.flashpunk.Tween;

/**
 * Tweens a color's red, green, and blue properties
 * independently. Can also tween an alpha value.
 */
class ColorTween extends Tween {
	public var red(get, never):Int;
	public var green(get, never):Int;
	public var blue(get, never):Int;

	/**
	 * The current color.
	 */
	public var color:Int;

	/**
	 * The current alpha.
	 */
	public var alpha:Float = 1;

	/**
	 * Constructor.
	 * @param	complete	Optional completion callback.
	 * @param	type		Tween type.
	 */
	public function new(complete:Function = null, type:Int = 0) {

		super(0, type, complete);
	}

	/**
	 * Tweens the color to a new color and an alpha to a new alpha.
	 * @param	duration		Duration of the tween.
	 * @param	fromColor		Start color.
	 * @param	toColor			End color.
	 * @param	fromAlpha		Start alpha
	 * @param	toAlpha			End alpha.
	 * @param	ease			Optional easer function.
	 */
	public function tween(duration:Float, fromColor:Int, toColor:Int, fromAlpha:Float = 1, toAlpha:Float = 1, ease:Function = null):Void {
		fromColor = fromColor & 0xFFFFFF;
		toColor = toColor & 0xFFFFFF;
		color = fromColor;
		_r = as3hx.Compat.parseInt(fromColor >> 16) & 0xFF;
		_g = as3hx.Compat.parseInt(fromColor >> 8) & 0xFF;
		_b = fromColor & 0xFF;
		_startR = _r / 255;
		_startG = _g / 255;
		_startB = _b / 255;
		_rangeR = ((as3hx.Compat.parseInt(toColor >> 16) & 0xFF) / 255) - _startR;
		_rangeG = ((as3hx.Compat.parseInt(toColor >> 8) & 0xFF) / 255) - _startG;
		_rangeB = ((toColor & 0xFF) / 255) - _startB;
		_startA = alpha = fromAlpha;
		_rangeA = toAlpha - alpha;
		_target = duration;
		_ease = ease;
		start();
	}

	/** @private Updates the Tween. */
	override public function update():Void {
		super.update();
		alpha = _startA + _rangeA * _t;
		_r = as3hx.Compat.parseInt((_startR + _rangeR * _t) * 255);
		_g = as3hx.Compat.parseInt((_startG + _rangeG * _t) * 255);
		_b = as3hx.Compat.parseInt((_startB + _rangeB * _t) * 255);
		color = as3hx.Compat.parseInt(_r << 16 | _g << 8) | _b;
	}

	/**
	 * Red value of the current color, from 0 to 255.
	 */
	private function get_red():Int {
		return _r;
	}

	/**
	 * Green value of the current color, from 0 to 255.
	 */
	private function get_green():Int {
		return _g;
	}

	/**
	 * Blue value of the current color, from 0 to 255.
	 */
	private function get_blue():Int {
		return _b;
	}

	// Color information.

	/** @private */
	private var _r:Int;

	/** @private */
	private var _g:Int;

	/** @private */
	private var _b:Int;

	/** @private */
	private var _startA:Float;

	/** @private */
	private var _startR:Float;

	/** @private */
	private var _startG:Float;

	/** @private */
	private var _startB:Float;

	/** @private */
	private var _rangeA:Float;

	/** @private */
	private var _rangeR:Float;

	/** @private */
	private var _rangeG:Float;

	/** @private */
	private var _rangeB:Float;
}
