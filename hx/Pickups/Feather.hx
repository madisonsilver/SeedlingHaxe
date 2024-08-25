package pickups;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class Feather extends Pickup {
	private var imgFeather:BitmapData;
	private var sprFeather:Spritemap;

	private var tag:Int = 0;
	private var doActions:Bool = true;

	private function load_image_assets():Void {
		imgFeather = Assets.getBitmapData("assets/graphics/Feather.png");
	}

	public function new(_x:Int, _y:Int, _tag:Int = -1) {
		load_image_assets();
		sprFeather = new Spritemap(imgFeather, 12, 12);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprFeather, null, false);
		sprFeather.centerOO();
		setHitbox(8, 8, 4, 4);

		tag = _tag;

		special = true;
		text = "You got the Penguin's Feather!~You can now swim up waterfalls.";
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
			Player.hasFeather = true;
			Game.setPersistence(tag, false);
		}
	}

	override public function update():Void {
		super.update();
	}

	override public function render():Void {
		sprFeather.frame = Game.worldFrame(8);
		super.render();
	}
}
