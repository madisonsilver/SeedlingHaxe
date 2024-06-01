package enemies;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import net.flashpunk.masks.Pixelmask;
import scenery.Tile;
import puzzlements.Whirlpool;

/**
 * ...
 * @author Time
 */
class TentacleBeast extends Enemy {
private var imgTentacleBeastMask:BitmapData;
private var imgTentacleBeast:BitmapData;
	private var sprTentacleBeast:Spritemap;

	private var sittingFrames(default, never):Array<Dynamic> = [0, 1, 2, 1];
	private var sittingDeadFrames(default, never):Array<Dynamic> = [17, 18, 19, 18];
	private var spawnRect(default, never):Rectangle = new Rectangle(16, 96, 176, 96);
	private var distActivate(default, never):Int = 48;

	private var tentacleMargin(default, never):Rectangle = new Rectangle(8, 0, 8, 4); // 2x2 point specifying left margin, up margin, right margin, down margin
	private var whirlpoolMargin(default, never):Rectangle = new Rectangle(Tile.w, Tile.h, Tile.w, Tile.h);

	public var maxTentacles:Int = 8;
	public var maxWhirlpools:Int = 1;

	private var activated:Bool = false;
	private var dead:Bool = false;

	private var tag:Int;

private function load_image_assets():Void {
imgTentacleBeastMask = Assets.getBitmapData("assets/graphics/TentacleBeastMask.png");
imgTentacleBeast = Assets.getBitmapData("assets/graphics/TentacleBeast.png");
}
	public function new(_x:Int, _y:Int, _tag:Int = -1) {

load_image_assets();
		sprTentacleBeast = new Spritemap(imgTentacleBeast, 46, 44, animEnd);
		super(_x + 24, _y + 24, sprTentacleBeast);
		sprTentacleBeast.add("sink", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 8);
		sprTentacleBeast.add("rise", [11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 8);
		sprTentacleBeast.add("under", [12]);
		sprTentacleBeast.add("dying", [13, 14, 15, 16], 2);
		sprTentacleBeast.centerOO();

		mask = new Pixelmask(imgTentacleBeastMask, -23, -22);
		type = "Solid";

		layer = Std.int(-(y - sprTentacleBeast.originY + 46));

		tag = _tag;

		if (tag >= 0 && !Game.checkPersistence(tag)) {
			sprTentacleBeast.play("");
			dead = true;
			maxTentacles = 0;
			maxWhirlpools = 0;
			activated = true;
			createMouthEntrance();
		} else {
			sprTentacleBeast.play("under");
		}
	}

	override public function check():Void {
		super.check();
		if (dead) {
			sprTentacleBeast.frame = 17;
		}
	}

	override public function update():Void {
		if (Game.freezeObjects) {
			return;
		}

		var player:Player = try cast(FP.world.nearestToEntity("Player", this), Player) catch (e:Dynamic) null;
		if (player != null && !activated && FP.distance(x, y, player.x, player.y) <= distActivate && !player.fallFromCeiling) {
			sprTentacleBeast.play("rise");
			Game.levelMusics[(try cast(FP.world, Game) catch (e:Dynamic) null).level] = Game.bossMusic;
			Music.playSound("Boss Die", 3, 0.2);
			activated = true;
		}
		if (sprTentacleBeast.currentAnim == "rise") {
			Game.shake = 5;
		}
		if (!dead && maxTentacles <= 0) {
			sprTentacleBeast.play("dying");
			Music.playSound("Boss Die", 4, 0.2);
			Game.levelMusics[(try cast(FP.world, Game) catch (e:Dynamic) null).level] = -1;
			dead = true;
			if (Game.checkPersistence(tag)) {
				Main.unlockMedal(Main.badges[7]);
				Game.setPersistence(tag, false);
			}
		}
		if (sprTentacleBeast.currentAnim == "") {
			if (dead) {
				sprTentacleBeast.frame = sittingDeadFrames[Game.worldFrame(sittingFrames.length, 2)];
			} else {
				sprTentacleBeast.frame = sittingFrames[Game.worldFrame(sittingFrames.length)];
			}
		}
		if (activated && !dead) {
			if (sprTentacleBeast.currentAnim == "") {
				var cont:Bool = true;
				var xpos:Int;
				var ypos:Int;
				var cWhirl:Whirlpool;
				var cTent:Tentacle;

				var whirlpoolDist:Int = as3hx.Compat.parseInt(16 + Tile.w * 2); // Radii of both whirlpools, plus the minimum margin in between them
				var vW:Array<Whirlpool> = new Array<Whirlpool>();
				FP.world.getClass(Whirlpool, vW);

				var tentacleDistance:Int = 32;
				var v:Array<Tentacle> = new Array<Tentacle>();
				FP.world.getClass(Tentacle, v);

				var tries:Int = 0;
				var created:Int = 0;
				while (FP.world.classCount(Whirlpool) + created < maxWhirlpools && tries <= 100) {
					xpos = as3hx.Compat.parseInt(Math.random() * (spawnRect.width - whirlpoolMargin.x - whirlpoolMargin.width)
						+ spawnRect.x
						+ whirlpoolMargin.x);
					ypos = as3hx.Compat.parseInt(Math.random() * (spawnRect.height - whirlpoolMargin.y - whirlpoolMargin.height)
						+ spawnRect.y
						+ whirlpoolMargin.y);

					for (cTent in v) {
						if (FP.distance(xpos, ypos, cTent.x, cTent.y) <= whirlpoolDist) {
							cont = false;
							break;
						}
					}
					for (cWhirl in vW) {
						if (FP.distance(xpos, ypos, cWhirl.x, cWhirl.y) <= whirlpoolDist) {
							cont = false;
							break;
						}
					}
					if (cont) {
						FP.world.add(new Whirlpool(xpos - Tile.w, ypos - Tile.h, true));
						created++;
					}
					tries++;
				}
				cont = true;
				if (FP.world.classCount(Tentacle) < maxTentacles) {
					xpos = as3hx.Compat.parseInt(Math.random() * (spawnRect.width - tentacleMargin.x - tentacleMargin.width) + spawnRect.x + tentacleMargin.x);
					ypos = as3hx.Compat.parseInt(Math.random() * (spawnRect.height - tentacleMargin.y - tentacleMargin.height)
						+ spawnRect.y
						+ tentacleMargin.y);

					for (cTent in v) {
						if (FP.distance(xpos, ypos, cTent.x, cTent.y) <= tentacleDistance) {
							cont = false;
							break;
						}
					}
					for (cWhirl in vW) {
						if (FP.distance(xpos, ypos, cWhirl.x, cWhirl.y) <= whirlpoolDist)
							// Tile.w as radii of whirlpool
						{
							{
								cont = false;
								break;
							}
						}
					}
					if (cont) {
						FP.world.add(new Tentacle(xpos, ypos, this, xpos < FP.width / 2));
					}
				}
			}
		}
	}

	public function animEnd():Void {
		var _sw13_ = (sprTentacleBeast.currentAnim);

		switch (_sw13_) {
			case "rise":
				sprTentacleBeast.play("");
			case "dying":
				sprTentacleBeast.play("");
				// Teleporter to the tentacle beast's mouth
				createMouthEntrance();
			default:
		}
	}

	public function createMouthEntrance():Void {
		FP.world.add(new Teleporter(Std.int(x - Tile.w / 2), Std.int(y - Tile.h / 2), 58, 56, 96));
	}
}
