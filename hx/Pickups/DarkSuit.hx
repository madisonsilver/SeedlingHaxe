package pickups;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.graphics.Image;
import net.flashpunk.FP;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class DarkSuit extends Pickup {
private var imgDarkSuit:BitmapData;
	private var sprDarkSuit:Image;

	private var tag:Int;
	private var doActions:Bool = true;

private function load_image_assets():Void {
imgDarkSuit = Assets.getBitmapData("assets/graphics/DarkSuit.png");
}
	public function new(_x:Int, _y:Int, _tag:Int = -1) {

load_image_assets();
		sprDarkSuit = new Image(imgDarkSuit);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprDarkSuit, null, false);
		sprDarkSuit.centerOO();
		setHitbox(10, 10, 5, 5);

		tag = _tag;

		special = true;
		text = "You got the Dark Suit!~It hurts what it hits, and it lets you swim in lava.";
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
			Player.hasDarkSuit = true;
			Game.setPersistence(tag, false);
		}
	}
}
