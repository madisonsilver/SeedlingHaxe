package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import scenery.Tile;
import net.flashpunk.FP;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class Moonrock extends Entity {
	public static var beam(get, set):Bool;

private var imgMoonrock:BitmapData;
	private var sprMoonrock:Spritemap;

	private var tag:Int;

	private var trigger:Bool = false;

	private static function set_beam(_t:Bool):Bool {
		Main.beam = _t;
		return _t;
	}

	private static function get_beam():Bool {
		return Main.beam;
	}

	private inline static final beamTimeMax:Int = Main.FPS * 5;

	private var beamTime:Int = beamTimeMax;
	private var canBeam:Bool = false;

	private var cameraTimerMax(default, never):Int = 90; // The length of time that the camera focuses after this hits
	private var cameraTimer:Int = 0;

	private var fallRate(default, never):Int = 20;
	private var fallTo:Int;

private function load_image_assets():Void {
imgMoonrock = Assets.getBitmapData("assets/graphics/Moonrock.png");
}
	public function new(_x:Int, _y:Int, _tag:Int = -1) {

load_image_assets();
		sprMoonrock = new Spritemap(imgMoonrock, 52, 52);
		super(_x, _y, sprMoonrock);
		fallTo = _y;
		sprMoonrock.x = sprMoonrock.y = -2;
		sprMoonrock.originX = sprMoonrock.originY = 2;
		setHitbox(48, 48);
		type = "";
		tag = _tag;
		y = -1000;
		if (Game.moonrockSet) {
			y = fallTo;
			type = "Solid";
		}
	}

	override public function check():Void {
		super.check();
		if (tag >= 0 && !Game.checkPersistence(tag)) {
			FP.world.remove(this);
		}
	}

	override public function update():Void {
		if (!Game.moonrockSet) {
			if ((beam && canBeam) || trigger) {
				Game.freezeObjects = true;
			}
			canBeam = false;
			var vp:Array<Player> = new Array<Player>();
			FP.world.getClass(Player, vp);
			var p:Player = null;
			for (temp_p in vp) {
				p = temp_p;
				if (FP.distance(x + sprMoonrock.width / 2, fallTo + sprMoonrock.height / 2, p.x, p.y) > sprMoonrock.width * 3 / 4) {
					canBeam = true;
				}
			}
			if ((beam && canBeam) || trigger) {
				playersDirection(as3hx.Compat.parseInt(p.x > x + sprMoonrock.width / 2) * 2);
			}
			if (beam && canBeam) {
				Game.cameraTarget = new Point(x - FP.screen.width / 2, fallTo - FP.screen.height / 2);
				if (beamTime > 0) {
					if (beamTime == beamTimeMax) {
						Music.playSound("Light");
					}
					beamTime--;
					if (beamTime <= 0) {
						beamTime = 0;
						beam = false;
						trigger = true;
					}
				} else {
					beam = false;
				}
			}
			if (trigger) {
				y += fallRate;
				if (y >= fallTo) {
					y = fallTo;
					type = "Solid";
					Game.shake = 60;
					Music.playSound("Rock", 0, 2);
					cameraTimer = cameraTimerMax;
					Game.moonrockSet = true;
					trigger = false;
				}
			}
		} else {
			var p = try cast(collide("Player", x, y), Player) catch (e:Dynamic) null;
			if ((p != null) && !p.fallFromCeiling && !p.fallInPit) {
				p.y = y - originY + p.originY - p.height;
			}

			var stairs:Entity = collide("Teleporter", x, y);
			if (Std.is(stairs, Stairs)) {
				FP.world.add(new Teleporter(Std.int(stairs.x), Std.int(stairs.y), 2, 48, 32));
				Game.setPersistence(0, false, 2);
				FP.world.remove(stairs);
			}

			if (cameraTimer > 0) {
				cameraTimer--;
			} else if (cameraTimer == 0) {
				Game.resetCamera();
				Game.freezeObjects = false;
				playersDirection(-1);
				cameraTimer = -1;
			}
		}
		super.update();
		layer = Std.int(-(fallTo - originY + height / 2));
	}

	public function playersDirection(d:Int):Void {
		var vp:Array<Player> = new Array<Player>();
		FP.world.getClass(Player, vp);
		for (p in vp) {
			p.directionFace = d;
		}
	}

	public function removeSelf():Void {
		Game.setPersistence(tag, false);
	}

	override public function render():Void {
		if (!trigger && beam && canBeam) {
			drawFlares();
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			drawFlares();
			Draw.resetTarget();
		}

		sprMoonrock.frame = Game.worldFrame(7);
		super.render();
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		super.render();
		Draw.resetTarget();
	}

	public function drawFlares():Void {
		var m:Int = 2;
		Draw.rect(Std.int(x + sprMoonrock.width / 2 - Tile.w / 2 - m), Std.int(y + sprMoonrock.height / 2 - m), Tile.w, Std.int(fallTo - y + Tile.h / 2),
			0xFFFFFF, 0.5);
		for (i in 0...20) {
			var c:Int = FP.getColorRGB(Std.int(192 + 64 * Math.random()), Std.int(192 + 64 * Math.random()), Std.int(192 * Math.random()));
			var dx:Int = as3hx.Compat.parseInt(Tile.w * 2 * Math.random() - Tile.w); // The distance each beam can be from the center
			var dy:Int = as3hx.Compat.parseInt(Tile.h * 2 * Math.random() - Tile.h);
			var alpha:Float = Math.random() / 2;
			var thick:Float = Math.random() * 3 + 0.5;
			Draw.linePlus(Std.int(x + sprMoonrock.width / 2 + dx - m), Std.int(y + sprMoonrock.height / 2 - m), Std.int(x + sprMoonrock.width / 2 + dx - m),
				Std.int(fallTo + sprMoonrock.height / 2 + dy - m), c, alpha, thick);
		}
	}
}
