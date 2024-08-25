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
class Conch extends Pickup {
	private var imgConch:BitmapData;
	private var sprConch:Spritemap;

	private var tag:Int = 0;
	private var doActions:Bool = true;

	private function load_image_assets():Void {
		imgConch = Assets.getBitmapData("assets/graphics/Conch.png");
	}

	public function new(_x:Int, _y:Int, _tag:Int = -1) {
		load_image_assets();
		sprConch = new Spritemap(imgConch, 8, 8);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprConch, null, false);
		sprConch.centerOO();
		setHitbox(8, 8, 4, 4);

		tag = _tag;

		special = true;
		text = "You got the Conch!~Now you can swim in water!";
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
			Player.canSwim = true;
			Game.setPersistence(tag, false);
		}
	}

	override public function update():Void {
		super.update();
	}

	override public function render():Void {
		sprConch.frame = Game.worldFrame(3);
		super.render();
	}
}
