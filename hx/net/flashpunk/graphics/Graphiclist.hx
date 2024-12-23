package net.flashpunk.graphics;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.utils.Dictionary;
import net.flashpunk.*;

/**
 * A Graphic that can contain multiple Graphics of one or various types.
 * Useful for drawing sprites with multiple different parts, etc.
 */
class Graphiclist extends Graphic {
	public var children(get, never):Array<Graphic>;
	public var count(get, never):Int;

	/**
	 * Constructor.
	 * @param	...graphic		Graphic objects to add to the list.
	 */
	public function new(graphic:Array<Dynamic> = null) {
		super();
		for (g in graphic) {
			add(g);
		}
	}

	/** @private Updates the graphics in the list. */
	override public function update():Void {
		for (g /* AS3HX WARNING could not determine type for var: g exp: EIdent(_graphics) type: Graphics */ in _graphics) {
			if (g.active) {
				g.update();
			}
		}
	}

	/** @private Renders the Graphics in the list. */
	override public function render(point:Point, camera:Point):Void {
		point.x += x;
		point.y += y;
		camera.x *= scrollX;
		camera.y *= scrollY;
		for (g /* AS3HX WARNING could not determine type for var: g exp: EIdent(_graphics) type: Graphics */ in _graphics) {
			if (g.visible) {
				if (g.relative) {
					_point.x = point.x;
					_point.y = point.y;
				} else {
					_point.x = _point.y = 0;
				}
				_camera.x = camera.x;
				_camera.y = camera.y;
				g.render(_point, _camera);
			}
		}
	}

	/**
	 * Adds the Graphic to the list.
	 * @param	graphic		The Graphic to add.
	 * @return	The added Graphic.
	 */
	public function add(graphic:Graphic):Graphic {
		_graphics[_count++] = graphic;
		if (!active) {
			active = graphic.active;
		}
		return graphic;
	}

	/**
	 * Removes the Graphic from the list.
	 * @param	graphic		The Graphic to remove.
	 * @return	The removed Graphic.
	 */
	public function remove(graphic:Graphic):Graphic {
		if (_graphics.indexOf(graphic) < 0) {
			return graphic;
		}
		_temp = [];
		for (g /* AS3HX WARNING could not determine type for var: g exp: EIdent(_graphics) type: Graphics */ in _graphics) {
			if (g == graphic) {
				_count--;
			} else {
				_temp[_temp.length] = g;
			}
		}
		var temp:Array<Graphic> = _graphics;
		_graphics = _temp;
		_temp = temp;
		updateCheck();
		return graphic;
	}

	/**
	 * Removes the Graphic from the position in the list.
	 * @param	index		Index to remove.
	 */
	public function removeAt(index:Int = 0):Void {
		if (!_graphics.length) {
			return;
		}
		index %= _graphics.length;
		remove(_graphics[index % _graphics.length]);
		updateCheck();
	}

	/**
	 * Removes all Graphics from the list.
	 */
	public function removeAll():Void {
		_graphics.length = _temp.length = _count = 0;
		active = false;
	}

	/**
	 * All Graphics in this list.
	 */
	private function get_children():Array<Graphic> {
		return _graphics;
	}

	/**
	 * Amount of Graphics in this list.
	 */
	private function get_count():Int {
		return _count;
	}

	/**
	 * Check if the Graphiclist should update.
	 */
	private function updateCheck():Void {
		active = false;
		for (g /* AS3HX WARNING could not determine type for var: g exp: EIdent(_graphics) type: Graphics */ in _graphics) {
			if (g.active) {
				active = true;
				return;
			}
		}
	}

	// List information.

	/** @private */
	private var _graphics:Array<Graphic> = new Array<Graphic>();

	/** @private */
	private var _temp:Array<Graphic> = new Array<Graphic>();

	/** @private */
	private var _count:Int = 0;

	/** @private */
	private var _point:Point = new Point();

	/** @private */
	private var _camera:Point = new Point();
}
