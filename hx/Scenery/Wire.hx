package scenery;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import puzzlements.ButtonRoom;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class Wire extends Entity {
	private var img:Int;

	public var on:Bool = false;

	private var onColor(default, never):Int = 0xFFFF00;
	private var offColor(default, never):Int = 0x404040;

	public function new(_x:Int, _y:Int, _img:Int = -1) {
		super(_x, _y);
		type = "Wire";
		setHitbox(16, 16);
		active = false;
		img = _img;
	}

	override public function check():Void {
		super.check();
		if (img < 0) {
			img = 0;
			var c:Bool;
			var types:Dynamic = ["Wire", "ButtonRoom"];
			if (collideTypes(types, x + Tile.w / 2, y) != null || x - originX + width + 1 >= FP.width) {
				img++;
			}
			if (collideTypes(types, x, y - Tile.h / 2) != null || y - originY - 1 < 0) {
				img += 2;
			}
			if (collideTypes(types, x - Tile.w / 2, y) != null || x - originX - 1 < 0) {
				img += 4;
			}
			if (collideTypes(types, x, y + Tile.h / 2) != null || y - originY + height + 1 >= FP.height) {
				img += 8;
			}
		}
	}

	override public function render():Void {
		if (!onScreen()) {
			return;
		}
		var c:Entity;
		var types:Dynamic = ["Wire", "ButtonRoom"];
		c = collideTypes(types, x + Tile.w, y);
		if (c != null) {
			if (Std.is(c, ButtonRoom) && (try cast(c, ButtonRoom) catch (e:Dynamic) null).activate) {
				on = (try cast(c, ButtonRoom) catch (e:Dynamic) null).activate;
			} else if (Std.is(c, Wire) && (try cast(c, Wire) catch (e:Dynamic) null).on) {
				on = (try cast(c, Wire) catch (e:Dynamic) null).on;
			}
		}
		c = collideTypes(types, x, y - Tile.h);
		if (c != null) {
			if (Std.is(c, ButtonRoom) && (try cast(c, ButtonRoom) catch (e:Dynamic) null).activate) {
				on = (try cast(c, ButtonRoom) catch (e:Dynamic) null).activate;
			} else if (Std.is(c, Wire) && (try cast(c, Wire) catch (e:Dynamic) null).on) {
				on = (try cast(c, Wire) catch (e:Dynamic) null).on;
			}
		}
		c = collideTypes(types, x - Tile.w, y);
		if (c != null) {
			if (Std.is(c, ButtonRoom) && (try cast(c, ButtonRoom) catch (e:Dynamic) null).activate) {
				on = (try cast(c, ButtonRoom) catch (e:Dynamic) null).activate;
			} else if (Std.is(c, Wire) && (try cast(c, Wire) catch (e:Dynamic) null).on) {
				on = (try cast(c, Wire) catch (e:Dynamic) null).on;
			}
		}
		c = collideTypes(types, x, y + Tile.h);
		if (c != null) {
			if (Std.is(c, ButtonRoom) && (try cast(c, ButtonRoom) catch (e:Dynamic) null).activate) {
				on = (try cast(c, ButtonRoom) catch (e:Dynamic) null).activate;
			} else if (Std.is(c, Wire) && (try cast(c, Wire) catch (e:Dynamic) null).on) {
				on = (try cast(c, Wire) catch (e:Dynamic) null).on;
			}
		}
		if (on) {
			Game.sprWire.color = onColor;
		} else {
			Game.sprWire.color = offColor;
		}
		Game.sprWire.frame = img;
		Game.sprWire.render(new Point(x, y), FP.camera);
		if (on) {
			Game.sprWire.alpha = 0.1;
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			Game.sprWire.render(new Point(x, y), FP.camera);
			Draw.resetTarget();
			Game.sprWire.alpha = 1;
		}
	}
}
