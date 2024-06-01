package net.flashpunk.tweens.misc;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.errors.Error;
import haxe.Constraints.Function;
import net.flashpunk.Tween;

/**
 * Tweens a numeric public property of an Object.
 */
class VarTween extends Tween {
	/**
	 * Constructor.
	 * @param	complete	Optional completion callback.
	 * @param	type		Tween type.
	 */
	public function new(complete:Function = null, type:Int = 0) {

		super(0, type, complete);
	}

	/**
	 * Tweens a numeric public property.
	 * @param	object		The object containing the property.
	 * @param	property	The name of the property (eg. "x").
	 * @param	to			Value to tween to.
	 * @param	duration	Duration of the tween.
	 * @param	ease		Optional easer function.
	 */
	public function tween(object:Dynamic, property:String, to:Float, duration:Float, ease:Function = null):Void {
		_object = object;
		_property = property;
		if (!object.exists(property)) {
			throw new Error("The Object does not have the property\"" + property + "\", or it is not accessible.");
		}
		var a:Dynamic = as3hx.Compat.parseFloat(Reflect.field(_object, property));
		if (a == null) {
			throw new Error("The property \"" + property + "\" is not numeric.");
		}
		_start = Reflect.field(_object, property);
		_range = to - _start;
		_target = duration;
		start();
	}

	/** @private Updates the Tween. */
	override public function update():Void {
		super.update();
		_object[_property] = _start + _range * _t;
	}

	// Tween information.

	/** @private */
	private var _object:Dynamic;

	/** @private */
	private var _property:String;

	/** @private */
	private var _start:Float;

	/** @private */
	private var _range:Float;
}
