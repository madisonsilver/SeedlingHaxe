package projectiles;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import enemies.Enemy;
import enemies.LavaBoss;
import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class LavaBall extends Mobile {
	private var imgLavaBall:BitmapData;
	private var sprLavaBall:Spritemap;

	public var hitables:Dynamic = ["Player", "Tree", "Solid", "Shield"];

	private var sc(default, never):Float = 0.5;
	private var beenHit:Bool = false;

	private function load_image_assets():Void {
		imgLavaBall = Assets.getBitmapData("assets/graphics/LavaBall.png");
	}

	public function new(_x:Int, _y:Int, _v:Point) {
		load_image_assets();
		sprLavaBall = new Spritemap(imgLavaBall, 48, 32);
		super(_x, _y, sprLavaBall);
		sprLavaBall.scale = sc;
		sprLavaBall.originX = 32;
		sprLavaBall.x = -sprLavaBall.originX;
		sprLavaBall.originY = 16;
		sprLavaBall.y = -sprLavaBall.originY;
		sprLavaBall.add("fly", [0, 1, 2], 10);
		sprLavaBall.play("fly");
		v = _v;
		f = 0;
		setHitbox(Std.int(24 * sc), Std.int(24 * sc), Std.int(12 * sc), Std.int(12 * sc));
		type = "LavaBall";
		solids = [];
		if (v.length > 0) {
			sprLavaBall.angle = Math.atan2(-v.y, v.x) * 180 / Math.PI;
		}
	}

	public function hit():Void {
		if (!beenHit) {
			beenHit = true;
			v.x = -v.x * 2;
			v.y = -v.y * 2;
			hitables.push("LavaBoss");
		}
	}

	override public function update():Void {
		super.update();
		if (v.length > 0) {
			imageAngle();
			var hits:Array<Entity> = new Array<Entity>();
			collideTypesInto(hitables, x, y, hits);
			for (i in 0...hits.length) {
				var _sw3_ = (hits[i].type);

				switch (_sw3_) {
					case "Player":
						(try cast(hits[i], Player) catch (e:Dynamic) null).hit(null, v.length, new Point(x, y));
					case "Enemy":
						(try cast(hits[i], Enemy) catch (e:Dynamic) null).hit(v.length, new Point(x, y));
					case "LavaBoss":
						(try cast(hits[i], LavaBoss) catch (e:Dynamic) null).hit(0, new Point(), 1, "LavaBall");
					default:
				}
			}
			if (hits.length > 0) {
				FP.world.add(new Explosion(Std.int(x + v.x), Std.int(y + v.y), hitables, Std.int(32 * sc), 1));
				FP.world.remove(this);
			}
		}
		if (!onScreen((try cast(graphic, Spritemap) catch (e:Dynamic) null).width)) {
			FP.world.remove(this);
		}
	}

	public function imageAngle():Void {
		(try cast(graphic, Image) catch (e:Dynamic) null).angle = Math.atan2(-v.y, v.x) * 180 / Math.PI;
	}

	override public function render():Void {
		super.render();
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		super.render();
		Draw.resetTarget();
	}
}
