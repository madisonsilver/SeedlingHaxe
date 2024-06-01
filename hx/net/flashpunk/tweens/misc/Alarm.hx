package net.flashpunk.tweens.misc;
import openfl.utils.Assets;import openfl.display.BitmapData;

import haxe.Constraints.Function;
import net.flashpunk.Tween;

/**
 * A simple alarm, useful for timed events, etc.
 */
class Alarm extends Tween {
	public var elapsed(get, never):Float;
	public var duration(get, never):Float;
	public var remaining(get, never):Float;

	/**
	 * Constructor.
	 * @param	duration	Duration of the alarm.
	 * @param	complete	Optional completion callback.
	 * @param	type		Tween type.
	 */
	public function new(duration:Float, complete:Function = null, type:Int = 0) {

		super(duration, type, complete, null);
	}

	/**
	 * Sets the alarm.
	 * @param	duration	Duration of the alarm.
	 */
	public function reset(duration:Float):Void {
		_target = duration;
		start();
	}

	/**
	 * How much time has passed since reset.
	 */
	private function get_elapsed():Float {
		return _time;
	}

	/**
	 * Current alarm duration.
	 */
	private function get_duration():Float {
		return _target;
	}

	/**
	 * Time remaining on the alarm.
	 */
	private function get_remaining():Float {
		return _target - _time;
	}
}
