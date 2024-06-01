package puzzlements;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import enemies.Enemy;
import enemies.IceTurret;
import openfl.geom.Point;
import net.flashpunk.Entity;
import scenery.Tile;
import net.flashpunk.FP;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class Pulser extends Activators {
	private var imgPulser:BitmapData;
	private var sprPulser:Spritemap;

	private var radiusMin(default, never):Int = 10;
	private var radiusMax(default, never):Int = 28;
	private var radiusHit(default, never):Int = 22;
	private var radius:Float;
	private var radiusRate(default, never):Float = 0.8;

	private var thicknessMin(default, never):Int = 1;
	private var thicknessMax(default, never):Int = 8;
	private var thicknessLightExtra(default, never):Int = 2;

	private var pulseColor(default, never):Int = 0xFFFF00;
	private var pulseTimerMax(default, never):Int = 20;
	private var pulseTimer:Int = 0;

	private var force(default, never):Int = 6;
	private var damage(default, never):Int = 1;

	private var hitables(default, never):Dynamic = ["Player", "Solid", "Enemy"];

	private function load_image_assets():Void {
		imgPulser = Assets.getBitmapData("assets/graphics/Pulser.png");
	}

	public function new(_x:Int, _y:Int, _t:Int) {
		load_image_assets();
		sprPulser = new Spritemap(imgPulser, 16, 16, endAnim);
		radius = radiusMin;
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprPulser, _t);
		(try cast(graphic, Image) catch (e:Dynamic) null).centerOO();
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).add("pulse", [0, 1, 2, 3, 4], 20);
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).add("", [0]);
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("");
		setHitbox(16, 16, 8, 8);
		type = "Solid";
	}

	override public function update():Void {
		super.update();
		if (activate || radius > radiusMin) {
			if ((try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "") {
				if (pulseTimer > 0) {
					pulseTimer--;
				} else if (pulseTimer == 0) {
					(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("pulse");
					Music.playSoundDistPlayer(Std.int(x), Std.int(y), "Energy Pulse", -1, 120);
					pulseTimer = -1;
				} else {
					hit();
					radius += radiusRate;
					if (radius >= radiusMax) {
						pulseTimer = pulseTimerMax;
						radius = radiusMin;
					}
				}
			}
		} else {
			pulseTimer = -1;
			radius = radiusMin;
		}
	}

	public function hit():Void {
		var v:Array<Entity> = new Array<Entity>();
		for (i in 0...hitables.length) {
			FP.world.collideRectInto(Reflect.field(hitables, Std.string(i)), x - radiusHit, y - radiusHit, radiusHit * 2, radiusHit * 2, v);
		}
		for (c in v) {
			if (FP.distanceRectPoint(x, y, c.x - c.originX, c.y - c.originY, c.width, c.height) > radiusHit) {
				continue;
			}
			if (Std.is(c, PushableBlockFire)) {
				(try cast(c, PushableBlockFire) catch (e:Dynamic) null).hit(new Point(x, y), "Pulse");
			} else if (Std.is(c, IceTurret)) {
				(try cast(c, IceTurret) catch (e:Dynamic) null).bump(new Point(x, y), "Pulse");
			} else if (Std.is(c, Enemy)) {
				(try cast(c, Enemy) catch (e:Dynamic) null).hit(force, new Point(x, y), damage, "Pulse");
			} else if (Std.is(c, Player)) {
				(try cast(c, Player) catch (e:Dynamic) null).hit(null, force, new Point(x, y), damage);
			}
		}
	}

	override public function render():Void {
		if (radius > radiusMin) {
			var rVal:Float = 1 - radius / radiusMax;
			Draw.circlePlus(Std.int(x), Std.int(y), radius, pulseColor, rVal, false, Std.int((thicknessMax - thicknessMin) * rVal + thicknessMin));
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			Draw.circlePlus(Std.int(x), Std.int(y), radius, pulseColor, rVal, false,
				Std.int((thicknessMax - thicknessMin) * rVal + thicknessMin + thicknessLightExtra));
			Draw.resetTarget();
		}
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		super.render();
		Draw.resetTarget();
		super.render();
	}

	public function endAnim():Void {
		if ((try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "pulse") {
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("");
		}
	}
}
