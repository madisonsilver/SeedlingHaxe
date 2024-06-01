package net.flashpunk.tweens.motion;
import openfl.utils.Assets;import openfl.display.BitmapData;

import haxe.Constraints.Function;
import openfl.geom.Point;
import net.flashpunk.FP;
import net.flashpunk.utils.Ease;

/**
 * Determines a circular motion.
 */
class CircularMotion extends Motion {
	public var angle(get, never):Float;
	public var circumference(get, never):Float;

	/**
	 * Constructor.
	 * @param	complete	Optional completion callback.
	 * @param	type		Tween type.
	 */
	public function new(complete:Function = null, type:Int = 0) {

		super(0, complete, type, null);
	}

	/**
	 * Starts moving along a circle.
	 * @param	centerX		X position of the circle's center.
	 * @param	centerY		Y position of the circle's center.
	 * @param	radius		Radius of the circle.
	 * @param	angle		Starting position on the circle.
	 * @param	clockwise	If the motion is clockwise.
	 * @param	duration	Duration of the movement.
	 * @param	ease		Optional easer function.
	 */
	public function setMotion(centerX:Float, centerY:Float, radius:Float, angle:Float, clockwise:Bool, duration:Float, ease:Function = null):Void {
		_centerX = centerX;
		_centerY = centerY;
		_radius = radius;
		_angle = _angleStart = angle * FP.RAD;
		_angleFinish = _CIRC * ((clockwise) ? 1 : -1);
		_target = duration;
		_ease = ease;
		start();
	}

	/**
	 * Starts moving along a circle at the speed.
	 * @param	centerX		X position of the circle's center.
	 * @param	centerY		Y position of the circle's center.
	 * @param	radius		Radius of the circle.
	 * @param	angle		Starting position on the circle.
	 * @param	clockwise	If the motion is clockwise.
	 * @param	speed		Speed of the movement.
	 * @param	ease		Optional easer function.
	 */
	public function setMotionSpeed(centerX:Float, centerY:Float, radius:Float, angle:Float, clockwise:Bool, speed:Float, ease:Function = null):Void {
		_centerX = centerX;
		_centerY = centerY;
		_radius = radius;
		_angle = _angleStart = angle * FP.RAD;
		_angleFinish = _CIRC * ((clockwise) ? 1 : -1);
		_target = (_radius * _CIRC) / speed;
		_ease = ease;
		start();
	}

	/** @private Updates the Tween. */
	override public function update():Void {
		super.update();
		_angle = _angleStart + _angleFinish * _t;
		x = _centerX + Math.cos(_angle) * _radius;
		y = _centerY + Math.sin(_angle) * _radius;
	}

	/**
	 * The current position on the circle.
	 */
	private function get_angle():Float {
		return _angle;
	}

	/**
	 * The circumference of the current circle motion.
	 */
	private function get_circumference():Float {
		return _radius * _CIRC;
	}

	// Circle information.

	/** @private */
	private var _centerX:Float = 0;

	/** @private */
	private var _centerY:Float = 0;

	/** @private */
	private var _radius:Float = 0;

	/** @private */
	private var _angle:Float = 0;

	/** @private */
	private var _angleStart:Float = 0;

	/** @private */
	private var _angleFinish:Float = 0;

	/** @private */
	private static var _CIRC:Float = Math.PI * 2;
}
