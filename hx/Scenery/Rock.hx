package scenery;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import Game;

/**
 * ...
 * @author Time
 */
class Rock extends Entity {
	public function new(_x:Int, _y:Int, _t:Int = 0, _w:Int = 16, _h:Int = 16) {
		super(_x, _y, Game.rocks[_t]);
		setHitbox(_w, _h);
		type = "Solid";
		layer = Std.int(-(y - originY + height * 3 / 4));
	}
}
