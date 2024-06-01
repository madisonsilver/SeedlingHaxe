package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;

/**
 * ...
 * @author Time
 */
class RuinedPillar extends Entity {
private var imgRuinedPillar:BitmapData;
	private var sprRuinedPillar:Spritemap;

private function load_image_assets():Void {
imgRuinedPillar = Assets.getBitmapData("assets/graphics/RuinedPillar.png");
}
	public function new(_x:Int, _y:Int) {
load_image_assets();
		sprRuinedPillar = new Spritemap(imgRuinedPillar, 32, 48);
		super(_x, _y, sprRuinedPillar);
		sprRuinedPillar.y = -16;
		sprRuinedPillar.originY = Std.int(-sprRuinedPillar.y);
		setHitbox(32, 32);
		type = "Solid";
		layer = Std.int(-(y - originY + height * 4 / 5));
	}
}
