package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class Dresser extends Entity {
private var imgDresser:BitmapData;
	private var sprDresser:Image;

private function load_image_assets():Void {
imgDresser = Assets.getBitmapData("assets/graphics/Dresser.png");
}
	public function new(_x:Int, _y:Int) {

load_image_assets();
		sprDresser = new Image(imgDresser);
		super(_x, _y, sprDresser);
		sprDresser.y = -8;
		sprDresser.originY = Std.int(-sprDresser.y);
		setHitbox(32, 16);
		type = "Solid";
		layer = Std.int(-(y - originY + height * 4 / 5));
	}
}
