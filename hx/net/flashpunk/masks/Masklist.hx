package net.flashpunk.masks;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.*;
import net.flashpunk.masks.Masklist;

/**
 * A Mask that can contain multiple Masks of one or various types.
 */
class Masklist extends Hitbox {
	public var count(get, never):Int;

	/**
	 * Constructor.
	 * @param	...mask		Masks to add to the list.
	 */
	public function new(mask:Array<Dynamic> = null) {

		super();
		for (m in mask) {
			add(m);
		}
	}

	/** @private Collide against a mask. */
	override public function collide(mask:Mask):Bool {
		for (m /* AS3HX WARNING could not determine type for var: m exp: EIdent(_masks) type: null */ in _masks) {
			if (m.collide(mask)) {
				return true;
			}
		}
		return false;
	}

	/** @private Collide against a Masklist. */
	override private function collideMasklist(other:Masklist):Bool {
		for (a /* AS3HX WARNING could not determine type for var: a exp: EIdent(_masks) type: null */ in _masks) {
			for (b /* AS3HX WARNING could not determine type for var: b exp: EField(EIdent(other),_masks) type: null */ in other._masks) {
				if (a.collide(b)) {
					return true;
				}
			}
		}
		return true;
	}

	/**
	 * Adds a Mask to the list.
	 * @param	mask		The Mask to add.
	 * @return	The added Mask.
	 */
	public function add(mask:Mask):Mask {
		_masks[_count++] = mask;
		mask.list = this;
		update();
		return mask;
	}

	/**
	 * Removes the Mask from the list.
	 * @param	mask		The Mask to remove.
	 * @return	The removed Mask.
	 */
	public function remove(mask:Mask):Mask {
		if (_masks.indexOf(mask) < 0) {
			return mask;
		}
		_temp = [];
		for (m /* AS3HX WARNING could not determine type for var: m exp: EIdent(_masks) type: null */ in _masks) {
			if (m == mask) {
				mask.list = null;
				_count--;
				update();
			} else {
				_temp[_temp.length] = m;
			}
		}
		var temp:Array<Mask> = _masks;
		_masks = _temp;
		_temp = temp;
		return mask;
	}

	/**
	 * Removes the Mask at the index.
	 * @param	index		The Mask index.
	 */
	public function removeAt(index:Int = 0):Void {
		_temp = [];
		var i:Int = _masks.length;
		index %= i;
		while (i-- != 0) {
			if (i == index) {
				_masks[index].list = null;
				_count--;
				update();
			} else {
				_temp[_temp.length] = _masks[index];
			}
		}
		var temp:Array<Mask> = _masks;
		_masks = _temp;
		_temp = temp;
	}

	/**
	 * Removes all Masks from the list.
	 */
	public function removeAll():Void {
		for (m /* AS3HX WARNING could not determine type for var: m exp: EIdent(_masks) type: null */ in _masks) {
			m.list = null;
		}
		while (_masks.length > 0) {
			_masks.pop();
		}
		while (_temp.length > 0) {
			_temp.pop();
		}
		_count = 0;
		update();
	}

	/**
	 * Gets a Mask from the list.
	 * @param	index		The Mask index.
	 * @return	The Mask at the index.
	 */
	public function getMask(index:Int = 0):Mask {
		return _masks[index % _masks.length];
	}

	/** @private Updates the parent's bounds for this mask. */
	override private function update():Void // find bounds of the contained masks
	{
		var t:Int = 0;
		var l:Int = 0;
		var r:Int = 0;
		var b:Int = 0;
		var h:Hitbox;
		var i:Int = _count;
		while (i-- != 0) {
			var h = try cast(_masks[i], Hitbox) catch (e:Dynamic) null;
			if (h != null) {
				if (h._x < l) {
					l = h._x;
				}
				if (h._y < t) {
					t = h._y;
				}
				if (h._x + h._width > r) {
					r = as3hx.Compat.parseInt(h._x + h._width);
				}
				if (h._y + h._height > b) {
					b = as3hx.Compat.parseInt(h._y + h._height);
				}
			}
		}

		// update hitbox bounds
		_x = l;
		_y = t;
		_width = as3hx.Compat.parseInt(r - l);
		_height = as3hx.Compat.parseInt(b - t);
		super.update();
	}

	/**
	 * Amount of Masks in the list.
	 */
	private function get_count():Int {
		return _count;
	}

	// List information.

	/** @private */
	private var _masks:Array<Mask> = new Array<Mask>();

	/** @private */
	private var _temp:Array<Mask> = new Array<Mask>();

	/** @private */
	private var _count:Int;
}
