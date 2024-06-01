package pickups;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import nPCs.Help;
import scenery.Tile;
import scenery.Moonrock;

/**
 * ...
 * @author Time
 */
class Sword extends Pickup {
private var imgSword:BitmapData;
	private var sprSword:Spritemap;

	private var tag:Int;
	private var doActions:Bool = true;

private function load_image_assets():Void {
imgSword = Assets.getBitmapData("assets/graphics/Sword.png");
}
	public function new(_x:Int, _y:Int, _tag:Int = -1) {

load_image_assets();
		sprSword = new Spritemap(imgSword, 16, 16);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprSword, null, false);
		sprSword.centerOO();
		setHitbox(8, 8, 4, 4);

		tag = _tag;

		special = true;
		text = "You got the sword!~Double tap to dash and swing.";
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
			Player.hasSword = true;
			Game.setPersistence(tag, false);
			FP.world.add(new Help(3));
		}
	}

	override public function update():Void {
		super.update();
	}

	override public function render():Void {
		sprSword.frame = Game.worldFrame(3);
		super.render();
	}
}
