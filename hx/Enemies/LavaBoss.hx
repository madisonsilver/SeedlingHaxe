package enemies;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import openfl.display.BlendMode;
import projectiles.LavaBall;
import scenery.Tile;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class LavaBoss extends Enemy {
	private var imgLavaBoss:BitmapData;
	private var sprLavaBoss:Spritemap;

	private var shotSpeed(default, never):Int = 1;
	private var tag:Int;
	private var lastHitType:String = "";
	private var startAttacking:Bool = false;

	private function load_image_assets():Void {
		imgLavaBoss = Assets.getBitmapData("assets/graphics/LavaBoss.png");
	}

	public function new(_x:Int, _y:Int, _tag:Int = -1) {
		load_image_assets();
		sprLavaBoss = new Spritemap(imgLavaBoss, 160, 82, endAnim);
		super(_x + 48, _y + 40, sprLavaBoss);
		sprLavaBoss.centerOO();
		sprLavaBoss.add("sit", [0, 1, 2, 3, 4], 8);
		sprLavaBoss.add("smash", [5, 6, 7, 8, 9], 10);
		sprLavaBoss.add("smashback", [10, 11, 12, 6, 5], 10);
		sprLavaBoss.add("armsup", [6, 7, 13, 14, 14, 14, 14], 10);
		sprLavaBoss.add("sweep", [13, 15, 16], 10);
		sprLavaBoss.add("sweepback", [17, 16, 15, 6, 5], 10);
		sprLavaBoss.add("hit", [18, 19], hitsTimerInt);
		sprLavaBoss.add("hitplayer", [20], hitsTimerInt);
		sprLavaBoss.add("die", [21, 22, 23, 24, 25, 26, 27], 5);
		sprLavaBoss.add("dead", [27]);

		sprLavaBoss.play("sit");

		tag = _tag;
		layer = Std.int(-(y - sprLavaBoss.originY + sprLavaBoss.height));

		type = "LavaBoss";

		setHitbox(64, 58, 32, 29);

		activeOffScreen = true;
		dieInLava = false;

		hitsTimerMax = 120;

		(try cast(FP.world, Game) catch (e:Dynamic) null).playerPosition = new Point(152, 176);

		hitSoundIndex = 1; // Big hit sound
		dieSoundIndex = 1;
	}

	override public function check():Void {
		super.check();
		if (tag >= 0 && !Game.checkPersistence(tag)) {
			FP.world.remove(this);
		}
	}

	override public function removed():Void {
		Game.resetCamera();
	}

	override public function update():Void {
		sprLavaBoss.active = !Game.freezeObjects && startAttacking;
		if (!Game.freezeObjects && !destroy) {
			if (startAttacking) {
				super.update();
				if (hitsTimer > 0) {
					if (lastHitType == "LavaBall") {
						sprLavaBoss.play("hit");
					} else {
						sprLavaBoss.play("hitplayer");
					}
				} else if (sprLavaBoss.currentAnim == "hit" || sprLavaBoss.currentAnim == "hitplayer") {
					sprLavaBoss.play("sit");
				}
			}
			var p:Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch (e:Dynamic) null;
			if (p != null
				&& !p.fallFromCeiling
				&& (Math.abs(y - p.y) <= FP.screen.height * 3 / 4 && Math.abs(x - p.x) <= FP.screen.width * 3 / 4)) {
				Game.cameraTarget = new Point((x + p.x) / 2 - FP.screen.width / 2, (y + p.y) / 2 - FP.screen.height / 2);
				if (!startAttacking) {
					startAttacking = true;
					Game.levelMusics[(try cast(FP.world, Game) catch (e:Dynamic) null).level] = Game.bossMusic;
				}
			} else {
				Game.resetCamera();
			}
		}
	}

	override public function knockback(f:Float = 0, p:Point = null):Void {}

	override public function layering():Void {}

	override public function hitPlayer():Void {}

	override public function startDeath(t:String = ""):Void {
		destroy = true;
		sprLavaBoss.play("die");
		sprLavaBoss.color = 0xFFFFFF;
		if (Game.checkPersistence(tag)) {
			Game.setPersistence(tag, false);
			Main.unlockMedal(Main.badges[11]);
		}
		Game.levelMusics[(try cast(FP.world, Game) catch (e:Dynamic) null).level] = -1;
	}

	override public function hit(f:Float = 0, p:Point = null, d:Float = 1, t:String = ""):Void {
		if (((hitsTimer <= 0 && t == "LavaBall") || hitByDarkStuff || (t != "LavaBall" && lastHitType == "LavaBall" && hitsTimer > 0))
			&& !Game.freezeObjects
			&& canHit) {
			if (hitByFire || t != "Fire") {
				if (hits < hitsMax) {
					if (t != "LavaBall") {
						hits += 1;
					}
					hitsTimer = hitsTimerMax;
					hitByDarkStuff = (t == "Shield" || t == "Suit");
					if (hits >= hitsMax) {
						startDeath();
					} else {
						knockback(f, p);
					}
				}
			}
			// hitsTimer = hitsTimerMax;
			else {
				knockback(f, p);
			}
		}
		lastHitType = t;
	}

	override public function render():Void {
		super.render();

		if (sprLavaBoss.currentAnim == "armsup" || sprLavaBoss.currentAnim == "sweep") {
			var n:Float = 0.2;
			sprLavaBoss.scale = 1 + Math.random() * n - n;
		}
		if (!destroy) {
			sprLavaBoss.alpha = 0.8;
		} else if (sprLavaBoss.currentAnim == "dead") {
			sprLavaBoss.alpha -= 0.01;
			if (sprLavaBoss.alpha <= 0) {
				FP.world.remove(this);
			}
		}
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).solidBmp, FP.camera);
		super.render();
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		super.render();
		Draw.resetTarget();

		if (!destroy) {
			sprLavaBoss.scale = 1;
			sprLavaBoss.alpha = 1;
		}
	}

	public function endAnim():Void {
		var _sw6_ = (sprLavaBoss.currentAnim);

		switch (_sw6_) {
			case "sit":
				sprLavaBoss.play("smash");
			case "smash":
				sprLavaBoss.play("smashback");
				Music.playSound("Lava", 0);

				var xpos:Dynamic = [-34, 34];
				var ypos:Dynamic = [32, 32];
				for (i in 0...xpos.length)
					// This area covered must be >= the area covered by the hitbox of the lava runner,
				{
					// or else they will stick on top of one another.
					if (FP.world.collideRect("Enemy", x + Reflect.field(xpos, Std.string(i)) - Tile.w / 2,
						y + Reflect.field(ypos, Std.string(i)) - Tile.h / 2, Tile.w, Tile.h) == null) {
						var lr:LavaRunner;
						FP.world.add(lr = new LavaRunner(Std.int(x + Reflect.field(xpos, Std.string(i)) - Tile.w / 2),
							Std.int(y + Reflect.field(ypos, Std.string(i)) - Tile.h / 2)));
						lr.runRange = 1000;
						lr.activeOffScreen = true;
						lr.jump(!cast(i, Bool));
					}
				}
			case "smashback":
				sprLavaBoss.play("armsup");
			case "armsup":
				sprLavaBoss.play("sweep");
			case "sweep":
				sprLavaBoss.play("sweepback");
				Game.shake = 15;
				Music.playSound("Lava", 1);

				var numLavaBalls:Int = 5;
				var angle:Float = Math.PI;
				for (i in 0...numLavaBalls) {
					var ang:Float = -angle / 2 + i / (numLavaBalls - 1) * angle + Math.PI / 2;
					FP.world.add(new LavaBall(Std.int(x), Std.int(y + 32), new Point(shotSpeed * Math.cos(ang), shotSpeed * Math.sin(ang))));
				}
			case "hit":
				sprLavaBoss.play("sit");
			case "die":
				sprLavaBoss.play("dead");
			case "dead":
			default:
				sprLavaBoss.play("sit");
		}
		if (sprLavaBoss.currentAnim == "die") {
			destroy = true;
		}
	}
}
