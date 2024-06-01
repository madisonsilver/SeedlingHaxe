package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class ShieldStatue extends Entity {
private var imgShieldStatue:BitmapData;
	private var sprShieldStatue:Image;

private function load_image_assets():Void {
imgShieldStatue = Assets.getBitmapData("assets/graphics/ShieldStatue.png");
}
	public function new(_x:Int, _y:Int) {
load_image_assets();
		sprShieldStatue = new Image(imgShieldStatue);
		super(_x + Tile.w / 2, _y, sprShieldStatue);
		sprShieldStatue.y = -11;
		sprShieldStatue.originY = 11;
		setHitbox(32, 32);
		type = "Solid";
		layer = Std.int(-(y - originY));
	}
}
