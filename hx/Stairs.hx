import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;

/**
 * ...
 * @author Time
 */
class Stairs extends Teleporter {
	@:meta(Embed(source = "../assets/graphics/Stairs.png"))
	private var imgStairs:Class<Dynamic>;
	private var sprStairs:Spritemap;

	private var up:Bool;

	public function new(_x:Int, _y:Int, _up:Bool = true, _flip:Bool = false, _to:Int = 0, _px:Int = 0, _py:Int = 0, _sign:Int = 0) {
		sprStairs = new Spritemap(imgStairs, 16, 16);
		super(_x, _y, _to, _px, _py, true, -1, false, _sign);
		up = _up;
		graphic = sprStairs;
		sprStairs.frame = as3hx.Compat.parseInt(!up);
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
