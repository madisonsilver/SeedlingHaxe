package enemies;

import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;
import pickups.Coin;

/**
 * ...
 * @author Time
 */
class Jellyfish extends Enemy {
	@:meta(Embed(source = "../../assets/graphics/Jellyfish.png"))
	private var imgJelly:Class<Dynamic>;
	private var sprJelly:Spritemap = new Spritemap(imgJelly, 14, 15, endAnim);

	public var moveSpeedNormal(default, never):Float = 0.8;
	public var moveSpeed:Float = moveSpeedNormal;

	private var walkAnimSpeed(default, never):Int = 15;
	private var walkFrames(default, never):Array<Dynamic> = [0, 1, 2, 3, 2, 1];
	private var dieFrames(default, never):Array<Dynamic> = [4, 5, 6, 7, 8, 9, 10, 11];
	private var runRange(default, never):Int = 160; // Range at which the Jellyfish will run after the character

	public function new(_x:Int, _y:Int) {
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprJelly);

		sprJelly.centerOO();
		sprJelly.add("walk", walkFrames, walkAnimSpeed, false);
		sprJelly.add("die", dieFrames, 7, false);
		dieInWater = false;
		dieInLava = false;
		setHitbox(12, 12, 6, 6);

		solids.push("Enemy");

		canFallInPit = false;
	}

	override public function removed():Void { // if(!fell) dropCoins();
	}

	override public function update():Void {
		super.update();
		if (destroy || (try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "die") {
			return;
		}

		moveSpeed = moveSpeedNormal; // * (1 + hits / hitsMax);
		var player:Player = try cast(FP.world.nearestToEntity("Player", this), Player) catch (e:Dynamic) null;
		if (player != null) {
			var d:Float = FP.distance(x, y, player.x, player.y);
			if (d <= runRange)
				// && !FP.world.collideLine("Solid", x, y, player.x, player.y))
			{
				{
					var a:Float = Math.atan2(player.y - y, player.x - x);
					var toV:Point = new Point(moveSpeed * Math.cos(a), moveSpeed * Math.sin(a));
					var pushed:Bool = v.length > moveSpeed; // If we're already moving faster than we should...
					v.x += FP.sign(toV.x - v.x) * moveSpeed;
					v.y += FP.sign(toV.y - v.y) * moveSpeed;
					if (!pushed && v.length > moveSpeed) {
						v.normalize(moveSpeed);
					}
					sprJelly.play("walk");
				}
			}
		}

		if (sprJelly.currentAnim == "") {
			sprJelly.frame = walkFrames[Game.worldFrame(walkFrames.length)];
		}
	}

	override public function startDeath(t:String = ""):Void {
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("die");
		dieEffects(t);
	}

	public function endAnim():Void {
		if ((try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "die") {
			destroy = true;
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("");
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).frame = (try cast(graphic, Spritemap) catch (e:Dynamic) null).frameCount - 1;
		} else {
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("");
		}
	}
}
