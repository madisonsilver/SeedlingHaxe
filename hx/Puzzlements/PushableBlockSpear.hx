package puzzlements;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class PushableBlockSpear extends PushableBlockFire {
	public function new(_x:Int, _y:Int) {

		super(_x, _y);
		moveTypes = ["Spear"];
		(try cast(graphic, Image) catch (e:Dynamic) null).color = 0x8822FF;
	}
}
