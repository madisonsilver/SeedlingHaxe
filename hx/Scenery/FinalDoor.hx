package scenery;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Draw;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class FinalDoor extends Entity {
	private var imgFinalDoor:BitmapData;
	private var sprFinalDoor:Spritemap;

	private var seeDistance(default, never):Int = 32;
	private var seenSeal:Bool = false;

	public var mySealController:SealController;

	private var tag:Int;

	private function load_image_assets():Void {
		imgFinalDoor = Assets.getBitmapData("assets/graphics/FinalDoor.png");
	}

	public function new(_x:Int, _y:Int, _tag:Int = -1) {
		load_image_assets();
		sprFinalDoor = new Spritemap(imgFinalDoor, 32, 32, animEnd);
		super(_x + Tile.w, _y + Tile.h, sprFinalDoor);
		sprFinalDoor.centerOO();
		setHitbox(32, 32, 16, 16);
		type = "Solid";
		layer = Std.int(-(y - originY + height));
		tag = _tag;

		sprFinalDoor.add("open", [
			1, 1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25
		], 15);
	}

	override public function check():Void {
		super.check();
		if (tag >= 0 && !Game.checkPersistence(tag)) {
			FP.world.remove(this);
		}
	}

	override public function removed():Void {
		super.removed();
		Game.setPersistence(tag, false);
	}

	override public function update():Void {
		var talkedToWatcher:Bool = !Game.checkPersistence(0, 114); // 0 is the tag for the Watcher's text, while 114 is the room that it refers to.
		var p:Player = try cast(FP.world.nearestToEntity("Player", this), Player) catch (e:Dynamic) null;
		if (p != null) {
			if (FP.distance(x, y, p.x, p.y) <= seeDistance) {
				if (!seenSeal) {
					seenSeal = true;
					FP.world.add(mySealController = new SealController(false, this,
						(talkedToWatcher) ? "Your path to redemption lies here" : "Face the Watcher and return"));
				} else if (mySealController == null && SealController.hasAllSealParts() && talkedToWatcher) {
					sprFinalDoor.play("open");
				}
			} else {
				seenSeal = false;
			}
		}
	}

	override public function render():Void {
		super.render();
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		super.render();
		Draw.resetTarget();
	}

	public function animEnd():Void {
		var _sw0_ = (sprFinalDoor.currentAnim);

		switch (_sw0_) {
			case "open":
				FP.world.remove(this);
			default:
		}
	}
}
