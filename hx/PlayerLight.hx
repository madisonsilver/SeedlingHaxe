import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import scenery.Light;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class PlayerLight extends Light {
	private var imgPlayerLight:BitmapData;
	private var sprPlayerLight:Image;

	private var follow:Player;
	private var colorLoops:Int = 12;

	private var movementDivisor(default, never):Int = 5;
	private var colors(default, never):Array<Dynamic> = [0xFFCC00, 0xFFFFFF, 0xFF0000, 0x00FF00, 0x0000FF];

	private function load_image_assets():Void {
		imgPlayerLight = Assets.getBitmapData("assets/graphics/PlayerLight.png");
	}

	public function new(_x:Int, _y:Int, _follow:Player) {
		load_image_assets();
		sprPlayerLight = new Image(imgPlayerLight);
		super(_x, _y, 100, 3, colors[0], true, 20);
		alpha = 0.5;
		follow = _follow;
		graphic = sprPlayerLight;
		sprPlayerLight.centerOO();
	}

	override public function update():Void {
		var wf:Int = Game.worldFrame(frames, colorLoops);
		color = FP.colorLerp(colors[Std.int(wf / frames * colors.length)],
			colors[Std.int(wf / frames * colors.length + 1) % colors.length],
			wf / frames * colors.length - Std.int(wf / frames * colors.length));
		sprPlayerLight.color = color;
		if (follow != null) {
			x += Std.int((follow.x + follow.myLightPosition.x - x) / movementDivisor);
			y += Std.int((follow.y + follow.myLightPosition.y - y) / movementDivisor);
		}
		super.update();
	}
}
