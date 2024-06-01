package puzzlements;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;
import scenery.Wire;

/**
 * ...
 * @author Time
 */
class ButtonRoom extends Activators {
	private var imgButtonRoom:BitmapData;
	private var sprButtonRoom:Spritemap;

	private var hitables:Dynamic = ["Player", "Enemy", "Solid"]; // Things that push down the button
	private var flip:Bool; // Changes the actions of the button so that there's persistence in the room.
	// Defaults to pushed is true, and unpushed is false.
	private var room:Int;

	private var tag:Int;

	private var frameAdd:Int = 0;

	// tset matches up with "tag" for objects in other rooms, not their tsets.

	private function load_image_assets():Void {
		imgButtonRoom = Assets.getBitmapData("assets/graphics/ButtonRoom.png");
	}

	public function new(_x:Int, _y:Int, _t:Int, _tag:Int, _flip:Bool, _room:Int) {
		load_image_assets();
		sprButtonRoom = new Spritemap(imgButtonRoom, 16, 16);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprButtonRoom, _t);
		sprButtonRoom.centerOO();
		setHitbox(8, 6, 4, 3);
		type = "ButtonRoom";
		layer = Tile.LAYER;
		flip = _flip;
		room = _room;
		tag = _tag;
	}

	override public function check():Void {
		super.check();
		_active = !Game.checkPersistence(tag); // Notted so that it starts off as up (not down, as "true" would imply)
		activate = _active;
		if (collide("Wire", x, y + Tile.h) != null) {
			frameAdd = 2;
			sprButtonRoom.frame = as3hx.Compat.parseInt(activate) + frameAdd;
		}
	}

	override public function update():Void {
		var v:Array<Entity> = new Array<Entity>();
		collideTypesInto(hitables, x, y, v);
		var tempCheck:Bool = false;
		for (c in v) {
			if (c != null && !(Std.is(c, Cover))) {
				tempCheck = true;
			}
		}
		activate = tempCheck;
	}

	override private function set_activate(a:Bool):Bool {
		if (a)
			// Can't be reset to false!!
		{
			{
				if (!_active) {
					Music.playSound("Switch");
				}
				_active = a;
				var persist:Bool = _active;
				if (flip) {
					persist = !persist;
				}
				if (room == -1) {
					var v:Array<Activators> = new Array<Activators>();
					FP.world.getClass(Activators, v);
					for (i in 0...v.length) {
						if (v[i] != this && v[i].t == t) {
							v[i].activate = persist;
						}
					}
				} else {
					Game.setPersistence(t, persist, room);
				}
				sprButtonRoom.frame = as3hx.Compat.parseInt(_active) + frameAdd;
				Game.setPersistence(tag, !activate);
			}
		}
		return a;
	}
}
