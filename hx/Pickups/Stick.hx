package pickups;

import openfl.geom.Point;
import net.flashpunk.Graphic;
import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class Stick extends Pickup {
	@:meta(Embed(source = "../../assets/graphics/Stick.png"))
	private var imgStick:Class<Dynamic>;
	private var sprStick:Image = new Image(imgStick);

	public function new(_x:Int, _y:Int, _v:Point = null) {
		super(_x, _y, sprStick, _v);
		sprStick.centerOO();
		sprStick.angle = Math.random() * 360;
		type = "Stick";
		setHitbox(4, 4, 2, 2);

		solids = ["Solid"];
	}
}
