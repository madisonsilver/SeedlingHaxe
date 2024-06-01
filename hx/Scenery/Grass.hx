package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class Grass extends Entity {
	private var startIndex:Int = Math.floor(Math.random() * (Game.sprGrass.frameCount - 1) / 2) * 2 + 1;
	private var cutGrass:Bool = false;

	private var color:Int = 0xFFFFFF;
	private var alpha:Float = 1;

	public function new(_x:Int, _y:Int) {


		super(_x, _y, Game.sprGrass);
		active = false;
		layer = Std.int(-y);
		type = "Grass";
		setHitbox(16, 4, 8, 4);
	}

	public function cut(t:String = ""):Void {
		if (!cutGrass) {
			if (!Music.soundIsPlaying("Arrow", 0)) {
				Music.playSound("Arrow", 0);
			}
			Main.grassCut++;
			cutGrass = true;
		}
		if (t == "Fire") {
			color = 0x444444;
			alpha = 0.25;
		}
	}

	override public function render():Void {
		if (cutGrass) {
			Game.sprGrass.frame = 0;
		} else {
			Game.sprGrass.frame = startIndex + Game.worldFrame(2);
		}
		Game.sprGrass.color = color;
		Game.sprGrass.alpha = alpha;
		super.render();
	}
}
