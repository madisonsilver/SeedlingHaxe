package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class LittleStones extends Entity {
private var imgLittleStones:BitmapData;
	private var sprLittleStones:Image;

	private var grassPosX:Dynamic = [1, 1, 9, 5, 1];
	private var grassPosY:Dynamic = [14, 9, 14, 1, 6];

private function load_image_assets():Void {
imgLittleStones = Assets.getBitmapData("assets/graphics/LittleStones.png");
}
	public function new(_x:Int, _y:Int) {

load_image_assets();
		sprLittleStones = new Image(imgLittleStones);
		super(_x, _y, sprLittleStones);
		layer = Std.int(-y);
		for (i in 0...grassPosX.length) {
			FP.world.add(new Grass(x + Reflect.field(grassPosX, Std.string(i)), y + Reflect.field(grassPosY, Std.string(i))));
		}
	}
}
