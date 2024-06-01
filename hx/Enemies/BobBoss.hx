package enemies;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.geom.Point;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import nPCs.BobBossNPC;
import pickups.Fire;
import scenery.Tile;
import net.flashpunk.Entity;

/**
 * ...
 * @author Time
 */
class BobBoss extends BobSoldier {
	private static var imgBobBoss1:BitmapData;
	private static var imgBobBoss2:BitmapData;
	private static var imgBobBoss3:BitmapData;
	private static var images:Array<Dynamic> = [imgBobBoss1, imgBobBoss2, imgBobBoss3];

	private var imgBobBossWeapons:BitmapData;
	private var sprBobBossWeapons:Spritemap;

	private var bossType:Int;

	private var nextBossTimerMax(default, never):Int = 120;
	private var nextBossTimer:Int; // The time between bosses.

	private var formingTimerMax(default, never):Int = 60;
	private var formingTimer:Int; // The time after creation that this boss does its animation before beginning its actions.

	private var text(default, never):Array<Dynamic> = [
		"..., ...?~...~...!",
		"...never...~ages...~...seen...~...odd.~...for...minutes?~seconds...hours...~mine!",
		"Time is stasis.~You bring much conflict.~Is it my place to resist?~Seems I must."
	];

	private override function load_image_assets():Void {
		imgBobBoss1 = Assets.getBitmapData("assets/graphics/BobBoss1.png");
		imgBobBoss2 = Assets.getBitmapData("assets/graphics/BobBoss2.png");
		imgBobBoss3 = Assets.getBitmapData("assets/graphics/BobBoss3.png");
		imgBobBossWeapons = Assets.getBitmapData("assets/graphics/BobBossWeapons.png");
	}

	public function new(_x:Int, _y:Int, _st:Int = 0) {
		load_image_assets();
		sprBobBossWeapons = new Spritemap(imgBobBossWeapons, 24, 5);
		nextBossTimer = nextBossTimerMax;
		formingTimer = formingTimerMax;
		// Tile offsets are multiplied by the BobSoldier constructor
		super(_x, _y, new Spritemap(images[_st], 20, 20, endAnim));
		if (Player.hasFire) {
			FP.world.remove(this);
			return;
		}

		Game.levelMusics[(try cast(FP.world, Game) catch (e:Dynamic) null).level] = Game.bossMusic;

		bossType = _st;

		weapon = sprBobBossWeapons;
		sprBobBossWeapons.y = -3;
		sprBobBossWeapons.originY = Std.int(-sprBobBossWeapons.y);
		sprBobBossWeapons.frame = _st;
		weaponLength = sprBobBossWeapons.width;

		swordSpinRate = -swordSpinRate;
		switch (bossType) {
			case 0:
				swordSpinRate /= 4;
				damage = 2;
				hitsMax = 2;
				moveSpeed = 0.5;
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).rate = 1 / 4;
			case 1:
				swordSpinRate /= 3;
				swords = 2;
				moveSpeed = 0.65;
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).rate = 1 / 2;
			case 2:
				swordSpinRate /= 2;
				hitsMax = 2;
				swordSpinResetTimerMax = 0;
				swords = 2;
				moveSpeed = 0.5;
			default:
		}
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).alpha = 0;

		setHitbox(14, 14, 7, 7);

		FP.world.add(new BobBossNPC(_x, _y, bossType, text[bossType], 6));

		canFallInPit = false; // So that he doesn't fall in the pit while flying off of the screen when killed.

		activeOffScreen = true;

		hitSoundIndex = 1; // Big hit sound
		hopSoundIndex = 1; // Big hop sound
		dieSoundIndex = 1;
	}

	override public function update():Void {
		if (Player.hasFire) {
			FP.world.remove(this);
			return;
		}
		if (Game.freezeObjects) {
			return;
		}
		if (formingTimer > 0) {
			formingTimer--;
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).alpha = 1 - formingTimer / formingTimerMax;
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).scale = 1 + formingTimer / formingTimerMax;
			var v:Int = as3hx.Compat.parseInt(255 * (1 - formingTimer / formingTimerMax));
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).color = FP.getColorRGB(v, 255, v);
		} else {
			super.update();
		}
		standingAnimation();
	}

	override public function render():Void {
		if (Player.hasFire) {
			return;
		}
		super.render();
	}

	override public function swordSpinningBeginCheck(d:Int = 0):Void {
		if (!swordSpinning) {
			if (swordSpinResetTimer > 0) {
				swordSpinResetTimer--;
			} else {
				swordSpinningBegin();
			}
		}
	}

	override public function swordSpinningStep(player:Player):Void {
		if (swordSpinning) {
			switch (bossType) {
				case 0:
					swordSpin[swordIndex] += swordSpinRate;
				case 1:
					swordSpin[0] += swordSpinRate;
					swordSpin[1] += swordSpinRate / 4;
				case 2:
					swordSpin[swordIndex] += swordSpinRate;
					var ang:Float = Math.PI * 2;
					if (Math.abs(swordSpin[swordIndex] - swordSpinBegin[swordIndex]) >= ang) {
						swordSpinningStop(swordSpin[swordIndex]);
					}
				default:
			}
		}
	}

	override public function hit(f:Float = 0, p:Point = null, d:Float = 1, t:String = ""):Void {
		if (hitsTimer <= 0 && bossType == 2 && !Game.freezeObjects) {
			swords++;
			for (i in 0...swords) {
				swordSpinBegin[i] = Math.PI * 3 / 2 + 2 * Math.PI / swords * i;
				swordSpin[i] = swordSpinBegin[i];
			}
		}
		super.hit(0, null, d, t);
	}

	override public function death():Void {
		if (destroy) {
			var player:Player = try cast(FP.world.nearestToPoint("Player", x, y, true), Player) catch (e:Dynamic) null;
			if (nextBossTimer <= 0 || player == null) {
				if (bossType < 2) {
					FP.world.add(new BobBoss(Std.int(FP.width / 2 - Tile.w / 2), Std.int(FP.height / 2 - Tile.h / 2), bossType + 1));
				} else {
					FP.world.add(new Fire(Std.int(FP.width / 2 - Tile.w / 2), Std.int(FP.height / 2 - Tile.h / 2), -1));
					Game.levelMusics[(try cast(FP.world, Game) catch (e:Dynamic) null).level] = -1;
					Main.unlockMedal(Main.badges[5]);
				}
				FP.world.remove(this);
				player.receiveInput = true;
				player.hits = 0;
				player.directionFace = -1;
				(try cast(player.graphic, Image) catch (e:Dynamic) null).color = 0xFFFFFF;
				return;
			}
			if (nextBossTimer > 0) {
				nextBossTimer--;
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleX /= 1.1;
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleY += 0.1;
				swords = 0;
				v.y = Math.min(0, v.y);
				v.y -= 1.2;
				y += v.y;
				(try cast(player.graphic, Image) catch (e:Dynamic) null).color = FP.getColorRGB(Std.int(255 * (1 - nextBossTimer / nextBossTimerMax)),
					Std.int(255 * (1 - nextBossTimer / nextBossTimerMax)), 255);

				if (nextBossTimer <= nextBossTimerMax / 3) {
					player.x = FP.width / 2;
					player.y = FP.height - 40;
						(try cast(player.graphic, Image) catch (e:Dynamic) null).alpha = 1 - nextBossTimer / (nextBossTimerMax / 3);
				} else {
					(try cast(player.graphic, Image) catch (e:Dynamic) null).alpha = (nextBossTimer - nextBossTimerMax / 3) / (nextBossTimerMax
						- nextBossTimerMax / 3);
				}
				player.receiveInput = false;
				player.directionFace = 1;
			}
		}
	}
}
