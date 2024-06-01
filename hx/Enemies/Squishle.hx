package enemies;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.graphics.Spritemap;

/**
 * ...
 * @author Time
 */
class Squishle extends Enemy {
private var imgSquishle:BitmapData;
	private var sprSquishle:Spritemap;

	private var sittingAnim(default, never):Array<Dynamic> = [2, 3];
	private var loops(default, never):Int = 1;

private function load_image_assets():Void {
imgSquishle = Assets.getBitmapData("assets/graphics/Squishle.png");
}
	public function new(_x:Int, _y:Int) {
load_image_assets();
		sprSquishle = new Spritemap(imgSquishle, 16, 11);
		super(_x, _y, sprSquishle);
		sprSquishle.add("run", [0, 1, 2, 3, 4], 10);

		sprSquishle.play("");
	}

	override public function render():Void {
		if (sprSquishle.currentAnim == "") {
			sprSquishle.frame = sittingAnim[Game.worldFrame(sittingAnim.length, loops)];
		}
		super.render();
	}
}
