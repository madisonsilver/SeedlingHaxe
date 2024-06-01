package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.masks.Pixelmask;
import openfl.geom.Point;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class OpenTree extends Tree {
	public function new(_x:Int, _y:Int) {


		super(_x, _y);
		active = true;
	}

	override public function update():Void {
		super.update();
		if (mask == null) {
			setHitbox();
			mask = new Pixelmask(Game.imgOpenTreeMask, -16, -16);
		}
	}

	override public function render():Void {
		Game.sprOpenTree.frame = frame;
		Game.sprOpenTree.render(new Point(x, y), FP.camera);
	}
}
