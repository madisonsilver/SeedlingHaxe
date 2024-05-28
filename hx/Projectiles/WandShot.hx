package projectiles;

import enemies.Enemy;
import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import puzzlements.MagicalLock;
import scenery.Tile;
import net.flashpunk.utils.Draw;
import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class WandShot extends Mobile {
	@:meta(Embed(source = "../../assets/graphics/WandShot.png"))
	private var imgWandShot:Class<Dynamic>;
	private var sprWandShot:Spritemap ;
	@:meta(Embed(source = "../../assets/graphics/FireWandShot.png"))
	private var imgFireWandShot:Class<Dynamic>;
	private var sprFireWandShot:Spritemap ;

	private var tilesMove(default, never):Int = 3; // The number of tiles that the shot will travel in a given direction.
	private var force(default, never):Int = 3; // The knockback when hitting enemies

	private var lifeMax:Int = 0; // The length of time that the shot lives for
	private var life:Int = 0;

	private var damage:Float = 0.5;

	private var shotType:Int = 0;

	private var fireVolume(default, never):Float = 0.6;
	private var fizzleVolume(default, never):Float = 0.3;

	public function new(_x:Int, _y:Int, _v:Point, _fire:Bool = false) {
sprWandShot =  new Spritemap(imgWandShot, 7, 7, animEnd);
sprFireWandShot =  new Spritemap(imgFireWandShot, 9, 9, animEnd);
		super(_x, _y, sprWandShot);
		sprWandShot.centerOO();
		sprWandShot.add("flare", [0, 1, 2], 5);
		sprWandShot.add("die", [3, 4, 5], 20);
		sprWandShot.play("flare");
		sprFireWandShot.centerOO();
		sprFireWandShot.add("flare", [0, 1, 2], 5);
		sprFireWandShot.add("die", [3, 4, 5], 20);
		sprFireWandShot.play("flare");

		type = "Projectile";

		v = _v;
		f = 0;

		if (_fire) {
			graphic = sprFireWandShot;
			setHitbox(5, 5, 2, 2);
			damage = 1;
			shotType = 1;
		} else {
			setHitbox(3, 3, 2, 2);
		}

		// Only works in the four cardinal directions correctly (if Tile.w == Tile.h)
		lifeMax = as3hx.Compat.parseInt(tilesMove * Tile.w / v.length);
		life = lifeMax;

		solids.push("Enemy");

		Music.playSound("Wand Fire", -1, fireVolume);
	}

	public function animEnd():Void {
		if ((try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "die") {
			destroy = true;
		}
	}

	override public function update():Void {
		if ((try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim != "die") {
			life--;
			if (life <= 0) {
				Music.playSound("Wand Fizzle", -1, fizzleVolume);
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("die");
			}
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
		}
		death();
	}

	public function checkEntity(_e:Entity):Void {
		if (Std.is(_e, Enemy)) {
			(try cast(_e, Enemy) catch (e:Dynamic) null).hit(force, new Point(x, y), damage, "Wand");
		} else if (Std.is(_e, MagicalLock)) {
			(try cast(_e, MagicalLock) catch (e:Dynamic) null).hit(shotType);
		}
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("die");
		Music.playSound("Wand Fizzle", -1, fizzleVolume);
	}

	override public function render():Void {
		super.render();
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		super.render();
		Draw.resetTarget();
	}
}
