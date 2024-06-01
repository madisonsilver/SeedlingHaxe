package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.Entity;
import net.flashpunk.Graphic;
import net.flashpunk.masks.Pixelmask;

/**
 * ...
 * @author Time
 */
class SnowHill extends Entity {
	public function new(_x:Int, _y:Int) {


		super(_x, _y, Game.sprSnowHill);
		Game.sprSnowHill.y = -8;
		mask = new Pixelmask(Game.imgSnowHillMask, 0, 0);
		type = "Solid";
		layer = Std.int(-(y - originY + height - 32));
		active = false;
	}
}
