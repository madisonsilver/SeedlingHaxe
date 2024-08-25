package pickups;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.FP;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import scenery.Tile;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class BossKey extends Pickup {
	private var keyType:Int = 0;
	private var doActions:Bool = true;

	public function new(_x:Int, _y:Int, _t:Int = 0) {
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), Game.bossKeys[_t], null, false);
		setHitbox(8, 8, 4, 4);
		keyType = _t;

		special = true;
		if (keyType == 0) {
			text = "You got a key!~Keys open locks of their color.";
		}
		mySound = Music.sndOKey;
	}

	override public function check():Void {
		super.check();
		if (Player.hasKey(keyType)) {
			doActions = false;
			FP.world.remove(this);
		}
	}

	override public function render():Void {
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).frame = Game.worldFrame((try cast(graphic, Spritemap) catch (e:Dynamic) null).frameCount);
		super.render();
		if (keyType == 2 || keyType == 3 || keyType == 4)
			// Wand/Ice/6th Dungeon key
		{
			{
				Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
				var minsc:Float = 0.1;
				var sc:Float = 0.25;
				var alph:Float = 0.25;
				var phases:Int = 5;
				if (keyType == 2) {
					Draw.circlePlus(Std.int(x), Std.int(y), Math.max(width, height) * (1 + minsc + sc * Game.worldFrame(phases) / phases), 0xFFFFCC, alph);
				}
				super.render();
				Draw.resetTarget();
			}
		}
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).frame = 0;
	}

	override public function removed():Void {
		if (doActions) {
			Player.hasKeySet(keyType, true);
		}
	}
}
