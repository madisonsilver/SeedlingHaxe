package scenery;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class LittleStones extends Entity {
	@:meta(Embed(source = "../../assets/graphics/LittleStones.png"))
	private var imgLittleStones:Class<Dynamic>;
	private var sprLittleStones:Image ;

	private var grassPosX:Dynamic = [1, 1, 9, 5, 1];
	private var grassPosY:Dynamic = [14, 9, 14, 1, 6];

	public function new(_x:Int, _y:Int) {
sprLittleStones =  new Image(imgLittleStones);
		super(_x, _y, sprLittleStones);
		layer = Std.int(-y);
		for (i in 0...grassPosX.length) {
			FP.world.add(new Grass(x + Reflect.field(grassPosX, Std.string(i)), y + Reflect.field(grassPosY, Std.string(i))));
		}
	}
}
