package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;

/**
 * ...
 * @author Time
 */
class OracleStatue extends Entity {
private var imgOracleStatue:BitmapData;
	private var sprOracleStatue:Spritemap;

private function load_image_assets():Void {
imgOracleStatue = Assets.getBitmapData("assets/graphics/OracleStatue.png");
}
	public function new(_x:Int, _y:Int) {
load_image_assets();
		sprOracleStatue = new Spritemap(imgOracleStatue, 32, 48);
		super(_x, _y, sprOracleStatue);
		sprOracleStatue.y = -16;
		sprOracleStatue.originY = Std.int(-sprOracleStatue.y);
		setHitbox(32, 32);
		type = "Solid";
		layer = Std.int(-(y - originY + height * 4 / 5));
	}

	override public function render():Void {
		sprOracleStatue.frame = Game.worldFrame(sprOracleStatue.frameCount);
		super.render();
	}
}
