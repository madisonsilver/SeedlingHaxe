import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;

/**
 * ...
 * @author Time
 */
class Stairs extends Teleporter {
	private var imgStairs:BitmapData;
	private var sprStairs:Spritemap;

	private var up:Bool;

	private override function load_image_assets():Void {
		super.load_image_assets();
		imgStairs = Assets.getBitmapData("assets/graphics/Stairs.png");
	}

	public function new(_x:Int, _y:Int, _up:Bool = true, _flip:Bool = false, _to:Int = 0, _px:Int = 0, _py:Int = 0, _sign:Int = 0) {
		load_image_assets();
		sprStairs = new Spritemap(imgStairs, 16, 16);
		super(_x, _y, _to, _px, _py, true, -1, false, _sign);
		up = _up;
		graphic = sprStairs;
		sprStairs.frame = (!up ? 1 : 0);
		if (up) {
			soundIndex = 1;
		} else {
			soundIndex = 2;
		}
		sprStairs.originX = Std.int(sprStairs.width / 2);

		if (_flip) {
			sprStairs.scaleX = -1;
		}
		renderLight = false;
	}

	override public function update():Void {
		super.update();
		if (!Math.isNaN(originY) && !Math.isNaN(height)) {
			layer = Std.int(-y);
		}
	}
}
