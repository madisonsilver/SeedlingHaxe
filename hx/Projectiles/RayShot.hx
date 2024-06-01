package projectiles;
import openfl.utils.Assets;import openfl.display.BitmapData;

import enemies.Enemy;
import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import puzzlements.MagicalLock;
import scenery.Tile;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class RayShot extends Mobile {
private var imgRayShot:BitmapData;
	private var sprRayShot:Spritemap;

	private var force(default, never):Int = 3; // The knockback when hitting enemies
	private var damage:Float = 100;

private function load_image_assets():Void {
imgRayShot = Assets.getBitmapData("assets/graphics/DeathRayShot.png");
}
	public function new(_x:Int, _y:Int, _v:Point) {

load_image_assets();
		sprRayShot = new Spritemap(imgRayShot, 8, 3, animEnd);
		super(_x, _y, sprRayShot);
		sprRayShot.centerOO();
		sprRayShot.add("flare", [0, 1], 15);
		sprRayShot.play("flare");

		setHitbox(3, 3, 2, 2);
		type = "Projectile";

		v = _v;
		sprRayShot.angle = -Math.atan2(v.y, v.x) * 180 / Math.PI;
		f = 0;
		solids.push("Enemy");
	}

	public function animEnd():Void {
		destroy = true;
	}

	override public function update():Void {
		var margin:Int = 160; // The distance outside of the camera view for which the wandshot will survive
		if (x < FP.camera.x - margin
			|| x > FP.camera.x + FP.screen.width + margin
			|| y < FP.camera.y - margin
			|| y > FP.camera.y + FP.screen.height + margin) {
			destroy = true;
		}
		var hitX:Entity = moveX(v.x);
		var hitY:Entity = moveY(v.y);
		if (hitX != null) {
			checkEntity(hitX);
		} else if (hitY != null) {
			checkEntity(hitY);
		}
		layering();
		death();
	}

	override public function render():Void {
		super.render();
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		super.render();
		Draw.resetTarget();
	}

	public function checkEntity(_e:Entity):Void {
		if (Std.is(_e, Enemy)) {
			(try cast(_e, Enemy) catch (e:Dynamic) null).hit(force, new Point(x, y), damage);
		} else if (Std.is(_e, MagicalLock)) {
			(try cast(_e, MagicalLock) catch (e:Dynamic) null).hit(100);
		}
		destroy = true;
	}
}
