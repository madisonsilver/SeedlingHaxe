package pickups;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.Graphic;
import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class Stick extends Pickup {
private var imgStick:BitmapData;
	private var sprStick:Image;

private function load_image_assets():Void {
imgStick = Assets.getBitmapData("assets/graphics/Stick.png");
}
	public function new(_x:Int, _y:Int, _v:Point = null) {

load_image_assets();
		sprStick = new Image(imgStick);
		super(_x, _y, sprStick, _v);
		sprStick.centerOO();
		sprStick.angle = Math.random() * 360;
		type = "Stick";
		setHitbox(4, 4, 2, 2);

		solids = ["Solid"];
	}
}
