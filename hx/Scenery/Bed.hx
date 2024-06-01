package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class Bed extends Entity {
private var imgBed:BitmapData;
	private var sprBed:Image;

private function load_image_assets():Void {
imgBed = Assets.getBitmapData("assets/graphics/Bed.png");
}
	public function new(_x:Int, _y:Int) {

load_image_assets();
		sprBed = new Image(imgBed);
		super(_x, _y, sprBed);
		setHitbox(16, 32);
		type = "Solid";
		layer = Std.int(-(y - originY + height * 4 / 5));
	}
}
