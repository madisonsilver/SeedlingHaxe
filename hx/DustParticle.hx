import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.Entity;
import net.flashpunk.utils.Draw;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class DustParticle extends Entity {
	private var w(default, never):Int = (cast Math.random() * 3 + 1:Int);
	private var h:Int = 0;
	private var c(default, never):Int = FP.getColorRGB((cast Math.random() * 64 + 192:Int), (cast Math.random() * 64 + 192:Int), 0);
	private var a:Float = Math.random() / 2 + 0.5;

	private var m(default, never):Float = Math.random() * 2 + 1;
	private var startT:Int = 0;
	private var startY:Int = 0;

	public function new(_x:Int, _y:Int) {
		h = w;
		super(_x, _y);
		startY = Std.int(y - FP.camera.y);
		startT = Std.int(Game.time);

		layer = -FP.height;
	}

	override public function update():Void {
		// TODO: The DustParticles incorrectly unload en masse when they reach the edge of the screen.
		x = (Game.time - startT) * m + FP.camera.x;
		y = FP.camera.y + startY + Math.sin((Game.time - startT) / m) * m;

		if ((try cast(FP.world, Game) catch (e:Dynamic) null).timeRate <= 0) {
			a -= 1 / (m * 10);
			if (a <= 0) {
				FP.world.remove(this);
			}
		}

		if (x >= FP.camera.x + FP.screen.width || x < FP.camera.x || y < FP.camera.y || y >= FP.camera.y + FP.screen.height) {
			FP.world.remove(this);
		}
	}

	override public function render():Void {
		Draw.rect(Std.int(x), Std.int(y), w, h, c, a);
	}
}
