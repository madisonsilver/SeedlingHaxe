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
class Fire extends Pickup {
	private var imgFire:BitmapData;
	private var sprFire:Spritemap;

	private var tag:Int;
	private var doActions:Bool = true;

	private function load_image_assets():Void {
		imgFire = Assets.getBitmapData("assets/graphics/FirePickup.png");
	}

	public function new(_x:Int, _y:Int, _tag:Int = -1) {
		load_image_assets();
		sprFire = new Spritemap(imgFire, 16, 16);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprFire, null, false);
		sprFire.centerOO();
		sprFire.alpha = 0;
		setHitbox(8, 8, 4, 4);

		tag = _tag;

		special = true;
		text = "You got Fire!~It pushes but does not hurt.";
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
			Player.hasFire = true;
			Game.setPersistence(tag, false);
		}
	}

	override public function update():Void {
		super.update();
		sprFire.alpha = Math.min(sprFire.alpha + 0.05, 1);
	}

	override public function render():Void {
		sprFire.frame = Game.worldFrame(sprFire.frameCount);
		super.render();
	}
}
