package scenery;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class MoonrockPile extends Entity {
	private var imgMoonrockPile:BitmapData;
	private var sprMoonrockPile:Image;

	private var tag:Int;

	private function load_image_assets():Void {
		imgMoonrockPile = Assets.getBitmapData("assets/graphics/MoonrockPile.png");
	}

	public function new(_x:Int, _y:Int, _tag:Int = 0) {
		load_image_assets();
		sprMoonrockPile = new Image(imgMoonrockPile);
		super(_x, _y, sprMoonrockPile);
		setHitbox(sprMoonrockPile.width, sprMoonrockPile.height);
		type = "Solid";
		layer = Std.int(-(y - originY + height * 4 / 5));
		tag = 0;
	}

	override public function check():Void {
		super.check();
		if (tag >= 0 && Game.checkPersistence(tag))
			// false = there, true = not there
		{
			{
				FP.world.remove(this);
			}
		}
	}
}
