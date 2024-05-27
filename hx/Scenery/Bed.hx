package scenery;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class Bed extends Entity {
	@:meta(Embed(source = "../../assets/graphics/Bed.png"))
	private var imgBed:Class<Dynamic>;
	private var sprBed:Image = new Image(imgBed);

	public function new(_x:Int, _y:Int) {
		super(_x, _y, sprBed);
		setHitbox(16, 32);
		type = "Solid";
		layer = Std.int(-(y - originY + height * 4 / 5));
	}
}
