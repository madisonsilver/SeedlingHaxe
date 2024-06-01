package pickups;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.graphics.Image;
import net.flashpunk.FP;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class DarkShield extends Pickup {
private var imgDarkShield:BitmapData;
	private var sprDarkShield:Image;

	private var tag:Int;
	private var doActions:Bool = true;

private function load_image_assets():Void {
imgDarkShield = Assets.getBitmapData("assets/graphics/DarkShield.png");
}
	public function new(_x:Int, _y:Int, _tag:Int = -1) {

load_image_assets();
		sprDarkShield = new Image(imgDarkShield);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprDarkShield, null, false);
		sprDarkShield.centerOO();
		setHitbox(9, 9, 5, 5);

		tag = _tag;

		special = true;
		text = "You got the Dark Shield!~It hurts what it touches.";
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
			Player.hasDarkShield = true;
			Game.setPersistence(tag, false);
		}
	}
}
