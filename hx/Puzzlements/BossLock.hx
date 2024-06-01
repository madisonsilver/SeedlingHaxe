package puzzlements;
import openfl.utils.Assets;import openfl.display.BitmapData;

import enemies.*;
import openfl.geom.Point;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;
import openfl.display.BlendMode;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class BossLock extends Activators {
	private var normType:String = "Solid";
	private var keyType:Int; // corresponds to a player variable "hasKey" which is an array of booleans denoting if they've picked up the right key.
	private var tag:Int;
	private var myKey:Spritemap;

	// These are placeholders values for use on the sprite when drawn from the Game class
	private var scale:Float = 1;
	private var alpha:Float = 1;

	private var keyTimerMax(default, never):Int = 60;
	private var keyTimer:Int;

	public function new(_x:Int, _y:Int, _t:Int = 0, _tag:Int = -1) {

		keyTimer = keyTimerMax;
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), Game.bossLocks[_t], -1);
		myKey = Game.bossKeys[_t];
		setHitbox(16, 16, 8, 8);
		type = normType;
		tag = _tag;
		keyType = _t;
		layer = Std.int(-(y - originY + height));
	}

	override public function check():Void {
		super.check();
		if (tag >= 0 && !Game.checkPersistence(tag)) {
			FP.world.remove(this);
		}
	}

	override private function set_activate(a:Bool):Bool {
		if (!_active && a) {
			Music.playSoundDistPlayer(Std.int(x), Std.int(y), "Lock");
		}
		_active = a;
		return a;
	}

	override public function update():Void {
		super.update();
		var m:Int = 2; // The distance to check from the edges of the chest
		var p:Player = try cast(FP.world.collideLine("Player", Std.int(x - originX + m), Std.int(y - originY + height + 1),
			Std.int(x - originX + width - 2 * m), Std.int(y - originY + height + 1)), Player) catch (e:Dynamic) null;
		if (p != null && Player.hasKey(keyType)) {
			activate = true;
		}
		if (activate) {
			if (keyTimer > 0) {
				keyTimer--;
			} else {
				scale += 0.05;
				alpha -= 0.05;
				if (alpha <= 0 && type != "") {
					type = "";
					alpha = 0;
					Game.setPersistence(tag, false);
				}
			}
		} else if (type != normType) {
			type = normType;
			alpha = 1;
			Game.setPersistence(tag, true);
		}
	}

	override public function render():Void {
		(try cast(graphic, Image) catch (e:Dynamic) null).alpha = alpha;
		(try cast(graphic, Image) catch (e:Dynamic) null).scale = scale;
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).frame = Game.worldFrame((try cast(graphic, Spritemap) catch (e:Dynamic) null).frameCount);
		if (activate) {
			if (keyTimer <= keyTimerMax / 3) {
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).blend = BlendMode.SCREEN;
			}
		}
		super.render();
		if (keyType == 4 /* Dungeon 6 */) {
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).alpha = alpha * 0.2;
			super.render();
			Draw.resetTarget();
		}
		if (activate) {
			if (myKey != null && keyTimer > 0) {
				var a:Float = myKey.alpha;
				myKey.alpha = keyTimer / keyTimerMax;
				myKey.render(new Point(x
					- originX
					+ width / 2
					- myKey.originX
					+ myKey.width / 2,
					y
					+ height / 2
					- myKey.height
					- keyTimer / keyTimerMax * 8
					+ 3),
					FP.camera);
				myKey.alpha = a;
			}
		}
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).frame = 0;
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).blend = BlendMode.NORMAL;
		(try cast(graphic, Image) catch (e:Dynamic) null).alpha = (try cast(graphic, Image) catch (e:Dynamic) null).scale = 1;
	}
}
