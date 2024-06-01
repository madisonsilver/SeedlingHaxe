package pickups;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import nPCs.Help;
import scenery.Tile;
import scenery.Moonrock;

/**
 * ...
 * @author Time
 */
class DarkSword extends Pickup {
	private var imgDarkSword:BitmapData;
	private var sprDarkSword:Spritemap;

	private var tag:Int;
	private var doActions:Bool = true;

	private function load_image_assets():Void {
		imgDarkSword = Assets.getBitmapData("assets/graphics/SwordDark.png");
	}

	public function new(_x:Int, _y:Int, _tag:Int = -1) {
		load_image_assets();
		sprDarkSword = new Spritemap(imgDarkSword, 16, 16);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprDarkSword, null, false);
		sprDarkSword.centerOO();
		setHitbox(8, 8, 4, 4);

		tag = _tag;

		special = true;
		text = "You got the dark sword!~It does more damage.";
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
			Player.hasDarkSword = true;
			if (Game.checkPersistence(tag)) {
				Game.setPersistence(tag, false);
				Main.unlockMedal(Main.badges[12]);
			}
		}
	}

	override public function update():Void {
		super.update();
	}

	override public function render():Void {
		sprDarkSword.frame = Game.worldFrame(3);
		super.render();
	}
}
