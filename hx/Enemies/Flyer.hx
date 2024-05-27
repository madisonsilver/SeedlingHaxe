package enemies;

import openfl.geom.Point;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;
import scenery.Tile;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class Flyer extends Bob {
	@:meta(Embed(source = "../../assets/graphics/Flyer.png"))
	private var imgFlyer:Class<Dynamic>;
	private var sprFlyer:Spritemap = new Spritemap(imgFlyer, 18, 26, endAnim);

	private static inline var normalSpeed:Float = 1;
	private static inline var animSpeed:Int = 15;
	private static inline var dropForce:Int = 1;
	private static inline var droppedFrame:Int = 10; // The frame at which the flyer is on the ground (when to hit the player)

	public function new(_x:Int, _y:Int) {
		super(_x, _y, sprFlyer);

		sitFrames = [0, 1, 2, 3];
		sitLoops = 0.5;
		targetOffset = new Point(0, -10);

		sprFlyer.centerOO();
		sprFlyer.add("walk", [0, 1, 2, 3], animSpeed);
		sprFlyer.add("fall", [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22], 2 * animSpeed);
		sprFlyer.add("die", [23, 24, 25, 26], 10);
		sprFlyer.play("");
		setHitbox(10, 8, 5, 12);

		dieInLava = false;
		dieInWater = false;
		canFallInPit = false;

		moveSpeed = normalSpeed;
		hitsMax = 3;
		damage = 2;

		solids = [];
	}

	override public function update():Void {
		if (Game.freezeObjects) {
			return;
		}
		if (destroy || (try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "die") {
			super.update();
			return;
		}

		var p:Player = try cast(FP.world.collidePoint("Player", x - targetOffset.x, y - targetOffset.y), Player) catch (e:Dynamic) null;
		if (p != null) {
			sprFlyer.play("fall");
		}
		if (sprFlyer.currentAnim == "fall" && !destroy) {
			v.x = v.y = 0;
			if (p != null && sprFlyer.frame == droppedFrame) {
				p.hit(null, dropForce, new Point(x, y), damage);
			}
			hitUpdate();
		} else {
			super.update();
		}
	}

	override public function layering():Void {
		layer = Std.int(-(y - targetOffset.y));
	}

	override public function hitPlayer():Void {}
}
