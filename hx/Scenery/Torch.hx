package scenery;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Draw;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class Torch extends Entity {
	private var imgTorch:BitmapData;
	private var sprTorch:Spritemap;

	private var color:Int = 0;

	private function load_image_assets():Void {
		imgTorch = Assets.getBitmapData("assets/graphics/Torch.png");
	}

	public function new(_x:Int, _y:Int, _c:Int = 0xFFFFFF) {
		load_image_assets();
		sprTorch = new Spritemap(imgTorch, 4, 10);
		super(_x + Tile.w / 2, _y + Tile.h / 2, sprTorch);
		sprTorch.centerOO();
		color = _c;
		layer = Std.int(-(y - sprTorch.originY + sprTorch.height + Tile.h / 2));
		FP.world.add(new Light(Std.int(x), Std.int(y), sprTorch.frameCount, 1, color, false));
	}

	override public function render():Void {
		sprTorch.frame = Game.worldFrame(sprTorch.frameCount);
		super.render();
	}
}
