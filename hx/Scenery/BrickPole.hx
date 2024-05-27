package scenery;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class BrickPole extends Entity {
	@:meta(Embed(source = "../../assets/graphics/BrickPole.png"))
	private var imgBrickPole:Class<Dynamic>;
	private var sprBrickPole:Image = new Image(imgBrickPole);

	public function new(_x:Int, _y:Int) {
		super(_x, _y, sprBrickPole);
		sprBrickPole.y = -4;
		sprBrickPole.originY = 4;
		setHitbox(16, 16);
		type = "Solid";
		layer = Std.int(-(y - originY + height * 4 / 5));
	}
}
