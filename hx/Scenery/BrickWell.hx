package scenery;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class BrickWell extends Entity {
	private var imgBrickWell:BitmapData;
	private var sprBrickWell:Image;

	private function load_image_assets():Void {
		imgBrickWell = Assets.getBitmapData("assets/graphics/BrickWell.png");
	}

	public function new(_x:Int, _y:Int) {
		load_image_assets();
		sprBrickWell = new Image(imgBrickWell);
		super(_x, _y, sprBrickWell);
		sprBrickWell.y = -4;
		sprBrickWell.originY = 4;
		sprBrickWell.x = -1;
		sprBrickWell.originX = 1;
		setHitbox(16, 16);
		type = "Solid";
		layer = Std.int(-(y - originY + height * 4 / 5));
	}
}
