package net.flashpunk;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import haxe.Constraints.Function;
import openfl.geom.Point;

/**
 * Base class for all graphical types that can be drawn by Entity.
 */
class Graphic {
	private var assign(get, set):Function;

	/**
	 * If the graphic should update.
	 */
	public var active:Bool = false;

	/**
	 * If the graphic should render.
	 */
	public var visible:Bool = true;

	/**
	 * X offset.
	 */
	public var x:Float = 0;

	/**
	 * Y offset.
	 */
	public var y:Float = 0;

	/**
	 * X scrollfactor, effects how much the camera offsets the drawn graphic.
	 * Can be used for parallax effect, eg. Set to 0 to follow the camera,
	 * 0.5 to move at half-speed of the camera, or 1 (default) to stay still.
	 */
	public var scrollX:Float = 1;

	/**
	 * Y scrollfactor, effects how much the camera offsets the drawn graphic.
	 * Can be used for parallax effect, eg. Set to 0 to follow the camera,
	 * 0.5 to move at half-speed of the camera, or 1 (default) to stay still.
	 */
	public var scrollY:Float = 1;

	/**
	 * If the graphic should render at its position relative to its parent Entity's position.
	 */
	public var relative:Bool = true;

	/**
	 * Constructor.
	 */
	public function new() {}

	/**
	 * Updates the graphic.
	 */
	public function update():Void {}

	/**
	 * Renders the graphic to the screen buffer.
	 * @param	point		The position to draw the graphic.
	 * @param	camera		The camera offset.
	 */
	public function render(point:Point, camera:Point):Void {}

	/** @private Callback for when the graphic is assigned to an Entity. */
	private function get_assign():Function {
		return _assign;
	}

	private function set_assign(value:Function):Function {
		_assign = value;
		return value;
	}

	// Graphic information.

	/** @private */ @:allow(net.flashpunk)
	private var _assign:Function;

	/** @private */ @:allow(net.flashpunk)
	private var _scroll:Bool = true;
}
