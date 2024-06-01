package enemies;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import projectiles.IceTurretBlast;
import projectiles.TurretSpit;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class IceTurret extends Enemy {
private var imgIceTurret:BitmapData;
	private var sprIceTurret:Spritemap;

	private var attackAnimSpeed(default, never):Int = 10;
	private var attackRange(default, never):Int = 128;

	private var shootTimerMax(default, never):Int = 25; // The time between shots
	private var shootTimer:Int = 0;
	private var shotSpeed(default, never):Int = 6;

	private var moveSpeed(default, never):Float = 0.5;
	private var cTile:Point;
	private var lTile:Point;
	private var tile:Point;

private function load_image_assets():Void {
imgIceTurret = Assets.getBitmapData("assets/graphics/IceTurret.png");
}
	public function new(_x:Int, _y:Int) {
load_image_assets();
		sprIceTurret = new Spritemap(imgIceTurret, 32, 32, endAnim);
		super(_x + Tile.w, _y + Tile.h, sprIceTurret);

		sprIceTurret.originX = 12;
		sprIceTurret.x = -sprIceTurret.originX;
		sprIceTurret.originY = 16;
		sprIceTurret.y = -sprIceTurret.originY;
		// the animation "" will reset it to the world frame speed
		sprIceTurret.add("startshot", [0], attackAnimSpeed);
		sprIceTurret.add("finishshot", [1, 2, 3, 4, 5], attackAnimSpeed);
		sprIceTurret.add("hit", [1]);
		sprIceTurret.add("dead", [6]);

		setHitbox(32, 32, 16, 16);

		tile = new Point(Math.floor(x / Tile.w), Math.floor(y / Tile.h));
		cTile = tile;
		lTile = tile;

		v = new Point();
		dieInWater = false;
	}

	override public function update():Void {
		dieInWater = hits >= hitsMax;
		super.update();
		if (Game.freezeObjects) {
			return;
		}
		if (sprIceTurret.currentAnim != "dead") {
			var player:Player = try cast(FP.world.nearestToEntity("Player", this), Player) catch (e:Dynamic) null;
			if (player != null) {
				var d:Int = Std.int(FP.distance(x, y, player.x, player.y));
				if (d <= attackRange && sprIceTurret.currentAnim != "startshot" && sprIceTurret.currentAnim != "finishshot") {
					var angleSpeedDivisor:Int = 10;
					sprIceTurret.angle += FP.angle_difference(-Math.atan2(player.y - y, player.x - x),
						sprIceTurret.angle / 180 * Math.PI) * 180 / Math.PI / angleSpeedDivisor;
					if (shootTimer > 0) {
						shootTimer--;
					} else if (hitsTimer <= 0) {
						shootTimer = shootTimerMax;
						sprIceTurret.play("startshot");
					}
				} else {
					shootTimer = shootTimerMax;
				}
			}
			if (sprIceTurret.currentAnim == "") {
				sprIceTurret.frame = 0;
			}
		} else if (collide("Player", x, y) == null) {
			type = "Solid";
		}
		layer = Std.int(-(y - originY + height));
	}

	override public function render():Void {
		var tpos:Point = new Point(x, y);
		x = Math.round(x);
		y = Math.round(y);
		super.render();
		x = tpos.x;
		y = tpos.y;
	}

	override public function layering():Void {}

	override public function knockback(f:Float = 0, p:Point = null):Void {}

	override public function hit(f:Float = 0, p:Point = null, d:Float = 1, t:String = ""):Void {
		if (sprIceTurret.currentAnim != "dead") {
			super.hit(f, p, d, t);
		}
	}

	override public function hitPlayer():Void {
		if (sprIceTurret.currentAnim != "dead") {
			super.hitPlayer();
		}
	}

	override public function death():Void {
		if (destroy) {
			if ((try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "dead") {
				super.death();
			} else {
				setHitbox(16, 16, 8, 8);
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("dead");
				destroy = false;
				solids.push("Enemy", "Player");
			}
		}
	}

	public function endAnim():Void {
		var _sw5_ = (sprIceTurret.currentAnim);

		switch (_sw5_) {
			case "startshot":
				sprIceTurret.play("finishshot");
				var a:Float = -sprIceTurret.angle / 180 * Math.PI;
				FP.world.add(new IceTurretBlast(Std.int(x), Std.int(y), new Point(shotSpeed * Math.cos(a), shotSpeed * Math.sin(a))));
				var distBtwnShots:Int = 12;
				FP.world.add(new IceTurretBlast(Std.int(x + distBtwnShots * Math.cos(a + Math.PI / 2)),
					Std.int(y + distBtwnShots * Math.sin(a + Math.PI / 2)), new Point(shotSpeed * Math.cos(a), shotSpeed * Math.sin(a))));
				FP.world.add(new IceTurretBlast(Std.int(x - distBtwnShots * Math.cos(a + Math.PI / 2)),
					Std.int(y - distBtwnShots * Math.sin(a + Math.PI / 2)), new Point(shotSpeed * Math.cos(a), shotSpeed * Math.sin(a))));
			case "dead":
			default:
				sprIceTurret.play("");
		}
	}

	public function bump(p:Point, t:String):Void {
		if (sprIceTurret.currentAnim == "dead" && (t == "Fire" || t == "Pulse")) {
			var tTile:Point = new Point(Math.round(x / Tile.w), Math.round(y / Tile.h));
			var a:Float = Math.atan2(-(y - originY + height / 2) + p.y, p.x - (x - originX + width / 2));
			var bothRange:Float = 0.1; // This range determines when both horizontal and vertical movement will occur.
			if (Math.abs(Math.sin(a)) - bothRange < Math.abs(Math.cos(a))) {
				if (Math.cos(a) > 0) {
					tile.x = tTile.x - 1;
				} else {
					tile.x = tTile.x + 1;
				}
			}
			if (Math.abs(Math.sin(a)) > Math.abs(Math.cos(a)) - bothRange) {
				if (Math.sin(a) > 0) {
					tile.y = tTile.y - 1;
				} else {
					tile.y = tTile.y + 1;
				}
			}
		}
	}

	override public function input():Void {
		if (sprIceTurret.currentAnim == "dead") {
			sprIceTurret.angle -= FP.angle_difference(Math.atan2(1, 0), -sprIceTurret.angle / 180 * Math.PI) * 180 / Math.PI / 10;
		}
		lTile = cTile;
		cTile = new Point(Math.round(x / Tile.w), Math.round(y / Tile.h));
		if (x == cTile.x * Tile.w && y == cTile.y * Tile.h)
			// cTile.x != lTile.x || cTile.y != lTile.y)
		{
			{
				var myTile:Tile = try cast(FP.world.nearestToPoint("Tile", x - originX + width / 2, y - originY + height / 2), Tile) catch (e:Dynamic) null;
				if (myTile != null) {
					if (myTile.t == 1 || myTile.t == 17 || myTile.t == 6)
						// Water && Lava && Pit
					{
						{
							destroy = true;
						}
					}
				}
			}
		}
		v.x = moveSpeed * FP.sign(tile.x - cTile.x);
		if (v.x == 0) {
			x = Math.floor(x / Tile.w) * Tile.w + Tile.w / 2;
		}
		v.y = moveSpeed * FP.sign(tile.y - cTile.y);
		if (v.y == 0) {
			y = Math.floor(y / Tile.h) * Tile.h + Tile.h / 2;
		}

		if (x == Math.floor(x / Tile.w) * Tile.w + Tile.w / 2 && y == Math.floor(y / Tile.h) * Tile.h + Tile.h / 2) {
			if (v.length > 0 && collideTypes(solids, x + v.x, y + v.y) == null) {
				Music.playSound("Push Rock", -1, 0.5);
			}
		}
	}
}
