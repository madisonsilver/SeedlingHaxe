package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.masks.Pixelmask;
import net.flashpunk.utils.Draw;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class Building extends Entity {
	private var buildingType:Int;

	private static var moundFrames:Array<Dynamic> = [0, 1, 2, 1];

	public function new(_x:Int, _y:Int, _t:Int = 0) {


		super(_x, _y, Game.buildings[_t]);
		Game.buildings[_t].y = -8;
		mask = new Pixelmask(Game.buildingMasks[_t], 0, 0);
		type = "Solid";
		buildingType = _t;

		switch (_t) {
			case 4:
				layer = Std.int(-(y - originY + 1 / 2 * height));
			case 6:
				layer = Std.int(-(y - originY + 72));
			case 7:
				layer = Std.int(-(y - originY + 16));
			case 8:
				layer = Std.int(-(y - originY + 48));
				Game.buildings[_t].y = 0;
			default:
				layer = Std.int(-(y - originY + height));
		}
	}

	override public function render():Void {
		if (buildingType == 8) {
			var moundLoops:Int = 1;
			Game.buildings[buildingType].frame = moundFrames[Game.worldFrame(moundFrames.length, moundLoops)];
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
		super.render();
	}
}
