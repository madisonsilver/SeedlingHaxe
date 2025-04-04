package pickups;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;
import scenery.Moonrock;

/**
 * ...
 * @author Time
 */
class GhostSpear extends Pickup {
	private var imgSpear:BitmapData;
	private var sprSpear:Spritemap;

	private var tag:Int = 0;
	private var doActions:Bool = true;

	private function load_image_assets():Void {
		imgSpear = Assets.getBitmapData("assets/graphics/GhostSpear.png");
	}

	public function new(_x:Int, _y:Int, _tag:Int = -1) {
		load_image_assets();
		sprSpear = new Spritemap(imgSpear, 20, 7);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprSpear, null, false);
		sprSpear.centerOO();
		setHitbox(12, 4, 6, 2);

		tag = _tag;

		special = true;
		text = "You got the Ghost Spear!~It hits harder and through walls.";
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
			Player.hasSpear = true;
			Game.setPersistence(tag, false);
		}
	}

	override public function render():Void {
		sprSpear.frame = Game.worldFrame(sprSpear.frameCount);
		super.render();
	}
}
