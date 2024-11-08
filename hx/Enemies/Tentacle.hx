package enemies;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class Tentacle extends Enemy {
	private var imgTentacle:BitmapData;
	private var sprTentacle:Spritemap;

	private var right:Bool;
	private var hitRect:Rectangle;
	private var parent:TentacleBeast;

	private var force(default, never):Int = 2;

	private function load_image_assets():Void {
		imgTentacle = Assets.getBitmapData("assets/graphics/Tentacle.png");
	}

	public function new(_x:Int, _y:Int, _parent:TentacleBeast = null, _right:Bool = true) {
		load_image_assets();
		sprTentacle = new Spritemap(imgTentacle, 80, 49, animEnd);
		super(_x, _y, sprTentacle);

		parent = _parent;
		right = _right;

		sprTentacle.originX = 8;
		sprTentacle.originY = 47;
		sprTentacle.x = -sprTentacle.originX;
		sprTentacle.y = -sprTentacle.originY;

		var dAnimSpeed:Int = 10;
		var dSitAnimSpeed:Int = 5;
		sprTentacle.add("rise", [0, 1, 2, 3, 4], dAnimSpeed);
		sprTentacle.add("sit", [5, 6, 5, 6, 5, 6], dSitAnimSpeed);
		sprTentacle.add("hit", [7, 8, 9, 10, 11], dAnimSpeed);
		sprTentacle.add("hitting", [12], dAnimSpeed);
		sprTentacle.add("sink", [13, 14, 15, 16], dAnimSpeed);
		sprTentacle.add("cut", [17, 18, 19, 20], dAnimSpeed);
		sprTentacle.play("rise");

		hitRect = new Rectangle(66 * (!right ? 1 : 0), 6, 66, 8);

		setHitbox(16, 4, 8, 2);

		sprTentacle.scaleX = 2 * (right ? 1 : 0) - 1;
		type = "Enemy";

		hitsMax = 1;

		layer = Std.int(-(y - originY + height));
	}

	override public function update():Void {
		if (Game.freezeObjects) {
			sprTentacle.rate = 0;
			return;
		}
		sprTentacle.rate = 1;

		canHit = sprTentacle.currentAnim == "sit";

		if (sprTentacle.currentAnim == "hitting") {
			var p:Player = try cast(FP.world.collideRect("Player", x - hitRect.x, y - hitRect.y, hitRect.width, hitRect.height), Player) catch (e:Dynamic) null;
			if (p != null) {
				p.hit(this, force, new Point(x, y), damage);
			}
		}
		hitUpdate();
		if (destroy) {
			sprTentacle.play("cut");
			sprTentacle.alpha -= 0.01;
			if (sprTentacle.alpha <= 0) {
				if (parent != null) {
					parent.maxTentacles--;
					parent.maxWhirlpools++;
				}
				FP.world.remove(this);
			}
		}
	}

	override public function knockback(f:Float = 0, p:Point = null):Void {}

	public function animEnd():Void {
		var _sw12_ = (sprTentacle.currentAnim);

		switch (_sw12_) {
			case "rise":
				sprTentacle.play("sit");
			case "sit":
				sprTentacle.play("hit");
			case "hit":
				sprTentacle.play("hitting");
				Music.playSoundDistPlayer(Std.int(x), Std.int(y), "Tentacle");
			case "hitting":
				sprTentacle.play("sink");
			case "sink":
				FP.world.remove(this);
			default:
				sprTentacle.play("cut");
		}
	}

	override public function startDeath(t:String = ""):Void {
		destroy = true;
		dieEffects(t, 24, Std.int(sprTentacle.scaleX * 8), -8);
	}
}
