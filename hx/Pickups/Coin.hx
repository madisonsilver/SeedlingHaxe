package pickups;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class Coin extends Pickup {
private var imgCoin:BitmapData;
	private var sprCoin:Spritemap;

private function load_image_assets():Void {
imgCoin = Assets.getBitmapData("assets/graphics/Coin.png");
}
	public function new(_x:Int, _y:Int, _v:Point = null) {

load_image_assets();
		sprCoin = new Spritemap(imgCoin, 4, 4);
		super(_x, _y, sprCoin, _v);
		sprCoin.centerOO();
		type = "Coin";
		setHitbox(4, 4, 2, 2);
	}

	override public function render():Void {
		sprCoin.frame = Game.worldFrame(sprCoin.frameCount);
		super.render();
	}
}
