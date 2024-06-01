package net.flashpunk.tweens.motion;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import haxe.Constraints.Function;
import net.flashpunk.Tween;

/**
 * Base class for motion Tweens.
 */
class Motion extends Tween {
	/**
	 * Current x position of the Tween.
	 */
	public var x:Float = 0;

	/**
	 * Current y position of the Tween.
	 */
	public var y:Float = 0;

	/**
	 * Constructor.
	 * @param	duration	Duration of the Tween.
	 * @param	complete	Optional completion callback.
	 * @param	type		Tween type.
	 * @param	ease		Optional easer function.
	 */
	public function new(duration:Float, complete:Function = null, type:Int = 0, ease:Function = null) {
		super(duration, type, complete, ease);
	}
}
