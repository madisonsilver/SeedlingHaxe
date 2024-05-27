package enemies;

import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.SlashHit;
import scenery.Tile;
import pickups.Coin;

/**
 * ...
 * @author Time
 */
class Drill extends Enemy {
	@:meta(Embed(source = "../../assets/graphics/Drill.png"))
	private var imgDrill:Class<Dynamic>;
	private var sprDrill:Spritemap = new Spritemap(imgDrill, 16, 16, endAnim);

	private var runRange(default, never):Int = 48; // Range at which the Drill will move after the character
	private var drillAnimSpeed(default, never):Int = 20;

	public function new(_x:Int, _y:Int) {
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprDrill);

		sprDrill.centerOO();
		sprDrill.add("sit", [0]); // doesn't matter the frame--turns invisible when sitting.
		sprDrill.add("drill", [0, 1, 2, 3, 4], drillAnimSpeed, false);
		sprDrill.add("undrill", [3, 2, 1, 0], drillAnimSpeed, false);
		sprDrill.add("die", [5, 6, 7, 8, 9, 10], 10, false);
		sprDrill.add("hit", [3, 4], 20, true);

		sprDrill.play("sit");
		sprDrill.visible = false;

		solids.push("Enemy");

		setHitbox(10, 10, 5, 5);

		hitSound = "Metal Hit";
	}

	override public function removed():Void { // if(!fell) dropCoins();
	}

	override public function knockback(f:Float = 0, p:Point = null):Void {}

	override public function update():Void {
		if (Game.freezeObjects) {
			return;
		}
		super.update();
		if (destroy || (try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "die") {
			return;
		}

		if (hitsTimer > 0) {
			sprDrill.play("hit");
		} else {
			if (sprDrill.currentAnim == "hit") {
				sprDrill.play("undrill");
			}

			if (sprDrill.currentAnim == "sit") {
				sprDrill.visible = false;
			} else {
				sprDrill.visible = true;
			}

			var player:Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch (e:Dynamic) null;
			if (player != null) {
				var d:Float = FP.distance(x, y, player.x, player.y);
				if (sprDrill.currentAnim == "sit"
					&& d <= runRange
					&& FP.world.collideLine("Solid", Std.int(x), Std.int(y), Std.int(player.x), Std.int(player.y)) == null) {
					var tox:Int = Std.int(x);
					var toy:Int = Std.int(y);
					if (Math.abs(player.x - x) > Tile.w / 2) {
						tox += as3hx.Compat.parseInt((2 * as3hx.Compat.parseInt(player.x > x) - 1) * Tile.w);
					}
					if (Math.abs(player.y - y) > Tile.h / 2) {
						toy += as3hx.Compat.parseInt((2 * as3hx.Compat.parseInt(player.y > y) - 1) * Tile.h);
					}
					if (tox != x && collideTypes(solids, tox, y) == null) {
						x = tox;
						sprDrill.play("drill");
						Music.playSound("Drill", 0.6);
					}
					if (toy != y && collideTypes(solids, x, toy) == null) {
						y = toy;
						sprDrill.play("drill");
						Music.playSound("Drill", 0.6);
					}
				}
			}
		}
	}

	override public function startDeath(t:String = ""):Void {
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("die");
		dieEffects(t);
	}

	public function endAnim():Void {
		var _sw2_ = (sprDrill.currentAnim);

		switch (_sw2_) {
			case "drill":
				sprDrill.play("undrill");
			case "undrill":
				sprDrill.play("sit");
			case "hit":
				sprDrill.play("hit");
			case "die":
				destroy = true;
				sprDrill.play("");
				sprDrill.frame = sprDrill.frameCount - 1;
			default:
				sprDrill.play("sit");
		}
	}
}
