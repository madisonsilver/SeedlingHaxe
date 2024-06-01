package net.flashpunk;
import openfl.utils.Assets;import openfl.display.BitmapData;

import haxe.Constraints.Function;

/**
 * Base class for all Tween objects, can be added to any Core-extended classes.
 */
class Tween {
	public var percent(get, set):Float;
	public var scale(get, never):Float;

	/**
	 * Persistent Tween type, will stop when it finishes.
	 */
	public static inline var PERSIST:Int = 0;

	/**
	 * Looping Tween type, will restart immediately when it finishes.
	 */
	public static inline var LOOPING:Int = 1;

	/**
	 * Oneshot Tween type, will stop and remove itself from its core container when it finishes.
	 */
	public static inline var ONESHOT:Int = 2;

	/**
	 * If the tween should update.
	 */
	public var active:Bool;

	/**
	 * Tween completion callback.
	 */
	public var complete:Function;

	/**
	 * Constructor. Specify basic information about the Tween.
	 * @param	duration		Duration of the tween (in seconds or frames).
	 * @param	type			Tween type, one of Tween.PERSIST (default), Tween.LOOPING, or Tween.ONESHOT.
	 * @param	complete		Optional callback for when the Tween completes.
	 * @param	ease			Optional easer function to apply to the Tweened value.
	 */
	public function new(duration:Float, type:Int = 0, complete:Function = null, ease:Function = null) {

		_target = duration;
		_type = type;
		this.complete = complete;
		_ease = ease;
	}

	/**
	 * Updates the Tween, called by World.
	 */
	public function update():Void {
		_time += (FP.fixed) ? 1 : FP.elapsed;
		_t = _time / _target;
		if (_ease != null && _t > 0 && _t < 1) {
			_t = _ease(_t);
		}
		if (_time >= _target) {
			_t = 1;
			_finish = true;
		}
	}

	/**
	 * Starts the Tween, or restarts it if it's currently running.
	 */
	public function start():Void {
		_time = 0;
		if (_target == 0) {
			active = false;
			return;
		}
		active = true;
	}

	/** @private Called when the Tween completes. */
	@:allow(net.flashpunk)
	private function finish():Void {
		switch (_type) {
			case 0:
				_time = _target;
				active = false;
			case 1:
				_time %= _target;
				_t = _time / _target;
				if (_ease != null && _t > 0 && _t < 1) {
					_t = _ease(_t);
				}
				start();
			case 2:
				_time = _target;
				active = false;
				_parent.removeTween(this);
		}
		_finish = false;
		if (complete != null) {
			complete();
		}
	}

	/**
	 * The completion percentage of the Tween.
	 */
	private function get_percent():Float {
		return _time / _target;
	}

	private function set_percent(value:Float):Float {
		_time = as3hx.Compat.parseInt(_target * value);
		return value;
	}

	/**
	 * The current time scale of the Tween (after easer has been applied).
	 */
	private function get_scale():Float {
		return _t;
	}

	// Tween information.

	/** @private */
	private var _type:Int;

	/** @private */
	private var _ease:Function;

	/** @private */
	private var _t:Float = 0;

	// Timing information.

	/** @private */
	private var _time:Float;

	/** @private */
	private var _target:Float;

	// List information.

	/** @private */ @:allow(net.flashpunk)
	private var _finish:Bool;

	/** @private */ @:allow(net.flashpunk)
	private var _parent:Tweener;

	/** @private */ @:allow(net.flashpunk)
	private var _prev:Tween;

	/** @private */ @:allow(net.flashpunk)
	private var _next:Tween;
}
