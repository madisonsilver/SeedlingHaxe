package enemies;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Light;
import scenery.Tile;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class Grenade extends Enemy {
	@:meta(Embed(source = "../../assets/graphics/Grenade.png"))
	private var imgGrenade:Class<Dynamic>;
	private var sprGrenade:Spritemap = new Spritemap(imgGrenade, 16, 16, animEnd);

	private var hitRadius(default, never):Int = 20;
	private var fallHeight(default, never):Int = 48;
	private var fallTriggerDistance(default, never):Int = 32;
	private var g(default, never):Float = 0.1;
	private var force(default, never):Int = 2;
	private var hitFrames(default, never):Array<Dynamic> = [5, 6, 7];

	private var explodeTime:Int;
	private var myLight:Light;
	private var startY:Int;
	private var endY:Int;
	private var activated:Bool;

	public function new(_x:Int, _y:Int, _active:Bool = false, _exTime:Int = 60) {
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2 - fallHeight), sprGrenade);
		endY = as3hx.Compat.parseInt(_y + Tile.h / 2);
		startY = Std.int(y);

		hitsMax = 1;

		setHitbox(6, 6, 3, 3);
		type = "Enemy";

		sprGrenade.centerOO();
		sprGrenade.add("explode", [0, 1, 0, 2, 0, 3, 4, 3], 12);
		sprGrenade.add("hit", hitFrames, 12);
		sprGrenade.add("sit", [0, 4], 5);
		sprGrenade.play("sit");

		f = 0;
		damage = 1;

		activated = _active;
		if (activated) {
			y = endY;
		}

		explodeTime = _exTime;
	}

	override public function removed():Void {
		super.removed();
		if (myLight != null) {
			FP.world.remove(myLight);
		}
	}

	override public function hit(f:Float = 0, p:Point = null, d:Float = 1, t:String = ""):Void {}

	override public function update():Void {
		var p:Player = try cast(FP.world.nearestToPoint("Player", x, endY), Player) catch (e:Dynamic) null;
		if (y >= endY) {
			collidable = true;
			if (v.y > 0) {
				v.y = -v.y + 1;
			} else {
				v.y = 0;
				if (explodeTime > 0) {
					explodeTime--;
				} else if (explodeTime == 0) {
					explodeTime = -1;
					sprGrenade.play("explode");
				}
			}
			if (myLight != null && sprGrenade.currentAnim == "hit") {
				myLight.alpha = 1 - sprGrenade.index / (hitFrames.length - 1);
			}
			mobileUpdate();
		} else if (p != null && FP.distance(x, endY, p.x, p.y) <= fallTriggerDistance) {
			activated = true;
		}

		if (y < endY && activated) {
			collidable = false;
			v.y += g;
			mobileUpdate();
		}
	}

	override public function render():Void {
		sprGrenade.alpha = (y - startY) / (endY - startY);
		super.render();
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		sprGrenade.alpha *= 0.5;
		super.render();
		Draw.resetTarget();
	}

	public function animEnd():Void {
		var p:Player = try cast(FP.world.nearestToPoint("Player", x, endY), Player) catch (e:Dynamic) null;
		var _sw4_ = (sprGrenade.currentAnim);

		switch (_sw4_) {
			case "explode":
				if (p != null && FP.distance(x, endY, p.x, p.y) <= hitRadius) {
					p.hit(null, force, new Point(x, endY), damage);
				}
				Music.playSoundDistPlayer(Std.int(x), Std.int(y), "Explosion", -1, 120);
				FP.world.add(myLight = new Light(Std.int(x), endY, 2, 1, 0xFFFF00, false, hitRadius, hitRadius, 1));
				sprGrenade.play("hit");
			case "hit":
				FP.world.remove(this);
			default:
		}
	}

	override public function knockback(f:Float = 0, p:Point = null):Void {}
}
