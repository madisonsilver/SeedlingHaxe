package net.flashpunk;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.masks.*;
import net.flashpunk.graphics.*;

/**
 * Main game Entity class updated by World.
 */
class Entity extends Tweener {
	public var layer(get, set):Int;
	public var type(get, set):String;
	public var mask(get, set):Mask;
	public var graphic(get, set):Graphic;

	/**
	 * If the Entity should render.
	 */
	public var visible:Bool = true;

	/**
	 * If the Entity should respond to collision checks.
	 */
	public var collidable:Bool = true;

	/**
	 * X position of the Entity in the World.
	 */
	public var x:Float = 0;

	/**
	 * Y position of the Entity in the World.
	 */
	public var y:Float = 0;

	/**
	 * Width of the Entity's hitbox.
	 */
	public var width:Int;

	/**
	 * Height of the Entity's hitbox.
	 */
	public var height:Int;

	/**
	 * X origin of the Entity's hitbox.
	 */
	public var originX:Int;

	/**
	 * Y origin of the Entity's hitbox.
	 */
	public var originY:Int;

	/**
	 * Constructor. Can be usd to place the Entity and assign a graphic and mask.
	 * @param	x			X position to place the Entity.
	 * @param	y			Y position to place the Entity.
	 * @param	graphic		Graphic to assign to the Entity.
	 * @param	mask		Mask to assign to the Entity.
	 */
	public function new(x:Float = 0, y:Float = 0, graphic:Graphic = null, mask:Mask = null) {

		super();
		this.x = x;
		this.y = y;
		if (graphic != null) {
			this.graphic = graphic;
		}
		if (mask != null) {
			this.mask = mask;
		}
		HITBOX.assignTo(this);
		_class = cast((Type.resolveClass(Type.getClassName(Type.getClass(this)))), Class<Dynamic>);
	}

	/**
	 * Override this, called when the Entity is added to a World.
	 */
	public function added():Void {}

	/**
	 * Runs in the first frame of an entity for the world
	 */
	public function check():Void {}

	/**
	 * Override this, called when the Entity is removed from a World.
	 */
	public function removed():Void {}

	/**
	 * Updates the Entity's graphic. If you override this for
	 * update logic, remember to call super.update() if you're
	 * using a Graphic type that animates (eg. Spritemap).
	 */
	override public function update():Void {}

	/**
	 * Renders the Entity. If you override this for special behaviour,
	 * remember to call super.render() to render the Entity's graphic.
	 */
	public function render():Void {
		if (_graphic != null && _graphic.visible) {
			if (_graphic.relative) {
				_point.x = x;
				_point.y = y;
			} else {
				_point.x = _point.y = 0;
			}
			_camera.x = FP.camera.x;
			_camera.y = FP.camera.y;
			_graphic.render(_point, _camera);
		}
	}

	/**
	 * Checks if the object is onscreen (by its bounding box)
	 * @param	n			The margin (positive for out of the screen, negative for into it)
	 * @return	True or false
	 */
	public function onScreen(n:Int = 0):Bool {
		if (x - originX + width < FP.camera.x - n
			|| y - originY + height < FP.camera.y - n
			|| x - originX > FP.camera.x + FP.screen.width + n
			|| y
			- originY > FP.camera.y + FP.screen.height + n) {
			return false;
		}
		return true;
	}

	/**
	 * Checks for a collision against an Entity type.
	 * @param	type		The Entity type to check for.
	 * @param	x			Virtual x position to place this Entity.
	 * @param	y			Virtual y position to place this Entity.
	 * @return	The first Entity collided with, or null if none were collided.
	 */
	public function collide(type:String, x:Float, y:Float):Entity {
		var e:Entity = Reflect.field(FP._world._typeFirst, type);
		if (!collidable || e == null) {
			return null;
		}

		_x = this.x;
		_y = this.y;
		this.x = x;
		this.y = y;

		if (_mask == null) {
			while (e != null) {
				if (x - originX + width > e.x - e.originX
					&& y - originY + height > e.y - e.originY
					&& x - originX < e.x - e.originX + e.width
					&& y
					- originY < e.y - e.originY + e.height
					&& e.collidable
					&& e != this) {
					if (e._mask == null || e._mask.collide(HITBOX)) {
						this.x = _x;
						this.y = _y;
						return e;
					}
				}
				e = e._typeNext;
			}
			this.x = _x;
			this.y = _y;
			return null;
		}

		while (e != null) {
			if (x - originX + width > e.x - e.originX
				&& y - originY + height > e.y - e.originY
				&& x - originX < e.x - e.originX + e.width
				&& y
				- originY < e.y - e.originY + e.height
				&& e.collidable
				&& e != this) {
				if (_mask.collide((e._mask != null) ? e._mask : e.HITBOX)) {
					this.x = _x;
					this.y = _y;
					return e;
				}
			}
			e = e._typeNext;
		}
		this.x = _x;
		this.y = _y;
		return null;
	}

	/**
	 * Checks for collision against multiple Entity types.
	 * @param	types		An Array or Vector of Entity types to check for.
	 * @param	x			Virtual x position to place this Entity.
	 * @param	y			Virtual y position to place this Entity.
	 * @return	The first Entity collided with, or null if none were collided.
	 */
	public function collideTypes(types:Array<Dynamic>, x:Float, y:Float):Entity {
		var e:Entity;
		for (type /* AS3HX WARNING could not determine type for var: type exp: EIdent(types) type: Dynamic */ in types) {
			e = collide(type, x, y);
			if (e != null) {
				return e;
			}
		}
		return null;
	}

	/**
	 * Checks if this Entity collides with a specific Entity.
	 * @param	e		The Entity to collide against.
	 * @param	x		Virtual x position to place this Entity.
	 * @param	y		Virtual y position to place this Entity.
	 * @return	The Entity if they overlap, or null if they don't.
	 */
	public function collideWith(e:Entity, x:Float, y:Float):Entity {
		_x = this.x;
		_y = this.y;
		this.x = x;
		this.y = y;

		if (x - originX + width > e.x - e.originX
			&& y - originY + height > e.y - e.originY
			&& x - originX < e.x - e.originX + e.width
			&& y
			- originY < e.y - e.originY + e.height
			&& collidable
			&& e.collidable) {
			if (_mask == null) {
				if (e._mask == null || e._mask.collide(HITBOX)) {
					this.x = _x;
					this.y = _y;
					return e;
				}
				this.x = _x;
				this.y = _y;
				return null;
			}
			if (_mask.collide((e._mask != null) ? e._mask : e.HITBOX)) {
				this.x = _x;
				this.y = _y;
				return e;
			}
		}
		this.x = _x;
		this.y = _y;
		return null;
	}

	/**
	 * Checks if this Entity overlaps the specified rectangle.
	 * @param	x			Virtual x position to place this Entity.
	 * @param	y			Virtual y position to place this Entity.
	 * @param	rX			X position of the rectangle.
	 * @param	rY			Y position of the rectangle.
	 * @param	rWidth		Width of the rectangle.
	 * @param	rHeight		Height of the rectangle.
	 * @return	If they overlap.
	 */
	public function collideRect(x:Float, y:Float, rX:Float, rY:Float, rWidth:Float, rHeight:Float):Bool {
		if (x - originX + width >= rX && y - originY + height >= rY && x - originX <= rX + rWidth && y - originY <= rY + rHeight) {
			if (_mask == null) {
				return true;
			}
			_x = this.x;
			_y = this.y;
			this.x = x;
			this.y = y;
			FP.entity.x = rX;
			FP.entity.y = rY;
			FP.entity.width = (cast rWidth : Int);
			FP.entity.height = (cast rHeight : Int);
			if (_mask.collide(FP.entity.HITBOX)) {
				this.x = _x;
				this.y = _y;
				return true;
			}
			this.x = _x;
			this.y = _y;
			return false;
		}
		return false;
	}

	/**
	 * Checks if this Entity overlaps the specified position.
	 * @param	x			Virtual x position to place this Entity.
	 * @param	y			Virtual y position to place this Entity.
	 * @param	pX			X position.
	 * @param	pY			Y position.
	 * @return	If the Entity intersects with the position.
	 */
	public function collidePoint(x:Float, y:Float, pX:Float, pY:Float):Bool {
		if (pX >= x - originX && pY >= y - originY && pX < x - originX + width && pY < y - originY + height) {
			if (_mask == null) {
				return true;
			}
			_x = this.x;
			_y = this.y;
			this.x = x;
			this.y = y;
			FP.entity.x = pX;
			FP.entity.y = pY;
			FP.entity.width = 1;
			FP.entity.height = 1;
			if (_mask.collide(FP.entity.HITBOX)) {
				this.x = _x;
				this.y = _y;
				return true;
			}
			this.x = _x;
			this.y = _y;
			return false;
		}
		return false;
	}

	/**
	 * Populates an array with all collided Entities of a type.
	 * @param	type		The Entity type to check for.
	 * @param	x			Virtual x position to place this Entity.
	 * @param	y			Virtual y position to place this Entity.
	 * @param	array		The Array or Vector object to populate.
	 * @return	The array, populated with all collided Entities.
	 */
	public function collideInto(type:String, x:Float, y:Float, array:Dynamic):Void {
		var e:Entity = FP._world._typeFirst[type];
		if (!collidable || e == null) {
			return;
		}

		_x = this.x;
		_y = this.y;
		this.x = x;
		this.y = y;
		var n:Int = array.length;

		if (_mask == null) {
			while (e != null) {
				if (x - originX + width > e.x - e.originX
					&& y - originY + height > e.y - e.originY
					&& x - originX < e.x - e.originX + e.width
					&& y
					- originY < e.y - e.originY + e.height
					&& e.collidable
					&& e != this) {
					if (_mask == null || e._mask.collide(HITBOX)) {
						Reflect.setField(array, Std.string(n++), e);
					}
				}
				e = e._typeNext;
			}
			this.x = _x;
			this.y = _y;
			return;
		}

		while (e != null) {
			if (x - originX + width > e.x - e.originX
				&& y - originY + height > e.y - e.originY
				&& x - originX < e.x - e.originX + e.width
				&& y
				- originY < e.y - e.originY + e.height
				&& e.collidable
				&& e != this) {
				if (_mask.collide((e._mask != null) ? e._mask : e.HITBOX)) {
					Reflect.setField(array, Std.string(n++), e);
				}
			}
			e = e._typeNext;
		}
		this.x = _x;
		this.y = _y;
		return;
	}

	/**
	 * Populates an array with all collided Entities of multiple types.
	 * @param	types		An array of Entity types to check for.
	 * @param	x			Virtual x position to place this Entity.
	 * @param	y			Virtual y position to place this Entity.
	 * @param	array		The Array or Vector object to populate.
	 * @return	The array, populated with all collided Entities.
	 */
	public function collideTypesInto(types:Array<Dynamic>, x:Float, y:Float, array:Dynamic):Void {
		for (type /* AS3HX WARNING could not determine type for var: type exp: EIdent(types) type: Dynamic */ in types) {
			collideInto(type, x, y, array);
		}
	}

	/**
	 * The rendering layer of this Entity. Higher layers are rendered first.
	 */
	private function get_layer():Int {
		return _layer;
	}

	private function set_layer(value:Int):Int {
		if (_layer == value) {
			return value;
		}
		if (!_added) {
			_layer = value;
			return value;
		}
		_world.removeRender(this);
		_layer = value;
		_world.addRender(this);
		return value;
	}

	/**
	 * The collision type, used for collision checking.
	 */
	private function get_type():String {
		return _type;
	}

	private function set_type(value:String):String {
		if (_type == value) {
			return value;
		}
		if (!_added) {
			_type = value;
			return value;
		}
		if (_type != null && type != "") {
			_world.removeType(this);
		}
		_type = value;
		if (value != null && value != null) {
			_world.addType(this);
		}
		return value;
	}

	/**
	 * An optional Mask component, used for specialized collision. If this is
	 * not assigned, collision checks will use the Entity's hitbox by default.
	 */
	private function get_mask():Mask {
		return _mask;
	}

	private function set_mask(value:Mask):Mask {
		if (_mask == value) {
			return value;
		}
		if (_mask != null) // Was "_mask"
		{
			_mask.assignTo(null);
		}
		_mask = value;
		if (value != null) {
			_mask.assignTo(this);
		}
		return value;
	}

	/**
	 * Graphical component to render to the screen.
	 */
	private function get_graphic():Graphic {
		return _graphic;
	}

	private function set_graphic(value:Graphic):Graphic {
		if (_graphic == value) {
			return value;
		}
		_graphic = value;
		if (value != null && value._assign != null) {
			value._assign();
		}
		return value;
	}

	/**
	 * Sets the Entity's hitbox properties.
	 * @param	width		Width of the hitbox.
	 * @param	height		Height of the hitbox.
	 * @param	originX		X origin of the hitbox.
	 * @param	originY		Y origin of the hitbox.
	 */
	public function setHitbox(width:Int = 0, height:Int = 0, originX:Int = 0, originY:Int = 0):Void {
		this.width = width;
		this.height = height;
		this.originX = originX;
		this.originY = originY;
	}

	/**
	 * Calculates the distance from another Entity.
	 * @param	e				The other Entity.
	 * @param	useHitboxes		If hitboxes should be used to determine the distance. If not, the Entities' x/y positions are used.
	 * @return	The distance.
	 */
	public function distanceFrom(e:Entity, useHitboxes:Bool = false):Float {
		if (!useHitboxes) {
			return Math.sqrt((x - e.x) * (x - e.x) + (y - e.y) * (y - e.y));
		}
		return FP.distanceRects(x - originX, y - originY, width, height, e.x - e.originX, e.y - e.originY, e.width, e.height);
	}

	/**
	 * Calculates the distance from this Entity to the point.
	 * @param	px				X position.
	 * @param	py				Y position.
	 * @param	useHitboxes		If hitboxes should be used to determine the distance. If not, the Entities' x/y positions are used.
	 * @return	The distance.
	 */
	public function distanceToPoint(px:Float, py:Float, useHitbox:Bool = false):Float {
		if (!useHitbox) {
			return Math.sqrt((x - px) * (x - px) + (y - py) * (y - py));
		}
		return FP.distanceRectPoint(px, py, x - originX, y - originY, width, height);
	}

	/**
	 * Calculates the distance from this Entity to the rectangle.
	 * @param	rx			X position of the rectangle.
	 * @param	ry			Y position of the rectangle.
	 * @param	rwidth		Width of the rectangle.
	 * @param	rheight		Height of the rectangle.
	 * @return	The distance.
	 */
	public function distanceToRect(rx:Float, ry:Float, rwidth:Float, rheight:Float):Float {
		return FP.distanceRects(rx, ry, rwidth, rheight, x - originX, y - originY, width, height);
	}

	/**
	 * Gets the class name as a string.
	 * @return	A string representing the class name.
	 */
	public function toString():String {
		var s:String = Std.string(_class);
		return s.substring(7, s.length - 1);
	}

	// Entity information.

	/** @private */ @:allow(net.flashpunk)
	private var _class:Class<Dynamic>;

	/** @private */ @:allow(net.flashpunk)
	private var _world:World;

	/** @private */ @:allow(net.flashpunk)
	private var _added:Bool;

	/** @private */ @:allow(net.flashpunk)
	private var _type:String = "";

	/** @private */ @:allow(net.flashpunk)
	private var _layer:Int;

	/** @private */ @:allow(net.flashpunk)
	private var _updatePrev:Entity;

	/** @private */ @:allow(net.flashpunk)
	private var _updateNext:Entity;

	/** @private */ @:allow(net.flashpunk)
	private var _renderPrev:Entity;

	/** @private */ @:allow(net.flashpunk)
	private var _renderNext:Entity;

	/** @private */ @:allow(net.flashpunk)
	private var _typePrev:Entity;

	/** @private */ @:allow(net.flashpunk)
	private var _typeNext:Entity;

	/** @private */ @:allow(net.flashpunk)
	private var _recycleNext:Entity;

	// Collision information.

	/** @private */
	private var HITBOX(default, never):Mask = new Mask();

	/** @private */
	private var _mask:Mask;

	/** @private */
	private var _x:Float;

	/** @private */
	private var _y:Float;

	// Rendering information.

	/** @private */ @:allow(net.flashpunk)
	private var _graphic:Graphic;

	/** @private */
	private var _point:Point = FP.point;

	/** @private */
	private var _camera:Point = FP.point2;
}
