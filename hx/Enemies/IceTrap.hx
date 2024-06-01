package enemies;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class IceTrap extends Enemy {
private var imgIceTrap:BitmapData;
	private var sprIceTrap:Spritemap;

	private var chompAnimSpeed(default, never):Int = 10;
	private var chompRange(default, never):Int = 8; // The distance at which the ice trap will start chomping from a player

private function load_image_assets():Void {
imgIceTrap = Assets.getBitmapData("assets/graphics/IceTrap.png");
}
	public function new(_x:Int, _y:Int) {

load_image_assets();
		sprIceTrap = new Spritemap(imgIceTrap, 16, 16, endAnim);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprIceTrap);

		sprIceTrap.centerOO();
		// the animation "" will reset it to the world frame speed
		sprIceTrap.add("chomp", [0, 1, 2, 1], chompAnimSpeed);
		sprIceTrap.add("hit", [1]);

		setHitbox(16, 16, 8, 8);

		layer = Std.int(-(y - originY + height * 4 / 5));

		canHit = false;
	}

	override public function update():Void {
		super.update();
		var player:Player = try cast(FP.world.nearestToEntity("Player", this), Player) catch (e:Dynamic) null;
		if (player != null) {
			var d:Int = Std.int(FP.distance(x, y, player.x, player.y));
			if (d <= chompRange && (try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim != "chomp") {
				Music.playSoundDistPlayer(Std.int(x), Std.int(y), "Enemy Attack", 3);
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("chomp");
			}
		}
		if (sprIceTrap.currentAnim == "") {
			sprIceTrap.frame = Game.worldFrame(2);
		}
	}

	override public function layering():Void {}

	override public function knockback(f:Float = 0, p:Point = null):Void {}

	override public function death():Void {
		if (destroy) {
			super.death();
		}
	}

	public function endAnim():Void {
		sprIceTrap.play("");
	}
}
