package net.flashpunk.tweens.motion;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.errors.Error;
import haxe.Constraints.Function;
import openfl.geom.Point;
import net.flashpunk.FP;

/**
 * Determines linear motion along a set of points.
 */
class LinearPath extends Motion {
	public var distance(get, never):Float;
	public var pointCount(get, never):Float;

	/**
	 * Constructor.
	 * @param	complete	Optional completion callback.
	 * @param	type		Tween type.
	 */
	public function new(complete:Function = null, type:Int = 0) {

		super(0, complete, type, null);
		_pointD[0] = _pointT[0] = 0;
	}

	/**
	 * Starts moving along the path.
	 * @param	duration		Duration of the movement.
	 * @param	ease			Optional easer function.
	 */
	public function setMotion(duration:Float, ease:Function = null):Void {
		updatePath();
		_target = duration;
		_speed = _distance / duration;
		_ease = ease;
		start();
	}

	/**
	 * Starts moving along the path at the speed.
	 * @param	speed		Speed of the movement.
	 * @param	ease		Optional easer function.
	 */
	public function setMotionSpeed(speed:Float, ease:Function = null):Void {
		updatePath();
		_target = _distance / speed;
		_speed = speed;
		_ease = ease;
		start();
	}

	/**
	 * Adds the point to the path.
	 * @param	x		X position.
	 * @param	y		Y position.
	 */
	public function addPoint(x:Float = 0, y:Float = 0):Void {
		if (_last) {
			_distance += Math.sqrt((x - _last.x) * (x - _last.x) + (y - _last.y) * (y - _last.y));
			_pointD[_points.length] = _distance;
		}
		_points[_points.length] = _last = new Point(x, y);
	}

	/**
	 * Gets a point on the path.
	 * @param	index		Index of the point.
	 * @return	The Point object.
	 */
	public function getPoint(index:Int = 0):Point {
		if (!_points.length) {
			throw new Error("No points have been added to the path yet.");
		}
		return _points[index % _points.length];
	}

	/** @private Starts the Tween. */
	override public function start():Void {
		_index = 0;
		super.start();
	}

	/** @private Updates the Tween. */
	override public function update():Void {
		super.update();
		if (_index < _points.length - 1) {
			while (_t > _pointT[_index + 1]) {
				_index++;
			}
		}
		var td:Float = _pointT[_index];
		var tt:Float = _pointT[_index + 1] - td;
		td = (_t - td) / tt;
		_prev = _points[_index];
		_next = _points[_index + 1];
		x = _prev.x + (_next.x - _prev.x) * td;
		y = _prev.y + (_next.y - _prev.y) * td;
	}

	/** @private Updates the path, preparing it for motion. */
	private function updatePath():Void {
		if (_points.length < 2) {
			throw new Error("A LinearPath must have at least 2 points to operate.");
		}
		if (_pointD.length == _pointT.length) {
			return;
		}
		// evaluate t for each point
		var i:Int = 0;
		while (i < _points.length) {
			_pointT[i] = _pointD[i++] / _distance;
		}
	}

	/**
	 * The full length of the path.
	 */
	private function get_distance():Float {
		return _distance;
	}

	/**
	 * How many points are on the path.
	 */
	private function get_pointCount():Float {
		return _points.length;
	}

	// Path information.

	/** @private */
	private var _points:Array<Point> = new Array<Point>();

	/** @private */
	private var _pointD:Array<Float> = new Array<Float>();

	/** @private */
	private var _pointT:Array<Float> = new Array<Float>();

	/** @private */
	private var _distance:Float = 0;

	/** @private */
	private var _speed:Float = 0;

	/** @private */
	private var _index:Int = 0;

	// Line information.

	/** @private */
	private var _last:Point;

	/** @private */
	private var _prev:Point;

	/** @private */
	private var _next:Point;
}
