package net.flashpunk.tweens.misc;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import haxe.Constraints.Function;
import net.flashpunk.Tween;

/**
 * Tweens a numeric value.
 */
class NumTween extends Tween {
	/**
	 * The current value.
	 */
	public var value:Float = 0;

	/**
	 * Constructor.
	 * @param	complete	Optional completion callback.
	 * @param	type		Tween type.
	 */
	public function new(complete:Function = null, type:Int = 0) {
		super(0, type, complete);
	}

	/**
	 * Tweens the value from one value to another.
	 * @param	fromValue		Start value.
	 * @param	toValue			End value.
	 * @param	duration		Duration of the tween.
	 * @param	ease			Optional easer function.
	 */
	public function tween(fromValue:Float, toValue:Float, duration:Float, ease:Function = null):Void {
		_start = value = fromValue;
		_range = toValue - value;
		_target = duration;
		_ease = ease;
		start();
	}

	/** @private Updates the Tween. */
	override public function update():Void {
		super.update();
		value = _start + _range * _t;
	}

	// Tween information.

	/** @private */
	private var _start:Float;

	/** @private */
	private var _range:Float;
}
