package enemies;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import projectiles.TurretSpit;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class Turret extends Enemy {
	private var imgTurret:BitmapData;
	private var sprTurret:Spritemap;

	private var attackAnimSpeed(default, never):Int = 10;
	private var attackRange(default, never):Int = 64;

	private var shootTimerMax(default, never):Int = 40; // The time between shots
	private var shootTimer:Int = 0;
	private var shotSpeed(default, never):Int = 3;

	private function load_image_assets():Void {
		imgTurret = Assets.getBitmapData("assets/graphics/Turret.png");
	}

	public function new(_x:Int, _y:Int) {
		load_image_assets();
		sprTurret = new Spritemap(imgTurret, 16, 16, endAnim);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprTurret);

		sprTurret.centerOO();
		// the animation "" will reset it to the world frame speed
		sprTurret.add("startshot", [1, 2], attackAnimSpeed);
		sprTurret.add("finishshot", [2, 1], attackAnimSpeed);
		sprTurret.add("hit", [0]);
		sprTurret.add("die", [3, 4, 5, 6, 7, 8], 10);

		setHitbox(16, 16, 8, 8);

		layer = Std.int(-(y - originY + height * 4 / 5));
	}

	override public function check():Void {
		super.check();
	}

	override public function update():Void {
		super.update();
		if (Game.freezeObjects || destroy || (try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "die") {
			return;
		}
		var player:Player = try cast(FP.world.nearestToEntity("Player", this), Player) catch (e:Dynamic) null;
		if (player != null) {
			var d:Int = Std.int(FP.distance(x, y, player.x, player.y));
			if (d <= attackRange && sprTurret.currentAnim != "startshot" && sprTurret.currentAnim != "finishshot") {
				var angleSpeedDivisor:Int = 10;
				sprTurret.angle += FP.angle_difference(-Math.atan2(player.y - y, player.x - x),
					sprTurret.angle / 180 * Math.PI) * 180 / Math.PI / angleSpeedDivisor;
				if (shootTimer > 0) {
					shootTimer--;
				} else if (hitsTimer <= 0) {
					shootTimer = shootTimerMax;
					sprTurret.play("startshot");
				}
			} else {
				shootTimer = shootTimerMax;
			}
		}
		if (sprTurret.currentAnim == "") {
			sprTurret.frame = 0;
		}
	}

	override public function layering():Void {}

	override public function knockback(f:Float = 0, p:Point = null):Void {}

	override public function startDeath(t:String = ""):Void {
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("die");
		dieEffects(t);
	}

	public function endAnim():Void {
		var _sw14_ = (sprTurret.currentAnim);

		switch (_sw14_) {
			case "startshot":
				sprTurret.play("finishshot");
				var a:Float = -sprTurret.angle / 180 * Math.PI;
				FP.world.add(new TurretSpit(Std.int(x), Std.int(y), new Point(shotSpeed * Math.cos(a), shotSpeed * Math.sin(a))));
			case "die":
				destroy = true;
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("");
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).frame = (try cast(graphic, Spritemap) catch (e:Dynamic) null).frameCount - 1;
			default:
				sprTurret.play("");
		}
	}
}
