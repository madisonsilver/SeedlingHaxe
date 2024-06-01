package net.flashpunk;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.utils.Dictionary;
import net.flashpunk.masks.Hitbox;
import net.flashpunk.masks.Masklist;

/**
 * Base class for Entity collision masks.
 */
class Mask {
	/**
	 * The parent Entity of this mask.
	 */
	public var parent:Entity;

	/**
	 * The parent Masklist of the mask.
	 */
	public var list:Masklist;

	/**
	 * Constructor.
	 */
	public function new() {
		_class = cast((Type.resolveClass(Type.getClassName(Type.getClass(this)))), Class<Dynamic>);
		_check[Mask] = collideMask;
		_check[Masklist] = collideMasklist;
	}

	/**
	 * Checks for collision with another Mask.
	 * @param	mask	The other Mask to check against.
	 * @return	If the Masks overlap.
	 */
	public function collide(mask:Mask):Bool {
		if (_check[mask._class] != null) {
			return _check[mask._class](mask);
		}
		if (mask._check[_class] != null) {
			return mask._check[_class](this);
		}
		return false;
	}

	/** @private Collide against an Entity. */
	private function collideMask(other:Mask):Bool {
		return parent.x - parent.originX + parent.width > other.parent.x - other.parent.originX
			&& parent.y - parent.originY + parent.height > other.parent.y - other.parent.originY
			&& parent.x - parent.originX < other.parent.x - other.parent.originX + other.parent.width
			&& parent.y - parent.originY < other.parent.y - other.parent.originY + other.parent.height;
	}

	/** @private Collide against a Masklist. */
	private function collideMasklist(other:Masklist):Bool {
		return other.collide(this);
	}

	/** @private Assigns the mask to the parent. */
	@:allow(net.flashpunk)
	private function assignTo(parent:Entity):Void {
		this.parent = parent;
		if (parent != null) {
			update();
		}
	}

	/** @private Updates the parent's bounds for this mask. */
	private function update():Void {}

	// Mask information.

	/** @private */
	private var _class:Class<Dynamic>;

	/** @private */
	private var _check:Dictionary<Class<Dynamic>, (Dynamic) -> Bool> = new Dictionary();
}
