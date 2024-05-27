package enemies;

import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class Cactus extends Enemy {
	@:meta(Embed(source = "../../assets/graphics/Cactus.png"))
	private var imgCactus:Class<Dynamic>;
	private var sprCactus:Spritemap = new Spritemap(imgCactus, 8, 8, endAnim);

	private var chompAnimSpeed(default, never):Int = 10;
	private var chompRange(default, never):Int = 20; // The distance at which the cactus will start chomping from a player

	public function new(_x:Int, _y:Int) {
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprCactus);
		sprCactus.centerOO();
		sprCactus.add("sit", [0]);
		sprCactus.add("chomp", [0, 1], chompAnimSpeed, true);
		sprCactus.add("hit", [1]);
		sprCactus.play("sit");

		setHitbox(6, 6, 3, 3);
	}

	override public function update():Void {
		super.update();
		var player:Player = try cast(FP.world.nearestToEntity("Player", this), Player) catch (e:Dynamic) null;
		if (player != null) {
			var d:Int = Std.int(FP.distance(x, y, player.x, player.y));
			if (d <= chompRange) {
				sprCactus.play("chomp");
			}
		}

		if (hitsTimer <= 0 && collide("Player", x, y) != null) {
			if (sprCactus.frame == 1)
				// The closed frame
			{
				{
					// Hit the player
				}
			} else {
				hit();
			}
		}
	}

	public function endAnim():Void {
		sprCactus.play("sit");
	}
}
