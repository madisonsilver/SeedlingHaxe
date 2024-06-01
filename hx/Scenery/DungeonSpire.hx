package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class DungeonSpire extends Entity {
private var imgDungeonSpire:BitmapData;
	private var sprDungeonSpire:Image;

private function load_image_assets():Void {
imgDungeonSpire = Assets.getBitmapData("assets/graphics/DungeonSpire.png");
}
	public function new(_x:Int, _y:Int) {
load_image_assets();
		sprDungeonSpire = new Image(imgDungeonSpire);
		super(_x, _y, sprDungeonSpire);
		sprDungeonSpire.y = -8;
		sprDungeonSpire.originY = 8;
		setHitbox(16, 16);
		type = "Solid";
		layer = Std.int(-(y - originY + height * 2 / 3));
	}
}
