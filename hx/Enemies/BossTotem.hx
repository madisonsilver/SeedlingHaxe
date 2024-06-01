package enemies;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import net.flashpunk.utils.Draw;
import pickups.Wand;
import openfl.display.BlendMode;
import projectiles.BossTotemShot;

/**
 * ...
 * @author Time
 */
class BossTotem extends Enemy {
	public var state(get, set):Int;

private var imgBossTotem:BitmapData;
	private var sprBossTotem:Spritemap;

	// General rules for arrays: arms then legs.
	// "Pos" constants are points for the positions of arms and legs relative to the head depending
	// on the frame of the animation.
	private var headBase(default, never):Point = new Point();
	private var headRestingAng(default, never):Array<Dynamic> = [0, 0, 0, 0, 0, 0, 0, 0];
	private var headRestingPos(default, never):Array<Dynamic> = [
		new Point(0, 0),
		new Point(0, 0),
		new Point(0, 1),
		new Point(0, 1),
		new Point(0, 2),
		new Point(0, 1),
		new Point(0, 1),
		new Point(0, 0)
	];
	private var headWalkingAng(default, never):Array<Dynamic> = [0, 0, 0, 0, 0, 0, 0, 0];
	private var headWalkingPos(default, never):Array<Dynamic> = [
		new Point(0, 0),
		new Point(0, 1),
		new Point(0, 2),
		new Point(0, 3),
		new Point(0, 4),
		new Point(0, 3),
		new Point(0, 2),
		new Point(0, 1)
	];
	private var headJumpingAng(default, never):Array<Dynamic> = [0, 0, 0, 0, 0, 0, 0, 0];
	private var headJumpingPos(default, never):Array<Dynamic> = [
		new Point(0, 0),
		new Point(0, -1),
		new Point(0, -2),
		new Point(0, -3),
		new Point(0, -4),
		new Point(0, -5),
		new Point(0, -6),
		new Point(0, -7)
	];
	private var headAttacksAng(default, never):Array<Dynamic> = [0, 0, 0, 0, 0, 0, 0, 0];
	private var headAttacksPos(default, never):Array<Dynamic> = [
		new Point(0, 0), new Point(0, 1), new Point(0, 1), new Point(0, 2), new Point(0, 2), new Point(0, 4), new Point(0, 4), new Point(0, 8),
		new Point(0, 6), new Point(0, 4), new Point(0, 2), new Point(0, 1), new Point(0, 1), new Point(0, 0)];

	private var armsBase(default, never):Point = new Point(23, 0);
	private var armsRestingAng(default, never):Array<Dynamic> = [0, 2, 4, 8, 9, 8, 4, 2];

	private static var armsRestingPos:Array<Dynamic> = [
		new Point(0, 0),
		new Point(0, 1),
		new Point(0, 2),
		new Point(0, 4),
		new Point(0, 5),
		new Point(0, 4),
		new Point(0, 2),
		new Point(0, 1)
	];

	private var armsWalkingAng(default, never):Array<Dynamic> = [0, 2, 4, 8, 9, 8, 4, 2];
	private var armsWalkingPos(default, never):Array<Dynamic> = [
		new Point(0, 0),
		new Point(1, 1),
		new Point(1, 2),
		new Point(2, 4),
		new Point(2, 5),
		new Point(1, 4),
		new Point(1, 2),
		new Point(0, 1)
	];
	private var armsJumpingAng(default, never):Array<Dynamic> = [0, 3, 6, 9, 12, 15, 18, 21, 24];
	private var armsJumpingPos(default, never):Array<Dynamic> = [
		new Point(0, 0),
		new Point(-2, -1),
		new Point(-6, -2),
		new Point(-10, -4),
		new Point(-13, -5),
		new Point(-16, -6),
		new Point(-18, -7),
		new Point(-18, -8)
	];
	/*private const armsAttacksAng:Array = new Array(0, 5, 10, 15, 20, 25, 31, 38, 31, 25, 20, 15, 10, 5);
		private const armsAttacksPos:Array = new Array(
												new Point(0, 0),
												new Point(-1, 4),
												new Point(-3, 9),
												new Point(-6, 13),
												new Point(-10, 17),
												new Point(-11, 30),
												new Point(-12, 40),
												new Point(-14, 44),
												new Point(-12, 40),
												new Point(-11, 30),
												new Point(-10, 20),
												new Point(-6, 13),
												new Point(-3, 9),
												new Point(-1, 4)); */
	private var armsAttacksAng(default, never):Array<Dynamic> = [0, 5, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 5];
	private var armsAttacksPos(default, never):Array<Dynamic> = [
		new Point(0, 0), new Point(-1, 4), new Point(-1, 9), new Point(-1, 13), new Point(-1, 17), new Point(-1, 30), new Point(-1, 40), new Point(-1, 44),
		new Point(-1, 40), new Point(-1, 30), new Point(-1, 20), new Point(-1, 13), new Point(-1, 9), new Point(-1, 4)];

	private var legsBase(default, never):Point = new Point(6, 16);
	private var legsRestingAng(default, never):Array<Dynamic> = [0, 0, 0, 0, 0, 0, 0, 0];
	private var legsRestingPos(default, never):Array<Dynamic> = [
		new Point(0, 0),
		new Point(0, 0),
		new Point(1, 0),
		new Point(1, 0),
		new Point(1, 0),
		new Point(1, 0),
		new Point(0, 0),
		new Point(0, 0)
	];
	private var legsWalkingAng(default, never):Array<Dynamic> = [0, -5, -10, -5, 0, -5, -10, -5];
	private var legsWalkingPos(default, never):Array<Dynamic> = [
		new Point(0, 0),
		new Point(0, 2),
		new Point(1, 4),
		new Point(1, 2),
		new Point(1, 0),
		new Point(1, -2),
		new Point(1, -4),
		new Point(0, -2)
	];
	private var legsJumpingAng(default, never):Array<Dynamic> = [0, -1, -2, -3, -4, -5, -6, -7, -8];
	private var legsJumpingPos(default, never):Array<Dynamic> = [
		new Point(0, 0),
		new Point(1, 0),
		new Point(2, 0),
		new Point(3, 0),
		new Point(4, 0),
		new Point(5, 0),
		new Point(6, 0),
		new Point(7, 0)
	];
	private var legsAttacksAng(default, never):Array<Dynamic> = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
	private var legsAttacksPos(default, never):Array<Dynamic> = [
		new Point(0, 0), new Point(1, 0), new Point(1, 0), new Point(1, 0), new Point(2, 0), new Point(2, 0), new Point(1, 0), new Point(0, 0),
		new Point(0, 0), new Point(0, 0), new Point(0, 0), new Point(0, 0), new Point(0, 0), new Point(0, 0)];
	private var headOrigin(default, never):Point = new Point(16, 47);
	private var bodyAng:Int = 0; // Rotates all body components.

	private var headPos:Point = new Point();
	private var laserPos:Point = new Point(-8, -11);

	private static inline final laserWidthDef:Int = 6;
	private static inline final laserColDef:Int = 0xFFFFFF;

	private var laserColHit(default, never):Int = 0xFF0000;
	private var laserColMax(default, never):Int = 0xFFFF00;
	private var laserWidth:Float = laserWidthDef;
	private var laserCol:Int = laserColDef;

	private var shootFrame(default, never):Int = 7;
	private var shot:Bool = false;

	private var playerPosSet(default, never):Point = new Point(144, 352);

	// Number of frames per animation.
	private var animate:Bool = true; // Whether or not the animations for all of the body parts will proceed
	private var animateFrames:Dynamic = {};
	private var animateRate(default, never):Dynamic = {};

	private var currentFrame:Float = 0;
	private var currentAnimation:String = "rest";

	private var _state:Int = 0; // 0 = resting, 1 = walking, 2 = attacking, 3 = jumping, 4 = special
	private var stateAnimations:Array<Dynamic> = ["rest", "walk", "attack", "jump", "special"];

	private var attackDistance(default, never):Int = 60;
	private var maxYPosition(default, never):Int = 352; // maxYPosition is the location at which the boss will teleport back to the top.
	private var startY:Int = 0;

	private var rumbleDistMax(default, never):Int = 3;
	private var rumbleAngleMax(default, never):Int = 20;

	private static inline final rumblingTimeMax:Int = 240;

	private var rumblingTime:Int = rumblingTimeMax;

	public var activated:Bool = false;

	private var activationRate:Float = 0.02;

	public var activationStage:Float = 0;
	public var fullyActivated:Bool = false;

	private var bodyAngMax(default, never):Int = 10; // The rotation of the body components.

	private static inline final activationRestTimeMax:Int = 120;

	public var activationRestTime:Int = activationRestTimeMax;

	private var rate:Float = 0; // a scale for the boss's movement and animation speed.
	private var rateRate(default, never):Float = 0.025;

	private var force(default, never):Int = 10;

	private var laserHitTimeMax(default, never):Int = 15;
	private var laserHitTime:Int = 0;

	private var waitAtTopTimeMax(default, never):Int = 30;
	private var waitAtTopTime:Int = 0;

	private var tag:Int;
	private var doActions:Bool = true;

	private var playedSound:Bool = false;

private function load_image_assets():Void {
imgBossTotem = Assets.getBitmapData("assets/graphics/BossTotem.png");
}
	public function new(_x:Int, _y:Int, _tag:Int = -1) {
load_image_assets();
		sprBossTotem = new Spritemap(imgBossTotem, 32, 48);
		super(_x, _y, sprBossTotem);
		startY = _y;

		Reflect.setField(animateFrames, "attack", 14);
		Reflect.setField(animateFrames, "rest", 8);
		Reflect.setField(animateFrames, "walk", 8);
		Reflect.setField(animateFrames, "jump", 8);

		Reflect.setField(animateRate, "attack", 0.3);
		Reflect.setField(animateRate, "rest", 0.1);
		Reflect.setField(animateRate, "walk", 0.2);
		Reflect.setField(animateRate, "jump", 0.5);
		setHitbox(80, 32, 40, -12);

		activeOffScreen = true;
		hitsMax = 5;
		hitsTimerMax = 20;
		onlyHitBy = "Wand";

		tag = _tag;

		hitSoundIndex = 1; // Big hit sound

		dieSound = "Boss Die";
		dieSoundIndex = 0;
	}

	override public function update():Void {
		if (destroy) {
			return;
		}

		var p:Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch (e:Dynamic) null;
		if (p != null && fullyActivated) {
			if (p.y < y - originY + height) {
				p.y = y - originY + height;
			}
		}
		if (FP.world.classCount(Wand) <= 0 && !activated) {
			activated = true;
			Music.playSound("Other", 0);
			Game.levelMusics[(try cast(FP.world, Game) catch (e:Dynamic) null).level] = Game.bossMusic;
			(try cast(FP.world, Game) catch (e:Dynamic) null).playerPosition = playerPosSet.clone();
		}
		if (activated) {
			type = "Enemy";
			super.update();
			if (rumblingTime > 0) {
				rumblingTime--;
			}
			if (rumblingTime <= rumblingTimeMax / 2 && activationStage < 1) {
				var n:Int = 8;
				activationStage += activationRate * (n - 1) / n * Math.sin(activationStage * Math.PI) + activationRate / n;
				if (activationStage >= 1) {
					activationStage = 1;
					fullyActivated = true;
				}
			}
		} else {
			type = "Solid";
		}
		if (waitAtTopTime > 0) {
			waitAtTopTime--;
		} else if (fullyActivated && !Game.freezeObjects) {
			if (activationRestTime > 0) {
				activationRestTime--;
			} else {
				if (rate < 1) {
					rate = Math.min(rate + rateRate, 1);
				}
				if (p != null) {
					if (state == 3) {
						v.y = -5 * rate;
						collidable = false;
						laserWidth = laserWidthDef;
						laserCol = laserColDef;
						laserHitTime = 0;
						if (currentFrame + Reflect.field(animateRate, currentAnimation) * rate >= Reflect.field(animateFrames, currentAnimation)) {
							currentFrame = Reflect.field(animateFrames, currentAnimation) - 1;
							animate = false;
						}
						if (y <= startY - 32) {
							y = startY - 32;
							v.y = 0;
							state = 0;
							waitAtTopTime = waitAtTopTimeMax;
						}
					} else if (state == 2) {
						animate = true;
						collidable = true;
						v.y = 0;
						if (Math.floor(currentFrame) == shootFrame && !shot) {
							shot = true;
							var shotPosition:Point = new Point(30, 75);
							var shotSpeed:Point = new Point(0, 2);
							Music.playSound("Enemy Attack", 2, 0.2);
							FP.world.add(new BossTotemShot(Std.int(x + shotPosition.x), Std.int(y + shotPosition.y), shotSpeed));
							FP.world.add(new BossTotemShot(Std.int(x - shotPosition.x), Std.int(y + shotPosition.y), new Point(-shotSpeed.x, shotSpeed.y)));
						}
						if (currentFrame + Reflect.field(animateRate, currentAnimation) * rate >= Reflect.field(animateFrames, currentAnimation)) {
							state = 1;
						}
					} else {
						shot = false;
						animate = true;
						collidable = true;
						state = 1; // walk
						v.y = rate;
						laserStep();

						if (Math.floor(currentFrame) == 2 || Math.floor(currentFrame) == 6) {
							if (!playedSound) {
								playedSound = true;
								Music.playSound("Other", 1);
							}
						} else {
							playedSound = false;
						}
						if (y - originY + height >= maxYPosition) {
							state = 3;
						}
					}
				}
				if (animate) {
					currentFrame = (currentFrame + Reflect.field(animateRate, currentAnimation) * rate) % Reflect.field(animateFrames, currentAnimation);
				}
			}
		}
		if (p != null && (Math.abs(y - p.y) <= FP.screen.height * 3 / 4 && Math.abs(x - p.x) <= FP.screen.width * 3 / 4)) {
			Game.cameraTarget = new Point((x + p.x) / 2 - FP.screen.width / 2, (y + p.y) / 2 - FP.screen.height / 2);
		} else {
			Game.resetCamera();
		}
	}

	public function laserStep():Void {
		if (laserWidth < laserWidthDef * 2) {
			var divisor:Int = 4;
			var minIncrease:Float = 0.01;
			laserWidth += Math.max((laserWidth - laserWidthDef) / laserWidthDef / divisor, minIncrease);
			laserCol = FP.colorLerp(laserColDef, laserColHit, (laserWidth - laserWidthDef) / laserWidthDef / 2 + 0.5);
		} else if (laserHitTime > 0) {
			laserHitTime--;
			if (laserHitTime <= 0) {
				laserWidth = laserWidthDef;
				laserCol = laserColDef;
				state = 2; // attack
				v.y = 0;
			}
		} else {
			laserWidth = laserWidthDef * 3;
			laserHitTime = laserHitTimeMax;

			laserCol = laserColMax;
			var players:Array<Player> = new Array<Player>();
			var rect:Rectangle = getLaserRect(1, headPos, laserPos);
			FP.world.collideRectInto("Player", rect.x, rect.y, rect.width, rect.height, players);
			rect = getLaserRect(-1, headPos, laserPos);
			FP.world.collideRectInto("Player", rect.x, rect.y, rect.width, rect.height, players);
			hitPlayers(players);
			Game.shake = laserHitTimeMax * 2;
			Music.playSound("Enemy Attack", 0, 0.15);
			Music.playSound("Enemy Attack", 1, 0.15);
		}
	}

	override public function check():Void {
		super.check();
		if (tag >= 0 && !Game.checkPersistence(tag)) {
			doActions = false;
			FP.world.remove(this);
		}
	}

	override public function removed():Void {
		super.removed();
		if (doActions) {
			Game.resetCamera();
			(try cast(FP.world, Game) catch (e:Dynamic) null).undrawCover();
			Music.playSound("Boss Die", 1, 0.8);
			Game.levelMusics[(try cast(FP.world, Game) catch (e:Dynamic) null).level] = -1;
			Main.unlockMedal(Main.badges[6]);
			Game.shake = 60;
			Game.setPersistence(tag, false);
		}
	}

	public function hitPlayers(p:Array<Player>):Void {
		for (player in p) {
			player.hit(null, force, new Point(player.x, y), damage);
		}
	}

	private function set_state(i:Int):Int {
		_state = i;
		changeAnimation(stateAnimations[state]);
		return i;
	}

	private function get_state():Int {
		return _state;
	}

	override public function render():Void {
		var frame:Int = Math.floor(currentFrame);
		var frameUp:Int = as3hx.Compat.parseInt(Math.ceil(currentFrame) % Reflect.field(animateFrames, currentAnimation));
		var armsPos:Point = new Point();
		var armsAng:Int = 0;
		headPos = new Point();
		var headAng:Int = 0;
		var legsPos:Point = new Point();
		var legsAng:Int = 0;

		var defLegsPos:Point = new Point(12, -8);
		var defLegsAng:Int = 45;
		var defArmsPos:Point = new Point(-20, 4);
		var defArmsAng:Int = -45;
		var defHeadPos:Point = new Point(0, 36);
		var defHeadAng:Int = 0;

		switch (currentAnimation) {
			case "attack":
				armsPos = armsAttacksPos[frameUp].clone().add(armsAttacksPos[frame].clone());
				armsPos.normalize(armsPos.length / 2);
				armsAng = as3hx.Compat.parseInt((armsAttacksAng[frameUp] + armsAttacksAng[frame]) / 2);
				headPos = headAttacksPos[frameUp].clone().add(headAttacksPos[frame].clone());
				headPos.normalize(headPos.length / 2);
				headAng = as3hx.Compat.parseInt((headAttacksAng[frameUp] + headAttacksAng[frame]) / 2);
				legsPos = legsAttacksPos[frameUp].clone().add(legsAttacksPos[frame].clone());
				legsPos.normalize(legsPos.length / 2);
				legsAng = as3hx.Compat.parseInt((legsAttacksAng[frameUp] + legsAttacksAng[frame]) / 2);
			case "rest":
				armsPos = armsRestingPos[frameUp].clone().add(armsRestingPos[frame].clone());
				armsPos.normalize(armsPos.length / 2);
				armsAng = as3hx.Compat.parseInt((armsRestingAng[frameUp] + armsRestingAng[frame]) / 2);
				headPos = headRestingPos[frameUp].clone().add(headRestingPos[frame].clone());
				headPos.normalize(headPos.length / 2);
				headAng = as3hx.Compat.parseInt((headRestingAng[frameUp] + headRestingAng[frame]) / 2);
				legsPos = legsRestingPos[frameUp].clone().add(legsRestingPos[frame].clone());
				legsPos.normalize(legsPos.length / 2);
				legsAng = as3hx.Compat.parseInt((legsRestingAng[frameUp] + legsRestingAng[frame]) / 2);
			case "walk":
				armsPos = armsWalkingPos[frameUp].clone().add(armsWalkingPos[frame].clone());
				armsPos.normalize(armsPos.length / 2);
				armsAng = as3hx.Compat.parseInt((armsWalkingAng[frameUp] + armsWalkingAng[frame]) / 2);
				headPos = headWalkingPos[frameUp].clone().add(headWalkingPos[frame].clone());
				headPos.normalize(headPos.length / 2);
				headAng = as3hx.Compat.parseInt((headWalkingAng[frameUp] + headWalkingAng[frame]) / 2);
				legsPos = legsWalkingPos[frameUp].clone().add(legsWalkingPos[frame].clone());
				legsPos.normalize(legsPos.length / 2);
				legsAng = as3hx.Compat.parseInt((legsWalkingAng[frameUp] + legsWalkingAng[frame]) / 2);
			case "jump":
				armsPos = armsJumpingPos[frameUp].clone().add(armsJumpingPos[frame].clone());
				armsPos.normalize(armsPos.length / 2);
				armsAng = as3hx.Compat.parseInt((armsJumpingAng[frameUp] + armsJumpingAng[frame]) / 2);
				headPos = headJumpingPos[frameUp].clone().add(headJumpingPos[frame].clone());
				headPos.normalize(headPos.length / 2);
				headAng = as3hx.Compat.parseInt((headJumpingAng[frameUp] + headJumpingAng[frame]) / 2);
				legsPos = legsJumpingPos[frameUp].clone().add(legsJumpingPos[frame].clone());
				legsPos.normalize(legsPos.length / 2);
				legsAng = as3hx.Compat.parseInt((legsJumpingAng[frameUp] + legsJumpingAng[frame]) / 2);
			default:
				armsPos = armsRestingPos[0].clone();
				armsAng = 0;
				headPos = headRestingPos[0].clone();
				headAng = 0;
				legsPos = legsRestingPos[0].clone();
				legsAng = 0;
		}
		if (destroy) {
			rumblingTime++;
			(try cast(FP.world, Game) catch (e:Dynamic) null).drawCover(0xFFFFFF, rumblingTime / rumblingTimeMax * 2);
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			Draw.rect(Std.int(FP.camera.x), Std.int(FP.camera.y), FP.screen.width, FP.screen.height, 0xFFFFFF, rumblingTime / rumblingTimeMax * 2);
			Draw.resetTarget();
			if (rumblingTime >= rumblingTimeMax) {
				FP.world.remove(this);
			}
		}
		var val:Float = activationStage;
		var rumble:Float = (1 - Math.cos(rumblingTime / rumblingTimeMax * 2 * Math.PI)) / 2;
		var rumbleRandAngle:Float = Math.random() * rumble * rumbleAngleMax;
		var rumbleRandDist:Float = (Math.random() - 0.5) * rumbleDistMax * rumble;
		armsPos.x = (armsPos.x - defArmsPos.x) * val + defArmsPos.x + rumbleRandDist;
		armsPos.y = (armsPos.y - defArmsPos.y) * val + defArmsPos.y + rumbleRandDist;
		armsAng = as3hx.Compat.parseInt((armsAng - defArmsAng) * val + defArmsAng + rumbleRandAngle);
		headPos.x = (headPos.x - defHeadPos.x) * val + defHeadPos.x + rumbleRandDist;
		headPos.y = (headPos.y - defHeadPos.y) * val + defHeadPos.y + rumbleRandDist;
		headAng = as3hx.Compat.parseInt((headAng - defHeadAng) * val + defHeadAng + rumbleRandAngle);
		legsPos.x = (legsPos.x - defLegsPos.x) * val + defLegsPos.x + rumbleRandDist;
		legsPos.y = (legsPos.y - defLegsPos.y) * val + defLegsPos.y + rumbleRandDist;
		legsAng = as3hx.Compat.parseInt((legsAng - defLegsAng) * val + defLegsAng + rumbleRandAngle);
		bodyAng = as3hx.Compat.parseInt(bodyAngMax * (1 - val));

		// Legs
		sprBossTotem.frame = 2;
		setOrigin(sprBossTotem, new Point(0, 0));
		sprBossTotem.angle = legsAng + bodyAng;
		renderPart(new Point(x - legsPos.x + legsBase.x * sprBossTotem.scaleX, y + legsPos.y + legsBase.y));
		sprBossTotem.scaleX = -Math.abs(sprBossTotem.scaleX);
		sprBossTotem.angle = -legsAng + bodyAng;
		renderPart(new Point(x + legsPos.x + legsBase.x * sprBossTotem.scaleX, y - legsPos.y + legsBase.y));
		sprBossTotem.scaleX = Math.abs(sprBossTotem.scaleX);
		sprBossTotem.angle = 0;

		// Arms
		sprBossTotem.frame = 1;
		setOrigin(sprBossTotem, new Point(armsBase.x * sprBossTotem.scaleX, 0));
		sprBossTotem.angle = armsAng + bodyAng;
		renderPart(new Point(x - armsPos.x - armsBase.x * sprBossTotem.scaleX, y + armsPos.y + armsBase.y));
		sprBossTotem.scaleX = -Math.abs(sprBossTotem.scaleX);
		sprBossTotem.angle = -armsAng + bodyAng;
		renderPart(new Point(x + armsPos.x - armsBase.x * sprBossTotem.scaleX, y + armsPos.y + armsBase.y));
		sprBossTotem.scaleX = Math.abs(sprBossTotem.scaleX);
		sprBossTotem.angle = 0;

		// Head
		if (activated) {
			sprBossTotem.color = laserCol;

			sprBossTotem.frame = 0;
			setOrigin(sprBossTotem, headOrigin);
			sprBossTotem.angle = headAng;
			if (activationStage < 1) {
				sprBossTotem.alpha = activationStage;
			}
			renderPart(new Point(x + headPos.x, y + headPos.y));
			sprBossTotem.alpha = 1;
			sprBossTotem.angle = 0;

			sprBossTotem.color = 0xFFFFFF;
		}

		// Laser
		if (activated && headAng == 0) {
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			var rect:Rectangle = getLaserRect(1, headPos, laserPos);
			Draw.rect(Std.int(rect.x), Std.int(rect.y), Std.int(rect.width), Std.int(rect.height), laserCol, activationStage);
			rect = getLaserRect(-1, headPos, laserPos);
			Draw.rect(Std.int(rect.x), Std.int(rect.y), Std.int(rect.width), Std.int(rect.height), laserCol, activationStage);
			Draw.resetTarget();
		}
	}

	public function getLaserRect(dir:Int, headPos:Point, laserPos:Point):Rectangle {
		var laserStart:Point = new Point(headPos.x + laserPos.x, headPos.y + laserPos.y);
		var laserTo:Point = new Point();
		var i:Int = 0;
		while (i < FP.width) {
			laserTo = new Point(laserStart.x, laserStart.y + i);
			if (FP.world.collideRect("Solid", x + laserTo.x * dir - as3hx.Compat.parseInt(dir < 0) * laserWidth, y + laserTo.y, laserWidth, 1) != null) {
				break;
			}
			i += 1;
		}
		return new Rectangle(x
			+ laserStart.x * dir
			- laserWidth / 2, y
			+ laserStart.y, laserTo.x
			- laserStart.x
			+ laserWidth, laserTo.y
			- laserStart.y);
	}

	public function renderPart(renderPos:Point):Void {
		graphic = sprBossTotem;
		var temp:Point = new Point(x, y);
		x = renderPos.x;
		y = renderPos.y;

		var r:Float = 0.1;
		(try cast(graphic, Image) catch (e:Dynamic) null).blend = BlendMode.SCREEN;
		(try cast(graphic, Image) catch (e:Dynamic) null).scale += r;

		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		var tempAlpha:Float = (try cast(graphic, Image) catch (e:Dynamic) null).alpha;
		if (activationStage < 1) {
			(try cast(graphic, Image) catch (e:Dynamic) null).alpha = activationStage;
		}
		super.render();
		(try cast(graphic, Image) catch (e:Dynamic) null).alpha = tempAlpha;
		Draw.resetTarget();

		(try cast(graphic, Image) catch (e:Dynamic) null).blend = BlendMode.NORMAL;
		(try cast(graphic, Image) catch (e:Dynamic) null).scale -= r;

		super.render();

		x = temp.x;
		y = temp.y;
	}

	public function setOrigin(_s:Image, _p:Point):Void {
		_s.originX = Std.int(_p.x);
		_s.originY = Std.int(_p.y);
		_s.x = -_s.originX;
		_s.y = -_s.originY;
	}

	public function changeAnimation(str:String, restart:Bool = false):Void {
		if (currentAnimation != str || restart) {
			currentFrame = 0;
		}
		currentAnimation = str;
	}

	override public function hit(f:Float = 0, p:Point = null, d:Float = 1, t:String = ""):Void {
		if (fullyActivated && activationRestTime <= 0) {
			super.hit(f, p, d, t);
		}
	}

	override public function knockback(f:Float = 0, p:Point = null):Void {}
}
