package scenery;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class Barstool extends Entity {
	@:meta(Embed(source = "../../assets/graphics/Barstool.png"))
	private var imgBarstool:Class<Dynamic>;
	private var sprBarstool:Image ;

	public function new(_x:Int, _y:Int) {
sprBarstool =  new Image(imgBarstool);
		super(_x + Tile.w / 4, _y + Tile.h / 4, sprBarstool);
		setHitbox(8, 8);
		sprBarstool.y = -4;
		sprBarstool.originY = Std.int(-sprBarstool.y);
		type = "Solid";
		layer = Std.int(-(y - originY));
	}
}
