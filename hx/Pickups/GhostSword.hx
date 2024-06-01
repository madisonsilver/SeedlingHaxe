package pickups;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class GhostSword extends Pickup {
private var imgGhostSword:BitmapData;
	private var sprGhostSword:Spritemap;

	private var tag:Int;
	private var doActions:Bool = true;

private function load_image_assets():Void {
imgGhostSword = Assets.getBitmapData("assets/graphics/GhostSwordPickup.png");
}
	public function new(_x:Int, _y:Int, _tag:Int = -1) {
load_image_assets();
		sprGhostSword = new Spritemap(imgGhostSword, 24, 7);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprGhostSword, null, false);
		sprGhostSword.centerOO();
		setHitbox(20, 4, 10, 2);

		tag = _tag;

		special = true;
		text = "You got the Ghost Sword!~It swings like a Sword, but hits like the Spear.";
	}

	override public function check():Void {
		super.check();
		if (tag >= 0 && !Game.checkPersistence(tag)) {
			doActions = false;
			FP.world.remove(this);
		}
	}

	override public function removed():Void {
		if (doActions) {
			Player.hasGhostSword = true;
			Game.setPersistence(tag, false);
		}
	}

	override public function render():Void {
		sprGhostSword.frame = Game.worldFrame(sprGhostSword.frameCount);
		super.render();
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		super.render();
		Draw.resetTarget();
	}
}
