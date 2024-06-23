package enemies;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.geom.Point;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import projectiles.LightBossShot;
import scenery.Light;

/**
 * ...
 * @author Time
 */
class LightBoss extends Enemy {
	private var imgLightBoss:BitmapData;
	private var sprLightBoss:Spritemap;

	private var divisor(default, never):Int = 20;
	private var lightLength(default, never):Int = 4;
	private var shotSpeed(default, never):Int = 1;
	private var maxSpeed(default, never):Float = 1.5;

	public var goto:Point;

	private var parent:LightBossController;

	public var id:Int;

	private var myLight:Light;
	private var angleFace:Float;

	private function load_image_assets():Void {
		imgLightBoss = Assets.getBitmapData("assets/graphics/LightBoss.png");
	}

	public function new(_x:Int, _y:Int, _id:Int, _parent:LightBossController) {
		load_image_assets();
		sprLightBoss = new Spritemap(imgLightBoss, 17, 16, animEnd);
		super(_x, _y, sprLightBoss);
		sprLightBoss.centerOO();
		sprLightBoss.add("sit", [0]);
		sprLightBoss.add("die", [1, 2, 3, 4, 5, 6, 7, 8, 9], 20);
		sprLightBoss.play("sit");

		canFallInPit = false;
		activeOffScreen = true;
		dieInWater = false;

		setHitbox(12, 12, 6, 6);

		solids = [];

		id = _id;
		parent = _parent;

		hitsMax = 3;

		FP.world.add(myLight = new Light(Std.int(x), Std.int(y), 100, 1, 0xFFFF00, true));

		hitSoundIndex = 1; // Big hit sound
		dieSoundIndex = 1;
	}

	override public function update():Void {
		super.update();
		if (Game.freezeObjects) {
			return;
		}

		if (goto != null) {
			v.x += (goto.x - x) / divisor;
			v.y += (goto.y - y) / divisor;
		}

		if (Math.floor(Math.random() * 90) == 0) {
			Music.playSound("Boss 6 Move");
		}

		angleFace = Math.atan2(v.y, v.x);

		if (myLight != null) {
			myLight.x = x + lightLength * Math.cos(angleFace);
			myLight.y = y + lightLength * Math.sin(angleFace);
			myLight.color = FP.colorLerp(0xFFFF00, 0x00FF00, hits / hitsMax);
		}
		v.normalize(Math.min(v.length, maxSpeed));
		(try cast(graphic, Image) catch (e:Dynamic) null).angle = angleFace * FP.DEG;
		normalColor = Std.int(0xFFFFFF * (1 - hits / hitsMax));
	}

	override public function startDeath(t:String = ""):Void {
		sprLightBoss.play("die");
		sprLightBoss.scale = 1.1;
		parent.removeFlier(id);

		var p:Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch (e:Dynamic) null;

		if (myLight != null) {
			FP.world.remove(myLight);
		}
	}

	public function animEnd():Void {
		var _sw9_ = ((try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim);

		switch (_sw9_) {
			case "die":
				destroy = true;
				FP.world.remove(this);
			default:
		}
	}

	public function shoot():Void {
		FP.world.add(new LightBossShot(Std.int(x + lightLength * Math.cos(angleFace)), Std.int(y + lightLength * Math.sin(angleFace)),
			new Point(shotSpeed * Math.cos(angleFace), shotSpeed * Math.sin(angleFace))));
	}
}
