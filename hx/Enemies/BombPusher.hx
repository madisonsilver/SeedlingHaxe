package enemies;

import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Draw;
import net.flashpunk.FP;
import projectiles.Bomb;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class BombPusher extends Enemy {
	@:meta(Embed(source = "../../assets/graphics/BombPusher.png"))
	private var imgBombPusher:Class<Dynamic>;
	private var sprBombPusher:Spritemap ;

	private var sitAnimation(default, never):Array<Dynamic> = [0, 3];
	private var shootAnimation(default, never):Array<Dynamic> = [0, 2, 1, 2, 3];
	private var shotTimeMax(default, never):Int = 15;
	private var shotTime:Int = 0;
	private var maxDistance(default, never):Int = 256;

	public function new(_x:Int, _y:Int) {
sprBombPusher =  new Spritemap(imgBombPusher, 48, 48, endAnim);
		super(Std.int(_x + Tile.w * 3 / 2), Std.int(_y + Tile.h * 3 / 2), sprBombPusher);
		sprBombPusher.centerOO();
		setHitbox(48, 48, 24, 24);
		sprBombPusher.add("shoot", shootAnimation, 5);
		sprBombPusher.add("sit", sitAnimation, 2);
		type = "Solid";
		layer = Std.int(-(y - originY + height));

		activeOffScreen = true;
	}

	override public function update():Void {
		var p:Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch (e:Dynamic) null;
		if (shotTime > 0) {
			shotTime--;
		} else if (shotTime == 0 && p != null && FP.distance(x, y, p.x, p.y) <= maxDistance) {
			shotTime = -1;
			sprBombPusher.play("shoot");
		}
		super.update();
	}

	public function endAnim():Void {
		if (sprBombPusher.currentAnim == "shoot") {
			shotTime = shotTimeMax;
			var p:Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch (e:Dynamic) null;
			if (p != null) {
				FP.world.add(new Bomb(Std.int(x), Std.int(y), new Point(p.x, p.y)));
			}
			sprBombPusher.play("sit");
		}
	}

	override public function knockback(f:Float = 0, p:Point = null):Void {}

	override public function hit(f:Float = 0, p:Point = null, d:Float = 1, t:String = ""):Void {}
}
