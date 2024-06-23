import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.utils.Dictionary;
import enemies.Enemy;
import enemies.Flyer;
import enemies.IceTurret;
import enemies.LavaBoss;
import enemies.ShieldBoss;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Key;
import net.flashpunk.utils.Input;
import net.flashpunk.FP;
import nPCs.Watcher;
import projectiles.LavaBall;
import projectiles.WandShot;
import scenery.BurnableTree;
import scenery.Light;
import scenery.LightPole;
import scenery.Tile;
import scenery.Grass;
import scenery.Tree;
import puzzlements.*;
import scenery.Moonrock;
import projectiles.RayShot;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class Player extends Mobile {
	public static var hasSword(get, set):Bool;
	public static var hasGhostSword(get, set):Bool;
	public static var hasSpear(get, set):Bool;
	public static var hasWand(get, set):Bool;
	public static var hasFireWand(get, set):Bool;
	public static var hasFire(get, set):Bool;
	public static var hasTorch(get, set):Bool;
	public static var hasFeather(get, set):Bool;
	public static var hasDarkShield(get, set):Bool;
	public static var hasDarkSword(get, set):Bool;
	public static var hasShield(get, set):Bool;
	public static var hasDarkSuit(get, set):Bool;
	public static var canSwim(get, set):Bool;
	public static var hitsMax(get, set):Int;

	public var state(get, set):Int;
	public var slashing(get, set):Bool;
	public var spearing(get, set):Bool;
	public var wanding(get, set):Bool;
	public var firing(get, set):Bool;
	public var deathRaying(get, set):Bool;
	public var spearX(get, never):Int;
	public var spearY(get, never):Int;

	private var imgShrum:BitmapData;
	// [Embed(source = "../assets/graphics/ShrumBlue.png")] private var imgShrumBlue:Class;
	private var sprShrum:Spritemap;
	private var imgShrumDark:BitmapData;

	public var sprShrumDark:Spritemap;

	private var imgSlash:BitmapData;
	private var sprSlash:Spritemap;
	private var imgSlashDark:BitmapData;
	private var sprSlashDark:Spritemap;
	private var imgGhostSword:BitmapData;
	private var sprGhostSword:Spritemap;
	private var imgSpear:BitmapData;
	private var sprSpear:Spritemap;
	private var imgWand:BitmapData;
	private var sprWand:Spritemap;
	private var imgFireWand:BitmapData;
	private var sprFireWand:Spritemap;
	private var imgFire:BitmapData;
	private var sprFire:Spritemap;
	private var imgDeathRay:BitmapData;
	private var sprDeathRay:Spritemap;
	private var imgShield:BitmapData;
	private var sprShield:Spritemap;

	// Right, Up, Left, Down, Primary, Secondary, Talk, Inventory, Inventory 1
	public var keys(default, never):Array<Dynamic> = [Key.RIGHT, Key.UP, Key.LEFT, Key.DOWN, Key.X, Key.C, Key.X, Key.V, Key.I];

	private var direction:Int = 3; // last direction moved in 0,1,2,3 = right, up, left down

	public var directionFace:Int = -1; // a direction for the player to face with his sprite.  -1 to act normally.

	private var prev:Point = new Point(); // The last position of the player

	public var moveSpeed:Float = 0.5;
	public var slidingSpeed(default, never):Float = 1;
	public var waterfallAcceleration(default, never):Float = 0.8;

	private var onIce:Bool = false;
	private var onWaterfall:Bool = false;
	private var inWater:Bool = false;
	private var inLava:Bool = false;
	private var checkOffsetY:Int; // Set in the constructor--determines the relative position at which the state is checked.

	private static inline final dMS = 0.8; // Walking speed
	private static inline final dMSstair:Float = 0.4; // Walking speed on stairs
	private static inline final dwASstair:Int = 12; // Walking animation speed on stairs
	private static inline final dwAS:Int = 15; // Walking animation speed
	private static inline final dsAS:Int = 1; // Standing animation speed
	private static inline final dMSwater:Float = 0.45;
	private static inline final dwASwater:Int = 5;
	private static inline final slidingFriction:Float = 0.025;

	private var states(default, never):Array<Dynamic> = [
		"", "swim-", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "swim-", "", "", "", "", "", "", "", "swim-", "", "", "", "", "", "", "", "",
		"", "", "", ""
	]; // whether the player is on the ground, swimming, etc.
	private var moveSpeeds(default, never):Array<Dynamic> = [
		dMS, dMSwater, dMS, dMS, dMS, dMS, dMS, dMS, dMS, dMS, dMSstair, dMS, dMS, dMS, dMS, dMS, dMS, dMSwater, dMS, dMS, dMS, dMS, dMS, dMS, dMS,
		dMSwater / 2, dMS, dMS, dMS, dMS, dMSstair, dMS, dMS, dMS, dMS, dMS, dMS, dMS
	];
	private var walkAnimSpeeds(default, never):Array<Dynamic> = [
		dwAS, dwASwater, dwAS, dwAS, dwAS, dwAS, dwAS, dwAS, dwAS, dwAS, dwASstair, dwAS, dwAS, dwAS, dwAS, dwAS, dwAS, dwASwater, dwAS, dwAS, dwAS, dwAS,
		dwAS, dwAS, dwAS, dwASwater, dwAS, dwAS, dwAS, dwAS, dwASstair, dwAS, dwAS, dwAS, dwAS, dwAS, dwAS, dwAS
	];
	private var standAnimSpeeds(default, never):Array<Dynamic> = [
		dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS,
		dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS
	];

	private var hitables:Array<String> = [
		"Enemy", "Grass", "Tree", "Rock", "Rope", "ShieldBoss", "Solid", "LightPole", "LavaBall", "LavaBoss", "Watcher"
	]; // Solid added so that you can hit burnable trees.
	private var enemies:Dynamic = ["Enemy", "ShieldBoss"];

	private static function get_hasSword():Bool {
		return Main.hasSword;
	}

	private static function set_hasSword(_hs:Bool):Bool {
		Main.hasSword = _hs;
		return _hs;
	}

	private var slashingSprite:Spritemap;
	private var _slashing:Bool = false;
	private var slashDirection:Int = -1;
	private var ghostSwordDamage(default, never):Int = 2;
	private var darkSwordDamage(default, never):Int = 2;
	private var swordDamage(default, never):Int = 1;
	private var swordForce(default, never):Int = 5; // The amount of push when an object is hit by a sword.
	private var slashDelayMax(default, never):Int = 0; // The amount of time between slashes
	private var slashDelay:Int = 0;
	private var slashTimerMax(default, never):Int = 20; // The amount of time for which you can double-press to dash
	private var slashTimer:Int = 0;
	private var slashDashed:Bool = false;

	private static function get_hasGhostSword():Bool {
		return Main.hasGhostSword;
	}

	private static function set_hasGhostSword(_hgs:Bool):Bool {
		Main.hasGhostSword = _hgs;
		return _hgs;
	}

	private var ghostSwordAnimFrames:Dictionary<String, Int> = new Dictionary();
	private var swordSpeed(default, never):Int = 30;
	private var swordSpeedDash(default, never):Int = 20;

	private static function get_hasSpear():Bool {
		return Main.hasSpear;
	}

	private static function set_hasSpear(_hs:Bool):Bool {
		Main.hasSpear = _hs;
		return _hs;
	}

	private var _spearing:Bool = false;
	private var spearDirection:Int = -1;
	private var spearDamage(default, never):Int = 2;
	private var spearForce(default, never):Int = 7; // The amount of push when an object is hit by a sword.
	private var spearDelayMax(default, never):Int = 1;
	private var spearDelay:Int = 0;
	private var spearOffset(default, never):Point = new Point(-1, 2);

	private static function get_hasWand():Bool {
		return Main.hasWand;
	}

	private static function set_hasWand(_hw:Bool):Bool {
		Main.hasWand = _hw;
		return _hw;
	}

	private static function get_hasFireWand():Bool {
		return Main.hasFireWand;
	}

	private static function set_hasFireWand(_hfw:Bool):Bool {
		Main.hasFireWand = _hfw;
		return _hfw;
	}

	private var _wanding:Bool = false;
	private var wandSpeed(default, never):Int = 3;

	private static function get_hasFire():Bool {
		return Main.hasFire;
	}

	private static function set_hasFire(_hf:Bool):Bool {
		Main.hasFire = _hf;
		return _hf;
	}

	private var _firing:Bool = false;
	private var fireDamage(default, never):Float = 0; // .5;
	private var fireForce(default, never):Float = 0.325; // The amount of push when an object is hit by fire (done every step of collision).
	private var fireTimer:Int = 0;
	private var fireTimerMax(default, never):Int = 180;
	private var fireIncrement(default, never):Int = 60;

	public static var _hasTorch:Bool = false;

	private var myLight:PlayerLight;

	public var myLightPosition:Point = new Point();

	private static function get_hasTorch():Bool {
		return Main.hasTorch;
	}

	private static function set_hasTorch(_ht:Bool):Bool {
		Main.hasTorch = _ht;
		return _ht;
	}

	public static var _hasFeather:Bool = false;

	private static function get_hasFeather():Bool {
		return Main.hasFeather;
	}

	private static function set_hasFeather(_hf:Bool):Bool {
		Main.hasFeather = _hf;
		return _hf;
	}

	public static var hasDeathRay:Bool = false;

	private var _deathRaying:Bool = false;
	private var deathRaySpeed(default, never):Int = 8;

	private var darkShieldDamage(default, never):Float = 0.5;

	private static function get_hasDarkShield():Bool {
		return Main.hasDarkShield;
	}

	private static function set_hasDarkShield(_hf:Bool):Bool {
		Main.hasDarkShield = _hf;
		return _hf;
	}

	public static var _hasDarkSword:Bool = false;

	private static function get_hasDarkSword():Bool {
		return Main.hasDarkSword;
	}

	private static function set_hasDarkSword(_hf:Bool):Bool {
		Main.hasDarkSword = _hf;
		return _hf;
	}

	public static var _hasShield:Bool = false;

	private static function get_hasShield():Bool {
		return Main.hasShield;
	}

	private static function set_hasShield(_hf:Bool):Bool {
		Main.hasShield = _hf;
		return _hf;
	}

	private var shieldOffset(default, never):Point = new Point(2, 3);
	private var shieldSideOffset(default, never):Point = new Point(4, 0);
	private var shieldForce(default, never):Float = 5;
	private var shieldRange:Float = Math.PI / 2; // The angular range the shield covers in the direction of movement.
	private var shieldObj:Entity;

	public static var _hasDarkSuit:Bool = false;

	private static function get_hasDarkSuit():Bool {
		return Main.hasDarkSuit;
	}

	private static function set_hasDarkSuit(_hf:Bool):Bool {
		Main.hasDarkSuit = _hf;
		return _hf;
	}

	private var darkSuitDamage:Float = 1;
	private var darkSuitForce:Float = 1;

	public static inline var totalKeys:Int = 5;

	public static function hasKeySet(i:Int, _t:Bool):Void {
		Main.hasKeySet(i, _t);
	}

	public static function hasKey(i:Int):Bool {
		return Main.hasKey(i);
	}

	public static function hasKeyNumber():Int {
		var n:Int = 0;
		for (i in 0...totalKeys) {
			n += (hasKey(i) ? 1 : 0);
		}
		return n;
	}

	public static inline var totemParts:Int = 5;

	public static function hasTotemPartSet(i:Int, _t:Bool):Void {
		Main.hasTotemPartSet(i, _t);
	}

	public static function hasTotemPart(i:Int):Bool {
		return Main.hasTotemPart(i);
	}

	public static function hasTotemPartNumber():Int {
		var n:Int = 0;
		for (i in 0...totemParts) {
			n += (hasTotemPart(i) ? 1 : 0);
		}
		return n;
	}

	private var normalHitbox:Rectangle = new Rectangle(2, 2, 4, 5);

	private var _state:Int = 0;
	private var lastState:Int = 0; // The last type of block touched.
	private var lastPosition:Point = new Point(); // The last position before changing to a new kind of block

	private var knocked:Bool = false;

	public static var _canSwim:Bool = false;

	private static function get_canSwim():Bool {
		return Main.canSwim;
	}

	private static function set_canSwim(_cs:Bool):Bool {
		Main.canSwim = _cs;
		return _cs;
	}

	private var drownTimerMax(default, never):Int = 10;

	public var drownTimer:Float = 0;

	private var dying:Bool = false;
	private var drowning:Bool = false;

	public var fallFromCeiling:Bool = false;

	private var yStart:Int;
	private var bouncedFromCeiling:Bool = false;

	public var receiveInput:Bool = true;

	public var hits:Float = 0;

	public static inline var hitsMaxDef:Int = 3; // The default number of hits to kill the player.

	private static function set_hitsMax(_ht:Int):Int {
		Main.hitsMax = _ht;
		return _ht;
	}

	private static function get_hitsMax():Int {
		return Main.hitsMax;
	}

	public var hitsTimer:Int = 0;
	public var hitsTimerMax(default, never):Int = 20;
	public var hitsTimerInt(default, never):Int = 10;
	public var hitsColor(default, never):Int = 0xFF0000;
	public var normalColor(default, never):Int = 0xFFFFFF;
	public var frozenColor(default, never):Int = 0x0000FF;

	public var fallInPit:Bool = false;
	public var fallInPitPos:Point = new Point();
	public var fallSpinSpeed(default, never):Int = Std.int(8 * FP.choose([-1, 1]));
	public var fallAlphaSpeed(default, never):Float = 0.05;

	private var frozenTimer:Int = 0;
	private var frozenTimerMax(default, never):Int = 90;

	public var onGround:Bool = true;

	private var coverAlpha:Float = 0;
	private var coverAlphaRate:Float = 0.005;

	private function load_image_assets():Void {
		imgShrum = Assets.getBitmapData("assets/graphics/ShrumBlue.png");
		imgShrumDark = Assets.getBitmapData("assets/graphics/ShrumDark.png");
		imgSlash = Assets.getBitmapData("assets/graphics/Slash.png");
		imgSlashDark = Assets.getBitmapData("assets/graphics/SlashDark.png");
		imgGhostSword = Assets.getBitmapData("assets/graphics/GhostSword.png");
		imgSpear = Assets.getBitmapData("assets/graphics/GhostSpearStab.png");
		imgWand = Assets.getBitmapData("assets/graphics/Wand.png");
		imgFireWand = Assets.getBitmapData("assets/graphics/FireWand.png");
		imgFire = Assets.getBitmapData("assets/graphics/Fire.png");
		imgDeathRay = Assets.getBitmapData("assets/graphics/DeathRay.png");
		imgShield = Assets.getBitmapData("assets/graphics/Shield.png");
	}

	public function new(_x:Int, _y:Int) {
		load_image_assets();
		sprShrumDark = new Spritemap(imgShrumDark, 16, 16, endAnim);
		sprShrum = new Spritemap(imgShrum, 16, 16);
		sprGhostSword = new Spritemap(imgGhostSword, 24, 7, slashEnd);
		sprSlashDark = new Spritemap(imgSlashDark, 16, 32, slashEnd);
		sprSlash = new Spritemap(imgSlash, 16, 32, slashEnd);
		sprSpear = new Spritemap(imgSpear, 36, 7, spearEnd);
		sprShield = new Spritemap(imgShield, 7, 7);
		sprFireWand = new Spritemap(imgFireWand, 17, 10, wandEnd);
		sprWand = new Spritemap(imgWand, 16, 10, wandEnd);
		sprFire = new Spritemap(imgFire, 32, 32, fireEnd);
		sprDeathRay = new Spritemap(imgDeathRay, 10, 5, deathRayEnd);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2));
		yStart = Std.int(y);
		solids.push("LavaBoss");

		sprShrum.centerOO();
		sprShrumDark.centerOO();

		addAnimations(sprShrum);
		addAnimations(sprShrumDark);

		graphic = getSuit();
		slashingSprite = getSword();

		(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("down-stand");

		sprSlash.centerOO();
		sprSlash.x = sprSlash.originX = 0;
		sprSlash.add("slash", [0, 1, 2, 3, 4], swordSpeed, true);
		sprSlash.add("slashnarrow", [1, 2, 3], swordSpeedDash, true);
		sprSlashDark.centerOO();
		sprSlashDark.x = sprSlashDark.originX = 0;
		sprSlashDark.add("slash", [0, 1, 2, 3, 4], swordSpeed, true);
		sprSlashDark.add("slashnarrow", [1, 2, 3], swordSpeedDash, true);

		var ghostSwordFrames:Array<Dynamic> = [0, 1, 2, 2, 3, 3, 4];
		var ghostSwordFramesNarrow:Array<Dynamic> = [0, 1, 2, 3];
		sprGhostSword.centerOO();
		sprGhostSword.x = sprGhostSword.originX = 0;
		sprGhostSword.add("slash", ghostSwordFrames, swordSpeed, true);
		sprGhostSword.add("slashnarrow", ghostSwordFramesNarrow, swordSpeedDash, true);
		ghostSwordAnimFrames["slash"] = ghostSwordFrames.length;
		ghostSwordAnimFrames["slashnarrow"] = ghostSwordFramesNarrow.length * 2;

		sprSpear.centerOO();
		sprSpear.originX = 4;
		sprSpear.x = -sprSpear.originX;
		sprSpear.add("spear", [0, 1, 2, 3, 4, 5, 6, 7], 45, true);

		sprShield.centerOO();

		sprWand.x = sprWand.originX = 0;
		sprWand.y = -8;
		sprWand.originY = 8;
		sprWand.add("wand", [0, 1, 2, 3, 4], 20, true);

		sprFireWand.x = sprFireWand.originX = 0;
		sprFireWand.y = -8;
		sprFireWand.originY = 8;
		sprFireWand.add("wand", [0, 1, 2, 3, 4], 20, true);

		sprFire.centerOO();
		sprFire.add("fire", [0, 1, 2, 3, 4, 5, 6, 7, 8], 25, true);

		sprDeathRay.y = -1;
		sprDeathRay.originY = 1;
		sprDeathRay.add("ray", [0, 1, 2, 3], 10, true);

		type = "Player";
		setHitbox(Std.int(normalHitbox.width), Std.int(normalHitbox.height), Std.int(normalHitbox.x), Std.int(normalHitbox.y));

		checkOffsetY = Std.int(-originY + height - 2);
	}

	override public function check():Void {
		super.check();
		if (fallFromCeiling) {
			y = Std.int(FP.camera.y - (height - originY));
		}
		if (Game.cheats) {
			hasSword = true;
			hasFire = true;
			hasShield = true;
			hasWand = true;
			hasDarkSword = true;
			hasDarkShield = true;
			hasDarkSuit = true;
			canSwim = true;
			hasFeather = true;
			hasSpear = true;
			hasFireWand = true;
			hasGhostSword = true;
			hasTorch = true;

			Main.rockSet = true;

			hasTotemPartSet(0, true);
			hasTotemPartSet(1, true);
			hasTotemPartSet(2, true);
			hasTotemPartSet(3, true);
			hasTotemPartSet(4, true);

			hasKeySet(0, true);
			hasKeySet(1, true);
			hasKeySet(2, true);
			hasKeySet(3, true);
			hasKeySet(4, true);
		}
	}

	override public function update():Void {
		graphic = getSuit();
		slashingSprite = getSword();

		if (sprShrumDark.currentAnim == "dead") {
			(try cast(FP.world, Game) catch (e:Dynamic) null).drawCover(0, coverAlpha);
			coverAlpha += coverAlphaRate;
			if (coverAlpha >= 1) {
				coverAlpha = 1;
				Main.unlockMedal(Main.badges[13]);
				Game.menu = true;
				Game.cutscene[1] = false;
				FP.world = new Game(114, 72, 128, false, 2);
			}
		}

		if (myLight == null && hasTorch) {
			FP.world.add(myLight = new PlayerLight(Std.int(x), Std.int(y), this));
		}
		if (fallFromCeiling) {
			v.y += 0.1;
			v.y = Math.min(v.y, 5);
			y += v.y;
			layer = -yStart;
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).angle += 10;
			if (y >= yStart) {
				if (bouncedFromCeiling
					|| getStatePos(Std.int(x), yStart) == 6
					|| getStatePos(Std.int(x), yStart) == 1
					|| getStatePos(Std.int(x), yStart) == 17 /* Lava */ /* WATER */ /* PIT */) {
					fallFromCeiling = false;
					directionFace = -1;
					(try cast(graphic, Spritemap) catch (e:Dynamic) null).angle = 0;
					v.y = 0;
					direction = 3;
					Music.playSound("Ground Hit", 1);
				} else {
					y = yStart;
					v.y = -2;
					Music.playSound("Ground Hit", 0);
					bouncedFromCeiling = true;
				}
			}
		} else {
			getState();
			addShield();
			shieldBump();
			checkDrowning();
			freezeStep();

			if (onIce)
				// Ice
			{
				{
					f = slidingFriction;
					moveSpeed = slidingSpeed;
				}
			} else {
				moveSpeed = moveSpeeds[state];
				if (inWater || inLava) {
					f = Mobile.WATER_FRICTION;
					moveSpeed = moveSpeeds[state] + 0.25 * (Music.soundPosition("Swim") < 0.1 ? 1 : 0);
					if (v.length > 0 && !Music.soundIsPlaying("Swim")) {
						Music.playSound("Swim");
					}
				} else {
					f = Mobile.DEFAULT_FRICTION;
				}
			}

			if (hasSword) {
				slash();
			}
			if (hasSpear) {
				spear();
			}
			if (hasFire) {
				fire();
			}
			prev = new Point(x, y);
			if (!dying) {
				super.update();
			}
			sprites();
			hitUpdate();
			checkFallingInPit();

			x = Math.min(Math.max(x, originX), FP.width + originX - width);
			y = Math.min(Math.max(y, originY), FP.height + originY - height);
		}
	}

	public function freeze(frozenTime:Int):Void {
		frozenTimer = frozenTime;
	}

	public function freezeStep():Void {
		if (frozenTimer > 0) {
			frozenTimer--;
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).color = frozenColor;
			if (frozenTimer <= 0) {
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).color = normalColor;
			}
		}
	}

	public function getSuit():Spritemap {
		if (hasDarkSuit) {
			return sprShrumDark;
		} else {
			return sprShrum;
		}
	}

	public function getSword():Spritemap {
		if (hasGhostSword) {
			return sprGhostSword;
		} else if (hasDarkSword) {
			return sprSlashDark;
		} else {
			return sprSlash;
		}
	}

	public function addAnimations(g:Spritemap):Void {
		var colW:Int = 9; // columns per row
		for (row in 0...states.length + 1) {
			var next:Bool = false;
			for (i in 0...row) {
				if (states[i] == states[row]) {
					next = true;
					break;
				}
			}
			if (next) {
				continue;
			}
			g.add(states[row] + "down-walk", [row * colW, row * colW + 1, row * colW + 2, row * colW + 1], walkAnimSpeeds[row], true);
			g.add(states[row] + "down-stand", [row * colW, row * colW + 1], standAnimSpeeds[state], true);
			g.add(states[row] + "side-walk", [row * colW + 3, row * colW + 4, row * colW + 5, row * colW + 4], walkAnimSpeeds[row], true);
			g.add(states[row] + "side-stand", [row * colW + 3, row * colW + 4], standAnimSpeeds[state], true);
			g.add(states[row] + "up-walk", [row * colW + 6, row * colW + 7, row * colW + 8, row * colW + 7], walkAnimSpeeds[row], true);
			g.add(states[row] + "up-stand", [row * colW + 6, row * colW + 7], standAnimSpeeds[row], true);
		}
		// Sloppy hacky code for making the death animation in the final (bad) scene work.
		if (g == sprShrumDark) {
			var s:Int = Std.int(2 * colW);
			g.add("die", [s, s, s, s, s, s, s, s + 1, s + 2, s + 3, s + 4, s + 5, s + 6, s + 7, s + 8], 3.5);
			g.add("dead", [s + 8], 0);
		}
	}

	private function endAnim():Void {
		if (graphic == sprShrumDark && sprShrumDark.currentAnim == "die") {
			sprShrumDark.play("dead");
		}
	}

	public function getState():Void {
		var tile:Tile = try cast(FP.world.nearestToPoint("Tile", x, y + checkOffsetY), Tile) catch (e:Dynamic) null;
		// Check if there's a tile, and if you're hitting it
		if (tile != null
			&& (new Rectangle(tile.x - tile.originX, tile.y - tile.originY, tile.width,
				tile.height)).intersects(new Rectangle(x - originX, y - originY + checkOffsetY, width, height))) {
			if (state != tile.t && (tile.t == 1 || tile.t == 17 /* LAVA */ /* WATER */)) {
				Music.playSound("Splash");
			}
			state = tile.t;
		}
	}

	public function getStatePos(_x:Int, _y:Int):Int {
		var tile:Tile = try cast(FP.world.nearestToPoint("Tile", _x, _y), Tile) catch (e:Dynamic) null;
		if (tile != null) {
			return tile.t;
		} else {
			return -1;
		}
	}

	private function get_state():Int {
		return _state;
	}

	private function set_state(_s:Int):Int {
		if (_s != _state) {
			lastState = _state;
			var tile:Tile = try cast(FP.world.nearestToPoint("Tile", prev.x, prev.y + checkOffsetY), Tile) catch (e:Dynamic) null;
			if (onGround) {
				if (_s == 6 /* Pit */) {
					var tile_test:Tile = try cast(FP.world.nearestToPoint("Tile", x, y + checkOffsetY), Tile) catch (e:Dynamic) null;
					fallInPitPos = new Point(tile_test.x, tile_test.y);
					fallInPit = true;
					Music.playSound("Player Fall");
				}
				onIce = _s == 22; /* Ice */
				onWaterfall = _s == 25; /* Waterfall */
				inWater = _s == 1 || _s == 25; /* Water */
				inLava = _s == 17;
			} else {
				onIce = false;
				onWaterfall = false;
				inWater = false;
				inLava = false;
			}
			lastPosition = new Point(tile.x, tile.y);
		}
		_state = _s;
		moveSpeed = moveSpeeds[state];
		return _s;
	}

	public function checkFallingInPit():Void {
		if (fallInPit) {
			receiveInput = false;
			directionFace = 3;
			var divisor:Int = 10;
			x += Std.int((Math.floor(fallInPitPos.x / Tile.w) * Tile.w + Tile.w / 2 - x) / divisor);
			y += Std.int((Math.floor(fallInPitPos.y / Tile.h) * Tile.h + Tile.h / 2 - y) / divisor);
			(try cast(graphic, Image) catch (e:Dynamic) null).angle += fallSpinSpeed;
			(try cast(graphic, Image) catch (e:Dynamic) null).alpha -= fallAlphaSpeed;
			if ((try cast(graphic, Image) catch (e:Dynamic) null).alpha <= 0) {
				if (Game.fallthroughLevel > -1) {
					x = Std.int(Math.floor(Math.max(fallInPitPos.x - Game.fallthroughOffset.x, 0) / Tile.w) * Tile.w);
					y = Std.int(Math.floor(Math.max(fallInPitPos.y - Game.fallthroughOffset.y, 0) / Tile.h) * Tile.h);
					Game.setFallFromCeiling = true;
					Game.sign = Game.fallthroughSign;
					FP.world = new Game(Game.fallthroughLevel, Std.int(x), Std.int(y));
				} else {
					die();
				}
			}
		}
	}

	private function get_slashing():Bool {
		return _slashing;
	}

	private function set_slashing(_s:Bool):Bool // slashDirection = -1;
	{
		if ((hasSword || hasGhostSword) && !wanding && !firing && !deathRaying && !spearing) {
			if (slashTimer > 0 && _s && !slashDashed) {
				slashDashed = true;
				slashingSprite.play("slashnarrow", true);
				knockback(2, new Point(x - v.x, y - v.y));
				slashDirection = direction;
				Music.playSound("Sword");
			} else if (!slashing && _s) {
				slashingSprite.play("slash", true);
				slashDirection = direction;
				slashTimer = slashTimerMax;
				Music.playSound("Sword");
			}
			if (!_s) {
				slashDashed = false;
			}
			_slashing = _s;
		}
		return _s;
	}

	private function get_spearing():Bool {
		return _spearing;
	}

	private function set_spearing(_s:Bool):Bool {
		spearDirection = -1;
		if (hasSpear && !wanding && !firing && !deathRaying && !slashing) {
			if (!spearing && _s) {
				sprSpear.play("spear", true);
				spearDirection = direction;
				Music.playSound("Stab");
			}
			_spearing = _s;
		}
		return _s;
	}

	private function get_wanding():Bool {
		return _wanding;
	}

	private function set_wanding(_w:Bool):Bool {
		if ((hasWand || hasFireWand) && !slashing && (!firing || hasFireWand) && !deathRaying && !spearing) {
			if (!wanding && _w) {
				if (hasFireWand) {
					sprFireWand.play("wand", true);
				} else {
					sprWand.play("wand", true);
				}
			}
			_wanding = _w;
		}
		return _w;
	}

	private function get_firing():Bool {
		return _firing;
	}

	private function set_firing(_f:Bool):Bool {
		if ((hasFire || hasFireWand) && !slashing && (!wanding || hasFireWand) && !deathRaying && !spearing) {
			if (!firing && _f) {
				sprFire.play("fire", true);
				Music.playSound("Fire", -1, 0.4);
				fireTimer += fireIncrement;
				if (fireTimer >= fireTimerMax)
					// hit();
				{
					fireTimer = fireTimerMax;
				}
			}
			_firing = _f;
		}
		return _f;
	}

	private function get_deathRaying():Bool {
		return _deathRaying;
	}

	private function set_deathRaying(_d:Bool):Bool {
		if (hasDeathRay && !slashing && !wanding && !firing && !spearing) {
			if (!deathRaying && _d) {
				sprDeathRay.play("ray", true);
			}
			_deathRaying = _d;
		}
		return _d;
	}

	public function slash():Void {
		if (slashTimer > 0) {
			slashTimer--;
		}
		if (slashDelay > 0) {
			slashDelay--;
		} else if (slashing) {
			slashDelay = slashDelayMax;
			var v:Array<Entity> = new Array<Entity>();
			for (i in 0...hitables.length) {
				var rect:Rectangle = getSlashRect();
				FP.world.collideRectInto(hitables[i], rect.x, rect.y, rect.width, rect.height, v);
			}
			for (i in 0...v.length) {
				if ((FP.distance(x, y, v[i].x, v[i].y) <= slashingSprite.width * slashingSprite.scaleX && Std.is(v[i], Grass))
					|| (FP.distanceRectPoint(x, y, v[i].x - v[i].originX, v[i].y - v[i].originY, v[i].width,
						v[i].height) <= slashingSprite.width * slashingSprite.scaleX
						&& !(Std.is(v[i], Grass)))) {
					if ((FP.world.collideLine("Solid", Std.int(x), Std.int(y), Std.int(v[i].x), Std.int(v[i].y)) == null)
						|| hasGhostSword
						|| v[i].type == "Solid"
						|| v[i].type == "Rope"
						|| Std.is(v[i], Flyer)) {
						if (hasGhostSword) {
							spearDirection = direction;
						}
						genericHit(v[i], (hasGhostSword) ? "Spear" : "Sword", swordForce,
							(hasGhostSword) ? ghostSwordDamage : ((hasDarkSword) ? darkSwordDamage : swordDamage));
					}
				}
			}
		}
	}

	public function getSlashRect():Rectangle {
		var rect:Rectangle = new Rectangle();
		var h:Int = (hasGhostSword) ? slashingSprite.width * 2 : slashingSprite.height;
		switch (slashDirection) {
			case 0:
				rect.x = x;
				rect.y = y - h / 2 * slashingSprite.scaleY;
				rect.width = slashingSprite.width * slashingSprite.scaleX;
				rect.height = h * slashingSprite.scaleY;
			case 1:
				rect.x = x - h / 2 * slashingSprite.scaleY;
				rect.y = y - slashingSprite.width * slashingSprite.scaleX;
				rect.width = h * slashingSprite.scaleY;
				rect.height = slashingSprite.width * slashingSprite.scaleX;
			case 2:
				rect.x = x - slashingSprite.width * slashingSprite.scaleX;
				rect.y = y - h / 2 * slashingSprite.scaleY;
				rect.width = slashingSprite.width * slashingSprite.scaleX;
				rect.height = h * slashingSprite.scaleY;
			case 3:
				rect.x = x - h / 2 * slashingSprite.scaleY;
				rect.y = y;
				rect.width = h * slashingSprite.scaleY;
				rect.height = slashingSprite.width * slashingSprite.scaleX;
			default:
		}
		return rect;
	}

	public function spear():Void {
		if (spearDelay > 0) {
			spearDelay--;
		} else if (spearing) {
			spearDelay = spearDelayMax;
			var v:Array<Entity> = new Array<Entity>();
			for (i in 0...hitables.length) {
				var length:Int = 32;
				var thick:Int = 5;
				var rect:Rectangle = new Rectangle();
				switch (spearDirection) {
					case 0:
						rect.x = spearX;
						rect.y = spearY - thick / 2 + 1;
						rect.width = length;
						rect.height = thick;
					case 1:
						rect.x = spearX - thick / 2 + 1;
						rect.y = spearY - length;
						rect.width = thick;
						rect.height = length;
					case 2:
						rect.x = spearX - length;
						rect.y = spearY - thick / 2;
						rect.width = length;
						rect.height = thick;
					case 3:
						rect.x = spearX - thick / 2;
						rect.y = spearY;
						rect.width = thick;
						rect.height = length;
					default:
				}
				FP.world.collideRectInto(hitables[i], rect.x, rect.y, rect.width, rect.height, v);
			}
			for (i in 0...v.length) {
				genericHit(v[i], "Spear", spearForce, spearDamage);
			}
		}
	}

	public function wand():Void {
		if (wanding) {
			var a:Float = direction * Math.PI / 2;
			var pos:Point = new Point(x + sprWand.width * Math.cos(a), y - sprWand.width * Math.sin(a));
			var v:Point = new Point(wandSpeed * Math.cos(a), -wandSpeed * Math.sin(a));
			FP.world.add(new WandShot(Std.int(pos.x), Std.int(pos.y), v, hasFireWand));
		}
	}

	public function deathRay():Void {
		if (deathRaying) {
			var a:Float = direction * Math.PI / 2;
			FP.world.add(new RayShot(Std.int(x + sprDeathRay.width * Math.cos(a)), Std.int(y - sprDeathRay.width * Math.sin(a)),
				new Point(deathRaySpeed * Math.cos(a), -deathRaySpeed * Math.sin(a))));
		}
	}

	public function fire():Void {
		if (firing) {
			var fireHitFrameStart:Int = 3; // The first frame in the fire animation to hit enemies with.
			var fireHitFrameEnd:Int = 6; // The last frame in the fire animation to hit enemies with.
			if (sprFire.frame >= fireHitFrameStart && sprFire.frame <= fireHitFrameEnd) {
				var vc:Array<Entity> = new Array<Entity>();
				for (i in 0...hitables.length) {
					FP.world.collideRectInto(hitables[i], x - sprFire.originX, y - sprFire.originY, sprFire.width, sprFire.height, vc);
					for (e in vc) {
						if (FP.distanceRects(x - originX, y - originY, width, height, e.x - e.originX, e.y - originY, e.width, e.height) > sprFire.width / 2)
							// Only take those in a radius around the player, to cut off corners.
						{
							{
								continue;
							}
						}
						genericHit(e, "Fire", fireForce, fireDamage);
					}
				}
			}
		} else if (fireTimer > 0) {
			fireTimer--;
		}
	}

	public function slashEnd():Void {
		slashing = false;
	}

	public function spearEnd():Void {
		spearing = false;
	}

	public function wandEnd():Void {
		wand();
		wanding = false;
	}

	public function fireEnd():Void {
		firing = false;
	}

	public function deathRayEnd():Void {
		deathRay();
		deathRaying = false;
	}

	public function genericHit(e:Entity, t:String = "", f:Float, d:Float):Void {
		if (Game.freezeObjects) {
			return;
		}
		if (Std.is(e, Enemy)) {
			if (Std.is(e, IceTurret)) {
				(try cast(e, IceTurret) catch (e:Dynamic) null).bump(new Point(x, y), t);
			}
			(try cast(e, Enemy) catch (e:Dynamic) null).hit(f, new Point(x, y), d, t);
		} else if (Std.is(e, Grass)) {
			(try cast(e, Grass) catch (e:Dynamic) null).cut(t);
		} else if (Std.is(e, BreakableRock)) {
			(try cast(e, BreakableRock) catch (e:Dynamic) null).hit((hasGhostSword) ? 1 : 0);
		} else if (Std.is(e, RopeStart)) {
			(try cast(e, RopeStart) catch (e:Dynamic) null).hit();
		} else if (Std.is(e, ShieldBoss)) {
			(try cast(e, ShieldBoss) catch (e:Dynamic) null).hit(0, null, d);
		} else if (Std.is(e, LightPole)) {
			if (t == "Spear") {
				(try cast(e, LightPole) catch (e:Dynamic) null).hit();
			}
		} else if (Std.is(e, Tree)) {
			(try cast(e, Tree) catch (e:Dynamic) null).hit(t);
		} else if (Std.is(e, Tile)) {
			if (t == "Spear") {
				(try cast(e, Tile) catch (e:Dynamic) null).bridgeOpeningTimer--;
			}
		} else if (Std.is(e, PushableBlockSpear)) {
			(try cast(e, PushableBlockSpear) catch (e:Dynamic) null).hit(new Point((spearDirection % 2 == 0 ? 1 : 0) * (spearDirection - 1),
				(spearDirection % 2 == 1 ? 1 : 0) * (2 - spearDirection)),
				t, true);
		} else if (Std.is(e, PushableBlockFire)) {
			(try cast(e, PushableBlockFire) catch (e:Dynamic) null).hit(new Point(x, y), t);
		} else if (Std.is(e, LavaBall)) {
			(try cast(e, LavaBall) catch (e:Dynamic) null).hit();
		} else if (Std.is(e, Watcher)) {
			(try cast(e, Watcher) catch (e:Dynamic) null).hit();
		}
	}

	public function addShield():Void {
		if (shieldObj == null && hasShield) {
			shieldObj = new Entity();
			shieldObj.type = "Shield";
			FP.world.add(shieldObj);
		}
	}

	override public function render():Void {
		if (directionFace >= 0) {
			if (direction == 2) {
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleX = -Math.abs((try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleX);
			} else {
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleX = Math.abs((try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleX);
			}
		} else if (v.x < 0) {
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleX = -Math.abs((try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleX);
		} else if (v.x > 0) {
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleX = Math.abs((try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleX);
		}
		if (direction == 1 || direction == 2) {
			sprShield.scaleX = -Math.abs(sprShield.scaleX);
		} else {
			sprShield.scaleX = Math.abs(sprShield.scaleX);
		}
		var shieldDraw:Bool = sprShrumDark.currentAnim != "dead" && sprShrumDark.currentAnim != "die";
		if (hasShield && shieldObj != null && shieldDraw) {
			if (direction == 1 && v.x == 0) {
				shieldObj.setHitbox(sprShield.width, sprShield.height, Std.int(sprShield.width / 2), Std.int(sprShield.height / 2));
				shieldObj.x = x - shieldOffset.x;
				shieldObj.y = y - shieldOffset.y + (slashing ? 1 : 0);
				sprShield.frame = 2 * (hasDarkShield ? 1 : 0);
				sprShield.alpha = (try cast(graphic, Image) catch (e:Dynamic) null).alpha;
				sprShield.render(new Point(shieldObj.x, shieldObj.y), FP.camera);
			}
		}
		if (spearing && spearDirection == 1) {
			renderSpear();
		}
		if (slashing && slashingSprite.currentAnim == "slashnarrow") {
			var tempAlpha:Float = (try cast(graphic, Image) catch (e:Dynamic) null).alpha;
			var numBlurs:Int = 4;
			var i:Int = numBlurs;
			while (i > 0) {
				(try cast(graphic, Image) catch (e:Dynamic) null).alpha = (numBlurs - i - 1) / numBlurs + 0.5;
				(try cast(graphic, Image) catch (e:Dynamic) null).render(new Point(x - i * v.x, y - i * v.y), FP.camera);
				if (hasDarkSuit) {
					Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
					(try cast(graphic, Image) catch (e:Dynamic) null).render(new Point(x - i * v.x, y - i * v.y), FP.camera);
					Draw.resetTarget();
				}
				i--;
			}
			(try cast(graphic, Image) catch (e:Dynamic) null).alpha = tempAlpha;
		}
		super.render();
		if (hasDarkSuit) {
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
		if (hasDarkShield && hasShield && shieldObj != null && shieldDraw) {
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			sprShield.render(new Point(shieldObj.x, shieldObj.y), FP.camera);
			Draw.resetTarget();
		}
		if (hasShield && shieldObj != null && shieldDraw) {
			if (direction == 3 && v.x == 0) {
				shieldObj.setHitbox(sprShield.width, sprShield.height, Std.int(sprShield.width / 2), Std.int(sprShield.height / 2));
				shieldObj.x = x + shieldOffset.x;
				shieldObj.y = y + shieldOffset.y - (slashing ? 1 : 0);
				sprShield.frame = 2 * (hasDarkShield ? 1 : 0);
				sprShield.alpha = (try cast(graphic, Image) catch (e:Dynamic) null).alpha;
				sprShield.render(new Point(shieldObj.x, shieldObj.y), FP.camera);
			} else if (v.x < 0 || (v.x == 0 && direction == 2)) {
				shieldObj.setHitbox(3, sprShield.height, 2, Std.int(sprShield.height / 2));
				shieldObj.x = x - shieldSideOffset.x;
				shieldObj.y = y + shieldSideOffset.y;
				sprShield.alpha = (try cast(graphic, Image) catch (e:Dynamic) null).alpha;
				sprShield.frame = 1 + 2 * (hasDarkShield ? 1 : 0);
				sprShield.render(new Point(shieldObj.x, shieldObj.y), FP.camera);
			} else if (v.x > 0 || (v.x == 0 && direction == 0)) {
				shieldObj.setHitbox(3, sprShield.height, 2, Std.int(sprShield.height / 2));
				shieldObj.x = x + shieldSideOffset.x;
				shieldObj.y = y + shieldSideOffset.y;
				sprShield.alpha = (try cast(graphic, Image) catch (e:Dynamic) null).alpha;
				sprShield.frame = 1 + 2 * (hasDarkShield ? 1 : 0);
				sprShield.render(new Point(shieldObj.x, shieldObj.y), FP.camera);
			}
		}
		if (slashing) {
			if (slashingSprite.currentAnim == "slashnarrow" && !hasGhostSword) {
				slashingSprite.scaleX = 1.5;
				slashingSprite.scaleY = 0.65;
			} else {
				slashingSprite.scaleX = slashingSprite.scaleY = 1;
			}

			slashingSprite.angle = 90 * slashDirection;
			if (hasGhostSword) {
				var animFrames:Int = ghostSwordAnimFrames[slashingSprite.currentAnim];
				slashingSprite.angle += 90 - 180 * slashingSprite.index / (animFrames - 1);
				slashingSprite.angle -= 45 * (slashingSprite.currentAnim == "slashnarrow" ? 1 : 0);
			}
			slashingSprite.render(new Point(x, y), FP.camera);
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			slashingSprite.alpha = 0.25;
			slashingSprite.render(new Point(x, y), FP.camera);
			slashingSprite.alpha = 1;
			Draw.resetTarget();
		}
		if (spearing && spearDirection != 1) {
			renderSpear();
		}
		if (wanding) {
			if (hasFireWand) {
				sprFireWand.angle = 90 * direction;
				sprFireWand.render(new Point(x, y), FP.camera);
			} else {
				sprWand.angle = 90 * direction;
				sprWand.render(new Point(x, y), FP.camera);
			}
		}
		if (deathRaying) {
			sprDeathRay.angle = 90 * direction;
			sprDeathRay.render(new Point(x, y), FP.camera);
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			sprDeathRay.render(new Point(x, y), FP.camera);
			Draw.resetTarget();
		}
		if (firing) {
			sprFire.render(new Point(x, y), FP.camera);
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			sprFire.render(new Point(x, y), FP.camera);
			var scChange:Float = 0.25;
			sprFire.scale += scChange;
			sprFire.render(new Point(x, y), FP.camera);
			sprFire.scale -= 2 * scChange;
			sprFire.render(new Point(x, y), FP.camera);
			sprFire.scale += scChange;
			Draw.resetTarget();
		}

		if (fireTimer > 0) {
			/*
				drawFireOver(0.2);
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				drawFireOver(0.8);
				Draw.resetTarget();
			 */
		}
	}

	private function get_spearX():Int {
		return Std.int(x + spearOffset.x * (spearDirection % 2) * (spearDirection - 2));
	}

	private function get_spearY():Int {
		return Std.int(y + spearOffset.y * (spearDirection % 2) + (1 - (spearDirection % 2)) + (spearDirection == 2 ? 1 : 0));
	}

	public function renderSpear():Void {
		var divisor:Float = 1.5;
		sprSpear.angle += FP.DEG * FP.angle_difference(90 * spearDirection * FP.RAD, sprSpear.angle * FP.RAD) / divisor;
		sprSpear.render(new Point(spearX, spearY), FP.camera);
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		sprSpear.render(new Point(spearX, spearY), FP.camera);
		Draw.resetTarget();
	}

	public function drawFireOver(a:Float = 1):Void {
		var rMin:Int = 4;
		var rMax:Int = 20;
		var extra:Int = 4;
		var r:Int = Std.int(rMin + fireTimer / fireTimerMax * (rMax - rMin)); // + Game.worldFrame(2) * extra;

		Draw.circlePlus(Std.int(x), Std.int(y), r, 0xFF0000, fireTimer / fireTimerMax * a);
		Draw.circlePlus(Std.int(x), Std.int(y), r * 2 / 3, 0xFF8800, fireTimer / fireTimerMax * a);
		Draw.circlePlus(Std.int(x), Std.int(y), r / 3, 0xFFFF00, fireTimer / fireTimerMax * a);

		(try cast(FP.world, Game) catch (e:Dynamic) null).drawCover(0xFF0000, fireTimer / fireTimerMax / 3);
	}

	public function hit(e:Enemy = null, f:Float = 0, p:Point = null, d:Float = 1):Void {
		if (hitsTimer <= 0 && hits < hitsMax && !Game.freezeObjects) {
			if (e != null && hasDarkSuit) {
				e.hit(darkSuitForce, new Point(x, y), darkSuitDamage, "Suit");
			}
			Music.playSound("Hurt");
			hits += d;
			hitsTimer = hitsTimerMax;
			Game.shake += 5;
			if (hits >= hitsMax) {
				die();
			} else {
				knockback(f, p);
			}
		}
	}

	public function hitUpdate():Void {
		Game.health(Std.int(hits), hitsMax);
		if (hitsTimer > 0) {
			if (hitsTimer % hitsTimerInt == 0) {
				if ((try cast(graphic, Image) catch (e:Dynamic) null).color != hitsColor) {
					(try cast(graphic, Image) catch (e:Dynamic) null).color = hitsColor;
				} else {
					(try cast(graphic, Image) catch (e:Dynamic) null).color = normalColor;
				}
			}
			hitsTimer--;
			if (hitsTimer <= 0) {
				(try cast(graphic, Image) catch (e:Dynamic) null).color = normalColor;
				// watch out--this is a color resetter
				direction = directionFace;
				directionFace = -1;
			}
		}
	}

	public function drown():Void {
		drownTimer = (drownTimer - 0.5 + drownTimerMax) % drownTimerMax;
		v.x = Math.cos(drownTimer / drownTimerMax * 2 * Math.PI);
		v.y = Math.sin(drownTimer / drownTimerMax * 2 * Math.PI) * 2;
		dying = true;
		if (drownTimer <= 0)
			// x = lastPosition.x;
		{
			// y = lastPosition.y;
			// (FP.world as Game).playerPosition = new Point(Math.floor(x/Tile.w)*Tile.w, Math.floor(y/Tile.h)*Tile.h);
			die();
		}
	}

	public function checkDrowning():Void {
		if (drowning) {
			drown();
		} else {
			var v:Int = 0;
			if (state == 1 && !canSwim /*Water*/) {
				v = 1;
			} else if (state == 17 && !hasDarkSuit /*Lava*/) {
				v = 2;
			}
			if (v > 0) {
				if (v == 2) {
					hit(null, 0, null, 0);
				}
				if (drownTimer <= 0) {
					drownTimer = drownTimerMax;
				} else {
					drownTimer--;
					if (drownTimer <= 0) {
						drownTimer = 0;
						drowning = true;
					}
				}
			}
		}
	}

	public function die():Void {
		dying = true;
		(try cast(FP.world, Game) catch (e:Dynamic) null).restartLevel();
	}

	public function knockback(f:Float = 0, p:Point = null):Void {
		if (p != null)
			// If the player is bumped, make him face the direction he's facing until input
		{
			if (hitsTimer > 0) {
				directionFace = direction;
			}
			var center:Point = new Point(x - p.x, y - p.y);
			center.normalize(1);
			if (Math.abs(center.x) >= 0.5) {
				v.x += f * center.x;
			}
			if (Math.abs(center.y) > 0.5) {
				v.y += f * center.y;
			}
		}
	}

	override public function input():Void {
		if (Preloader.sponsorVersion) {
			extraInputs();
		}

		if (!receiveInput || frozenTimer > 0 || fallFromCeiling) {
			return;
		}
		var accel:Float = moveSpeed;
		if (hitsTimer <= 0) {
			if (Input.check(keys[1])) {
				if (v.y > -moveSpeed) {
					v.y -= accel;
				}
			}
			if (Input.check(keys[0])) {
				if (v.x < moveSpeed) {
					v.x += accel;
				}
			}
			if (Input.check(keys[3])) {
				if (v.y < moveSpeed) {
					v.y += accel;
				}
			}
			if (Input.check(keys[2])) {
				if (v.x > -moveSpeed) {
					v.x -= accel;
				}
			}
		}
		if (onWaterfall && (!hasFeather || v.y >= 0)) {
			v.y += waterfallAcceleration;
		}
		if (Input.pressed(keys[4])) {
			useItem(Main.primary);
		}
		if (Input.pressed(keys[5])) {
			useItem(Main.secondary);
		}
		if (Input.pressed(Key.W)) {
			new GetURL("http://rekcahdam.bandcamp.com/album/seedling-ost");
		}
	}

	public function useItem(i:Int):Void {
		switch (Inventory.getItem(i)) {
			case 0, 4:
				if (slashDelay <= 0) {
					slashing = true;
				}
			case 1:
				if (!firing) {
					firing = true;
				}
			case 2:
				if (!wanding) {
					wanding = true;
				}
			case 5:
				if (!wanding) {
					wanding = true;
				}
				if (!firing) {
					firing = true;
				}
			case 3:
				if (!spearing) {
					spearing = true;
				}
			default:
		}
	}

	public function sprites():Void {
		slashingSprite.update();
		sprSpear.update();
		sprWand.update();
		sprDeathRay.update();
		sprFire.update();
		sprFireWand.update();
		if (directionFace >= 0) {
			direction = directionFace;
		} else if (v.x < 0) {
			direction = 2;
		} else if (v.x > 0) {
			direction = 0;
		} else if (v.y < 0) {
			direction = 1;
		} else if (v.y > 0) {
			direction = 3;
		}

		switch (direction) {
			case 0:
				myLightPosition = new Point(-6, -5);
			case 1:
				myLightPosition = new Point(0, 5);
			case 2:
				myLightPosition = new Point(6, -5);
			case 3:
				myLightPosition = new Point(0, -6);
			default:
				myLightPosition = new Point();
		}

		if (sprShrumDark.currentAnim == "dead" || sprShrumDark.currentAnim == "die") {
			return;
		}
		if ((v.x != 0 && directionFace != 1 && directionFace != 3) || directionFace == 0 || directionFace == 2) {
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).play(states[state] + "side-walk");
		} else if ((v.y < 0 && directionFace != 3) || directionFace == 1) {
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).play(states[state] + "up-walk");
		} else if (v.y > 0 || directionFace == 3) {
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).play(states[state] + "down-walk");
		}

		if ((v.x == 0 && v.y == 0) || Game.freezeObjects) {
			switch (direction) {
				case 1:
					(try cast(graphic, Spritemap) catch (e:Dynamic) null).play(states[state] + "up-stand");
				case 3:
					(try cast(graphic, Spritemap) catch (e:Dynamic) null).play(states[state] + "down-stand");
				default:
					(try cast(graphic, Spritemap) catch (e:Dynamic) null).play(states[state] + "side-stand");
			}
		}
	}

	public function shieldBump():Void {
		if (shieldObj != null && v.length > 0) {
			var c_s_pos:Array<Enemy> = new Array<Enemy>();
			shieldObj.collideTypesInto(enemies, shieldObj.x, shieldObj.y, c_s_pos);
			for (o in c_s_pos) {
				if (hasDarkShield && o.hitsTimer <= 0)
					// Hit enemy if he's not already hit, so that he'll at least bounce
				{
					{
						o.hit(shieldForce, new Point(x, y), darkShieldDamage, "Shield");
					}
				} else {
					o.knockback(shieldForce, new Point(x, y));
				}
			}
		}
	}

	public static function hasAllTotemParts():Bool {
		for (i in 0...totemParts) {
			if (!hasTotemPart(i)) {
				return false;
			}
		}
		return true;
	}

	override public function moveX(_xrel:Float):Entity {
		for (i in 0...Std.int(Math.abs(_xrel))) {
			var d:Float = Math.min(1, Math.abs(_xrel) - i) * FP.sign(_xrel);
			var c_s:Entity = null;
			if (shieldObj != null) {
				c_s = null;
			}
			var c:Entity = collideTypes(solids, x + d, y);
			if (c == null && (c_s == null || hitsTimer > 0)) {
				x += Std.int(d);
			} else if (c != null) {
				return c;
			} else {
				return c_s;
			}
		}
		return null;
	}

	override public function moveY(_yrel:Float):Entity {
		for (i in 0...Std.int(Math.abs(_yrel))) {
			var d:Float = Math.min(1, Math.abs(_yrel) - i) * FP.sign(_yrel);
			var c_s:Entity = null;
			if (shieldObj != null) {
				c_s = null;
			}
			var c:Entity = collideTypes(solids, x, y + d);
			if (c == null && (c_s == null || hitsTimer > 0)) {
				y += Std.int(d);
			} else if (c != null) {
				return c;
			} else {
				return c_s;
			}
		}
		return null;
	}

	public function extraInputs():Void /* 
	 * For the love of god, please make sure you remove this.
	 */ {
		/*if (Input.released(Key.T))
			{
				Main.printItems();
			}
			if (Input.released(Key.E))
			{
				//FP.world = new Game(68, 16, 64); //Health
				//FP.world = new Game(30, 64, 128); //Lighting the Path
				//FP.world = new Game(19, 16, 144); //Fall of the Shieldspire
				//FP.world = new Game(32, 72, 128); //Fall of Time
				//FP.world = new Game(40, 400, 432); //Fall of the Totem
				//FP.world = new Game(56, 96, 32); //Fall of the Tentacled Beast
				//FP.world = new Game(69, 32, 32); //Fall of the Lights
				//FP.world = new Game(71, 208, 224); //Fall of the King of Fire
				//FP.world = new Game(111, 128, 64); //Fall of the Owl
				//FP.world = new Game(113, 64, 80); //Bloody
				//FP.world = new Game(11, 32, 64);// 115, 64, 128); //Bloodless
		}*/

		if (Input.released(Key.DIGIT_1)) {
			Main.clearSave();
			Main.primary = Main.secondary = 0;
			hasSword = hasFire = hasShield = hasWand = hasDarkSword = hasDarkShield = hasDarkSuit = canSwim = hasFeather = hasSpear = hasFireWand = hasGhostSword = hasTorch = Main.beam = Main.rockSet = false;

			hasTotemPartSet(0, false);
			hasTotemPartSet(1, false);
			hasTotemPartSet(2, false);
			hasTotemPartSet(3, false);
			hasTotemPartSet(4, false);

			hasKeySet(0, false);
			hasKeySet(1, false);
			hasKeySet(2, false);
			hasKeySet(3, false);
			hasKeySet(4, false);
			FP.world = new Game(2, 48, 32);
		} else if (Input.released(Key.DIGIT_2)) {
			Main.clearSave();
			Main.primary = Main.secondary = 0;
			hasSword = true;
			hasFire = hasShield = hasWand = hasDarkSword = hasDarkShield = hasDarkSuit = canSwim = hasFeather = hasSpear = hasFireWand = hasGhostSword = hasTorch = Main.beam = Main.rockSet = false;

			hasTotemPartSet(0, false);
			hasTotemPartSet(1, false);
			hasTotemPartSet(2, false);
			hasTotemPartSet(3, false);
			hasTotemPartSet(4, false);

			hasKeySet(0, false);
			hasKeySet(1, false);
			hasKeySet(2, false);
			hasKeySet(3, false);
			hasKeySet(4, false);
			FP.world = new Game(13, 64, 128);
		} else if (Input.released(Key.DIGIT_3)) {
			Main.clearSave();
			Main.primary = Main.secondary = 0;
			hasSword = hasShield = true;
			hasFire = hasWand = hasDarkSword = hasDarkShield = hasDarkSuit = canSwim = hasFeather = hasSpear = hasFireWand = hasGhostSword = hasTorch = Main.beam = false;
			Main.rockSet = true;

			hasTotemPartSet(0, false);
			hasTotemPartSet(1, false);
			hasTotemPartSet(2, false);
			hasTotemPartSet(3, false);
			hasTotemPartSet(4, false);

			hasKeySet(0, true);
			hasKeySet(1, false);
			hasKeySet(2, false);
			hasKeySet(3, false);
			hasKeySet(4, false);
			FP.world = new Game(12, 576, 624);
		} else if (Input.released(Key.DIGIT_4)) {
			Main.clearSave();
			Main.primary = Main.secondary = 0;
			hasSword = hasShield = hasFire = hasTorch = true;
			hasWand = hasDarkSword = hasDarkShield = hasDarkSuit = canSwim = hasFeather = hasSpear = hasFireWand = hasGhostSword = Main.beam = false;
			Main.rockSet = true;

			hasTotemPartSet(0, false);
			hasTotemPartSet(1, false);
			hasTotemPartSet(2, false);
			hasTotemPartSet(3, false);
			hasTotemPartSet(4, false);

			hasKeySet(0, true);
			hasKeySet(1, true);
			hasKeySet(2, false);
			hasKeySet(3, false);
			hasKeySet(4, false);
			FP.world = new Game(37, 288, 176);
		} else if (Input.released(Key.DIGIT_5)) {
			Main.clearSave();
			Main.primary = Main.secondary = 0;
			Inventory.help = false;
			hasSword = hasShield = hasFire = hasTorch = hasWand = true;
			hasDarkSword = hasDarkShield = hasDarkSuit = canSwim = hasFeather = hasSpear = hasFireWand = hasGhostSword = Main.beam = false;
			Main.rockSet = true;

			hasTotemPartSet(0, true);
			hasTotemPartSet(1, true);
			hasTotemPartSet(2, true);
			hasTotemPartSet(3, true);
			hasTotemPartSet(4, true);

			hasKeySet(0, true);
			hasKeySet(1, true);
			hasKeySet(2, true);
			hasKeySet(3, false);
			hasKeySet(4, false);
			FP.world = new Game(45, 112, 288);
		} else if (Input.released(Key.DIGIT_6)) {
			Main.clearSave();
			Main.primary = Main.secondary = 0;
			Inventory.help = false;
			hasSword = hasShield = hasFire = hasTorch = hasWand = canSwim = true;
			hasDarkSword = hasDarkShield = hasDarkSuit = hasFeather = hasSpear = hasFireWand = hasGhostSword = Main.beam = false;
			Main.rockSet = true;

			hasTotemPartSet(0, true);
			hasTotemPartSet(1, true);
			hasTotemPartSet(2, true);
			hasTotemPartSet(3, true);
			hasTotemPartSet(4, true);

			hasKeySet(0, true);
			hasKeySet(1, true);
			hasKeySet(2, true);
			hasKeySet(3, true);
			hasKeySet(4, false);
			FP.world = new Game(95, 560, 80);
		} else if (Input.released(Key.DIGIT_7)) {
			Main.clearSave();
			Main.primary = Main.secondary = 0;
			Inventory.help = false;
			hasSword = hasShield = hasFire = hasTorch = hasWand = canSwim = hasSpear = true;
			hasDarkSword = hasDarkShield = hasDarkSuit = hasFeather = hasFireWand = hasGhostSword = Main.beam = false;
			Main.rockSet = true;

			hasTotemPartSet(0, true);
			hasTotemPartSet(1, true);
			hasTotemPartSet(2, true);
			hasTotemPartSet(3, true);
			hasTotemPartSet(4, true);

			hasKeySet(0, true);
			hasKeySet(1, true);
			hasKeySet(2, true);
			hasKeySet(3, true);
			hasKeySet(4, true);
			FP.world = new Game(12, 32, 896);
		} else if (Input.released(Key.DIGIT_8)) {
			Main.clearSave();
			Main.primary = Main.secondary = 0;
			Inventory.help = false;
			hasSword = hasShield = hasFire = hasTorch = hasWand = canSwim = hasSpear = hasDarkShield = hasDarkSuit = hasFeather = true;
			hasDarkSword = hasFireWand = hasGhostSword = Main.beam = false;
			Main.rockSet = true;

			hasTotemPartSet(0, true);
			hasTotemPartSet(1, true);
			hasTotemPartSet(2, true);
			hasTotemPartSet(3, true);
			hasTotemPartSet(4, true);

			hasKeySet(0, true);
			hasKeySet(1, true);
			hasKeySet(2, true);
			hasKeySet(3, true);
			hasKeySet(4, true);
			FP.world = new Game(93, 112, 256);
		} else if (Input.released(Key.DIGIT_9)) {
			Main.clearSave();
			Main.primary = Main.secondary = 0;
			Inventory.help = false;
			hasSword = hasShield = hasFire = hasTorch = hasWand = canSwim = hasSpear = hasDarkShield = hasDarkSuit = hasFeather = hasFireWand = hasGhostSword = true;
			hasDarkSword = Main.beam = false;
			Main.rockSet = true;

			hasTotemPartSet(0, true);
			hasTotemPartSet(1, true);
			hasTotemPartSet(2, true);
			hasTotemPartSet(3, true);
			hasTotemPartSet(4, true);

			hasKeySet(0, true);
			hasKeySet(1, true);
			hasKeySet(2, true);
			hasKeySet(3, true);
			hasKeySet(4, true);
			FP.world = new Game(110, 64, 48);
		}
	}
}
