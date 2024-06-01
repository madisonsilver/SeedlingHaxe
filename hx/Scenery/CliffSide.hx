package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.masks.Pixelmask;

/**
 * ...
 * @author Time
 */
class CliffSide extends Entity {
	private var frame:Int;

	public function new(_x:Int, _y:Int, _f:Int = 0) {


		super(_x, _y);
		frame = _f;

		switch (frame) {
			case 0:
				mask = new Pixelmask(Game.imgCliffSidesMaskL);
			case 1:
				mask = new Pixelmask(Game.imgCliffSidesMaskR);
			case 2:
				mask = new Pixelmask(Game.imgCliffSidesMaskLU);
			case 3:
				mask = new Pixelmask(Game.imgCliffSidesMaskRU);
			default:
				mask = new Pixelmask(Game.imgCliffSidesMaskU);
		}
		type = "Solid";
	}

	override public function render():Void {
		Game.sprCliffSides.frame = frame;
		Game.sprCliffSides.render(new Point(x, y), FP.camera);
	}
}
