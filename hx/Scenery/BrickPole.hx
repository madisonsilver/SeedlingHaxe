package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class BrickPole extends Entity {
private var imgBrickPole:BitmapData;
	private var sprBrickPole:Image;

private function load_image_assets():Void {
imgBrickPole = Assets.getBitmapData("assets/graphics/BrickPole.png");
}
	public function new(_x:Int, _y:Int) {

load_image_assets();
		sprBrickPole = new Image(imgBrickPole);
		super(_x, _y, sprBrickPole);
		sprBrickPole.y = -4;
		sprBrickPole.originY = 4;
		setHitbox(16, 16);
		type = "Solid";
		layer = Std.int(-(y - originY + height * 4 / 5));
	}
}
