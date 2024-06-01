package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import net.flashpunk.utils.Draw;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class FrozenBoss extends Entity {
private var imgFrozenBoss:BitmapData;
	private var sprFrozenBoss:Image;

private function load_image_assets():Void {
imgFrozenBoss = Assets.getBitmapData("assets/graphics/FrozenBoss.png");
}
	public function new(_x:Int, _y:Int) {
load_image_assets();
		sprFrozenBoss = new Image(imgFrozenBoss);
		super(_x, _y, sprFrozenBoss);
		setHitbox(80, 32, -32, -128);
		type = "Solid";
		layer = Std.int(-(y - originY + height * 2 / 3));
	}

	override public function render():Void {
		super.render();
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		super.render();
		Draw.resetTarget();
	}
}
