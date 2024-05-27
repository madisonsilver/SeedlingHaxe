package scenery;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class ShieldStatue extends Entity {
	@:meta(Embed(source = "../../assets/graphics/ShieldStatue.png"))
	private var imgShieldStatue:Class<Dynamic>;
	private var sprShieldStatue:Image = new Image(imgShieldStatue);

	public function new(_x:Int, _y:Int) {
		super(_x + Tile.w / 2, _y, sprShieldStatue);
		sprShieldStatue.y = -11;
		sprShieldStatue.originY = 11;
		setHitbox(32, 32);
		type = "Solid";
		layer = Std.int(-(y - originY));
	}
}
