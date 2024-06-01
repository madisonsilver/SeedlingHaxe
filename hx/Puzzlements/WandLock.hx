package puzzlements;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.graphics.Spritemap;

/**
 * ...
 * @author Time
 */
class WandLock extends Lock {
private var imgWandLock:BitmapData;
	private var sprWandLock:Spritemap;

private override function load_image_assets():Void {
imgWandLock = Assets.getBitmapData("assets/graphics/WandLock.png");
}
	public function new(_x:Int, _y:Int, _t:Int, _tag:Int = -1) {

load_image_assets();
		sprWandLock = new Spritemap(imgWandLock, 16, 16);
		super(_x, _y, _t, _tag, sprWandLock);
	}
}
