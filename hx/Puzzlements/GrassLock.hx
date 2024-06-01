package puzzlements;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.graphics.Spritemap;

/**
 * ...
 * @author Time
 */
class GrassLock extends Lock {
	private var imgGrassLock:BitmapData;
	private var sprGrassLock:Spritemap;

	private override function load_image_assets():Void {
		super.load_image_assets();
		imgGrassLock = Assets.getBitmapData("assets/graphics/GrassLock.png");
	}

	public function new(_x:Int, _y:Int, _t:Int, _tag:Int = -1) {
		load_image_assets();
		sprGrassLock = new Spritemap(imgGrassLock, 16, 16);
		super(_x, _y, _t, _tag, sprGrassLock);
	}
}
