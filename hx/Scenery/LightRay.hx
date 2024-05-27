package scenery;

import net.flashpunk.Entity;
import net.flashpunk.utils.Draw;
import net.flashpunk.FP;
import openfl.display.BlendMode;

/**
 * ...
 * @author Time
 */
class LightRay extends Entity {
	private var c:Int;
	private var a:Float;
	private var w:Int;
	private var h:Int;

	public function new(_x:Int, _y:Int, _c:Int, _a:Float, _w:Int, _h:Int) {
		super(_x, _y);
		c = _c;
		a = _a;
		w = _w;
		h = _h;
		layer = Std.int(-(y + h));
	}

	override public function render():Void {
		if (y - FP.camera.y + h >= 0) {
			Draw.rect(Std.int(x), Std.int(FP.camera.y), w, Std.int(y - FP.camera.y + h), c, 0.2);
			Draw.blend = BlendMode.SCREEN;
			Draw.rect(Std.int(x), Std.int(y), w, h, c, a / 2);
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			Draw.rect(Std.int(x), Std.int(FP.camera.y), w, Std.int(y - FP.camera.y + h), c, a);
			Draw.resetTarget();
			Draw.blend = BlendMode.NORMAL;
		}
	}
}
