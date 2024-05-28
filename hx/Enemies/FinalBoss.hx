package enemies;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;
import puzzlements.RockLock;
import scenery.Pod;
import scenery.RockFall;
import scenery.Tile;
import puzzlements.Button;
import net.flashpunk.utils.Input;
import net.flashpunk.utils.Key;

/**
 * ...
 * @author Time
 */
class FinalBoss extends Enemy {
	@:meta(Embed(source = "../../assets/graphics/FinalBoss.png"))
	private var imgFinalBoss:Class<Dynamic>;
	private var sprFinalBoss:Spritemap ;
	@:meta(Embed(source = "../../assets/graphics/NPCs/OwlPic.png"))
	private var imgOwlPic:Class<Dynamic>;
	private var sprOwlPic:Spritemap ;

	public var moveSpeed:Float = 1;
	public var sitFrames:Array<Dynamic> = [0, 1, 2, 3];
	public var sitLoops:Float = 1;

	private var lavaForce(default, never):Int = 6;

	private var rockfallTimeMax(default, never):Int = 240;
	private var rockfallTime:Int = -1;

	private var podPositions(default, never):Array<Dynamic> = [new Point(120, 56), new Point(48, 128), new Point(120, 200), new Point(192, 128)];
	private var pods:Array<Pod> = new Array<Pod>();
	private var cpod:Int = 0; // The pod that you're currently going to
	private var hitThisSequence:Bool = false;

	private var tag:Int;

	private var started:Bool = false;

	public function new(_x:Int, _y:Int, _tag:Int = -1) {
sprFinalBoss =  new Spritemap(imgFinalBoss, 16, 16, endAnim);
sprOwlPic =  new Spritemap(imgOwlPic, 16, 16, endAnim);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprFinalBoss);
		sprFinalBoss.centerOO();
		sprFinalBoss.add("walk", [0, 1, 2, 3], 15);
		sprFinalBoss.add("die", [4, 5, 6, 7, 8, 9, 10, 11], 5);
		sprFinalBoss.add("dead", [11, 11], 1);
		sprFinalBoss.add("deadframe", [11]);
		sprFinalBoss.play("");

		setHitbox(12, 12, 6, 6);

		tag = _tag;

		activeOffScreen = true;
		canFallInPit = false;
		dieInWater = false;
		dieInLava = false; // Handled manually
		onlyHitBy = "Lava";
		justKnock = true;

		hitSoundIndex = 1; // Big hit sound
		dieSoundIndex = 1;
	}

	override public function check():Void {
		super.check();
		if (tag >= 0 && !Game.checkPersistence(tag)) {
			FP.world.remove(this);
		}
		for (i in 0...podPositions.length) {
			var pod:Pod = try cast(collide("Pod", podPositions[i].x, podPositions[i].y), Pod) catch (e:Dynamic) null;
			if (pod != null) {
				pods.push(pod);
			}
		}
	}

	override public function update():Void {
		if (!started) {
			Game.talking = true;
			Game.talkingText = "EEEEP!";
			Game.talkingPic = sprOwlPic;
			Game.freezeObjects = true;
			Game.cameraTarget = new Point(Math.max(Math.min(x - FP.screen.width / 2, FP.width - FP.screen.width), 0),
				Math.max(Math.min(y - FP.screen.height / 2, FP.height - FP.screen.height), 0));
			var p:Player = try cast(FP.world.nearestToEntity("Player", this), Player) catch (e:Dynamic) null;
			if (p != null) {
				if (Input.released(p.keys[6])) {
					Game.talking = false;
					Game.talkingText = "";
					Game.talkingPic = null;
					Game.freezeObjects = false;
					Game.resetCamera();
					started = true;
					Game.levelMusics[(try cast(FP.world, Game) catch (e:Dynamic) null).level] = Game.bossMusic;
				}
			}
		}

		super.update();
		if (Game.freezeObjects || destroy) {
			return;
		}

		var tile:Tile = try cast(collide("Tile", x, y), Tile) catch (e:Dynamic) null;
		if (tile != null && tile.t == 17 && !hitThisSequence /*Lava*/) {
			maxForce = -1;
			hit(lavaForce, new Point(FP.width / 2, (FP.height - Tile.h) / 2), 1, "Lava");
			maxForce = 2;
			hitThisSequence = true;
			return;
		}

		if (v.length > 4) {
			v.normalize(4);
		}

		canHit = rockfallTime < 0;
		if (rockfallTime > 0) {
			rockfallTime--;
			sprFinalBoss.play("");
			var rockFrequency:Int = 6;
			var stepsAhead:Int = -15;
			var radius:Int = 20;
			var p = try cast(FP.world.nearestToEntity("Player", this), Player) catch (e:Dynamic) null;
			if (p != null) {
				if (Math.floor(Math.random() * rockFrequency) == 0) {
					FP.world.add(new RockFall(Std.int(p.x + p.v.x * stepsAhead + Math.random() * radius * 2 - radius),
						Std.int(p.y + p.v.y * stepsAhead + Math.random() * radius * 2 - radius)));
				}
			}
		} else if (rockfallTime == 0) {
			pods[cpod].open = true;
			cpod = as3hx.Compat.parseInt((cpod + 1 + pods.length) % pods.length);
			hitThisSequence = false;
			rockfallTime--;
		} else if (v.length <= moveSpeed) {
			var grenadeFrequency:Int = 40;
			if (Math.floor(Math.random() * grenadeFrequency) == 0) {
				FP.world.add(new Grenade(Std.int(x - 8), Std.int(y - 8), true, 30));
			}

			var to:Point = new Point(pods[cpod].x - x, pods[cpod].y - y);
			to.normalize(moveSpeed);
			v = to;
			sprFinalBoss.play("walk");
			var pod:Pod = try cast(collide("Pod", x, y), Pod) catch (e:Dynamic) null;
			if (pod == pods[cpod]) {
				if (!pods[cpod].open) {
					pods[cpod].open = true;
				}
				if (FP.distance(x, y, pod.x, pod.y) <= v.length * 2) {
					x = pod.x;
					y = pod.y + 1;
					rockfallTime = rockfallTimeMax;
					pods[cpod].open = false;
				}
			}
		}

		if (sprFinalBoss.currentAnim == "") {
			sprFinalBoss.frame = sitFrames[Game.worldFrame(sitFrames.length, sitLoops)];
		}

		layer = Std.int(-(y - originY + height));
	}

	override public function removed():Void {
		super.removed();
		if (Game.checkPersistence(tag)) {
			Game.setPersistence(tag, false);
			Main.unlockMedal("Fall of the Owl");
		}
	}

	public function endAnim():Void {
		var _sw3_ = (sprFinalBoss.currentAnim);

		switch (_sw3_) {
			case "walk":
				sprFinalBoss.play("");
			case "die":
				sprFinalBoss.play("dead");
			case "dead":
				var n:Int = 5;
				for (i in 0...n) {
					FP.world.add(new RockFall(Std.int(120 + Math.random() * 8 - 4), Std.int(i / n * Tile.h * 2)));
				}
				Button.activateAll(null, 0, true);
				if (Game.checkPersistence(tag)) {
					Game.setPersistence(tag, false);
					Game.setPersistence(tag + 1, false);
					Main.unlockMedal(Main.badges[9]);
				}
				sprFinalBoss.play("deadframe");
			default:
		}
	}

	override public function startDeath(t:String = ""):Void {
		type = "Solid";
		sprFinalBoss.play("die");
		Game.levelMusics[(try cast(FP.world, Game) catch (e:Dynamic) null).level] = -1;
		destroy = true;
	}

	override public function death():Void {}
}
