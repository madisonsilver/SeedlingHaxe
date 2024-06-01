package scenery;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class BrickWell extends Entity {
	@:meta(Embed(source = "../../assets/graphics/BrickWell.png"))
	private var imgBrickWell:Class<Dynamic>;
	private var sprBrickWell:Image;

	public function new(_x:Int, _y:Int) {
		sprBrickWell = new Image(imgBrickWell);
		super(_x, _y, sprBrickWell);
		sprBrickWell.y = -4;
		sprBrickWell.originY = 4;
		sprBrickWell.x = -1;
		sprBrickWell.originX = 1;
		setHitbox(16, 16);
		type = "Solid";
		layer = Std.int(-(y - originY + height * 4 / 5));
	}
}
