package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.Graphic;
import net.flashpunk.graphics.Image;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;
import pickups.Stick;

/**
 * ...
 * @author Time
 */
class Tree extends Entity {
	public var frame:Int = 0;

	private var solids:Dynamic = ["Solid", "Tree"];
	private var bare:Bool;

	public function new(_x:Int, _y:Int, _bare:Bool = false, _g:Graphic = null) {

		super(_x + Tile.w, _y + Tile.h, _g);
		setHitbox(32, 32, 16, 16);
		type = "Tree";
		layer = Std.int(-(y - originY + height));
		active = false;
		bare = _bare;
	}

	override public function check():Void {
		super.check();
		frame = getFrame();
	}

	override public function render():Void {
		if (!onScreen()) {
			return;
		}
		if (bare) {
			Game.sprTreeBare.frame = frame;
			Game.sprTreeBare.render(new Point(x, y), FP.camera);
		} else {
			Game.sprTree.frame = frame;
			Game.sprTree.render(new Point(x, y), FP.camera);
		}
	}

	public function hit(t:String = ""):Void {}

	public function getFrame():Int {
		var v:Int = 0;
		if (collide("Tree", x + 1, y) != null || x + width - originX + 1 > FP.width) {
			v++;
		}
		if (collide("Tree", x, y - 1) != null || y - originY - 1 < 0) {
			v += 2;
		}
		if (collide("Tree", x - 1, y) != null || x - originX - 1 < 0) {
			v += 4;
		}
		if (collide("Tree", x, y + 1) != null || y + height - originY + 1 > FP.height) {
			v += 8;
		}
		return v;
	}
}
