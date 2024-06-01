package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class Bar extends Entity {
private var imgBar:BitmapData;
	private var sprBar:Image;

private function load_image_assets():Void {
imgBar = Assets.getBitmapData("assets/graphics/Bar.png");
}
	public function new(_x:Int, _y:Int) {

load_image_assets();
		sprBar = new Image(imgBar);
		super(_x, _y, sprBar);
		setHitbox(64, 16);
		sprBar.y = -4;
		sprBar.originY = Std.int(-sprBar.y);
		type = "Solid";
		layer = Std.int(-(y - originY + height * 4 / 5));
	}
}
