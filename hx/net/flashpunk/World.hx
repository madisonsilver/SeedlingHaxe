package net.flashpunk;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.utils.Dictionary;
import net.flashpunk.utils.Input;

/**
 * Updated by Engine, main game container that holds all currently active Entities.
 * Useful for organization, eg. "Menu", "Level1", etc.
 */
class World extends Tweener {
	public var mouseX(get, never):Int;
	public var mouseY(get, never):Int;
	public var count(get, never):Int;
	public var first(get, never):Entity;
	public var layers(get, never):Int;
	public var farthest(get, never):Entity;
	public var nearest(get, never):Entity;
	public var layerFarthest(get, never):Int;
	public var layerNearest(get, never):Int;
	public var uniqueTypes(get, never):Int;

	/**
	 * If the render() loop is performed.
	 */
	public var visible:Bool = true;

	/**
	 * Constructor.
	 */
	public function new() {
		super();
	}

	/**
	 * Override this; called when World is switch to, and set to the currently active world.
	 */
	public function begin():Void {}

	/**
	 * Override this; called when World is changed, and the active world is no longer this.
	 */
	public function end():Void {}

	/**
	 * Performed by the game loop, updates all contained Entities.
	 * If you override this to give your World update code, remember
	 * to call super.update() or your Entities will not be updated.
	 */
	override public function update():Void // update the entities
	{
		var e:Entity = _updateFirst;
		while (e != null) {
			if (e.active) {
				if (e._tween != null) {
					e.updateTweens();
				}
				e.update();
			}
			if (e._graphic != null && e._graphic.active) {
				e._graphic.update();
			}
			e = e._updateNext;
		}
	}

	/**
	 * Performed by the game loop, renders all contained Entities.
	 * If you override this to give your World render code, remember
	 * to call super.render() or your Entities will not be rendered.
	 */
	public function render():Void // render the entities in order of depth
	{
		var e:Entity;
		var i:Int = _layerList.length;
		while (i-- != 0) {
			e = _renderLast[_layerList[i]];
			while (e != null) {
				if (e.visible) {
					e.render();
				}
				e = e._renderPrev;
			}
		}
	}

	/**
	 * X position of the mouse in the World.
	 */
	private function get_mouseX():Int {
		return Std.int(FP.screen.mouseX + FP.camera.x);
	}

	/**
	 * Y position of the mouse in the world.
	 */
	private function get_mouseY():Int {
		return Std.int(FP.screen.mouseY + FP.camera.y);
	}

	/**
	 * Adds the Entity to the World at the end of the frame.
	 * @param	e		Entity object you want to add.
	 * @return	The added Entity object.
	 */
	public function add(e:Entity):Entity {
		if (e._world != null) {
			return e;
		}
		_add[_add.length] = e;
		e._world = this;
		return e;
	}

	/**
	 * Removes the Entity from the World at the end of the frame.
	 * @param	e		Entity object you want to remove.
	 * @return	The removed Entity object.
	 */
	public function remove(e:Entity):Entity {
		if (e._world != this) {
			return e;
		}
		_remove[_remove.length] = e;
		e._world = null;
		return e;
	}

	/**
	 * Removes all Entities from the World at the end of the frame.
	 */
	public function removeAll():Void {
		var e:Entity = _updateFirst;
		while (e != null) {
			_remove[_remove.length] = e;
			e._world = null;
			e = e._updateNext;
		}
	}

	/**
	 * Adds multiple Entities to the world.
	 * @param	...list		Several Entities (as arguments) or an Array/Vector of Entities.
	 */
	public function addList(list:Array<Dynamic> = null):Void {
		var e:Entity;
		if (Std.isOfType(list[0], Array)) {
			for (e in (cast list[0] : Array<Dynamic>)) {
				add(e);
			}
			return;
		}
		for (e in list) {
			add(e);
		}
	}

	/**
	 * Removes multiple Entities from the world.
	 * @param	...list		Several Entities (as arguments) or an Array/Vector of Entities.
	 */
	public function removeList(list:Array<Dynamic> = null):Void {
		var e:Entity;
		if (Std.isOfType(list[0], Array)) {
			for (e in (cast list[0] : Array<Dynamic>)) {
				remove(e);
			}
			return;
		}
		for (e in list) {
			remove(e);
		}
	}

	/**
	 * Adds an Entity to the World with the Graphic object.
	 * @param	graphic		Graphic to assign the Entity.
	 * @param	x			X position of the Entity.
	 * @param	y			Y position of the Entity.
	 * @param	layer		Layer of the Entity.
	 * @return	The Entity that was added.
	 */
	public function addGraphic(graphic:Graphic, layer:Int = 0, x:Int = 0, y:Int = 0):Entity {
		var e:Entity = new Entity(x, y, graphic);
		if (layer != 0) {
			e.layer = layer;
		}
		e.active = false;
		return add(e);
	}

	/**
	 * Adds an Entity to the World with the Mask object.
	 * @param	mask	Mask to assign the Entity.
	 * @param	type	Collision type of the Entity.
	 * @param	x		X position of the Entity.
	 * @param	y		Y position of the Entity.
	 * @return	The Entity that was added.
	 */
	public function addMask(mask:Mask, type:String, x:Int = 0, y:Int = 0):Entity {
		var e:Entity = new Entity(x, y, null, mask);
		if (type != null) {
			e.type = type;
		}
		e.active = e.visible = false;
		return add(e);
	}

	/**
	 * Returns a new Entity, or a stored recycled Entity if one exists.
	 * @param	classType		The Class of the Entity you want to add.
	 * @param	addToWorld		Add it to the World immediately.
	 * @return	The new Entity object.
	 */
	public function create(classType:Class<Dynamic>, addToWorld:Bool = true):Entity {
		var e:Entity = _recycled[Type.getClassName(classType)];
		if (e != null) {
			_recycled[Type.getClassName(classType)] = e._recycleNext;
			e._recycleNext = null;
		} else {
			e = Type.createInstance(classType, []);
		}
		if (addToWorld) {
			return add(e);
		}
		return e;
	}

	/**
	 * Removes the Entity from the World at the end of the frame and recycles it.
	 * The recycled Entity can then be fetched again by calling the create() function.
	 * @param	e		The Entity to recycle.
	 * @return	The recycled Entity.
	 */
	public function recycle(e:Entity):Entity {
		if (e._world != this) {
			return e;
		}
		e._recycleNext = _recycled[Type.getClassName(e._class)];
		_recycled[Type.getClassName(e._class)] = e;
		return remove(e);
	}

	/**
	 * Clears stored reycled Entities of the Class type.
	 * @param	classType		The Class type to clear.
	 */
	public function clearRecycled(classType:Class<Dynamic>):Void {
		var e:Entity = _recycled[Type.getClassName(classType)];
		var n:Entity;
		while (e != null) {
			n = e._recycleNext;
			e._recycleNext = null;
			e = n;
		};
	}

	/**
	 * Clears stored recycled Entities of all Class types.
	 */
	public function clearRecycledAll():Void {
		for (classType in _recycled.keys()) {
			clearRecycled(Type.getClass(classType));
		}
	}

	/**
	 * Brings the Entity to the front of its contained layer.
	 * @param	e		The Entity to shift.
	 * @return	If the Entity changed position.
	 */
	public function bringToFront(e:Entity):Bool {
		if (e._world != this || (e._renderPrev == null)) {
			return false;
		}
		// pull from list
		e._renderPrev._renderNext = e._renderNext;
		if (e._renderNext != null) {
			e._renderNext._renderPrev = e._renderPrev;
		} else {
			_renderLast[e._layer] = e._renderPrev;
		}
		// place at the start
		e._renderNext = _renderFirst[e._layer];
		e._renderNext._renderPrev = e;
		_renderFirst[e._layer] = e;
		e._renderPrev = null;
		return true;
	}

	/**
	 * Sends the Entity to the back of its contained layer.
	 * @param	e		The Entity to shift.
	 * @return	If the Entity changed position.
	 */
	public function sendToBack(e:Entity):Bool {
		if (e._world != this || (e._renderNext == null)) {
			return false;
		}
		// pull from list
		e._renderNext._renderPrev = e._renderPrev;
		if (e._renderPrev != null) {
			e._renderPrev._renderNext = e._renderNext;
		} else {
			_renderFirst[e._layer] = e._renderNext;
		}
		// place at the end
		e._renderPrev = _renderLast[e._layer];
		e._renderPrev._renderNext = e;
		_renderLast[e._layer] = e;
		e._renderNext = null;
		return true;
	}

	/**
	 * Shifts the Entity one place towards the front of its contained layer.
	 * @param	e		The Entity to shift.
	 * @return	If the Entity changed position.
	 */
	public function bringForward(e:Entity):Bool {
		if (e._world != this || (e._renderPrev == null)) {
			return false;
		}
		// pull from list
		e._renderPrev._renderNext = e._renderNext;
		if (e._renderNext != null) {
			e._renderNext._renderPrev = e._renderPrev;
		} else {
			_renderLast[e._layer] = e._renderPrev;
		}
		// shift towards the front
		e._renderNext = e._renderPrev;
		e._renderPrev = e._renderPrev._renderPrev;
		e._renderNext._renderPrev = e;
		if (e._renderPrev != null) {
			e._renderPrev._renderNext = e;
		} else {
			_renderFirst[e._layer] = e;
		}
		return true;
	}

	/**
	 * Shifts the Entity one place towards the back of its contained layer.
	 * @param	e		The Entity to shift.
	 * @return	If the Entity changed position.
	 */
	public function sendBackward(e:Entity):Bool {
		if (e._world != this || (e._renderNext == null)) {
			return false;
		}
		// pull from list
		e._renderNext._renderPrev = e._renderPrev;
		if (e._renderPrev != null) {
			e._renderPrev._renderNext = e._renderNext;
		} else {
			_renderFirst[e._layer] = e._renderNext;
		}
		// shift towards the back
		e._renderPrev = e._renderNext;
		e._renderNext = e._renderNext._renderNext;
		e._renderPrev._renderNext = e;
		if (e._renderNext != null) {
			e._renderNext._renderPrev = e;
		} else {
			_renderLast[e._layer] = e;
		}
		return true;
	}

	/**
	 * If the Entity as at the front of its layer.
	 * @param	e		The Entity to check.
	 * @return	True or false.
	 */
	public function isAtFront(e:Entity):Bool {
		return e._renderPrev == null;
	}

	/**
	 * If the Entity as at the back of its layer.
	 * @param	e		The Entity to check.
	 * @return	True or false.
	 */
	public function isAtBack(e:Entity):Bool {
		return e._renderNext == null;
	}

	/**
	 * Returns the first Entity that collides with the rectangular area.
	 * @param	type		The Entity type to check for.
	 * @param	rX			X position of the rectangle.
	 * @param	rY			Y position of the rectangle.
	 * @param	rWidth		Width of the rectangle.
	 * @param	rHeight		Height of the rectangle.
	 * @return	The first Entity to collide, or null if none collide.
	 */
	public function collideRect(type:String, rX:Float, rY:Float, rWidth:Float, rHeight:Float):Entity {
		var e:Entity = _typeFirst[type];
		while (e != null) {
			if (e.collideRect(e.x, e.y, rX, rY, rWidth, rHeight)) {
				return e;
			}
			e = e._typeNext;
		}
		return null;
	}

	/**
	 * Returns the first Entity found that collides with the position.
	 * @param	type		The Entity type to check for.
	 * @param	pX			X position.
	 * @param	pY			Y position.
	 * @return	The collided Entity, or null if none collide.
	 */
	public function collidePoint(type:String, pX:Float, pY:Float):Entity {
		var e:Entity = _typeFirst[type];
		while (e != null) {
			if (e.collidePoint(e.x, e.y, pX, pY)) {
				return e;
			}
			e = e._typeNext;
		}
		return null;
	}

	/**
	 * Returns the first Entity found that collides with the line.
	 * @param	type		The Entity type to check for.
	 * @param	fromX		Start x of the line.
	 * @param	fromY		Start y of the line.
	 * @param	toX			End x of the line.
	 * @param	toY			End y of the line.
	 * @param	precision		
	 * @param	p
	 * @return
	 */
	public function collideLine(type:String, fromX:Int, fromY:Int, toX:Int, toY:Int, precision:Int = 1,
			p:Point = null):Entity // If the distance is less than precision, do the short sweep.
	{
		if (precision < 1) {
			precision = 1;
		}
		if (FP.distance(fromX, fromY, toX, toY) < precision) {
			if (p != null) {
				if (fromX == toX && fromY == toY) {
					p.x = toX;
					p.y = toY;
					return collidePoint(type, toX, toY);
				}
				return collideLine(type, fromX, fromY, toX, toY, 1, p);
			} else {
				return collidePoint(type, fromX, toY);
			}
		}

		// Get information about the line we're about to raycast.
		var xDelta:Int = Std.int(Math.abs(toX - fromX));
		var yDelta:Int = Std.int(Math.abs(toY - fromY));
		var xSign:Float = (toX > fromX) ? precision : -precision;
		var ySign:Float = (toY > fromY) ? precision : -precision;
		var x:Float = fromX;
		var y:Float = fromY;
		var e:Entity;

		// Do a raycast from the start to the end point.
		if (xDelta > yDelta) {
			ySign *= yDelta / xDelta;
			if (xSign > 0) {
				while (x < toX) {
					e = collidePoint(type, x, y);
					if (e != null) {
						if (p == null) {
							return e;
						}
						if (precision < 2) {
							p.x = x - xSign;
							p.y = y - ySign;
							return e;
						}
						return collideLine(type, Std.int(x - xSign), Std.int(y - ySign), toX, toY, 1, p);
					}
					x += xSign;
					y += ySign;
				}
			} else {
				while (x > toX) {
					e = collidePoint(type, x, y);
					if (e != null) {
						if (p == null) {
							return e;
						}
						if (precision < 2) {
							p.x = x - xSign;
							p.y = y - ySign;
							return e;
						}
						return collideLine(type, Std.int(x - xSign), Std.int(y - ySign), toX, toY, 1, p);
					}
					x += xSign;
					y += ySign;
				}
			}
		} else {
			xSign *= xDelta / yDelta;
			if (ySign > 0) {
				while (y < toY) {
					e = collidePoint(type, x, y);
					if (e != null) {
						if (p == null) {
							return e;
						}
						if (precision < 2) {
							p.x = x - xSign;
							p.y = y - ySign;
							return e;
						}
						return collideLine(type, Std.int(x - xSign), Std.int(y - ySign), toX, toY, 1, p);
					}
					x += xSign;
					y += ySign;
				}
			} else {
				while (y > toY) {
					e = collidePoint(type, x, y);
					if (e != null) {
						if (p == null) {
							return e;
						}
						if (precision < 2) {
							p.x = x - xSign;
							p.y = y - ySign;
							return e;
						}
						return collideLine(type, Std.int(x - xSign), Std.int(y - ySign), toX, toY, 1, p);
					}
					x += xSign;
					y += ySign;
				}
			}
		}

		// Check the last position.
		if (precision > 1) {
			if (p == null) {
				return collidePoint(type, toX, toY);
			}
			if (collidePoint(type, toX, toY) != null) {
				return collideLine(type, Std.int(x - xSign), Std.int(y - ySign), toX, toY, 1, p);
			}
		}

		// No collision, return the end point.
		if (p != null) {
			p.x = toX;
			p.y = toY;
		}
		return null;
	}

	/**
	 * Populates an array with all Entities that collide with the rectangle. This
	 * function does not empty the array, that responsibility is left to the user.
	 * @param	type		The Entity type to check for.
	 * @param	rX			X position of the rectangle.
	 * @param	rY			Y position of the rectangle.
	 * @param	rWidth		Width of the rectangle.
	 * @param	rHeight		Height of the rectangle.
	 * @param	into		The Array or Vector to populate with collided Entities.
	 */
	public function collideRectInto(type:String, rX:Float, rY:Float, rWidth:Float, rHeight:Float, into:Dynamic):Void {
		if (Std.isOfType(into, Array) || Std.isOfType(into, Array /*Vector.<T> call?*/)) {
			var e:Entity = _typeFirst[type];
			var n:Int = into.length;
			while (e != null) {
				if (e.collideRect(e.x, e.y, rX, rY, rWidth, rHeight)) {
					Reflect.setField(into, Std.string(n++), e);
				}
				e = e._typeNext;
			}
		}
	}

	/**
	 * Populates an array with all Entities that collide with the position. This
	 * function does not empty the array, that responsibility is left to the user.
	 * @param	type		The Entity type to check for.
	 * @param	pX			X position.
	 * @param	pY			Y position.
	 * @param	into		The Array or Vector to populate with collided Entities.
	 * @return	The provided Array.
	 */
	public function collidePointInto(type:String, pX:Float, pY:Float, into:Dynamic):Void {
		if (Std.isOfType(into, Array) || Std.isOfType(into, Array /*Vector.<T> call?*/)) {
			var e:Entity = _typeFirst[type];
			var n:Int = into.length;
			while (e != null) {
				if (e.collidePoint(e.x, e.y, pX, pY)) {
					Reflect.setField(into, Std.string(n++), e);
				}
				e = e._typeNext;
			}
		}
	}

	/**
	 * Finds the Entity nearest to the rectangle.
	 * @param	type		The Entity type to check for.
	 * @param	x			X position of the rectangle.
	 * @param	y			Y position of the rectangle.
	 * @param	width		Width of the rectangle.
	 * @param	height		Height of the rectangle.
	 * @return	The nearest Entity to the rectangle.
	 */
	public function nearestToRect(type:String, x:Float, y:Float, width:Float, height:Float):Entity {
		var n:Entity = _typeFirst[type];
		var nearDist:Float = as3hx.Compat.FLOAT_MAX;
		var near:Entity = null;
		var dist:Float;
		while (n != null) {
			dist = squareRects(x, y, width, height, n.x - n.originX, n.y - n.originY, n.width, n.height);
			if (dist < nearDist) {
				nearDist = dist;
				near = n;
			}
			n = n._typeNext;
		}
		return near;
	}

	/**
	 * Finds the Entity nearest to another.
	 * @param	type		The Entity type to check for.
	 * @param	e			The Entity to find the nearest to.
	 * @param	useHitboxes	If the Entities' hitboxes should be used to determine the distance. If false, their x/y coordinates are used.
	 * @return	The nearest Entity to e.
	 */
	public function nearestToEntity(type:String, e:Entity, useHitboxes:Bool = false):Entity {
		if (useHitboxes) {
			return nearestToRect(type, e.x - e.originX, e.y - e.originY, e.width, e.height);
		}
		var n:Entity = _typeFirst[type];
		var nearDist:Float = as3hx.Compat.FLOAT_MAX;
		var near:Entity = null;
		var dist:Float;
		var x:Float = e.x - e.originX;
		var y:Float = e.y - e.originY;
		while (n != null) {
			dist = (x - n.x) * (x - n.x) + (y - n.y) * (y - n.y);
			if (dist < nearDist) {
				nearDist = dist;
				near = n;
			}
			n = n._typeNext;
		}
		return near;
	}

	/**
	 * Finds the Entity nearest to the position.
	 * @param	type		The Entity type to check for.
	 * @param	x			X position.
	 * @param	y			Y position.
	 * @param	useHitboxes	If the Entities' hitboxes should be used to determine the distance. If false, their x/y coordinates are used.
	 * @return	The nearest Entity to the position.
	 */
	public function nearestToPoint(type:String, x:Float, y:Float, useHitboxes:Bool = false):Entity {
		var n:Entity = _typeFirst[type];
		var nearDist:Float = as3hx.Compat.FLOAT_MAX;
		var near:Entity = null;
		var dist:Float;
		if (useHitboxes) {
			while (n != null) {
				dist = squarePointRect(x, y, n.x - n.originX, n.y - n.originY, n.width, n.height);
				if (dist < nearDist) {
					nearDist = dist;
					near = n;
				}
				n = n._typeNext;
			}
			return near;
		}
		while (n != null) {
			dist = (x - n.x) * (x - n.x) + (y - n.y) * (y - n.y);
			if (dist < nearDist) {
				nearDist = dist;
				near = n;
			}
			n = n._typeNext;
		}
		return near;
	}

	/**
	 * How many Entities are in the World.
	 */
	private function get_count():Int {
		return _count;
	}

	/**
	 * Returns the amount of Entities of the type are in the World.
	 * @param	type		The type (or Class type) to count.
	 * @return	How many Entities of type exist in the World.
	 */
	public function typeCount(type:String):Int {
		return try cast(Reflect.field(_typeCount, type), Int) catch (e:Dynamic) null;
	}

	/**
	 * Returns the amount of Entities of the Class are in the World.
	 * @param	c		The Class type to count.
	 * @return	How many Entities of Class exist in the World.
	 */
	public function classCount(c:Class<Dynamic>):Int {
		var count:Null<Int> = _classCount[Type.getClassName(c)];
		if (count == null) {
			return 0;
		} else {
			return count;
		}
	}

	/**
	 * Returns the amount of Entities are on the layer in the World.
	 * @param	layer		The layer to count Entities on.
	 * @return	How many Entities are on the layer.
	 */
	public function layerCount(layer:Int):Int {
		return try cast(_layerCount[layer], Int) catch (e:Dynamic) null;
	}

	/**
	 * The first Entity in the World.
	 */
	private function get_first():Entity {
		return _updateFirst;
	}

	/**
	 * How many Entity layers the World has.
	 */
	private function get_layers():Int {
		return _layerList.length;
	}

	/**
	 * The first Entity of the type.
	 * @param	type		The type to check.
	 * @return	The Entity.
	 */
	public function typeFirst(type:String):Entity {
		if (_updateFirst == null) {
			return null;
		}
		return try cast(_typeFirst[type], Entity) catch (e:Dynamic) null;
	}

	/**
	 * The first Entity of the Class.
	 * @param	c		The Class type to check.
	 * @return	The Entity.
	 */
	public function classFirst(c:Class<Dynamic>):Entity {
		if (_updateFirst == null) {
			return null;
		}
		var e:Entity = _updateFirst;
		while (e != null) {
			if (Std.isOfType(e, c)) {
				return e;
			}
			e = e._updateNext;
		}
		return null;
	}

	/**
	 * The first Entity on the Layer.
	 * @param	layer		The layer to check.
	 * @return	The Entity.
	 */
	public function layerFirst(layer:Int):Entity {
		if (_updateFirst == null) {
			return null;
		}
		return try cast(_renderFirst[layer], Entity) catch (e:Dynamic) null;
	}

	/**
	 * The last Entity on the Layer.
	 * @param	layer		The layer to check.
	 * @return	The Entity.
	 */
	public function layerLast(layer:Int):Entity {
		if (_updateFirst == null) {
			return null;
		}
		return try cast(_renderLast[layer], Entity) catch (e:Dynamic) null;
	}

	/**
	 * The Entity that will be rendered first by the World.
	 */
	private function get_farthest():Entity {
		if (_updateFirst == null) {
			return null;
		}
		return try cast(_renderLast[Std.int(_layerList[_layerList.length - 1])], Entity) catch (e:Dynamic) null;
	}

	/**
	 * The Entity that will be rendered last by the world.
	 */
	private function get_nearest():Entity {
		if (_updateFirst == null) {
			return null;
		}
		return try cast(_renderFirst[Std.int(_layerList[0])], Entity) catch (e:Dynamic) null;
	}

	/**
	 * The layer that will be rendered first by the World.
	 */
	private function get_layerFarthest():Int {
		if (_updateFirst == null) {
			return 0;
		}
		return Std.int(_layerList[_layerList.length - 1]);
	}

	/**
	 * The layer that will be rendered last by the World.
	 */
	private function get_layerNearest():Int {
		if (_updateFirst == null) {
			return 0;
		}
		return Std.int(_layerList[0]);
	}

	/**
	 * How many different types have been added to the World.
	 */
	private function get_uniqueTypes():Int {
		var i:Int = 0;
		for (type in Reflect.fields(_typeCount)) {
			i++;
		}
		return i;
	}

	/**
	 * Pushes all Entities in the World of the type into the Array or Vector.
	 * @param	type		The type to check.
	 * @param	into		The Array or Vector to populate.
	 * @return	The same array, populated.
	 */
	public function getType(type:String, into:Dynamic):Void {
		if (Std.isOfType(into, Array) || Std.isOfType(into, Array /*Vector.<T> call?*/)) {
			var e:Entity = _typeFirst[type];
			var n:Int = into.length;
			while (e != null) {
				Reflect.setField(into, Std.string(n++), e);
				e = e._typeNext;
			}
		}
	}

	/**
	 * Pushes all Entities in the World of the Class into the Array or Vector.
	 * @param	c			The Class type to check.
	 * @param	into		The Array or Vector to populate.
	 * @return	The same array, populated.
	 */
	public function getClass(c:Class<Dynamic>, into:Dynamic):Void {
		if (Std.isOfType(into, Array) || Std.isOfType(into, Array /*Vector.<T> call?*/)) {
			var e:Entity = _updateFirst;
			var n:Int = into.length;
			while (e != null) {
				if (Std.isOfType(e, c)) {
					Reflect.setField(into, Std.string(n++), e);
				}
				e = e._updateNext;
			}
		}
	}

	/**
	 * Pushes all Entities in the World on the layer into the Array or Vector.
	 * @param	layer		The layer to check.
	 * @param	into		The Array or Vector to populate.
	 * @return	The same array, populated.
	 */
	public function getLayer(layer:Int, into:Dynamic):Void {
		if (Std.isOfType(into, Array) || Std.isOfType(into, Array /*Vector.<T> call?*/)) {
			var e:Entity = _renderLast[layer];
			var n:Int = into.length;
			while (e != null) {
				Reflect.setField(into, Std.string(n++), e);
				e = e._updatePrev;
			}
		}
	}

	/**
	 * Pushes all Entities in the World into the array.
	 * @param	into		The Array or Vector to populate.
	 * @return	The same array, populated.
	 */
	public function getAll(into:Dynamic):Void {
		if (Std.isOfType(into, Array) || Std.isOfType(into, Array /*Vector.<T> call?*/)) {
			var e:Entity = _updateFirst;
			var n:Int = into.length;
			while (e != null) {
				Reflect.setField(into, Std.string(n++), e);
				e = e._updateNext;
			}
		}
	}

	/**
	 * Updates the add/remove lists at the end of the frame.
	 */
	public function updateLists():Void {
		var e:Entity;

		// remove entities
		if (_remove.length != 0) {
			for (e /* AS3HX WARNING could not determine type for var: e exp: EIdent(_remove) type: null */ in _remove) {
				e._added = false;
				e.removed();
				removeUpdate(e);
				removeRender(e);
				if (e._type != null) {
					removeType(e);
				}
				if (e.autoClear && e._tween != null) {
					e.clearTweens();
				}
			}
			_remove = [];
		}

		// add entities
		if (_add.length != 0) {
			for (e /* AS3HX WARNING could not determine type for var: e exp: EIdent(_add) type: null */ in _add) {
				e._added = true;
				addUpdate(e);
				addRender(e);
				if (e._type != null) {
					addType(e);
				}
				e.added();
			}
			_add = [];
		}

		// sort the depth list
		if (_layerSort) {
			if (_layerList.length > 1) {
				FP.sort(_layerList, true);
			}
			_layerSort = false;
		}
	}

	/** @private Adds Entity to the update list. */
	private function addUpdate(e:Entity):Void // add to update list
	{
		if (_updateFirst != null) {
			_updateFirst._updatePrev = e;
			e._updateNext = _updateFirst;
		} else {
			e._updateNext = null;
		}
		e._updatePrev = null;
		_updateFirst = e;
		_count++;
		if (_classCount[Type.getClassName(e._class)] == null) {
			_classCount[Type.getClassName(e._class)] = 0;
		}
		_classCount[Type.getClassName(e._class)]++;
	}

	/** @private Removes Entity from the update list. */
	private function removeUpdate(e:Entity):Void // remove from the update list
	{
		if (_updateFirst == e) {
			_updateFirst = e._updateNext;
		}
		if (e._updateNext != null) {
			e._updateNext._updatePrev = e._updatePrev;
		}
		if (e._updatePrev != null) {
			e._updatePrev._updateNext = e._updateNext;
		}
		e._updateNext = e._updatePrev = null;

		_count--;
		_classCount[Type.getClassName(e._class)]--;
	}

	/** @private Adds Entity to the render list. */
	@:allow(net.flashpunk)
	private function addRender(e:Entity):Void {
		var f:Entity = _renderFirst[e._layer];
		if (f != null)
			// Append entity to existing layer.
		{
			e._renderNext = f;
			f._renderPrev = e;
			_layerCount[e._layer]++;
		}
		// Create new layer with entity.
		else {
			_renderLast[e._layer] = e;
			_layerList[_layerList.length] = e._layer;
			_layerSort = true;
			e._renderNext = null;
			_layerCount[e._layer] = 1;
		}
		_renderFirst[e._layer] = e;
		e._renderPrev = null;
	}

	/** @private Removes Entity from the render list. */
	@:allow(net.flashpunk)
	private function removeRender(e:Entity):Void {
		if (e._renderNext != null) {
			e._renderNext._renderPrev = e._renderPrev;
		} else {
			_renderLast[e._layer] = e._renderPrev;
		}
		if (e._renderPrev != null) {
			e._renderPrev._renderNext = e._renderNext;
		}
		// Remove this entity from the layer.
		else {
			_renderFirst[e._layer] = e._renderNext;
			if (e._renderNext == null)
				// Remove the layer from the layer list if this was the last entity.
			{
				if (_layerList.length > 1) {
					_layerList[_layerList.indexOf(e._layer)] = _layerList[_layerList.length - 1];
					_layerSort = true;
				}
				_layerList.pop();
			}
		}
		_layerCount[e._layer]--;
		e._renderNext = e._renderPrev = null;
	}

	/** @private Adds Entity to the type list. */
	@:allow(net.flashpunk)
	private function addType(e:Entity):Void // add to type list
	{
		if (_typeFirst[e._type] != null) {
			_typeFirst[e._type]._typePrev = e;
			e._typeNext = _typeFirst[e._type];
			_typeCount[e._type]++;
		} else {
			e._typeNext = null;
			_typeCount[e._type] = 1;
		}
		e._typePrev = null;
		_typeFirst[e._type] = e;
	}

	/** @private Removes Entity from the type list. */
	@:allow(net.flashpunk)
	private function removeType(e:Entity):Void // remove from the type list
	{
		if (_typeFirst[e._type] == e) {
			_typeFirst[e._type] = e._typeNext;
		}
		if (e._typeNext != null) {
			e._typeNext._typePrev = e._typePrev;
		}
		if (e._typePrev != null) {
			e._typePrev._typeNext = e._typeNext;
		}
		e._typeNext = e._typePrev = null;
		_typeCount[e._type]--;
	}

	/** @private Calculates the squared distance between two rectangles. */
	private static function squareRects(x1:Float, y1:Float, w1:Float, h1:Float, x2:Float, y2:Float, w2:Float, h2:Float):Float {
		if (x1 < x2 + w2 && x2 < x1 + w1) {
			if (y1 < y2 + h2 && y2 < y1 + h1) {
				return 0;
			}
			if (y1 > y2) {
				return (y1 - (y2 + h2)) * (y1 - (y2 + h2));
			}
			return (y2 - (y1 + h1)) * (y2 - (y1 + h1));
		}
		if (y1 < y2 + h2 && y2 < y1 + h1) {
			if (x1 > x2) {
				return (x1 - (x2 + w2)) * (x1 - (x2 + w2));
			}
			return (x2 - (x1 + w1)) * (x2 - (x1 + w1));
		}
		if (x1 > x2) {
			if (y1 > y2) {
				return squarePoints(x1, y1, x2 + w2, y2 + h2);
			}
			return squarePoints(x1, y1 + h1, x2 + w2, y2);
		}
		if (y1 > y2) {
			return squarePoints(x1 + w1, y1, x2, y2 + h2);
		}
		return squarePoints(x1 + w1, y1 + h1, x2, y2);
	}

	/** @private Calculates the squared distance between two points. */
	private static function squarePoints(x1:Float, y1:Float, x2:Float, y2:Float):Float {
		return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
	}

	/** @private Calculates the squared distance between a rectangle and a point. */
	private static function squarePointRect(px:Float, py:Float, rx:Float, ry:Float, rw:Float, rh:Float):Float {
		if (px >= rx && px <= rx + rw) {
			if (py >= ry && py <= ry + rh) {
				return 0;
			}
			if (py > ry) {
				return (py - (ry + rh)) * (py - (ry + rh));
			}
			return (ry - py) * (ry - py);
		}
		if (py >= ry && py <= ry + rh) {
			if (px > rx) {
				return (px - (rx + rw)) * (px - (rx + rw));
			}
			return (rx - px) * (rx - px);
		}
		if (px > rx) {
			if (py > ry) {
				return squarePoints(px, py, rx + rw, ry + rh);
			}
			return squarePoints(px, py, rx + rw, ry);
		}
		if (py > ry) {
			return squarePoints(px, py, rx, ry + rh);
		}
		return squarePoints(px, py, rx, ry);
	}

	// Adding and removal.

	/** @private */
	private var _add:Array<Entity> = new Array<Entity>();

	/** @private */
	private var _remove:Array<Entity> = new Array<Entity>();

	// Update information.

	/** @private */
	private var _updateFirst:Entity;

	/** @private */
	private var _count:Int = 0;

	// Render information.
	private var _renderFirst:Array<Dynamic> = [];
	private var _renderLast:Array<Dynamic> = [];
	private var _layerList:Array<Dynamic> = [];
	private var _layerCount:Array<Dynamic> = [];
	private var _layerSort:Bool;
	private var _tempArray:Array<Dynamic> = [];

	/** @private */
	private var _classCount:Map<String, Int> = new Map();

	/** @private */ @:allow(net.flashpunk)
	private var _typeFirst:Dictionary<String, Entity> = new Dictionary();

	/** @private */
	private var _typeCount:Dictionary<String, Int> = new Dictionary();

	/** @private */
	private var _recycled:Map<String, Entity> = new Map();
}
