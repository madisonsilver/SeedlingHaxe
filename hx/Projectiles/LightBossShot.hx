package projectiles;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class LightBossShot extends TurretSpit {
private var imgLightBossShot:BitmapData;
	private var sprLightBossShot:Spritemap;

	private var angleSpinRate(default, never):Int = 10;

private override function load_image_assets():Void {
imgLightBossShot = Assets.getBitmapData("assets/graphics/LightBossShot.png");
}
	public function new(_x:Int, _y:Int, _v:Point) {

load_image_assets();
		sprLightBossShot = new Spritemap(imgLightBossShot, 8, 8);
		super(_x, _y, _v);
		graphic = sprLightBossShot;
		sprLightBossShot.centerOO();
		v = _v;
		f = 0;
		setHitbox(4, 4, 2, 2);
		type = "LightBossShot";
		solids = [];
		hitables = ["Player"];
	}

	override public function imageAngle():Void {
		if (!Game.freezeObjects) {
			(try cast(graphic, Image) catch (e:Dynamic) null).angle += angleSpinRate;
		}
	}

	override public function update():Void {
		super.update();
		if (!onScreen()) {
			FP.world.remove(this);
		}
	}
}
