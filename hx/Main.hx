import openfl.utils.Assets;
import openfl.display.BitmapData;
/*
	import com.newgrounds.*;
	import com.newgrounds.components.MedalPopup;
 */
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.media.SoundTransform;
import openfl.net.SharedObject;
import net.flashpunk.Engine;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class Main extends Engine {
	public static var hasSword(get, set):Bool;
	public static var hasGhostSword(get, set):Bool;
	public static var hasShield(get, set):Bool;
	public static var hasFire(get, set):Bool;
	public static var hasWand(get, set):Bool;
	public static var hasFireWand(get, set):Bool;
	public static var canSwim(get, set):Bool;
	public static var hasSpear(get, set):Bool;
	public static var hasDarkShield(get, set):Bool;
	public static var hasDarkSuit(get, set):Bool;
	public static var hasDarkSword(get, set):Bool;
	public static var hasFeather(get, set):Bool;
	public static var hasTorch(get, set):Bool;
	public static var beam(get, set):Bool;
	public static var rockSet(get, set):Bool;
	public static var hitsMax(get, set):Int;
	public static var firstUse(get, set):Bool;
	public static var extended(get, set):Bool;
	public static var time(get, set):Float;
	public static var primary(get, set):Int;
	public static var secondary(get, set):Int;
	public static var grassCut(get, set):Int;
	public static var playerPositionX(get, set):Int;
	public static var playerPositionY(get, set):Int;
	public static var level(get, set):Int;

	public static inline var SAVE_NAME:String = "shrumsave";
	public static var SAVE_FILE:SharedObject;
	public static var tempPersistence:Array<Dynamic>;
	public static var badges:Array<String> = [
		"The Quest",
		"Sardol",
		"Mower",
		"Lighting the Path",
		"Health",
		"Fall of Time",
		"Fall of the Totem",
		"Fall of the Tentacled Beast",
		"Fall of the Shieldspire",
		"Fall of the Owl",
		"Fall of the Lights",
		"Fall of the King of Fire",
		"Enchantments",
		"Bloody",
		"Bloodless"
	];

	public static inline var FPS:Int = 60;

	// public static var medals : Array<MedalPopup> = new Array<MedalPopup>();
	private static var READY_TO_SUBMIT_BADGES:Bool = false;
	private static var SUBMITTED_BADGES:Bool = false;

	public function new() {
		super(160, 160, FPS);
		begin();
	}

	public static function begin():Void // if (Preloader.CONNORULLMANN || Preloader.NEWGROUNDS)
	{
		// {
		SAVE_FILE = SharedObject.getLocal(SAVE_NAME);
		startSave();
		printItems();

		Music.begin();

		FP.world = new Splash(); // Game(level, playerPositionX, playerPositionY);// Splash();

		FP.screen.color = 0x000000;
		FP.screen.scale = 3;

		// var popup : MedalPopup = new MedalPopup();
		// FP.engine.addChild(popup);
	}

	override public function update():Void {
		super.update();
		Music.update();

		if (READY_TO_SUBMIT_BADGES && QuickKong.LOADED && !SUBMITTED_BADGES) {
			for (i in 0...Main.badges.length) {
				if (Main.hasBadge(Main.badges[i])) {
					Main.unlockMedal(Main.badges[i]);
				} else {
					QuickKong.stats.submit(Main.badges[i], 0);
				}
			}
			SUBMITTED_BADGES = true;
		}
	}

	public static function printItems():Void {
		var i:Int = 0;
		trace("-------------------------");
		trace("P-Pos:    " + playerPositionX + ", " + playerPositionY);
		trace("Level:    " + level);
		trace("Item <X>: " + primary);
		trace("Item <C>: " + secondary);
		trace("Grass cut:" + grassCut);

		/*trace("Sword:    " + hasSword);
			trace("G-Sword:  " + hasGhostSword);
			trace("Shield:   " + hasShield);
			trace("Fire:     " + hasFire);
			trace("Wand:     " + hasWand);
			trace("Fire Wand:" + hasFireWand);
			trace("Swim:     " + canSwim);
			trace("Spear:    " + hasSpear);
			trace("D-Shield: " + hasDarkShield);
			trace("D-Suit:   " + hasDarkSuit);
			trace("D-Sword:  " + hasDarkSword);
			trace("Feather:  " + hasFeather);
			trace("Torch:    " + hasTorch);
			trace("Beam:     " + beam);
			trace("Rock Set: " + rockSet);
			trace("Hits Max: " + hitsMax);
			trace("First Use:" + firstUse); //Inventory first used
			trace("Extended: " + extended); //Inventory all the way out

			trace("Totem Parts:");
			for (i = 0; i < SAVE_FILE.data.hasTotemPart.length; i++)
			{
				trace(i + ": " + hasTotemPart(i));
			}
			trace("Keys:");
			for (i = 0; i < SAVE_FILE.data.hasKey.length; i++)
			{
				trace(i + ": " + hasKey(i));
			}
			for (i = 0; i < SAVE_FILE.data.hasSealPart.length; i++)
			{
				trace(i + ": " + hasSealPart(i));
			}
		 */

		var s:String = "";
		for (i in 0...Game.tagsPerLevel) {
			s += Std.string(levelPersistence(Std.int(Math.max(level, 0)), i) ? 1 : 0);
		}
		trace(level + ": " + s);
	}

	private static function get_hasSword():Bool {
		return SAVE_FILE.data.hasSword;
	}

	private static function get_hasGhostSword():Bool {
		return SAVE_FILE.data.hasGhostSword;
	}

	private static function get_hasShield():Bool {
		return SAVE_FILE.data.hasShield;
	}

	private static function get_hasFire():Bool {
		return SAVE_FILE.data.hasFire;
	}

	private static function get_hasWand():Bool {
		return SAVE_FILE.data.hasWand;
	}

	private static function get_hasFireWand():Bool {
		return SAVE_FILE.data.hasFireWand;
	}

	private static function get_canSwim():Bool {
		return SAVE_FILE.data.canSwim;
	}

	private static function get_hasSpear():Bool {
		return SAVE_FILE.data.hasSpear;
	}

	private static function get_hasDarkShield():Bool {
		return SAVE_FILE.data.hasDarkShield;
	}

	private static function get_hasDarkSuit():Bool {
		return SAVE_FILE.data.hasDarkSuit;
	}

	private static function get_hasDarkSword():Bool {
		return SAVE_FILE.data.hasDarkSword;
	}

	private static function get_hasFeather():Bool {
		return SAVE_FILE.data.hasFeather;
	}

	private static function get_hasTorch():Bool {
		return SAVE_FILE.data.hasTorch;
	}

	private static function get_beam():Bool {
		return SAVE_FILE.data.beam;
	}

	private static function get_rockSet():Bool {
		return SAVE_FILE.data.rockSet;
	}

	private static function get_hitsMax():Int {
		if (!SAVE_FILE.data.hitsMax) {
			return Player.hitsMaxDef;
		}
		return SAVE_FILE.data.hitsMax;
	}

	private static function get_firstUse():Bool {
		return SAVE_FILE.data.firstUse;
	}

	private static function get_extended():Bool {
		return SAVE_FILE.data.extended;
	}

	private static function get_time():Float {
		if (!SAVE_FILE.data.time) {
			return Game.dayLength / 2;
		}
		return SAVE_FILE.data.time;
	}

	private static function get_primary():Int {
		if (!SAVE_FILE.data.primary) {
			return 0;
		}
		return SAVE_FILE.data.primary;
	}

	private static function get_secondary():Int {
		if (!SAVE_FILE.data.secondary) {
			return 0;
		}
		return SAVE_FILE.data.secondary;
	}

	private static function get_grassCut():Int {
		if (!SAVE_FILE.data.grassCut) {
			return 0;
		}
		return SAVE_FILE.data.grassCut;
	}

	public static function hasKey(i:Int):Bool {
		return SAVE_FILE.data.hasKey[i];
	}

	public static function hasTotemPart(i:Int):Bool {
		return SAVE_FILE.data.hasTotemPart[i];
	}

	public static function hasSealPart(i:Int):Int {
		return SAVE_FILE.data.hasSealPart[i];
	}

	public static function hasBadge(s:String):Bool {
		var _hasBadgeTemp:Map<String, Bool> = cast SAVE_FILE.data.hasBadge;
		return _hasBadgeTemp[s];
	}

	private static function set_hasSword(_t:Bool):Bool {
		SAVE_FILE.data.hasSword = _t;
		return _t;
	}

	private static function set_hasGhostSword(_t:Bool):Bool {
		SAVE_FILE.data.hasGhostSword = _t;
		return _t;
	}

	private static function set_hasShield(_t:Bool):Bool {
		SAVE_FILE.data.hasShield = _t;
		return _t;
	}

	private static function set_hasFire(_t:Bool):Bool {
		SAVE_FILE.data.hasFire = _t;
		return _t;
	}

	private static function set_hasWand(_t:Bool):Bool {
		SAVE_FILE.data.hasWand = _t;
		return _t;
	}

	private static function set_hasFireWand(_t:Bool):Bool {
		SAVE_FILE.data.hasFireWand = _t;
		return _t;
	}

	private static function set_canSwim(_t:Bool):Bool {
		SAVE_FILE.data.canSwim = _t;
		return _t;
	}

	private static function set_hasSpear(_t:Bool):Bool {
		SAVE_FILE.data.hasSpear = _t;
		return _t;
	}

	private static function set_hasDarkShield(_t:Bool):Bool {
		SAVE_FILE.data.hasDarkShield = _t;
		return _t;
	}

	private static function set_hasDarkSuit(_t:Bool):Bool {
		SAVE_FILE.data.hasDarkSuit = _t;
		return _t;
	}

	private static function set_hasDarkSword(_t:Bool):Bool {
		SAVE_FILE.data.hasDarkSword = _t;
		return _t;
	}

	private static function set_hasFeather(_t:Bool):Bool {
		SAVE_FILE.data.hasFeather = _t;
		return _t;
	}

	private static function set_hasTorch(_t:Bool):Bool {
		SAVE_FILE.data.hasTorch = _t;
		return _t;
	}

	private static function set_beam(_t:Bool):Bool {
		SAVE_FILE.data.beam = _t;
		return _t;
	}

	private static function set_rockSet(_t:Bool):Bool {
		SAVE_FILE.data.rockSet = _t;
		return _t;
	}

	private static function set_hitsMax(_t:Int):Int {
		SAVE_FILE.data.hitsMax = _t;
		return _t;
	}

	private static function set_firstUse(_t:Bool):Bool {
		SAVE_FILE.data.firstUse = _t;
		return _t;
	}

	private static function set_extended(_t:Bool):Bool {
		SAVE_FILE.data.extended = _t;
		return _t;
	}

	private static function set_time(_t:Float):Float {
		SAVE_FILE.data.time = _t;
		return _t;
	}

	private static function set_primary(_t:Int):Int {
		SAVE_FILE.data.primary = _t;
		return _t;
	}

	private static function set_secondary(_t:Int):Int {
		SAVE_FILE.data.secondary = _t;
		return _t;
	}

	private static function set_grassCut(_t:Int):Int {
		SAVE_FILE.data.grassCut = _t;
		if (SAVE_FILE.data.grassCut >= 10000) {
			unlockMedal(Main.badges[2]);
		}
		return _t;
	}

	public static function hasKeySet(i:Int, _t:Bool):Void {
		SAVE_FILE.data.hasKey[i] = _t;
	}

	public static function hasTotemPartSet(i:Int, _t:Bool):Void {
		SAVE_FILE.data.hasTotemPart[i] = _t;
	}

	public static function hasSealPartSet(i:Int, _t:Int):Void {
		SAVE_FILE.data.hasSealPart[i] = _t;
	}

	public static function hasBadgeSet(s:String, _t:Bool):Void {
		var _hasBadgeTemp:Map<String, Bool> = cast SAVE_FILE.data.hasBadge;
		_hasBadgeTemp[s] = _t;
	}

	private static function get_playerPositionX():Int {
		if (!SAVE_FILE.data.playerPositionX) {
			return 0;
		}
		return SAVE_FILE.data.playerPositionX;
	}

	private static function get_playerPositionY():Int {
		if (!SAVE_FILE.data.playerPositionY) {
			return 0;
		}
		return SAVE_FILE.data.playerPositionY;
	}

	private static function set_playerPositionX(i:Int):Int {
		SAVE_FILE.data.playerPositionX = i;
		return i;
	}

	private static function set_playerPositionY(i:Int):Int {
		SAVE_FILE.data.playerPositionY = i;
		return i;
	}

	private static function get_level():Int {
		if (SAVE_FILE.data.level == null) {
			return -1;
		}
		return SAVE_FILE.data.level;
	}

	private static function set_level(i:Int):Int {
		SAVE_FILE.data.level = i;
		return i;
	}

	public static function levelPersistence(i:Int, j:Int):Bool {
		var persistence:Array<Bool> = cast(SAVE_FILE.data.levelPersistence); // TODO: This fixes typing on HL.  Behaves correctly on save?
		return persistence[i * Game.tagsPerLevel + j];
	}

	public static function levelPersistenceSet(i:Int, j:Int, _t:Bool):Void {
		var pos:Int = i * Game.tagsPerLevel + j;
		if (pos < 0) {
			trace('Attempted to write to negative tag $pos (i=$i, j=$j, _t=$_t)');
			return;
		}

		var persistence:Array<Bool> = cast(SAVE_FILE.data.levelPersistence);
		SAVE_FILE.data.levelPersistence[pos] = _t;
	}

	public static function clearSave():Void {
		SAVE_FILE.clear();
		Inventory.clearItems();
		begin();
	}

	public static function unlockMedal(medal:String):Void {
		if (Preloader.ARMORGAMES) {
			return;
		}
		if (Preloader.KONGREGATE) {
			QuickKong.stats.submit(medal, 1);
			hasBadgeSet(medal, true);
			return;
		}
		/* var m : Medal = API.getMedal(medal);
			if (m == null || (m != null && m.unlocked))
			{
				return;
			}
			m.unlock(); */
	}

	/*
	 * Initializes all of the save values to whatever they're saved to be--if null, then it turns to false.
	 */
	public static function startSave():Void {
		hasSword = hasSword;
		hasGhostSword = hasGhostSword;
		hasShield = hasShield;
		hasFire = hasFire;
		hasWand = hasWand;
		hasFireWand = hasFireWand;
		canSwim = canSwim;
		hasSpear = hasSpear;
		hasDarkShield = hasDarkShield;
		hasDarkSuit = hasDarkSuit;
		hasDarkSword = hasDarkSword;
		hasFeather = hasFeather;
		hasTorch = hasTorch;
		beam = beam;
		rockSet = rockSet;
		hitsMax = hitsMax;
		firstUse = firstUse;
		extended = extended;
		time = time;
		primary = primary;
		secondary = secondary;
		grassCut = grassCut;

		if (!SAVE_FILE.data.hasBadge) {
			var _hasBadge:Map<String, Bool> = new Map();
			for (i in 0...badges.length) {
				_hasBadge[badges[i]] = false;
			}
			SAVE_FILE.data.hasBadge = _hasBadge;
		} else {
			for (i in 0...badges.length) {
				hasBadgeSet(badges[i], hasBadge(badges[i]));
			}
		}
		if (!SAVE_FILE.data.hasKey) {
			var _hasKey:Array<Dynamic> = [];
			for (i in 0...Player.totalKeys) {
				_hasKey[i] = false;
			}
			SAVE_FILE.data.hasKey = _hasKey;
		} else {
			for (i in 0...Player.totalKeys) {
				hasKeySet(i, hasKey(i));
			}
		}
		if (!SAVE_FILE.data.hasTotemPart) {
			var _hasTotemPart:Array<Dynamic> = [];
			for (i in 0...Player.totemParts) {
				_hasTotemPart[i] = false;
			}
			SAVE_FILE.data.hasTotemPart = _hasTotemPart;
		} else {
			for (i in 0...Player.totemParts) {
				hasTotemPartSet(i, hasTotemPart(i));
			}
		}
		if (!SAVE_FILE.data.hasSealPart) {
			var _hasSealPart:Array<Dynamic> = [];
			for (i in 0...SealController.SEALS) {
				_hasSealPart[i] = -1;
			}
			SAVE_FILE.data.hasSealPart = _hasSealPart;
		} else {
			for (i in 0...SealController.SEALS) {
				hasSealPartSet(i, hasSealPart(i));
			}
		}
		if (!SAVE_FILE.data.levelPersistence) {
			var tempPersistence:Array<Bool> = [];
			for (i in 0...Game.levels.length) {
				for (j in 0...Game.tagsPerLevel) {
					tempPersistence.push(true);
				}
			}
			SAVE_FILE.data.levelPersistence = tempPersistence;
			trace("NO LEVEL PERSISTENCE:   " + SAVE_FILE.data.levelPersistence.length);
		}

		playerPositionX = playerPositionX;
		playerPositionY = playerPositionY;
		level = level;

		READY_TO_SUBMIT_BADGES = true;
	}
}
