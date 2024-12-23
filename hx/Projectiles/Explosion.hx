package projectiles;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import enemies.Enemy;
import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class Explosion extends Entity {
	private var imgExplosion:BitmapData;
	private var sprExplosion:Spritemap;

	private var animSpeed(default, never):Int = 20;
	private var force(default, never):Int = 4;
	private var radiusCoeff(default, never):Float = 0.65; // so that the fringes of the explosion image aren't included for collision.

	private var radius:Int = 0;
	private var hitables:Dynamic;
	private var damage:Int = 0;

	private function load_image_assets():Void {
		imgExplosion = Assets.getBitmapData("assets/graphics/Explosion.png");
	}

	public function new(_x:Int, _y:Int, _hit:Dynamic, _r:Int = 16, _d:Int = 1) {
		load_image_assets();
		sprExplosion = new Spritemap(imgExplosion, 128, 128, endAnim);
		super(_x, _y, sprExplosion);
		sprExplosion.add("explode", [0, 1, 2, 3, 4, 5, 6, 7], animSpeed);
		sprExplosion.play("explode");
		sprExplosion.centerOO();

		hitables = _hit;
		radius = _r;
		damage = _d;

		type = "Explosion";
		sprExplosion.scale = radius * 2 / sprExplosion.width; // Assume that the explosion sprite is circular.
		sprExplosion.angle = Math.random() * 360;
		radius = Std.int(radius*radiusCoeff); // radius now represents the hitable area of the explosion.

		layer = -FP.height;
	}

	override public function added():Void {
		super.added();
		Music.playSoundDistPlayer(Std.int(x), Std.int(y), "Explosion", -1, 120);
		var v:Array<Entity> = new Array<Entity>();
		for (i in 0...hitables.length) {
			FP.world.collideRectInto(hitables[i], x - radius, y - radius, radius * 2, radius * 2, v);
		}
		for (c in v) {
			if (FP.distance(x, y, c.x, c.y) <= radius) {
				if (Std.isOfType(c, Player)) {
					(try cast(c, Player) catch (e:Dynamic) null).hit(null, force, new Point(x, y), damage);
				} else if (Std.isOfType(c, Enemy)) {
					(try cast(c, Enemy) catch (e:Dynamic) null).hit(force, new Point(x, y), damage);
				}
			}
		}
	}

	override public function update():Void {
		super.update();
	}

	override public function render():Void {
		super.render();
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		super.render();
		Draw.resetTarget();
	}

	public function endAnim():Void {
		FP.world.remove(this);
	}
}
