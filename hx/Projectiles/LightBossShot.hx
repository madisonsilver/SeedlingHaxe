package projectiles;

import openfl.geom.Point;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class LightBossShot extends TurretSpit {
	@:meta(Embed(source = "../../assets/graphics/LightBossShot.png"))
	private var imgLightBossShot:Class<Dynamic>;
	private var sprLightBossShot:Spritemap;

	private var angleSpinRate(default, never):Int = 10;

	public function new(_x:Int, _y:Int, _v:Point) {
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
