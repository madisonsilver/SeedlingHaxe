package scenery;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class Barstool extends Entity {
	private var imgBarstool:BitmapData;
	private var sprBarstool:Image;

	private function load_image_assets():Void {
		imgBarstool = Assets.getBitmapData("assets/graphics/Barstool.png");
	}

	public function new(_x:Int, _y:Int) {
		load_image_assets();
		sprBarstool = new Image(imgBarstool);
		super(_x + Tile.w / 4, _y + Tile.h / 4, sprBarstool);
		setHitbox(8, 8);
		sprBarstool.y = -4;
		sprBarstool.originY = Std.int(-sprBarstool.y);
		type = "Solid";
		layer = Std.int(-(y - originY));
	}
}
