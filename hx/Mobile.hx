import openfl.utils.Assets;import openfl.display.BitmapData;
import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.Graphic;
import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class Mobile extends Entity {
	public static inline var DEFAULT_FRICTION:Float = 0.25;
	public static inline var WATER_FRICTION:Float = 0.5;

	public var f:Float = DEFAULT_FRICTION; // Frictional constant
	public var solids:Dynamic = ["Solid", "Tree", "Rock", "Rope", "ShieldBoss"];
	public var v:Point = new Point();
	public var destroy:Bool = false;

	public function new(_x:Int, _y:Int, _g:Graphic = null) {


		super(_x, _y, _g);
	}

	override public function update():Void {
		mobileUpdate();
	}

	public function mobileUpdate():Void {
		if (!destroy) {
			if (!Game.freezeObjects) {
				friction();
				input();
				moveX(v.x);
				moveY(v.y);
			}
			layering();
		}
		death();
	}

	public function input():Void {}

	public function layering():Void {
		if (!Math.isNaN(originY) && !Math.isNaN(height)) {
			layer = Std.int(-(y - originY + height));
		}
	}

	public function death():Void {
		if (destroy)
			// (graphic as Image).scale -= 0.05;
		{
			(try cast(graphic, Image) catch (e:Dynamic) null).alpha -= 0.1;
			if ((try cast(graphic, Image) catch (e:Dynamic) null).alpha <= 0) {
				FP.world.remove(this);
			}
		}
	}

	public function friction():Void {
		v.normalize(Math.max(v.length - f, 0));
		if (Math.abs(v.x) < 0.05) {
			v.x = 0;
		}
		if (Math.abs(v.y) < 0.05) {
			v.y = 0;
		}
	}

	public function moveX(_xrel:Float):Entity // returns the object that is hit
	{
		var i:Int = 0;
		while (i < Math.abs(_xrel)) {
			var c:Entity = collideTypes(solids, x + Math.min(1, Math.abs(_xrel) - i) * FP.sign(_xrel), y);
			if (c == null) {
				x += Math.min(1, Math.abs(_xrel) - i) * FP.sign(_xrel);
			} else {
				return c;
			}
			i += 1;
		}
		return null;
	}

	public function moveY(_yrel:Float):Entity // returns the object that is hit
	{
		var i:Int = 0;
		while (i < Math.abs(_yrel)) {
			var c:Entity = collideTypes(solids, x, y + Math.min(1, Math.abs(_yrel) - i) * FP.sign(_yrel));
			if (c == null) {
				y += Math.min(1, Math.abs(_yrel) - i) * FP.sign(_yrel);
			} else {
				return c;
			}
			i += 1;
		}
		return null;
	}
}
