import openfl.utils.Assets;
import openfl.display.BitmapData;
import enemies.*;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.filters.ColorMatrixFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.graphics.Text;
import net.flashpunk.Tween;
import net.flashpunk.World;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.utils.Input;
import net.flashpunk.utils.Key;
import openfl.geom.Point;
import net.flashpunk.utils.Draw;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;
import nPCs.AdnanCharacter;
import nPCs.ForestCharacter;
import nPCs.Help;
import nPCs.Hermit;
import nPCs.IntroCharacter;
import nPCs.Karlore;
import nPCs.Oracle;
import nPCs.Rekcahdam;
import nPCs.Sensei;
import nPCs.Sign;
import nPCs.Statue;
import nPCs.Totem;
import nPCs.Watcher;
import nPCs.Witch;
import nPCs.Yeti;
import scenery.*;
import puzzlements.*;
import pickups.*;
import openfl.display.BlendMode;
import net.flashpunk.utils.Ease;
import haxe.xml.Access;
import openfl.utils.Dictionary;

/**
 * ...
 * @author Time
 */
class Game extends World {
	public static var time(get, set):Float;
	public static var moonrockSet(get, set):Bool;

	public var level(get, set):Int;
	public var playerPosition(get, set):Point;

	public static var talkingText(get, set):String;
	public static var cameraTarget(get, set):Point;

	public static var OverWorld1:String;
	public static var Building1:String;

	public static var Dungeon1_Entrance:String;
	public static var Dungeon1_1:String;
	public static var Dungeon1_2:String;
	public static var Dungeon1_3:String;
	public static var Dungeon1_4:String;
	public static var Dungeon1_5:String;
	public static var Dungeon1_6:String;
	public static var Dungeon1_7:String;
	public static var Dungeon1_8:String;
	public static var Dungeon1_9:String;

	public static var OverWorld1_1:String;

	public static var Dungeon2_Entrance:String;
	public static var Dungeon2_1:String;
	public static var Dungeon2_2:String;
	public static var Dungeon2_3:String;
	public static var Dungeon2_4:String;
	public static var Dungeon2_5:String;
	public static var Dungeon2_Boss:String;
	public static var Dungeon2_7:String;

	public static var Dungeon3_Entrance:String;
	public static var Dungeon3_1:String;
	public static var Dungeon3_2:String;
	public static var Dungeon3_3:String;
	public static var Dungeon3_4:String;
	public static var Dungeon3_5:String;
	public static var Dungeon3_6:String;
	public static var Dungeon3_7:String;
	public static var Dungeon3_8:String;
	public static var Dungeon3_9:String;
	public static var Dungeon3_10:String;
	public static var Dungeon3_Boss:String;

	public static var OverWorld1_witchhut:String;
	public static var OverWorld1_barhouse:String;
	public static var OverWorld1_blandashurmin:String;
	public static var OverWorld1_intree:String;
	public static var OverWorld1_2:String;

	public static var Dungeon4_Entrance:String;
	public static var Dungeon4_1:String;
	public static var Dungeon4_2:String;
	public static var Dungeon4_3:String;
	public static var Dungeon4_4:String;
	public static var Dungeon4_Boss:String;

	public static var OverWorld1_3:String;

	public static var Dungeon5_Entrance:String;
	public static var Dungeon5_1:String;
	public static var Dungeon5_2:String;
	public static var Dungeon5_3:String;
	public static var Dungeon5_4:String;
	public static var Dungeon5_5:String;
	public static var Dungeon5_6:String;
	public static var Dungeon5_7:String;
	public static var Dungeon5_8:String;
	public static var Dungeon5_9:String;
	public static var Dungeon5_10:String;
	public static var Dungeon5_11:String;
	public static var Dungeon5_Boss:String;
	public static var Dungeon5_DeadBoss:String;

	public static var Dungeon6_Entrance:String;
	public static var Dungeon6_1:String;
	public static var Dungeon6_2:String;
	public static var Dungeon6_3:String;
	public static var Dungeon6_4:String;
	public static var Dungeon6_5:String;
	public static var Dungeon6_6:String;
	public static var Dungeon6_7:String;
	public static var Dungeon6_8:String;
	public static var Dungeon6_9:String;
	public static var Dungeon6_Boss:String;
	public static var Dungeon6_10:String;

	public static var Dungeon7_Entrance:String;
	public static var Dungeon7_1:String;
	public static var Dungeon7_2:String;
	public static var Dungeon7_3:String;
	public static var Dungeon7_4:String;
	public static var Dungeon7_5:String;
	public static var Dungeon7_6:String;
	public static var Dungeon7_7:String;
	public static var Dungeon7_8:String;
	public static var Dungeon7_9:String;
	public static var Dungeon7_10:String;
	public static var Dungeon7_Boss:String;

	public static var OverWorld_fallhole:String;
	public static var OverWorld_fallhole1:String;
	public static var OverWorld_d7entrance:String;
	public static var OverWorld_house:String;
	public static var OverWorld1_4:String;
	public static var OverWorld1_5:String;
	public static var OverWorld1_6:String;
	public static var OverWorld_waterfallcave:String;
	public static var OverWorld_mountain:String;
	public static var OverWorld_mountain1:String;
	public static var OverWorld_finalboss:String;
	public static var OverWorld_treelarge:String;
	public static var OverWorld_d6entrance:String;
	public static var Dungeon7_11:String;
	public static var Dungeon7_12:String;

	public static var Dungeon8_Entrance:String;
	public static var Dungeon8_1:String;
	public static var Dungeon8_2:String;
	public static var Dungeon8_3:String;
	public static var Dungeon8_4:String;
	public static var Dungeon8_5:String;
	public static var Dungeon8_6:String;
	public static var Dungeon8_7:String;
	public static var Dungeon8_8:String;
	public static var Dungeon8_9:String;
	public static var Dungeon8_10:String;
	public static var Dungeon8_11:String;
	public static var Dungeon8_12:String;

	public static var End_1:String;
	public static var End_Boss:String;
	public static var End_2:String;
	public static var End_3:String;
	public static var End_4:String;

	/* 
		TODO: This is done before levels are initialized, so the array is full of dummy nulls.  This is necessary for hx/Main.hx:551, which accesses Game.levels.length.
		One possible future fix is to replace "levels" with the list of level names, then load them at loadLevel 
	 */
	public static var levels:Array<String> = [
		OverWorld1, Building1, Dungeon1_Entrance, Dungeon1_1, Dungeon1_2, Dungeon1_3, Dungeon1_4, Dungeon1_5, Dungeon1_6, Dungeon1_7, Dungeon1_8, Dungeon1_9,
		OverWorld1_1, Dungeon2_Entrance, Dungeon2_1, Dungeon2_2, Dungeon2_3, Dungeon2_4, Dungeon2_5, Dungeon2_Boss, Dungeon2_7, Dungeon3_Entrance, Dungeon3_1,
		Dungeon3_2, Dungeon3_3, Dungeon3_4, Dungeon3_5, Dungeon3_6, Dungeon3_7, Dungeon3_8, Dungeon3_9, Dungeon3_10, Dungeon3_Boss, OverWorld1_witchhut,
		OverWorld1_barhouse, OverWorld1_blandashurmin, OverWorld1_intree, OverWorld1_2, Dungeon4_Entrance, Dungeon4_1, Dungeon4_2, Dungeon4_3, Dungeon4_4,
		Dungeon4_Boss, OverWorld1_3, Dungeon5_Entrance, Dungeon5_1, Dungeon5_2, Dungeon5_3, Dungeon5_4, Dungeon5_5, Dungeon5_6, Dungeon5_7, Dungeon5_8,
		Dungeon5_9, Dungeon5_10, Dungeon5_11, Dungeon5_Boss, Dungeon5_DeadBoss, Dungeon6_Entrance, Dungeon6_1, Dungeon6_2, Dungeon6_3, Dungeon6_4, Dungeon6_5,
		Dungeon6_6, Dungeon6_7, Dungeon6_8, Dungeon6_9, Dungeon6_Boss, Dungeon6_10, Dungeon7_Entrance, Dungeon7_1, Dungeon7_2, Dungeon7_3, Dungeon7_4,
		Dungeon7_5, Dungeon7_6, Dungeon7_7, Dungeon7_8, Dungeon7_9, Dungeon7_10, Dungeon7_Boss, OverWorld_fallhole, OverWorld_fallhole1, OverWorld_d7entrance,
		OverWorld_house, OverWorld1_4, OverWorld1_5, OverWorld1_6, OverWorld_waterfallcave, OverWorld_mountain, OverWorld_mountain1, OverWorld_finalboss,
		OverWorld_treelarge, OverWorld_d6entrance, Dungeon7_11, Dungeon7_12, Dungeon8_Entrance, Dungeon8_1, Dungeon8_2, Dungeon8_3, Dungeon8_4, Dungeon8_5,
		Dungeon8_6, Dungeon8_7, Dungeon8_8, Dungeon8_9, Dungeon8_10, Dungeon8_11, Dungeon8_12, End_1, End_Boss, End_2, End_3, End_4
	];
	public static inline var bossMusic:Int = 13;
	public static var levelMusics:Array<Dynamic> = [
		0, 3, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 6, 6, 6, 6, 6, 6, -1, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, -1, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, -1, 0, 0, 9, 9, 9,
		9, 9, 9, 9, 9, 9, 9, 9, -1, 9, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, -1, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, -1, 0, 11, 11, 0, 0, 0, 0,
		0, 0, 0, 12, 0, 0, 11, 11, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 5, -1, 5, 5, 5
	];

	/*TILES*/
	private static var imgGrass:BitmapData;
	public static var sprGrass:Spritemap;
	private static var imgGround:BitmapData;
	public static var sprGround:Spritemap;
	private static var imgWater:BitmapData;
	public static var sprWater:Spritemap;
	private static var imgStone:BitmapData;
	public static var sprStone:Spritemap;
	private static var imgBrick:BitmapData;
	public static var sprBrick:Spritemap;
	private static var imgDirt:BitmapData;
	public static var sprDirt:Spritemap;
	private static var imgDungeonTile:BitmapData;
	public static var sprDungeonTile:Spritemap;
	private static var imgPit:BitmapData;
	public static var sprPit:Spritemap;
	private static var imgShieldTile:BitmapData;
	public static var sprShieldTile:Spritemap;
	private static var imgForest:BitmapData;
	public static var sprForest:Spritemap;
	private static var imgCliff:BitmapData;
	public static var sprCliff:Spritemap;
	private static var imgWood:BitmapData;
	public static var sprWood:Spritemap;
	private static var imgWoodWalk:BitmapData;
	public static var sprWoodWalk:Spritemap;
	private static var imgCave:BitmapData;
	public static var sprCave:Spritemap;
	private static var imgWoodTree:BitmapData;
	public static var sprWoodTree:Spritemap;
	private static var imgDarkTile:BitmapData;
	public static var sprDarkTile:Spritemap;
	private static var imgIgneousTile:BitmapData;
	public static var sprIgneousTile:Spritemap;
	private static var imgLava:BitmapData;
	public static var sprLava:Spritemap;
	private static var imgBlueTile:BitmapData;
	public static var sprBlueTile:Spritemap;
	private static var imgBlueTileWall:BitmapData;
	public static var sprBlueTileWall:Spritemap;
	private static var imgBlueTileWallDark:BitmapData;
	public static var sprBlueTileWallDark:Spritemap;
	private static var imgSnow:BitmapData;
	public static var sprSnow:Spritemap;
	private static var imgIce:BitmapData;
	public static var sprIce:Spritemap;
	private static var imgIceWall:BitmapData;
	public static var sprIceWall:Spritemap;
	private static var imgIceWallLit:BitmapData;
	public static var sprIceWallLit:Spritemap;
	private static var imgWaterfall:BitmapData;
	public static var sprWaterfall:Spritemap;
	private static var imgBody:BitmapData;
	public static var sprBody:Spritemap;
	private static var imgBodyWall:BitmapData;
	public static var sprBodyWall:Spritemap;
	private static var imgGhostTile:BitmapData;
	public static var sprGhostTile:Spritemap;
	public static var imgBridge:BitmapData;
	public static var sprBridge:Spritemap;
	private static var imgGhostTileStep:BitmapData;
	public static var sprGhostTileStep:Spritemap;
	private static var imgIgneousLava:BitmapData;
	public static var sprIgneousLava:Spritemap;
	private static var imgOddTile:BitmapData;
	public static var sprOddTile:Spritemap;
	private static var imgFuchTile:BitmapData;
	public static var sprFuchTile:Spritemap;
	private static var imgOddTileWall:BitmapData;
	public static var sprOddTileWall:Spritemap;
	private static var imgRockTile:BitmapData;
	public static var sprRockTile:Spritemap;
	private static var imgRockyTile:BitmapData;
	public static var sprRockyTile:Spritemap;

	/*CLIFFSIDE*/
	private static var imgCliffSides:BitmapData;
	public static var sprCliffSides:Spritemap;
	public static var imgCliffSidesMaskL:BitmapData;
	public static var imgCliffSidesMaskR:BitmapData;
	public static var imgCliffSidesMaskLU:BitmapData;
	public static var imgCliffSidesMaskRU:BitmapData;
	public static var imgCliffSidesMaskU:BitmapData;

	private static var imgCliffStairs:BitmapData;
	public static var sprCliffStairs:Spritemap;

	/*BUILDINGS*/
	private static var imgBuilding:BitmapData;
	public static var sprBuilding:Image;
	public static var imgBuildingMask:BitmapData;

	private static var imgBuilding1:BitmapData;
	public static var sprBuilding1:Image;
	public static var imgBuilding1Mask:BitmapData;

	private static var imgBuilding2:BitmapData;
	public static var sprBuilding2:Image;
	public static var imgBuilding2Mask:BitmapData;

	private static var imgBuilding3:BitmapData;
	public static var sprBuilding3:Image;
	public static var imgBuilding3Mask:BitmapData;

	private static var imgBuilding4:BitmapData;
	public static var sprBuilding4:Image;
	public static var imgBuilding4Mask:BitmapData;

	private static var imgBuilding5:BitmapData;
	public static var sprBuilding5:Image;
	public static var imgBuilding5Mask:BitmapData;

	private static var imgBuilding6:BitmapData;
	public static var sprBuilding6:Image;
	public static var imgBuilding6Mask:BitmapData;

	private static var imgBuilding7:BitmapData;
	public static var sprBuilding7:Image;
	public static var imgBuilding7Mask:BitmapData;

	private static var imgBuilding8:BitmapData;
	public static var sprBuilding8:Spritemap;
	public static var imgBuilding8Mask:BitmapData;

	public static var buildings:Array<Image>;
	public static var buildingMasks:Array<BitmapData>;

	/*STATUES*/
	private static var imgStatues:BitmapData;
	public static var sprStatues:Spritemap;

	/*ROCKS*/
	private static var imgRock:BitmapData;
	public static var sprRock:Image;

	private static var imgRock2:BitmapData;
	public static var sprRock2:Image;

	private static var imgRock3:BitmapData;
	public static var sprRock3:Image;

	private static var imgRock4:BitmapData;
	public static var sprRock4:Image;

	public static var rocks:Array<Dynamic> = [sprRock, sprRock2, sprRock3, sprRock4];

	/*OTHER*/
	private static var imgPole:BitmapData;
	public static var sprPole:Spritemap;
	private static var imgWire:BitmapData;
	public static var sprWire:Spritemap;

	private static var imgTree:BitmapData;
	public static var sprTree:Spritemap;
	private static var imgTreeBare:BitmapData;
	public static var sprTreeBare:Spritemap;
	private static var imgOpenTree:BitmapData;
	public static var sprOpenTree:Spritemap;
	public static var imgOpenTreeMask:BitmapData;

	private static var imgBlizzard:BitmapData;
	public static var sprBlizzard:Image;
	private static var imgLight:BitmapData;
	public static var sprLight:Image;

	private static var imgSnowHill:BitmapData;
	public static var sprSnowHill:Image;
	public static var imgSnowHillMask:BitmapData;

	public static var imgWaterfallSpray:BitmapData;

	private static var imgPitShadow:BitmapData;
	public static var sprPitShadow:Spritemap;

	private static var imgDroplet:BitmapData;
	public static var sprDroplet:Spritemap;

	private static var imgHealth:BitmapData;
	public static var sprHealth:Spritemap;

	private static var imgBlurRegion:BitmapData;
	public static var sprBlurRegion:Image;

	private static var imgBlurRegion2:BitmapData;
	public static var sprBlurRegion2:Image;

	private var imgTreeLarge:BitmapData;
	private var sprTreeLarge:Spritemap;

	private var imgLogo:BitmapData;
	private var sprLogo:Spritemap;

	private var imgNG:BitmapData;
	private var sprNG:Spritemap;

	private var imgGames:BitmapData;
	private var spGames:DisplayObject;

	private var imgMenuArrow:BitmapData;
	private var sprMenuArrow:Spritemap;

	/*BOSS KEYS/LOCKS*/
	private static var imgBossLock:BitmapData;
	private static var sprBossLock:Spritemap;
	private static var imgBossLock1:BitmapData;
	private static var sprBossLock1:Spritemap;
	private static var imgBossLock2:BitmapData;
	private static var sprBossLock2:Spritemap;
	private static var imgBossLock3:BitmapData;
	private static var sprBossLock3:Spritemap;
	private static var imgBossLock4:BitmapData;
	private static var sprBossLock4:Spritemap;

	private static var imgBossKey:BitmapData;
	public static var sprBossKey:Spritemap;
	private static var imgBossKey1:BitmapData;
	public static var sprBossKey1:Spritemap;
	private static var imgBossKey2:BitmapData;
	public static var sprBossKey2:Spritemap;
	private static var imgBossKey3:BitmapData;
	public static var sprBossKey3:Spritemap;
	private static var imgBossKey4:BitmapData;
	public static var sprBossKey4:Spritemap;

	public static var bossLocks:Array<Spritemap>;
	public static var bossKeys:Array<Spritemap>;

	/*Main variables*/
	public static var cheats:Bool = false;
	public static var menu:Bool = true; // Whether or not the game should start as a menu
	public static var menuLevels:Array<Dynamic> = [12, 37, 44, 87, 88, 89];
	private static var menuIndex:Int = 0;

	private var restartKey(default, never):Int = Key.R;
	private var escapeKey(default, never):Int = Key.ESCAPE;
	private var yesKey(default, never):Int = Key.Y;
	private var muteKey(default, never):Int = Key.M;
	private var menuKeyLeft(default, never):Int = Key.LEFT;
	private var menuKeyRight(default, never):Int = Key.RIGHT;
	private var restart:Bool;

	public static var inventory:Inventory;
	public static var dayLength:Int = 160 * Main.FPS; // the number is the number of seconds per day
	// The first quarter is dawn, the second two are day, and the last quarter is twilight
	public static var nightLength:Int = 80 * Main.FPS; // the number is the number of seconds per night

	public var todaysTime:Int = 0; // The time of the current day; 0 is dawn, and the last frame is the last of night.
	public var lightAlpha:Float = 1;
	public var minLightAlpha(default, never):Float = 0.1; // This is added to whatever light alpha is gained from the level itself.

	public static var daysPassed:Int = 0;
	public static inline var minDarkness:Float = 0.1;

	public var dayNight:Bool = true;
	public var nightBmp:BitmapData = new BitmapData(FP.screen.width, FP.screen.height, false, 0x000000);
	public var solidBmp:BitmapData = new BitmapData(FP.screen.width, FP.screen.height, true,
		0x00000000); // For drawing 1-alpha pics that'll be dimmed onto nightBmp

	private var solidBmpAlpha(default, never):Float = 1;

	// public var underwaterBmp:BitmapData = new BitmapData(FP.screen.width, FP.screen.height, false, 0x2222FF);
	public var underBmp:BitmapData = new BitmapData(FP.screen.width, FP.screen.height, true, 0x00000000);

	// Snow variables
	private var snowBmp:BitmapData = new BitmapData(FP.buffer.width, FP.buffer.height, false, 0);
	private var bwBuffer:BitmapData = new BitmapData(FP.buffer.width, FP.buffer.height, false, 0);

	public static var blackAndWhite:Bool = true;
	public static var snowing:Bool = true;
	public static var blizzardOffset:Point = new Point();
	public static var blizzardRate:Point = new Point(10, 10);
	public static inline var DEFAULT_SNOW_ALPHA:Float = 0.25;

	public var snowAlpha:Float = 0;

	public static inline var speakingAlpha:Float = 0.8; // The alpha of the bars that come down when talking to an NPC
	public static inline var speakingColor:Int = 0x000000; // The color of the bars that come down when talking to an NPC

	public static inline var timePerFrame:Int = 45;
	public static var _time:Float;

	private static function set_time(_t:Float):Float {
		Main.time = _t;
		return _t;
	}

	private static function get_time():Float {
		return Main.time;
	}

	public var timeRate:Float = 1;

	private static function set_moonrockSet(_t:Bool):Bool {
		Main.rockSet = _t;
		return _t;
	}

	private static function get_moonrockSet():Bool {
		return Main.rockSet;
	}

	public static var underwater:Bool;

	public static var freezeObjects:Bool = false;
	public static var ALIGN:String = "LEFT";
	public static var talking:Bool = false; // Whether in a conversation with an NPC
	public static var _talkingText:String = ""; // The text to display for a conversation
	public static var talkingPic:Image; // The picture to display for the person talking to you

	private var drawBlackCover:Bool = true;

	public var blackCover:Float = 1;
	public var blackCoverRate:Float = -0.05;

	public var blurRegion:Bool = false;
	public var blurRegion2:Bool = false;

	private var checked:Bool = false;

	public static inline var tagsPerLevel:Int = 30;

	private function set_level(i:Int):Int {
		Main.level = i;
		return i;
	}

	private function get_level():Int {
		return Main.level;
	}

	public static var fallthroughLevel:Int = -1;
	public static var fallthroughOffset:Point;
	public static var setFallFromCeiling:Bool = false;

	public static var shake:Float = 0; // set this to a value to have the screen shake

	private var newCoverColor:Int = 0x000000;
	private var newCoverAlpha:Float = 0;
	private var newCoverDraw:Bool = false;

	// Rain
	public static var raining:Bool = false;

	public var rainingHeaviness:Int = 0;
	public var rainingRect:Rectangle = new Rectangle();
	public var rainingHeight:Int = 0;
	public var rainingColor:Int = 0;

	public static var healthc:Int = 0;
	public static var healths:Int = 0;

	public static var currentPlayerPosition:Point;

	public var _playerPosition:Point;

	private function set_playerPosition(p:Point):Point {
		currentPlayerPosition = p.clone();
		_playerPosition = p.clone();
		Main.playerPositionX = Std.int(p.x);
		Main.playerPositionY = Std.int(p.y);
		return p;
	}

	private function get_playerPosition():Point {
		return _playerPosition;
	}

	public static var _cameraTarget:Point = new Point(-1, -1);
	public static var cameraSpeedDivisorDef:Int = 10;
	public static var cameraSpeedDivisor:Int = cameraSpeedDivisorDef;

	public function resetCameraSpeed():Void {
		cameraSpeedDivisor = cameraSpeedDivisorDef;
	}

	// Controls it a "Message" is shown at the start of this level (-1 means one is not shown)
	public static var sign:Int = -1;
	public static var fallthroughSign:Int = -1;

	// Main Menu motion stuff
	private static var menuOffset:Point = new Point();

	private var menuAlphaDivisor(default, never):Int = 128;
	private var menuStates(default, never):Int = 4;
	private var menuTweenTime(default, never):Int = 10;

	private static var menuState:Int = 0;
	private static var menuTween:Tween;
	private static var menuScroll:Float = 0;

	private var menuMaxWidthCredits:Int = 0;
	private var menuMaxWidthControlsLeft:Int = 0;
	private var menuMaxWidthControlsRight:Int = 0;

	private var menuText(default, never):Array<Dynamic> = ["Arrows", "X", "C", "V or I", "----------", "Esc", "R", "M", "W"];
	private var menuTextAppend(default, never):Array<Dynamic> = [
		"move",
		"action",
		"secondary",
		"inventory",
		"----------",
		"menu",
		"restart game",
		"mute",
		"soundtrack"
	];
	private var menuCreditsTitles(default, never):Array<Dynamic> = ["Programming\n & Graphics", "Sound", "Concept", "Thanks to"];
	private var menuCreditsNames(default, never):Array<Dynamic> = [
		["Connor Ullmann"],
		["Roger \"Rekcahdam\" Hicks"],
		["Connor Ullmann", "Joe Biglin", "Lisa Miller", "Dan Tsukasa"],
		[
			"Newgrounds",
			"Sheldon Ketterer",
			"Grant Demeter",
			"Collin Ullmann",
			"Max Beck",
			"Ian Ting"
		]
	];

	private static var rightArrowScale:Float = 1;
	private static var leftArrowScale:Float = 1;
	private static var arrowMoveRate:Float = 0.03;
	private static var arrowMove:Float = 0;

	public static var tiles:Array<Array<Tile>>;

	public static var currentCharacter:Int = 0; // The current character being displayed in a string.
	public static inline var framesPerCharacterDefault:Int = 4;
	public static var framesPerCharacter:Int = framesPerCharacterDefault; // The number of frames for each character displayed in the string.

	private var framesThisCharacter:Int = 0; // The counter for frames for each character displayed in the string.
	private var proceedText:Bool = true;

	public static var cutscene:Array<Dynamic> = [false, false, false, false];

	private var cTextIndex:Int = 0;

	private static var cutsceneText:Array<Array<String>> = [
		[
			"Wind calls you to life.",
			"Go, learn of good and evil.",
			"Answers lie in this house."
		],
		[]
	];
	private static inline var textTime:Int = 10; // Time between each message.

	private var textTimer:Int = textTime;
	/*
	 * cutsceneTimer[0][0] controls the time before the first message pops up during the wind.
	 */
	private var cutsceneTimer:Array<Dynamic> = [[3 * Main.FPS, 210], []]; // used for live counting.

	private function load_image_assets():Void {
		imgGrass = Assets.getBitmapData("assets/graphics/Grass.png");
		imgGround = Assets.getBitmapData("assets/graphics/Shore.png");
		imgWater = Assets.getBitmapData("assets/graphics/Water.png");
		imgStone = Assets.getBitmapData("assets/graphics/Stone.png");
		imgBrick = Assets.getBitmapData("assets/graphics/Brick.png");
		imgDirt = Assets.getBitmapData("assets/graphics/Dirt.png");
		imgDungeonTile = Assets.getBitmapData("assets/graphics/DungeonTile.png");
		imgPit = Assets.getBitmapData("assets/graphics/Pit.png");
		imgShieldTile = Assets.getBitmapData("assets/graphics/ShieldTile.png");
		imgForest = Assets.getBitmapData("assets/graphics/ForestTile.png");
		imgCliff = Assets.getBitmapData("assets/graphics/Cliff.png");
		imgWood = Assets.getBitmapData("assets/graphics/Wood.png");
		imgWoodWalk = Assets.getBitmapData("assets/graphics/WoodWalk.png");
		imgCave = Assets.getBitmapData("assets/graphics/Cave.png");
		imgWoodTree = Assets.getBitmapData("assets/graphics/WoodTree.png");
		imgDarkTile = Assets.getBitmapData("assets/graphics/DarkTile.png");
		imgIgneousTile = Assets.getBitmapData("assets/graphics/IgneousTile.png");
		imgLava = Assets.getBitmapData("assets/graphics/Lava2.png");
		imgBlueTile = Assets.getBitmapData("assets/graphics/BlueStone.png");
		imgBlueTileWall = Assets.getBitmapData("assets/graphics/BlueStoneWall.png");
		imgBlueTileWallDark = Assets.getBitmapData("assets/graphics/BlueStoneWallDark.png");
		imgSnow = Assets.getBitmapData("assets/graphics/Snow.png");
		imgIce = Assets.getBitmapData("assets/graphics/Ice.png");
		imgIceWall = Assets.getBitmapData("assets/graphics/IceWall.png");
		imgIceWallLit = Assets.getBitmapData("assets/graphics/IceWallLit.png");
		imgWaterfall = Assets.getBitmapData("assets/graphics/Waterfall.png");
		imgBody = Assets.getBitmapData("assets/graphics/Body.png");
		imgBodyWall = Assets.getBitmapData("assets/graphics/BodyWall.png");
		imgGhostTile = Assets.getBitmapData("assets/graphics/GhostTile.png");
		imgBridge = Assets.getBitmapData("assets/graphics/OpenBridge.png");
		imgGhostTileStep = Assets.getBitmapData("assets/graphics/GhostTileStep.png");
		imgIgneousLava = Assets.getBitmapData("assets/graphics/IgneousLava.png");
		imgOddTile = Assets.getBitmapData("assets/graphics/OddTile.png");
		imgFuchTile = Assets.getBitmapData("assets/graphics/FuchTile.png");
		imgOddTileWall = Assets.getBitmapData("assets/graphics/OddTileWall.png");
		imgRockTile = Assets.getBitmapData("assets/graphics/RockTile.png");
		imgRockyTile = Assets.getBitmapData("assets/graphics/RockyTile.png");
		imgCliffSides = Assets.getBitmapData("assets/graphics/CliffSide.png");
		imgCliffSidesMaskL = Assets.getBitmapData("assets/graphics/CliffSideMaskL.png");
		imgCliffSidesMaskR = Assets.getBitmapData("assets/graphics/CliffSideMaskR.png");
		imgCliffSidesMaskLU = Assets.getBitmapData("assets/graphics/CliffSideMaskLU.png");
		imgCliffSidesMaskRU = Assets.getBitmapData("assets/graphics/CliffSideMaskRU.png");
		imgCliffSidesMaskU = Assets.getBitmapData("assets/graphics/CliffSideMaskU.png");
		imgCliffStairs = Assets.getBitmapData("assets/graphics/CliffStairs.png");
		imgBuilding = Assets.getBitmapData("assets/graphics/Building.png");
		imgBuildingMask = Assets.getBitmapData("assets/graphics/BuildingMask.png");
		imgBuilding1 = Assets.getBitmapData("assets/graphics/Building1.png");
		imgBuilding1Mask = Assets.getBitmapData("assets/graphics/Building1Mask.png");
		imgBuilding2 = Assets.getBitmapData("assets/graphics/Building2.png");
		imgBuilding2Mask = Assets.getBitmapData("assets/graphics/Building2Mask.png");
		imgBuilding3 = Assets.getBitmapData("assets/graphics/Building3.png");
		imgBuilding3Mask = Assets.getBitmapData("assets/graphics/Building3Mask.png");
		imgBuilding4 = Assets.getBitmapData("assets/graphics/Building4.png");
		imgBuilding4Mask = Assets.getBitmapData("assets/graphics/Building4Mask.png");
		imgBuilding5 = Assets.getBitmapData("assets/graphics/Building5.png");
		imgBuilding5Mask = Assets.getBitmapData("assets/graphics/Building5Mask.png");
		imgBuilding6 = Assets.getBitmapData("assets/graphics/Building6.png");
		imgBuilding6Mask = Assets.getBitmapData("assets/graphics/Building6Mask.png");
		imgBuilding7 = Assets.getBitmapData("assets/graphics/Building7.png");
		imgBuilding7Mask = Assets.getBitmapData("assets/graphics/Building7Mask.png");
		imgBuilding8 = Assets.getBitmapData("assets/graphics/Building8.png");
		imgBuilding8Mask = Assets.getBitmapData("assets/graphics/Building8Mask.png");
		imgStatues = Assets.getBitmapData("assets/graphics/Statues.png");
		imgRock = Assets.getBitmapData("assets/graphics/Rock.png");
		imgRock2 = Assets.getBitmapData("assets/graphics/Rock2.png");
		imgRock3 = Assets.getBitmapData("assets/graphics/Rock3.png");
		imgRock4 = Assets.getBitmapData("assets/graphics/Rock4.png");
		imgPole = Assets.getBitmapData("assets/graphics/Pole.png");
		imgWire = Assets.getBitmapData("assets/graphics/Wire.png");
		imgTree = Assets.getBitmapData("assets/graphics/Tree2.png");
		imgTreeBare = Assets.getBitmapData("assets/graphics/TreeBare.png");
		imgOpenTree = Assets.getBitmapData("assets/graphics/OpenTree.png");
		imgOpenTreeMask = Assets.getBitmapData("assets/graphics/OpenTreeMask.png");
		imgBlizzard = Assets.getBitmapData("assets/graphics/Blizzard.png");
		imgLight = Assets.getBitmapData("assets/graphics/Light.png");
		imgSnowHill = Assets.getBitmapData("assets/graphics/SnowHill.png");
		imgSnowHillMask = Assets.getBitmapData("assets/graphics/SnowHillMask.png");
		imgWaterfallSpray = Assets.getBitmapData("assets/graphics/WaterfallSpray.png");
		imgPitShadow = Assets.getBitmapData("assets/graphics/PitShadow.png");
		imgDroplet = Assets.getBitmapData("assets/graphics/Droplet.png");
		imgHealth = Assets.getBitmapData("assets/graphics/Health.png");
		imgBlurRegion = Assets.getBitmapData("assets/graphics/BlurRegion.png");
		imgBlurRegion2 = Assets.getBitmapData("assets/graphics/BlurRegion2.png");
		imgTreeLarge = Assets.getBitmapData("assets/graphics/TreeLarge.png");
		imgLogo = Assets.getBitmapData("assets/graphics/Logo2.png");
		imgNG = Assets.getBitmapData("assets/graphics/pixel_logo_medium.png");
		imgGames = Assets.getBitmapData("assets/graphics/promos.png");
		imgMenuArrow = Assets.getBitmapData("assets/graphics/MenuArrow.png");
		imgBossLock = Assets.getBitmapData("assets/graphics/BossLock.png");
		imgBossLock1 = Assets.getBitmapData("assets/graphics/BossLock1.png");
		imgBossLock2 = Assets.getBitmapData("assets/graphics/BossLock2.png");
		imgBossLock3 = Assets.getBitmapData("assets/graphics/BossLock3.png");
		imgBossLock4 = Assets.getBitmapData("assets/graphics/BossLock4.png");
		imgBossKey = Assets.getBitmapData("assets/graphics/BossKey.png");
		imgBossKey1 = Assets.getBitmapData("assets/graphics/BossKey1.png");
		imgBossKey2 = Assets.getBitmapData("assets/graphics/BossKey2.png");
		imgBossKey3 = Assets.getBitmapData("assets/graphics/BossKey3.png");
		imgBossKey4 = Assets.getBitmapData("assets/graphics/BossKey4.png");
	}

	private function initialize_image_assets():Void {
		sprGrass = new Spritemap(imgGrass, 3, 4);
		sprGround = new Spritemap(imgGround, 16, 16);
		sprWater = new Spritemap(imgWater, 16, 16);
		sprStone = new Spritemap(imgStone, 16, 16);
		sprBrick = new Spritemap(imgBrick, 16, 16);
		sprDirt = new Spritemap(imgDirt, 16, 16);
		sprDungeonTile = new Spritemap(imgDungeonTile, 16, 16);
		sprPit = new Spritemap(imgPit, 16, 16);
		sprShieldTile = new Spritemap(imgShieldTile, 16, 16);
		sprForest = new Spritemap(imgForest, 16, 16);
		sprCliff = new Spritemap(imgCliff, 16, 16);
		sprWood = new Spritemap(imgWood, 16, 16);
		sprWoodWalk = new Spritemap(imgWoodWalk, 16, 16);
		sprCave = new Spritemap(imgCave, 16, 16);
		sprWoodTree = new Spritemap(imgWoodTree, 16, 16);
		sprDarkTile = new Spritemap(imgDarkTile, 16, 16);
		sprIgneousTile = new Spritemap(imgIgneousTile, 16, 16);
		sprLava = new Spritemap(imgLava, 16, 16);
		sprBlueTile = new Spritemap(imgBlueTile, 16, 16);
		sprBlueTileWall = new Spritemap(imgBlueTileWall, 16, 16);
		sprBlueTileWallDark = new Spritemap(imgBlueTileWallDark, 16, 16);
		sprSnow = new Spritemap(imgSnow, 16, 16);
		sprIce = new Spritemap(imgIce, 16, 16);
		sprIceWall = new Spritemap(imgIceWall, 16, 16);
		sprIceWallLit = new Spritemap(imgIceWallLit, 16, 16);
		sprWaterfall = new Spritemap(imgWaterfall, 16, 16);
		sprBody = new Spritemap(imgBody, 16, 16);
		sprBodyWall = new Spritemap(imgBodyWall, 16, 16);
		sprGhostTile = new Spritemap(imgGhostTile, 16, 16);
		sprBridge = new Spritemap(imgBridge, 16, 16);
		sprGhostTileStep = new Spritemap(imgGhostTileStep, 16, 16);
		sprIgneousLava = new Spritemap(imgIgneousLava, 16, 16);
		sprOddTile = new Spritemap(imgOddTile, 16, 16);
		sprFuchTile = new Spritemap(imgFuchTile, 16, 16);
		sprOddTileWall = new Spritemap(imgOddTileWall, 16, 16);
		sprRockTile = new Spritemap(imgRockTile, 16, 16);
		sprRockyTile = new Spritemap(imgRockyTile, 16, 16);
		sprCliffSides = new Spritemap(imgCliffSides, 16, 16);
		sprCliffStairs = new Spritemap(imgCliffStairs, 16, 16);
		sprBuilding = new Image(imgBuilding);
		sprBuilding1 = new Image(imgBuilding1);
		sprBuilding2 = new Image(imgBuilding2);
		sprBuilding3 = new Image(imgBuilding3);
		sprBuilding4 = new Image(imgBuilding4);
		sprBuilding5 = new Image(imgBuilding5);
		sprBuilding6 = new Image(imgBuilding6);
		sprBuilding7 = new Image(imgBuilding7);
		sprBuilding8 = new Spritemap(imgBuilding8, 64, 64);
		sprStatues = new Spritemap(imgStatues, 48, 40);
		sprRock = new Image(imgRock);
		sprRock2 = new Image(imgRock2);
		sprRock3 = new Image(imgRock3);
		sprRock4 = new Image(imgRock4);
		sprPole = new Spritemap(imgPole, 16, 16);
		sprWire = new Spritemap(imgWire, 16, 16);
		sprTree = new Spritemap(imgTree, 32, 32);
		sprTreeBare = new Spritemap(imgTreeBare, 32, 32);
		sprOpenTree = new Spritemap(imgOpenTree, 32, 32);
		sprBlizzard = new Image(imgBlizzard);
		sprLight = new Image(imgLight);
		sprSnowHill = new Image(imgSnowHill);
		sprPitShadow = new Spritemap(imgPitShadow, 16, 16);
		sprDroplet = new Spritemap(imgDroplet, 9, 5);
		sprHealth = new Spritemap(imgHealth, 12, 12);
		sprBlurRegion = new Image(imgBlurRegion);
		sprBlurRegion2 = new Image(imgBlurRegion2);
		sprBossLock = new Spritemap(imgBossLock, 16, 16);
		sprBossLock1 = new Spritemap(imgBossLock1, 16, 16);
		sprBossLock2 = new Spritemap(imgBossLock2, 16, 16);
		sprBossLock3 = new Spritemap(imgBossLock3, 16, 16);
		sprBossLock4 = new Spritemap(imgBossLock4, 16, 16);
		sprBossKey = new Spritemap(imgBossKey, 12, 16);
		sprBossKey1 = new Spritemap(imgBossKey1, 12, 16);
		sprBossKey2 = new Spritemap(imgBossKey2, 12, 16);
		sprBossKey3 = new Spritemap(imgBossKey3, 12, 16);
		sprBossKey4 = new Spritemap(imgBossKey4, 12, 16);
	}

	private function load_level_assets():Void {
		OverWorld1 = Assets.getText("assets/levels/OverWorld.oel");
		Building1 = Assets.getText("assets/levels/Building1.oel");
		Dungeon1_Entrance = Assets.getText("assets/levels/Dungeon1/Entrance.oel");
		Dungeon1_1 = Assets.getText("assets/levels/Dungeon1/1.oel");
		Dungeon1_2 = Assets.getText("assets/levels/Dungeon1/2.oel");
		Dungeon1_3 = Assets.getText("assets/levels/Dungeon1/3.oel");
		Dungeon1_4 = Assets.getText("assets/levels/Dungeon1/4.oel");
		Dungeon1_5 = Assets.getText("assets/levels/Dungeon1/5.oel");
		Dungeon1_6 = Assets.getText("assets/levels/Dungeon1/6.oel");
		Dungeon1_7 = Assets.getText("assets/levels/Dungeon1/7.oel");
		Dungeon1_8 = Assets.getText("assets/levels/Dungeon1/8.oel");
		Dungeon1_9 = Assets.getText("assets/levels/Dungeon1/9.oel");
		OverWorld1_1 = Assets.getText("assets/levels/OverWorld/region1.oel");
		Dungeon2_Entrance = Assets.getText("assets/levels/Dungeon2/Entrance.oel");
		Dungeon2_1 = Assets.getText("assets/levels/Dungeon2/1.oel");
		Dungeon2_2 = Assets.getText("assets/levels/Dungeon2/2.oel");
		Dungeon2_3 = Assets.getText("assets/levels/Dungeon2/3.oel");
		Dungeon2_4 = Assets.getText("assets/levels/Dungeon2/4.oel");
		Dungeon2_5 = Assets.getText("assets/levels/Dungeon2/5.oel");
		Dungeon2_Boss = Assets.getText("assets/levels/Dungeon2/6.oel");
		Dungeon2_7 = Assets.getText("assets/levels/Dungeon2/7.oel");
		Dungeon3_Entrance = Assets.getText("assets/levels/Dungeon3/Entrance.oel");
		Dungeon3_1 = Assets.getText("assets/levels/Dungeon3/1.oel");
		Dungeon3_2 = Assets.getText("assets/levels/Dungeon3/2.oel");
		Dungeon3_3 = Assets.getText("assets/levels/Dungeon3/3.oel");
		Dungeon3_4 = Assets.getText("assets/levels/Dungeon3/4.oel");
		Dungeon3_5 = Assets.getText("assets/levels/Dungeon3/5.oel");
		Dungeon3_6 = Assets.getText("assets/levels/Dungeon3/6.oel");
		Dungeon3_7 = Assets.getText("assets/levels/Dungeon3/7.oel");
		Dungeon3_8 = Assets.getText("assets/levels/Dungeon3/8.oel");
		Dungeon3_9 = Assets.getText("assets/levels/Dungeon3/9.oel");
		Dungeon3_10 = Assets.getText("assets/levels/Dungeon3/10.oel");
		Dungeon3_Boss = Assets.getText("assets/levels/Dungeon3/11.oel");
		OverWorld1_witchhut = Assets.getText("assets/levels/OverWorld/witchhut.oel");
		OverWorld1_barhouse = Assets.getText("assets/levels/OverWorld/barhouse.oel");
		OverWorld1_blandashurmin = Assets.getText("assets/levels/OverWorld/blandashurmin.oel");
		OverWorld1_intree = Assets.getText("assets/levels/OverWorld/intree.oel");
		OverWorld1_2 = Assets.getText("assets/levels/OverWorld/region2.oel");
		Dungeon4_Entrance = Assets.getText("assets/levels/Dungeon4/Entrance.oel");
		Dungeon4_1 = Assets.getText("assets/levels/Dungeon4/1.oel");
		Dungeon4_2 = Assets.getText("assets/levels/Dungeon4/2.oel");
		Dungeon4_3 = Assets.getText("assets/levels/Dungeon4/3.oel");
		Dungeon4_4 = Assets.getText("assets/levels/Dungeon4/4.oel");
		Dungeon4_Boss = Assets.getText("assets/levels/Dungeon4/Boss.oel");
		OverWorld1_3 = Assets.getText("assets/levels/OverWorld/region3.oel");
		Dungeon5_Entrance = Assets.getText("assets/levels/Dungeon5/Entrance.oel");
		Dungeon5_1 = Assets.getText("assets/levels/Dungeon5/1.oel");
		Dungeon5_2 = Assets.getText("assets/levels/Dungeon5/2.oel");
		Dungeon5_3 = Assets.getText("assets/levels/Dungeon5/3.oel");
		Dungeon5_4 = Assets.getText("assets/levels/Dungeon5/4.oel");
		Dungeon5_5 = Assets.getText("assets/levels/Dungeon5/5.oel");
		Dungeon5_6 = Assets.getText("assets/levels/Dungeon5/6.oel");
		Dungeon5_7 = Assets.getText("assets/levels/Dungeon5/7.oel");
		Dungeon5_8 = Assets.getText("assets/levels/Dungeon5/8.oel");
		Dungeon5_9 = Assets.getText("assets/levels/Dungeon5/9.oel");
		Dungeon5_10 = Assets.getText("assets/levels/Dungeon5/10.oel");
		Dungeon5_11 = Assets.getText("assets/levels/Dungeon5/11.oel");
		Dungeon5_Boss = Assets.getText("assets/levels/Dungeon5/Boss.oel");
		Dungeon5_DeadBoss = Assets.getText("assets/levels/Dungeon5/DeadBoss.oel");
		Dungeon6_Entrance = Assets.getText("assets/levels/Dungeon6/Entrance.oel");
		Dungeon6_1 = Assets.getText("assets/levels/Dungeon6/1.oel");
		Dungeon6_2 = Assets.getText("assets/levels/Dungeon6/2.oel");
		Dungeon6_3 = Assets.getText("assets/levels/Dungeon6/3.oel");
		Dungeon6_4 = Assets.getText("assets/levels/Dungeon6/4.oel");
		Dungeon6_5 = Assets.getText("assets/levels/Dungeon6/5.oel");
		Dungeon6_6 = Assets.getText("assets/levels/Dungeon6/6.oel");
		Dungeon6_7 = Assets.getText("assets/levels/Dungeon6/7.oel");
		Dungeon6_8 = Assets.getText("assets/levels/Dungeon6/8.oel");
		Dungeon6_9 = Assets.getText("assets/levels/Dungeon6/9.oel");
		Dungeon6_Boss = Assets.getText("assets/levels/Dungeon6/Boss.oel");
		Dungeon6_10 = Assets.getText("assets/levels/Dungeon6/10.oel");
		Dungeon7_Entrance = Assets.getText("assets/levels/Dungeon7/Entrance.oel");
		Dungeon7_1 = Assets.getText("assets/levels/Dungeon7/1.oel");
		Dungeon7_2 = Assets.getText("assets/levels/Dungeon7/2.oel");
		Dungeon7_3 = Assets.getText("assets/levels/Dungeon7/3.oel");
		Dungeon7_4 = Assets.getText("assets/levels/Dungeon7/4.oel");
		Dungeon7_5 = Assets.getText("assets/levels/Dungeon7/5.oel");
		Dungeon7_6 = Assets.getText("assets/levels/Dungeon7/6.oel");
		Dungeon7_7 = Assets.getText("assets/levels/Dungeon7/7.oel");
		Dungeon7_8 = Assets.getText("assets/levels/Dungeon7/8.oel");
		Dungeon7_9 = Assets.getText("assets/levels/Dungeon7/9.oel");
		Dungeon7_10 = Assets.getText("assets/levels/Dungeon7/10.oel");
		Dungeon7_Boss = Assets.getText("assets/levels/Dungeon7/Boss.oel");
		OverWorld_fallhole = Assets.getText("assets/levels/OverWorld/fallhole.oel");
		OverWorld_fallhole1 = Assets.getText("assets/levels/OverWorld/fallhole1.oel");
		OverWorld_d7entrance = Assets.getText("assets/levels/OverWorld/d7entrance.oel");
		OverWorld_house = Assets.getText("assets/levels/OverWorld/house.oel");
		OverWorld1_4 = Assets.getText("assets/levels/OverWorld/region4.oel");
		OverWorld1_5 = Assets.getText("assets/levels/OverWorld/region5.oel");
		OverWorld1_6 = Assets.getText("assets/levels/OverWorld/region6.oel");
		OverWorld_waterfallcave = Assets.getText("assets/levels/OverWorld/waterfallcave.oel");
		OverWorld_mountain = Assets.getText("assets/levels/OverWorld/mountain.oel");
		OverWorld_mountain1 = Assets.getText("assets/levels/OverWorld/mountain1.oel");
		OverWorld_finalboss = Assets.getText("assets/levels/OverWorld/finalboss.oel");
		OverWorld_treelarge = Assets.getText("assets/levels/OverWorld/treelarge.oel");
		OverWorld_d6entrance = Assets.getText("assets/levels/OverWorld/d6entrance.oel");
		Dungeon7_11 = Assets.getText("assets/levels/Dungeon7/11.oel");
		Dungeon7_12 = Assets.getText("assets/levels/Dungeon7/12.oel");
		Dungeon8_Entrance = Assets.getText("assets/levels/Dungeon8/Entrance.oel");
		Dungeon8_1 = Assets.getText("assets/levels/Dungeon8/1.oel");
		Dungeon8_2 = Assets.getText("assets/levels/Dungeon8/2.oel");
		Dungeon8_3 = Assets.getText("assets/levels/Dungeon8/3.oel");
		Dungeon8_4 = Assets.getText("assets/levels/Dungeon8/4.oel");
		Dungeon8_5 = Assets.getText("assets/levels/Dungeon8/5.oel");
		Dungeon8_6 = Assets.getText("assets/levels/Dungeon8/6.oel");
		Dungeon8_7 = Assets.getText("assets/levels/Dungeon8/7.oel");
		Dungeon8_8 = Assets.getText("assets/levels/Dungeon8/8.oel");
		Dungeon8_9 = Assets.getText("assets/levels/Dungeon8/9.oel");
		Dungeon8_10 = Assets.getText("assets/levels/Dungeon8/10.oel");
		Dungeon8_11 = Assets.getText("assets/levels/Dungeon8/11.oel");
		Dungeon8_12 = Assets.getText("assets/levels/Dungeon8/12.oel");
		End_1 = Assets.getText("assets/levels/End/1.oel");
		End_Boss = Assets.getText("assets/levels/End/Boss.oel");
		End_2 = Assets.getText("assets/levels/End/2.oel");
		End_3 = Assets.getText("assets/levels/End/3.oel");
		End_4 = Assets.getText("assets/levels/End/4.oel");
	}

	public function new(_level:Int = -1, _playerx:Int = 80, _playery:Int = 128, _restart:Bool = false, _menuState:Int = -1) {
		Music.load_audio_assets(); //TODO: This could very easily become a performance nightmare later on.  Probably also the wrong time to load it
		Music.initialize_audio_assets();

		// TODO: This has the potential to be slow when the Game object is recreated on death/loading.  Monitor performance and consider moving this to a "first time init" function.
		load_level_assets();
		load_image_assets();
		initialize_image_assets();
		bossLocks = [sprBossLock, sprBossLock1, sprBossLock2, sprBossLock3, sprBossLock4];
		bossKeys = [sprBossKey, sprBossKey1, sprBossKey2, sprBossKey3, sprBossKey4];
		levels = [
			OverWorld1, Building1, Dungeon1_Entrance, Dungeon1_1, Dungeon1_2, Dungeon1_3, Dungeon1_4, Dungeon1_5, Dungeon1_6, Dungeon1_7, Dungeon1_8,
			Dungeon1_9, OverWorld1_1, Dungeon2_Entrance, Dungeon2_1, Dungeon2_2, Dungeon2_3, Dungeon2_4, Dungeon2_5, Dungeon2_Boss, Dungeon2_7,
			Dungeon3_Entrance, Dungeon3_1, Dungeon3_2, Dungeon3_3, Dungeon3_4, Dungeon3_5, Dungeon3_6, Dungeon3_7, Dungeon3_8, Dungeon3_9, Dungeon3_10,
			Dungeon3_Boss, OverWorld1_witchhut, OverWorld1_barhouse, OverWorld1_blandashurmin, OverWorld1_intree, OverWorld1_2, Dungeon4_Entrance, Dungeon4_1,
			Dungeon4_2, Dungeon4_3, Dungeon4_4, Dungeon4_Boss, OverWorld1_3, Dungeon5_Entrance, Dungeon5_1, Dungeon5_2, Dungeon5_3, Dungeon5_4, Dungeon5_5,
			Dungeon5_6, Dungeon5_7, Dungeon5_8, Dungeon5_9, Dungeon5_10, Dungeon5_11, Dungeon5_Boss, Dungeon5_DeadBoss, Dungeon6_Entrance, Dungeon6_1,
			Dungeon6_2, Dungeon6_3, Dungeon6_4, Dungeon6_5, Dungeon6_6, Dungeon6_7, Dungeon6_8, Dungeon6_9, Dungeon6_Boss, Dungeon6_10, Dungeon7_Entrance,
			Dungeon7_1, Dungeon7_2, Dungeon7_3, Dungeon7_4, Dungeon7_5, Dungeon7_6, Dungeon7_7, Dungeon7_8, Dungeon7_9, Dungeon7_10, Dungeon7_Boss,
			OverWorld_fallhole, OverWorld_fallhole1, OverWorld_d7entrance, OverWorld_house, OverWorld1_4, OverWorld1_5, OverWorld1_6, OverWorld_waterfallcave,
			OverWorld_mountain, OverWorld_mountain1, OverWorld_finalboss, OverWorld_treelarge, OverWorld_d6entrance, Dungeon7_11, Dungeon7_12,
			Dungeon8_Entrance, Dungeon8_1, Dungeon8_2, Dungeon8_3, Dungeon8_4, Dungeon8_5, Dungeon8_6, Dungeon8_7, Dungeon8_8, Dungeon8_9, Dungeon8_10,
			Dungeon8_11, Dungeon8_12, End_1, End_Boss, End_2, End_3, End_4
		];
		buildings = [
			sprBuilding,
			sprBuilding1,
			sprBuilding2,
			sprBuilding3,
			sprBuilding4,
			sprBuilding5,
			sprBuilding6,
			sprBuilding7,
			sprBuilding8
		];
		buildingMasks = [
			imgBuildingMask,
			imgBuilding1Mask,
			imgBuilding2Mask,
			imgBuilding3Mask,
			imgBuilding4Mask,
			imgBuilding5Mask,
			imgBuilding6Mask,
			imgBuilding7Mask,
			imgBuilding8Mask
		];

		spGames = new Bitmap(imgGames);
		sprTreeLarge = new Spritemap(imgTreeLarge, 160, 192);
		sprLogo = new Spritemap(imgLogo, 152, 62);
		sprNG = new Spritemap(imgNG, 87, 75);
		sprMenuArrow = new Spritemap(imgMenuArrow, 16, 16);
		super();
		level = _level;
		playerPosition = new Point(_playerx, _playery);
		Main.printItems();

		restart = _restart;

		if (_menuState >= 0) {
			menuState = _menuState;
		}

		end();

		if (inventory == null) {
			inventory = new Inventory();
		}

		Music.bkgdVolumeMaxExtern = Music.fadeVolumeMaxExtern = 1; // Restore the volume.

		if (menu) {
			FP.engine.addChild(spGames);
		}
	}

	override public function end():Void {
		Inventory.drawFirstUseHelp = Inventory.drawExtendedHelp = false;
		underwater = false;
		talking = false;
		talkingText = "";
		talkingPic = null;
		fallthroughLevel = -1;
		fallthroughSign = -1;
		fallthroughOffset = new Point();
		resetCamera();
		resetCameraSpeed();
		if (!menu) {
			menuOffset = new Point();
			menuState = 0;
			menuScroll = 0;
			clearTweens();
			menuTween = null;
			rightArrowScale = leftArrowScale = 1;
			arrowMove = 0;
			arrowMoveRate = Math.abs(arrowMoveRate);
		}

		if (FP.engine.contains(spGames)) {
			FP.engine.removeChild(spGames);
		}
	}

	override public function begin():Void /*if (Main.hasSealPart(SealController.SEALS - 2) == -1)
		{
			for (var i:int = 0; i < 15; i++)
			{
				var index:int = -1;
				while (index < 0 || !SealController.getSealPart(index))
				{
					index = Math.floor(Math.random() * SealController.SEALS);
				}
			}
	}*/ {
		super.begin();
		sprGrass.x = -sprGrass.width / 2;
		sprGrass.y = -sprGrass.height;
		sprWater.centerOO();
		sprGround.centerOO();
		sprStone.centerOO();
		sprBrick.centerOO();
		sprDirt.centerOO();
		sprDungeonTile.centerOO();
		sprPit.centerOO();
		sprShieldTile.centerOO();
		sprForest.centerOO();
		sprCliff.centerOO();
		sprCliffStairs.centerOO();
		sprWood.centerOO();
		sprWoodWalk.centerOO();
		sprCave.centerOO();
		sprWoodTree.centerOO();
		sprDarkTile.centerOO();
		sprIgneousTile.centerOO();
		sprLava.centerOO();
		sprBlueTile.centerOO();
		sprBlueTileWall.centerOO();
		sprBlueTileWallDark.centerOO();
		sprSnow.centerOO();
		sprIce.centerOO();
		sprIceWall.centerOO();
		sprIceWallLit.centerOO();
		sprWaterfall.centerOO();
		sprBody.centerOO();
		sprBodyWall.centerOO();
		sprGhostTile.centerOO();
		sprBridge.centerOO();
		sprGhostTileStep.centerOO();
		sprIgneousLava.centerOO();
		sprOddTile.centerOO();
		sprFuchTile.centerOO();
		sprOddTileWall.centerOO();
		sprRockTile.centerOO();
		sprRockyTile.centerOO();

		sprLogo.centerOO();
		sprNG.centerOO();
		sprOpenTree.centerOO();
		sprTreeBare.centerOO();
		sprTree.centerOO();
		sprPole.centerOO();
		sprBlizzard.centerOO();
		sprPitShadow.centerOO();
		sprDroplet.centerOO();
		sprMenuArrow.centerOO();

		for (i in 0...bossLocks.length) {
			bossLocks[i].centerOO();
		}

		for (i in 0...bossKeys.length) {
			bossKeys[i].centerOO();
		}

		if (menu) {
			loadlevel(levels[menuLevels[menuIndex]]);
			cameraTarget = new Point((FP.width - FP.screen.width) * (menuIndex % 2), (FP.height - FP.screen.height) * (menuIndex % 2));
			FP.camera = cameraTarget.clone();
			// trace(menuLevels[menuIndex] + ": " + FP.camera.x + ", " + FP.camera.y);
			Input.clear();

			if (menuState != 0) {
				menuTween = new Tween(menuTweenTime, Tween.ONESHOT);
				addTween(menuTween, true);
			}
		} else {
			if (level < 0) {
				if (!cheats) {
					time = dayLength / 2;
					Music.playSound("Wind", 0);
					cutscene[0] = true;
				}
				level = 0;
			}
			loadlevel(levels[level]);
		}

		inventory.check();

		if (sign >= 0) {
			add(new Message(Std.int(FP.screen.width / 2), 0, sign));
			sign = -1;
		}

		if (cheats) {
			FP.console.enable();
		}
	}

	override public function update():Void {
		musicUpdate();

		if (Input.released(muteKey)) {
			FP.volume = as3hx.Compat.parseInt(FP.volume == 0 || Math.isNaN(FP.volume));
			Input.clear();
		} else {
			menuAndRestart();
		}

		if (!checked) {
			var v:Array<Entity> = new Array<Entity>();
			getAll(v);
			for (i in 0...v.length) {
				v[i].check();
			}
			checked = true;
		}
		if (blackCover <= 0) {
			super.update();
		}
		view();
		time += timeRate;
		if (time % (dayLength + nightLength) == 0) {
			daysPassed++;
		}
		todaysTime = as3hx.Compat.parseInt(time % (dayLength + nightLength));

		if (menu) {
			var cursor:String = MouseCursor.ARROW;
			var renderPt:Point = ngPos(Std.int(menuOffset.x), Std.int(menuOffset.y));
			if (Input.mouseX >= renderPt.x - sprNG.originX
				&& Input.mouseX < renderPt.x - sprNG.originX + sprNG.width
				&& Input.mouseY >= renderPt.y - sprNG.originY
				&& Input.mouseY < renderPt.y - sprNG.originY + sprNG.height) {
				cursor = MouseCursor.BUTTON;
				sprNG.frame = 1;
				if (Input.mouseDown) {
					sprNG.frame = 2;
				} else if (Input.mouseReleased) {
					new GetURL("http://www.newgrounds.com/games/browse/genre/adventure/interval/year/sort/score");
				}
			} else {
				sprNG.frame = 0;
			}

			if (spGames.alpha >= 1 && spGames.visible) {
				var gamesPos:Array<Dynamic> = [
					new Rectangle(33, 25, 282, 117),
					new Rectangle(33, 154, 282, 117),
					new Rectangle(33, 284, 282, 117)
				];
				var links:Array<Dynamic> = [
					"http://www.newgrounds.com/portal/view/555641",
					"http://www.newgrounds.com/portal/view/587346",
					"http://www.newgrounds.com/portal/view/579499"
				];
				for (i in 0...gamesPos.length) {
					var m:Point = new Point(Input.mouseX * FP.screen.scale, Input.mouseY * FP.screen.scale);
					if (m.x >= spGames.x + gamesPos[i].x
						&& m.x < spGames.x + gamesPos[i].x + gamesPos[i].width
						&& m.y >= spGames.y + gamesPos[i].y
						&& m.y < spGames.y + gamesPos[i].y + gamesPos[i].height) {
						cursor = MouseCursor.BUTTON;
						if (Input.mouseReleased) {
							new GetURL(links[i]);
						}
					}
				}
			}

			Mouse.cursor = cursor;
		} else {
			Mouse.cursor = MouseCursor.ARROW;
		}

		var p:Player = try cast(nearestToPoint("Player", 0, 0), Player) catch (e:Dynamic) null;
		if (p != null && classCount(Help) <= 0)
			// Managing snow alpha in the level (Dungeon5/Entrance) where the snow gets intense
		{
			if (level == 45 /* Dungeon5/Entrance.oel */) {
				snowAlpha = DEFAULT_SNOW_ALPHA * Math.pow(1 - p.y / FP.height, 2);
			} else {
				snowAlpha = DEFAULT_SNOW_ALPHA;
			}

			// The starting wind/text scene.
			if (cutscene[0] != null) {
				ALIGN = "CENTER";
				freezeObjects = true;
				p.receiveInput = false;
				p.directionFace = 3;
				timeRate = Math.max(timeRate - 0.0025, 0);
				if (classCount(DustParticle) <= 100 && timeRate > 0) {
					FP.world.add(new DustParticle(Std.int(FP.camera.x), Std.int(Math.random() * FP.screen.height + FP.camera.y)));
				}

				if (cutsceneTimer[0][0] > 0) {
					cutsceneTimer[0][0]--;
				} else if (cutsceneTimer[0][0] > -1) {
					talking = true;
					// The change in cTextIndex happens during the text function during the by-character change.
					if (cTextIndex <= 0) {
						proceedText = classCount(DustParticle) <= 0;
					} else if (cutsceneTimer[0][1] > 0)
						// Pan the camera over the first dungeon for some time, and don't proceed with text.
					{
						{
							proceedText = false;
							cutsceneTimer[0][1]--;
							cameraSpeedDivisor = 50;
							cameraTarget = new Point(256, 272);
						}
					}
					// Once the timer is up, reset the camera and let the text continue.
					else {
						{
							resetCamera();
							resetCameraSpeed();
							proceedText = true;
							if (cTextIndex >= cutsceneText[0].length)
								// If we're all done showing the text, go ahead and reactivate the player.
							{
								{
									// cTextIndex = cutsceneText[0][cutsceneText[0].length - 1]; TODO: Literally what is happening here??
									cutsceneTimer[0][0] = -1;
									talking = false;
									freezeObjects = false;
									p.directionFace = -1;
									p.receiveInput = true;
									cutscene[0] = false;
									timeRate = 1;
									ALIGN = "LEFT";
									add(new Help(2));
								}
							}
						}
					}

					talkingText = cutsceneText[0][cTextIndex];
				}
			} else if (cutscene[1] != null) {
				p.directionFace = 1;
				p.receiveInput = false;
				p.v.y = -1;
				if (p.y <= 64) {
					p.v.y = 0;
				}
			} else if (cutscene[2] != null) {
				p.receiveInput = false;
				p.visible = false;
				p.active = false;
			} else {
				cTextIndex = 0;
			}
		}
		if (raining) {
			var rainingHeavinessMax:Int = 100;
			if (Math.floor(Math.random() * (rainingHeavinessMax - rainingHeaviness)) == 0) {
				var rainingRectTemp:Rectangle = rainingRect.intersection(new Rectangle(FP.camera.x, FP.camera.y, FP.screen.width, FP.screen.height));
				if (rainingRectTemp != null) {
					FP.world.add(new Droplet(Std.int(rainingRectTemp.x + Math.random() * rainingRectTemp.width),
						Std.int(rainingRectTemp.y + rainingRectTemp.height * Math.random()), rainingHeight, rainingColor));
				}
			}
		}
		if (canInventory()) {
			inventory.update();
		} else if (inventory != null) {
			inventory.open = false;
		}
	}

	override public function render():Void {
		if (blurRegion) {
			sprBlurRegion.scale = 1 / 3;
			sprBlurRegion.render(new Point(FP.camera.x * (FP.width - sprBlurRegion.width * sprBlurRegion.scale) / (FP.width - FP.screen.width),
				FP.camera.y * (FP.height - sprBlurRegion.height * sprBlurRegion.scale) / (FP.height - FP.screen.height)),
				FP.camera);
		}
		if (blurRegion2) {
			sprBlurRegion2.x = -80;
			sprBlurRegion2.scale = 0.275;
			sprBlurRegion2.render(new Point(FP.camera.x * (FP.width - sprBlurRegion2.width * sprBlurRegion2.scale) / (FP.width - FP.screen.width),
				FP.camera.y * (FP.height - sprBlurRegion2.height * sprBlurRegion2.scale) / (FP.height - FP.screen.height)),
				FP.camera);
		}
		FP.buffer.draw(underBmp);
		underBmp.fillRect(underBmp.rect, 0x00000000);

		super.render();
		bufferTransforms();

		talk();
		if (newCoverDraw) {
			Draw.rect(Std.int(FP.camera.x), Std.int(FP.camera.y), FP.screen.width, FP.screen.height, newCoverColor, newCoverAlpha);
		}
		if (canInventory()) {
			inventory.render();
		}
		drawHealth();
		cover();

		var v:Array<Help> = new Array<Help>();
		getClass(Help, v);
		for (h in v) {
			h.render();
		}

		var vm:Array<Message> = new Array<Message>();
		getClass(Message, vm);
		for (m in vm) {
			m.render();
		}

		if (menu) {
			menuState = as3hx.Compat.parseInt((menuState + menuStates) % menuStates);
			var stateInterval:Int = FP.screen.width;
			var divisor:Int = 10;
			if (menuTween != null) {
				menuOffset.x = (-stateInterval * menuState - menuOffset.x) * menuTween.percent + menuOffset.x;
			} else {
				menuOffset.x = 0;
			}

			drawPromos(Std.int(menuOffset.x + stateInterval * 3), Std.int(menuOffset.y));
			drawCreditsText(Std.int(menuOffset.x + stateInterval * 2), Std.int(menuOffset.y));
			drawHelpText(Std.int(menuOffset.x + stateInterval), Std.int(menuOffset.y));
			drawLogo(Std.int(menuOffset.x), Std.int(menuOffset.y));

			var arrowScaleRate:Float = 0.1;
			if (rightArrowScale > 1) {
				rightArrowScale = Math.max(rightArrowScale - arrowScaleRate, 1);
			}
			if (leftArrowScale > 1) {
				leftArrowScale = Math.max(leftArrowScale - arrowScaleRate, 1);
			}

			arrowMove += arrowMoveRate;
			if (arrowMove >= 1) {
				arrowMove = 1;
				arrowMoveRate = -Math.abs(arrowMoveRate);
			}
			if (arrowMove <= 0) {
				arrowMove = 0;
				arrowMoveRate = Math.abs(arrowMoveRate);
			}
			var arrowMoveMax:Int = 8;
			var arrowMoveTemp:Float = arrowMoveMax * (1 - Math.sin(arrowMove * Math.PI));

			sprMenuArrow.scaleX = 1;
			sprMenuArrow.scale = rightArrowScale;
			sprMenuArrow.render(new Point(FP.screen.width - arrowMoveTemp - sprMenuArrow.width / 2, FP.screen.height - sprMenuArrow.height / 2), new Point());
			sprMenuArrow.scaleX = -sprMenuArrow.scaleX;
			sprMenuArrow.scale = leftArrowScale;
			sprMenuArrow.render(new Point(sprMenuArrow.width / 2 + arrowMoveTemp, FP.screen.height - sprMenuArrow.height / 2), new Point());
		}

		if (menu && restart) {
			Draw.rect(Std.int(FP.camera.x), Std.int(FP.camera.y), FP.screen.width, FP.screen.height, 0, 0.8);
			Text.static_size = 8;
			var text:Text = new Text("Would you like to restart? <Y>/<N>");
			text.color = 0xFFFFFF;
			text.render(new Point(FP.screen.width / 2 - text.width / 2, FP.screen.height / 2 - text.height / 2), new Point());
			Text.static_size = 16;
		}
		bufferRestore();
	}

	public function gameboy():Void {
		var cols:Array<Dynamic> = [0xFF0E380F, 0xFF306230, 0xFF8BAC0F, 0xFF9BBC0F];
		// (0xFF000000, 0xFF222222, 0xFF444444, 0xFF666666, 0xFF888888, 0xFFAAAAAA, 0xFFCCCCCC, 0xFFFFFFFF);//
		var hist:Array<Array<Float>> = (cast FP.buffer.histogram() : Array<Array<Float>>);
		var temp:BitmapData = new BitmapData(FP.buffer.width, FP.buffer.height, true, 0);
		for (i in 0...cols.length) {
			var c:BitmapData = FP.buffer.clone();

			var range:Int = 128;
			var r:Int = Std.int(Math.min(Math.max(maxIndex(hist[1]) + range, range), 255));
			var g:Int = Std.int(Math.min(Math.max(maxIndex(hist[2]) + range, range), 255));
			var b:Int = Std.int(Math.min(Math.max(maxIndex(hist[3]) + range, range), 255));
			var minCol:Int = FP.getColorRGB(Std.int(Math.max(r - range * 2, 0)), Std.int(Math.max(g - range * 2, 0)), Std.int(Math.max(b - range * 2, 0)));
			var col:Int = as3hx.Compat.parseInt(0xFF000000 + (FP.getColorRGB(r, g, b) - minCol) / cols.length * i + minCol);
			c.threshold(c, c.rect, new Point(), "<", col);
			c.threshold(c, c.rect, new Point(), ">=", col, cols[i]);
			temp.draw(c, null, null, BlendMode.HARDLIGHT);
			c.dispose();
		}
		FP.buffer.draw(temp);
		temp.dispose();
	}

	public function maxIndex(v:Array<Float>):Int {
		if (v.length <= 0) {
			return 0;
		}
		var m:Float = v[0];
		var index:Int = 0;
		for (i in 1...v.length) {
			if (v[i] > m) {
				index = i;
				m = v[i];
			}
		}
		return index;
	}

	/*
	 * Manages Music
	 */
	private function musicUpdate():Void {
		if (snowAlpha > 0 && blackAndWhite) {
			var maxBlizzardVolume:Float = 0.5;
			if (!Music.soundIsPlaying("Wind", 1)) {
				Music.playSound("Wind", 1);
			}
			Music.volumeSound("Wind", 1, snowAlpha / DEFAULT_SNOW_ALPHA * maxBlizzardVolume);
		} else {
			Music.stopSound("Wind", 1);
		}

		if (menu && !Music.sndOMenu.playing) {
			Music.fadeToLoop(Music.sndOMenu);
		}
		if (!menu) {
			if (Main.hasSword && !Main.hasShield && levelMusics[level] == 5 && level != 10 /* Watcher song */) {
				Music.stop(false, true, true);
			} else if (!Main.hasSword && (levelMusics[level] == 5 || levelMusics[level] == 0) && level != 10) {
				if (!Music.songs[4].playing) {
					Music.fadeToLoop(Music.songs[4], 0.05);
				}
			} else if (levelMusics[level] >= 0) {
				if (!Music.songs[levelMusics[level]].playing) {
					Music.fadeToLoop(Music.songs[levelMusics[level]], 0.05);
				}
			} else {
				Music.fadeToLoop(null, 0.05);
			}
		}
		if (Music.sndOTheme.playing) {
			var quarterDay:Float = dayLength / 4;
			var _a:Float = 1;
			if (todaysTime < quarterDay)
				// Dawn
			{
				{
					_a = todaysTime / quarterDay;
				}
			} else if (todaysTime < quarterDay * 3)
				// Daytime
			{
				{};
			} else if (todaysTime < dayLength)
				// Twilight
			{
				{
					_a = 1 - (todaysTime - quarterDay * 3) / quarterDay;
				}
			}
			// Night
			else {
				{
					_a = 0;
				}
			}
			Music.bkgdVolumeDefault = _a;
			Music.fadeVolumeDefault = _a;
		} else {
			Music.bkgdVolumeDefault = 1;
			Music.fadeVolumeDefault = 1;
		}
	}

	private function menuAndRestart():Void {
		if (menu) {
			cutscene[0] = false;

			if (Input.released(restartKey) && !restart) {
				restart = true;
				Input.clear();
			} else if (restart) {
				if (Input.released(yesKey)) {
					Main.clearSave();
					cutscene[1] = cutscene[2] = false;
					restart = false;
					menu = false;
					FP.world = new Game();
				} else if (Input.released(Key.ANY)) {
					restart = false;
					Input.clear();
				}
			} else if (Input.released(menuKeyRight)) {
				rightArrowScale = 2;
				menuState++;
				menuTween = new Tween(menuTweenTime, Tween.ONESHOT, null, Ease.circIn);
				addTween(menuTween, true);
				Music.playSound("Text", 1);
				Input.clear();
			} else if (Input.released(menuKeyLeft)) {
				leftArrowScale = 2;
				menuState--;
				menuTween = new Tween(menuTweenTime, Tween.ONESHOT, null, Ease.circIn);
				addTween(menuTween, true);
				Music.playSound("Text", 1);
				Input.clear();
			} else if (Input.released(Key.ANY))
				// || Input.mouseReleased)
			{
				{
					Input.clear();
					menu = false;
					FP.world = new Game(level, Std.int(playerPosition.x), Std.int(playerPosition.y));
				}
			}
			Game.freezeObjects = true;
			if (FP.width > FP.height) {
				cameraTarget = new Point(cameraTarget.x - 2 * (menuIndex % 2) + 1,
					cameraTarget.x * (FP.height - FP.screen.height) / (FP.width - FP.screen.width));
			} else {
				cameraTarget = new Point(cameraTarget.y * (FP.width - FP.screen.width) / (FP.height - FP.screen.height), cameraTarget.y + 1);
			}
			drawCover(0, 1 - Math.sin(cameraTarget.x / (FP.width - FP.screen.width) * Math.PI));
			if (cameraTarget.x > FP.width - FP.screen.width
				|| cameraTarget.x < -1
				|| cameraTarget.y > FP.height - FP.screen.height
				|| cameraTarget.y < -1) {
				undrawCover();
				menuIndex = as3hx.Compat.parseInt((menuIndex + 1) % menuLevels.length);
				FP.world = new Game(level, Std.int(playerPosition.x), Std.int(playerPosition.y));
				return;
			}
		} else if (Input.released(restartKey)) {
			menu = true;
			Input.clear();
			FP.world = new Game(level, Std.int(playerPosition.x), Std.int(playerPosition.y), true);
		} else if (Input.released(escapeKey)) {
			menu = true;
			FP.world = new Game(level, Std.int(playerPosition.x), Std.int(playerPosition.y));
		}
	}

	private function drawLogo(_xoff:Int = 0, _yoff:Int = 0):Void {
		renderMenu(_xoff, _yoff);
		Draw.setTarget(nightBmp, new Point());
		renderMenu(_xoff, _yoff);
		Draw.resetTarget();
	}

	private function drawPromos(_xoff:Int = 0, _yoff:Int = 0):Void {
		var maxRectAlpha:Float = 0.8;
		var basePos:Point = new Point(FP.screen.width / 2, FP.screen.height / 2);
		var tweenScale:Float = (menuAlphaDivisor == 0) ? 1 : Math.max(1 - Math.abs(_xoff) / menuAlphaDivisor, 0);

		if (tweenScale <= 0) {
			spGames.visible = false;
			return;
		}
		spGames.visible = true;

		var rectW:Int = as3hx.Compat.parseInt((spGames.width * FP.screen.scale + 4) / 2);
		Draw.rect(Std.int(FP.camera.x + basePos.x + _xoff - rectW), Std.int(FP.camera.y), rectW * 2, FP.screen.height, 0, tweenScale * maxRectAlpha);

		spGames.alpha = tweenScale;
		spGames.x = (basePos.x + _xoff) * FP.screen.scale - spGames.width / 2;
		spGames.y = (basePos.y + _yoff) * FP.screen.scale - spGames.height / 2;
	}

	private function drawCreditsText(_xoff:Int = 0, _yoff:Int = 0):Void {
		var sectionToSectionMargin:Int = 32; // The distance between the last text in "Programming/Graphics" to the title "Music"
		var titleToTextMargin:Int = 0; // The distance between the title and the first name
		var nameToNameMargin:Int = 0; // The distance between each name in the list.
		var rectToTextMargin:Int = 4; // The distance between the text and the edge of the bounding black box
		var maxRectAlpha:Float = 0.8;
		var menuScrollSpeed:Float = 0.6;
		var basePos:Point = new Point(FP.screen.width / 2, FP.screen.height / 3);
		var tweenScale:Float = (menuAlphaDivisor == 0) ? 1 : Math.max(1 - Math.abs(_xoff) / menuAlphaDivisor, 0);
		var text:Text;

		if (tweenScale <= 0) {
			return;
		} else {
			menuScroll -= tweenScale * menuScrollSpeed;
		}

		var rectW:Int = as3hx.Compat.parseInt(tweenScale * (menuMaxWidthCredits + rectToTextMargin));
		Draw.rect(Std.int(FP.camera.x + basePos.x + _xoff - rectW), Std.int(FP.camera.y), rectW * 2, FP.screen.height, 0, tweenScale * maxRectAlpha);

		var height:Int = 0;
		for (i in 0...menuCreditsTitles.length) {
			Text.static_size = 16;
			text = new Text(menuCreditsTitles[i]);
			text.x = basePos.x + _xoff;
			text.y = basePos.y + menuScroll + text.height / 2 + height + _yoff;
			text.centerOO();
			text.alpha = text.scaleX = tweenScale;
			text.color = 0x88FF44;
			drawTextBold(text, null, 0x002200);
			height += as3hx.Compat.parseInt(text.height + titleToTextMargin);

			menuMaxWidthCredits = Std.int(Math.max(text.width / 2, menuMaxWidthCredits));

			Text.static_size = 8;
			var textName:Text;
			for (j in 0...menuCreditsNames[i].length) {
				textName = new Text(menuCreditsNames[i][j]);
				textName.x = basePos.x + _xoff;
				textName.y = basePos.y + menuScroll + text.height / 2 + height + _yoff;
				textName.centerOO();
				textName.alpha = textName.scaleX = tweenScale;
				textName.color = 0x8844FF;
				textName.render(new Point(), new Point());
				// drawTextBold(textName, null, 0x000044);
				height += as3hx.Compat.parseInt(textName.height + ((j + 1 < menuCreditsNames[i].length) ? nameToNameMargin : sectionToSectionMargin));
				menuMaxWidthCredits = Std.int(Math.max(textName.width / 2, menuMaxWidthCredits));
			}
		}
		if (basePos.y + menuScroll + height + _yoff < 0) {
			menuState++;
			menuTween = new Tween(menuTweenTime, Tween.ONESHOT, null, Ease.circIn);
			addTween(menuTween, true);
			menuScroll = FP.screen.height - basePos.y;
		}
		Text.static_size = 16;
	}

	private function drawHelpText(_xoff:Int = 0, _yoff:Int = 0):Void {
		var margin:Int = 4;
		var maxRectAlpha:Float = 0.8;
		var basePos:Point = new Point(FP.screen.width / 2, FP.screen.height / 4);
		var tweenScale:Float = (menuAlphaDivisor == 0) ? 1 : Math.max(1 - Math.abs(_xoff) / menuAlphaDivisor, 0);
		if (tweenScale <= 0) {
			return;
		}

		var text:Text;

		var rectW_left:Float = tweenScale * (menuMaxWidthControlsLeft + margin);
		var rectW_right:Float = tweenScale * (menuMaxWidthControlsRight + margin);
		Draw.rect(Std.int(FP.camera.x + basePos.x + _xoff - rectW_left), Std.int(FP.camera.y), Std.int(rectW_left + rectW_right), FP.screen.height, 0,
			tweenScale * maxRectAlpha);

		Text.static_size = 16;
		text = new Text("Controls");
		text.centerOO();
		text.scaleX = tweenScale;
		text.x = basePos.x - text.width / 2 + _xoff;
		text.y = basePos.y - text.height + _yoff - FP.screen.height * (1 - tweenScale);
		text.color = 0xFFFFFF;
		drawTextBold(text, null, 0);

		Text.static_size = 8;
		var texts:Array<Text> = new Array<Text>();
		for (i in 0...menuText.length) {
			texts.push(new Text(menuText[i]));
		}
		for (i in 0...menuText.length) {
			texts[i].originX = texts[i].width;
			texts[i].x = basePos.x - texts[i].width - margin / 2 * tweenScale + _xoff;
			texts[i].y = ((i - 1 >= 0) ? texts[i - 1].y + texts[i].height : basePos.y + _yoff + FP.screen.height * (1 - tweenScale));
			texts[i].alpha = texts[i].scaleX = tweenScale;
			texts[i].color = 0x88FF44;
			drawTextBold(texts[i], null, 0x002200);
			menuMaxWidthControlsLeft = Std.int(Math.max(texts[i].width, menuMaxWidthControlsLeft));
		}
		for (i in 0...menuTextAppend.length) {
			text = new Text(menuTextAppend[i]);
			text.x = basePos.x + margin / 2 * tweenScale + _xoff;
			text.y = texts[i].y;
			text.alpha = text.scaleX = tweenScale;
			text.color = 0x8844FF;
			drawTextBold(text, null, 0x000022);
			menuMaxWidthControlsRight = Std.int(Math.max(text.width, menuMaxWidthControlsRight));
		}
		menuMaxWidthControlsLeft = menuMaxWidthControlsRight = Std.int(Math.max(menuMaxWidthControlsLeft, menuMaxWidthControlsRight));
		Text.static_size = 16;
	}

	private function renderMenu(_xoff:Int, _yoff:Int):Void {
		var offset:Int = 4;
		var renderPt:Point = new Point(FP.screen.width / 2 + _xoff, FP.screen.height / 4 + _yoff);
		sprLogo.alpha = (menuAlphaDivisor == 0) ? 1 : Math.max(1 - Math.abs(_xoff) / menuAlphaDivisor, 0);
		sprLogo.y += offset;
		sprLogo.color = 0;
		sprLogo.render(renderPt.clone(), new Point());
		sprLogo.y -= offset;
		sprLogo.color = 0xFFFFFF;
		sprLogo.render(renderPt.clone(), new Point());

		Text.static_size = 8;
		var t:Text = new Text("press any key to play", 26, 46);
		t.alpha = sprLogo.alpha;
		t.color = 0;
		t.render(new Point(renderPt.x - sprLogo.originX, renderPt.y + 1 - sprLogo.originY), new Point());
		t.color = 0xFFFFFF;
		t.render(new Point(renderPt.x - sprLogo.originX, renderPt.y - sprLogo.originY), new Point());
		Text.static_size = 16;

		sprNG.alpha = sprLogo.alpha;
		sprNG.render(ngPos(_xoff, _yoff), new Point());
	}

	private function ngPos(_xoff:Int, _yoff:Int):Point {
		return new Point(FP.screen.width / 2 + _xoff, FP.screen.height + _yoff - sprNG.height / 2);
	}

	public static function health(hits:Int, hitsMax:Int):Void {
		healthc = as3hx.Compat.parseInt(hitsMax - hits - 1);
		healths = hitsMax;
	}

	public static function drawHealth():Void {
		if (menu) {
			return;
		}
		var cols:Int = 2;
		for (i in 0...healths) {
			sprHealth.frame = as3hx.Compat.parseInt(i > healthc);
			sprHealth.render(new Point(FP.screen.width - sprHealth.width - as3hx.Compat.parseInt(i % cols) * (sprHealth.width - 1),
				as3hx.Compat.parseInt(i / 2) * (sprHealth.height - 1)),
				new Point());
		}
	}

	public function canInventory():Bool {
		var p:Player = try cast(nearestToPoint("Player", 0, 0), Player) catch (e:Dynamic) null;
		return inventory != null && !talking && p != null && p.receiveInput && !p.destroy;
	}

	public function bufferTransforms():Void {
		if (underwater) {
			FP.buffer.colorTransform(FP.buffer.rect, new ColorTransform(1, 1, 2, 1, -128, -128, 0));
		}
		// Day/night system
		var quarterDay:Float = dayLength / 4;
		var currentLightAlpha:Float = 1;
		var nightAlpha:Float = 0.1;
		if (dayNight) {
			if (todaysTime < quarterDay)
				// Dawn
			{
				{
					currentLightAlpha = (todaysTime / quarterDay) * (1 - nightAlpha) + nightAlpha;
				}
			} else if (todaysTime < quarterDay * 3)
				// Daytime
			{
				{};
			} else if (todaysTime < dayLength)
				// Twilight
			{
				{
					currentLightAlpha = (1 - (todaysTime - quarterDay * 3) / quarterDay) * (1 - nightAlpha) + nightAlpha;
				}
			}
			// Night
			else {
				{
					currentLightAlpha = nightAlpha;
				}
			}
		}
		nightBmp.draw(solidBmp, null, new ColorTransform(1, 1, 1, solidBmpAlpha), BlendMode.HARDLIGHT);

		if (snowing) {
			snowBmp.fillRect(snowBmp.rect, 0);
			Draw.setTarget(snowBmp, new Point());
			sprBlizzard.scaleX = FP.screen.width / sprBlizzard.width;
			sprBlizzard.scaleY = FP.screen.height / sprBlizzard.height;
			blizzardOffset.x += blizzardRate.x;
			blizzardOffset.y += blizzardRate.y;
			blizzardOffset.x %= sprBlizzard.width;
			blizzardOffset.y %= sprBlizzard.height;
			sprBlizzard.alpha = snowAlpha;
			// sprBlizzard.color = FP.colorLerp(0x000000, 0xFFFFFF, currentLightAlpha);
			for (i in 0...2) {
				for (j in 0...2) {
					var xpos:Float = blizzardOffset.x - i * sprBlizzard.width + sprBlizzard.originX;
					var ypos:Float = blizzardOffset.y - j * sprBlizzard.height + sprBlizzard.originY;
					sprBlizzard.render(new Point(xpos, ypos), new Point());

					sprBlizzard.render(new Point(xpos, ypos - 24), new Point());
					sprBlizzard.render(new Point(xpos, ypos + 24), new Point());
				}
			}
			var p:Player = try cast(nearestToPoint("Player", 0, 0), Player) catch (e:Dynamic) null;
			if (p != null && Player.hasWand) {
				var blizzardCircleRadius:Int = 64;
				sprLight.scaleX = blizzardCircleRadius / sprLight.width;
				sprLight.scaleY = blizzardCircleRadius / sprLight.height;
				sprLight.centerOO();
				sprLight.blend = BlendMode.DARKEN;
				var lightsToDraw:Int = as3hx.Compat.parseInt(10 * snowAlpha);
				for (i in 0...lightsToDraw) {
					sprLight.render(new Point(p.x, p.y), FP.camera);
				}
			}
			FP.buffer.draw(snowBmp, null, null, BlendMode.ADD);
		}
		FP.buffer.draw(nightBmp, null,
			new ColorTransform(1, 1, 1, 1 - (currentLightAlpha * lightAlpha) * (1 - minDarkness) - Math.min(minDarkness, lightAlpha)), BlendMode.MULTIPLY);

		if (blackAndWhite) {
			bwBuffer.copyPixels(FP.buffer, bwBuffer.rect, new Point());
			var rc:Float = 0.3;
			var gc:Float = 0.59;
			var bc:Float = 0.11;
			bwBuffer.applyFilter(bwBuffer, bwBuffer.rect, new Point(),
				new ColorMatrixFilter([rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, 0, 0, 0, 1, 0]));
			FP.buffer.draw(bwBuffer, null, new ColorTransform(1, 1, 1, snowAlpha / DEFAULT_SNOW_ALPHA));
		}
		Draw.resetTarget();
	}

	public function averageColor(v:Array<Float>):Int {
		var sum:Int = 0;
		for (i in 0...v.length) {
			sum += Std.int(v[i]);
		}
		sum = Std.int(sum / v.length);
		return sum;
	}

	public function bufferRestore():Void {
		nightBmp.fillRect(nightBmp.rect, 0xFF080822);
		solidBmp.fillRect(solidBmp.rect, 0x00000000);
	}

	public function drawCover(c:Int = 0x000000, a:Float = 1):Void {
		newCoverColor = c;
		newCoverAlpha = a;
		newCoverDraw = true;
	}

	public function undrawCover():Void {
		newCoverColor = 0x000000;
		newCoverAlpha = 0;
		newCoverDraw = false;
	}

	public function talk():Void {
		if (talking && talkingText != null) {
			var n:Int = 6;
			Draw.rect(Std.int(FP.camera.x), Std.int(FP.camera.y), FP.screen.width, Std.int(FP.screen.height / n), speakingColor, speakingAlpha);
			Draw.rect(Std.int(FP.camera.x), Std.int(FP.camera.y + FP.screen.height * (n - 1) / n), FP.screen.width, Std.int(FP.screen.height / n + 1),
				speakingColor, speakingAlpha);
			var minM:Int = 4; // The margin between the image border and the text area
			var textToImageMargin:Int = 8; // The distance between the text and the image
			var d:Int = as3hx.Compat.parseInt(FP.screen.height / n);
			Text.static_size = 8;

			// Scrolling text
			if (framesThisCharacter > 0) {
				framesThisCharacter--;
			} else {
				framesThisCharacter = framesPerCharacter;
				currentCharacter++;

				var soundBufferCharacters:Int = 3; // The number of characters before the end of the phrase where it stops restarting the sound.

				if (currentCharacter > talkingText.length) {
					if (textTimer > 0) {
						textTimer--;
					} else {
						if (proceedText) {
							cTextIndex++;
						}
						textTimer = textTime;
					}
				} else if (currentCharacter <= talkingText.length - soundBufferCharacters) {
					if (!Music.soundIsPlaying("Text", 0)) {
						Music.playSound("Text", 0);
					}
				}
			}
			var fullString:String;
			fullString = talkingText.substr(0, currentCharacter);

			var t:Text = new Text(fullString);
			var w:Int = textToImageMargin; // The distance of the text to the left edge.
			if (talkingPic != null) {
				var m:Int = as3hx.Compat.parseInt((d - talkingPic.height * talkingPic.scale) / 2);
				Draw.rect(Std.int(FP.camera.x + minM), Std.int(FP.camera.y + FP.screen.height * (n - 1) / n + minM), m * 2
					+ talkingPic.width
					- minM * 2,
					m * 2
					+ talkingPic.height
					- minM * 2, 0xFFFFFF, 1);
				talkingPic.render(new Point(m, FP.screen.height * (n - 1) / n + m), new Point());
				if (talkingPic != null) {
					w += as3hx.Compat.parseInt(m + talkingPic.width * talkingPic.scale);
				}
			}
			var alignOffsetX:Int = 0;
			switch (ALIGN) {
				case "LEFT":
				case "CENTER":
					alignOffsetX = as3hx.Compat.parseInt((FP.screen.width - w - t.width) / 2);
				case "RIGHT":
					alignOffsetX = as3hx.Compat.parseInt((FP.screen.width - w) - t.width);
				default:
			}
			t.render(new Point(w + alignOffsetX, FP.screen.height * (n - 1 / 2) / n - t.height / 2 + 1), new Point());
			if (currentCharacter > talkingText.length && cutscene[0] == null) {
				var text:Text = new Text("<X>");
				var pt:Point = new Point(FP.screen.width - text.width, FP.screen.height - d - text.height / 2);
				drawTextBold(text, pt);
			}
		}
	}

	public static function drawTextBold(t:Text, p:Point, c:Int = 0, camera:Point = null):Void {
		var _c:Int = t.color;
		t.color = c;
		if (camera == null) {
			camera = new Point();
		}
		if (p == null) {
			p = new Point();
		}
		t.render(new Point(p.x - 1, p.y), camera);
		t.render(new Point(p.x + 1, p.y), camera);
		t.render(new Point(p.x, p.y - 1), camera);
		t.render(new Point(p.x, p.y + 1), camera);
		t.color = _c;
		t.render(p.clone(), camera);
	}

	private static function set_talkingText(s:String):String {
		if (_talkingText != s) {
			currentCharacter = 0;
		}
		_talkingText = s;
		return s;
	}

	private static function get_talkingText():String {
		return _talkingText;
	}

	public function cover():Void {
		if (drawBlackCover) {
			if (blackCover > 0) {
				Draw.rect(Std.int(FP.camera.x), Std.int(FP.camera.y), FP.screen.width, FP.screen.height, 0x000000, blackCover);
			}
		}
		if (blackCoverRate > 0 && blackCover < 1) {
			blackCover = Math.min(blackCover + blackCoverRate, 1);
		} else if (blackCoverRate < 0 && blackCover > 0) {
			blackCover = Math.max(blackCover + blackCoverRate, 0);
		}
	}

	public function totalEnemies():Int // return typeCount("Enemy") + typeCount("ShieldBoss");
	{
		return as3hx.Compat.parseInt(classCount(Bob) + classCount(BobSoldier) + classCount(BobBoss) + classCount(Flyer) + classCount(Jellyfish)
			+ classCount(Cactus) + classCount(SandTrap) + classCount(ShieldBoss) + classCount(Spinner) + classCount(WallFlyer) + classCount(Puncher)
			+ classCount(Drill) + classCount(Turret) + classCount(IceTurret) + classCount(BossTotem) + classCount(Tentacle) + classCount(TentacleBeast)
			+ classCount(Grenade) + classCount(DarkTrap) + classCount(LightBoss) + classCount(LavaRunner) + classCount(Bulb) + classCount(Squishle)
			+ classCount(FinalBoss) + classCount(Enemy));
	}

	public static function checkPersistence(tag:Int, _l:Int = -1):Bool {
		return Main.levelPersistence((_l >= 0) ? _l : Main.level, tag);
	}

	public static function setPersistence(tag:Int, o:Bool, _l:Int = -1):Void {
		Main.levelPersistenceSet((_l >= 0) ? _l : Main.level, tag, o);
	}

	public static function worldFrame(n:Int,
			loops:Float = 1):Int // n is the number of values to return (1..n) and loops is the number of animation loops to go over.
	{
		return as3hx.Compat.parseInt((time % (timePerFrame * loops)) / (timePerFrame * loops / Math.max(n, 1)));
	}

	public function view():Void {
		var player:Player = try cast(nearestToPoint("Player", FP.camera.x + FP.width / 2, FP.camera.y + FP.height / 2), Player) catch (e:Dynamic) null;
		var targetPosition:Point = new Point();
		if (player != null) {
			targetPosition = new Point(player.x - FP.screen.width / 2, player.y - FP.screen.height / 2);
			// Inventory offsetting
			targetPosition.x -= Inventory.width / 2 + Inventory.offset.x / 2;
		}

		if (cameraTarget.x != -1 || cameraTarget.y != -1) {
			targetPosition = cameraTarget.clone();
		}
		FP.camera.x += (targetPosition.x - FP.camera.x) / cameraSpeedDivisor;
		FP.camera.y += (targetPosition.y - FP.camera.y) / cameraSpeedDivisor;

		if (FP.width < FP.screen.width) {
			FP.camera.x = -(FP.screen.width - FP.width) / 2;
		} else {
			FP.camera.x = Math.min(Math.max(FP.camera.x, 0), FP.width - FP.screen.width);
		}
		if (FP.height < FP.screen.height) {
			FP.camera.y = -(FP.screen.height - FP.height) / 2;
		} else {
			FP.camera.y = Math.min(Math.max(FP.camera.y, 0), FP.height - FP.screen.height);
		}

		if (shake > 0) {
			FP.camera.x += shake * Math.random() - shake / 2;
			FP.camera.y += shake * Math.random() - shake / 2;
			shake = Math.max(shake - 1, 0);
		}

		FP.camera.x = Math.round(FP.camera.x);
		FP.camera.y = Math.round(FP.camera.y);
	}

	private static function set_cameraTarget(_c:Point):Point {
		_cameraTarget = _c;
		return _c;
	}

	private static function get_cameraTarget():Point {
		return _cameraTarget;
	}

	public static function resetCamera():Void {
		cameraTarget = new Point(-1, -1);
	}

	public function restartLevel():Void {
		FP.world = new Game(level, Std.int(playerPosition.x), Std.int(playerPosition.y));
	}

	public function loadlevel(_level:String):Void {
		var xml:Access = new Access(Xml.parse(_level)).node.level;

		var e:Entity;
		var o:Access;
		var n:Access;

		FP.width = Std.parseInt(xml.node.width.innerData);
		FP.height = Std.parseInt(xml.node.height.innerData);

		var w:Int = Std.parseInt(xml.node.width.innerData);
		var h:Int = Std.parseInt(xml.node.height.innerData);

		lightAlpha = 1;
		dayNight = false;
		snowing = false;
		blackAndWhite = false;
		raining = false;
		blurRegion = false;
		blurRegion2 = false;

		if (xml.hasNode.objects) {
			if (xml.nodes.objects[0].hasNode.lightalpha) {
				lightAlpha = minLightAlpha + as3hx.Compat.parseFloat(xml.nodes.objects[0].node.lightalpha.att.alpha);
			}
			if (xml.nodes.objects[0].hasNode.daynight) {
				dayNight = true;
			}
			if (xml.nodes.objects[0].hasNode.snow) {
				snowing = true;
				blackAndWhite = true;
			}
			if (xml.nodes.objects[0].hasNode.blur) {
				blurRegion = true;
			}
			if (xml.nodes.objects[0].hasNode.blur2) {
				blurRegion2 = true;
			}
		}

		var tile:Tile;
		tiles = new Array<Array<Tile>>();
		var i:Int = 0;
		while (i < (FP.width / Tile.w)) {
			tiles.push(new Array<Tile>());
			var j:Int = 0;
			while (j < FP.height / Tile.h) {
				tiles[i].push(null);
				j += 1;
			}
			i += 1;
		}
		if (xml.hasNode.tiles) {
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),tiles),EConst(CInt(0))),tile) type: null */ in xml.nodes.tiles[0].nodes.tile) {
				if (Math.floor(Std.parseInt(o.att.x) / Tile.w) < tiles.length
					&& Math.floor(Std.parseInt(o.att.y) / Tile.h) < tiles[0].length) {
					switch (Math.floor(Std.parseInt(o.att.tx) / Tile.w)) {
						case 0:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 0, false));
						case 1:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 0));
						case 2:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 1));
						case 3:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 2));
						case 4:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 3));
						case 5:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 4));
						case 6:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 5));
						case 7:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 6));
						case 8:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 7));
						case 9:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 8, false));
						case 10:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 8));
						case 11:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 9));
						case 12:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 10));
						case 13:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 11));
						case 14:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 12));
						case 15:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 13));
						case 16:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 14));
						case 17:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 15));
						case 18:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 16));
						case 19:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 17));
						case 20:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 18));
						case 21:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 19));
						case 22:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 20));
						case 23:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 21));
						case 24:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 22));
						case 25:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 23));
						case 26:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 24));
						case 27:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 25, false, null, false, true, false));
						case 28:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 25, false, null, false, false, false));
						case 29:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 25, false, null, true, false, false));
						case 30:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 25, false, null, true, true, false));
						case 31:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 25, false, null, false, true, true));
						case 32:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 25, false, null, false, false, true));
						case 33:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 26));
						case 34:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 27));
						case 35:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 28));
						case 36:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 29));
						case 37:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 30));
						case 38:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 31));
						case 39:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 32));
						case 40:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 33));
						case 41:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 34));
						case 42:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 35));
						case 43:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 36));
						case 44:
							add(tile = new Tile(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 37));
						default:
							tile = null;
					}
					tiles[Math.floor(Std.parseInt(o.att.x) / Tile.w)][Math.floor(Std.parseInt(o.att.y) / Tile.h)] = tile;
				}
			}
		}
		if (xml.hasNode.cliffsides) {
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),cliffsides),EConst(CInt(0))),tile) type: null */ in xml.nodes.cliffsides[0].nodes.tile) {
				add(new CliffSide(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Math.floor(Std.parseInt(o.att.tx) / Tile.w)));
			}
		}

		if (!menu) {
			var v:Array<Player> = new Array<Player>();
			getClass(Player, v);
			if (v.length > 0) {
				for (p in v) {
					p.x = playerPosition.x;
					p.y = playerPosition.y;
					p.fallFromCeiling = setFallFromCeiling;
				}
			} else {
				if (xml.hasNode.objects) {
					for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),player) type: null */ in xml.nodes.objects[0].nodes.player) {
						playerPosition = new Point(Std.parseInt(o.att.x), Std.parseInt(o.att.y));
					}
				}
				var player:Player;
				add(player = new Player(Std.int(playerPosition.x), Std.int(playerPosition.y)));
				FP.camera.x = player.x - FP.screen.width / 2;
				FP.camera.y = player.y - FP.screen.height / 2;
				player.fallFromCeiling = setFallFromCeiling;
			}
		}
		if (xml.hasNode.objects) {
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),control) type: null */ in xml.nodes.objects[0].nodes.control)
				// Used to be above the player block, so check if it will cause issues.
			{
				{
					fallthroughLevel = Std.parseInt(o.att.fallthrough);
					fallthroughOffset = new Point(Std.parseInt(o.att.x), Std.parseInt(o.att.y));
					var tempOffset:Point = new Point(Std.parseInt(o.att.xOff), Std.parseInt(o.att.yOff));
					fallthroughOffset = new Point(fallthroughOffset.x + tempOffset.x, fallthroughOffset.y + tempOffset.y);
					fallthroughSign = as3hx.Compat.parseInt(Std.parseInt(o.att.sign) - 1);
				}
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),droplet) type: null */ in xml.nodes.objects[0].nodes.droplet) {
				raining = true;
				rainingHeaviness = Std.parseInt(o.att.heaviness);
				rainingRect = new Rectangle(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.width), Std.parseInt(o.att.height));
				rainingRect.width = rainingRect.width != -(1) ? rainingRect.width : FP.width;
				rainingRect.height = rainingRect.height != -(1) ? rainingRect.height : FP.height;
				rainingHeight = Std.parseInt(o.att.startheight);
				rainingColor = Std.parseInt(o.att.color);
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),bob) type: null */ in xml.nodes.objects[0].nodes.bob) {
				add(new Bob(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),bobsoldier) type: null */ in xml.nodes.objects[0].nodes.bobsoldier) {
				add(new BobSoldier(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),bobboss1) type: null */ in xml.nodes.objects[0].nodes.bobboss1) {
				add(new BobBoss(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 0));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),bobboss2) type: null */ in xml.nodes.objects[0].nodes.bobboss2) {
				add(new BobBoss(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 1));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),bobboss3) type: null */ in xml.nodes.objects[0].nodes.bobboss3) {
				add(new BobBoss(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 2));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),bosstotem) type: null */ in xml.nodes.objects[0].nodes.bosstotem) {
				add(new BossTotem(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),lightbosscontroller) type: null */ in xml.nodes.objects[0].nodes.lightbosscontroller) {
				add(new LightBossController(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.fliernum), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),lavaboss) type: null */ in xml.nodes.objects[0].nodes.lavaboss) {
				add(new LavaBoss(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),finalboss) type: null */ in xml.nodes.objects[0].nodes.finalboss) {
				add(new FinalBoss(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),flyer) type: null */ in xml.nodes.objects[0].nodes.flyer) {
				add(new Flyer(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),jellyfish) type: null */ in xml.nodes.objects[0].nodes.jellyfish) {
				add(new Jellyfish(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),lavarunner) type: null */ in xml.nodes.objects[0].nodes.lavarunner) {
				add(new LavaRunner(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),bulb) type: null */ in xml.nodes.objects[0].nodes.bulb) {
				add(new Bulb(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),tentaclebeast) type: null */ in xml.nodes.objects[0].nodes.tentaclebeast) {
				add(new TentacleBeast(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),drill) type: null */ in xml.nodes.objects[0].nodes.drill) {
				add(new Drill(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),sandtrap) type: null */ in xml.nodes.objects[0].nodes.sandtrap) {
				add(new SandTrap(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),icetrap) type: null */ in xml.nodes.objects[0].nodes.icetrap) {
				add(new IceTrap(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),lavatrap) type: null */ in xml.nodes.objects[0].nodes.lavatrap) {
				add(new LavaTrap(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),darktrap) type: null */ in xml.nodes.objects[0].nodes.darktrap) {
				add(new DarkTrap(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),turret) type: null */ in xml.nodes.objects[0].nodes.turret) {
				add(new Turret(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),iceturret) type: null */ in xml.nodes.objects[0].nodes.iceturret) {
				add(new IceTurret(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),beamtower) type: null */ in xml.nodes.objects[0].nodes.beamtower) {
				add(new BeamTower(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.direction), Std.parseInt(o.att.rate),
					Std.parseInt(o.att.speed)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),grenade) type: null */ in xml.nodes.objects[0].nodes.grenade) {
				add(new Grenade(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),bombpusher) type: null */ in xml.nodes.objects[0].nodes.bombpusher) {
				add(new BombPusher(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),crusher) type: null */ in xml.nodes.objects[0].nodes.crusher) {
				add(new Crusher(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tset)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),puncher) type: null */ in xml.nodes.objects[0].nodes.puncher) {
				add(new Puncher(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),treelarge) type: null */ in xml.nodes.objects[0].nodes.treelarge) {
				add(new TreeLarge(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),tree) type: null */ in xml.nodes.objects[0].nodes.tree) {
				add(new Tree(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),treebare) type: null */ in xml.nodes.objects[0].nodes.treebare) {
				add(new Tree(Std.parseInt(o.att.x), Std.parseInt(o.att.y), true));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),burnabletree) type: null */ in xml.nodes.objects[0].nodes.burnabletree) {
				add(new BurnableTree(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),opentree) type: null */ in xml.nodes.objects[0].nodes.opentree) {
				add(new OpenTree(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),snowhill) type: null */ in xml.nodes.objects[0].nodes.snowhill) {
				add(new SnowHill(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),building) type: null */ in xml.nodes.objects[0].nodes.building) {
				add(new Building(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 0));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),building1) type: null */ in xml.nodes.objects[0].nodes.building1) {
				add(new Building(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 1));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),building2) type: null */ in xml.nodes.objects[0].nodes.building2) {
				add(new Building(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 2));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),building3) type: null */ in xml.nodes.objects[0].nodes.building3) {
				add(new Building(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 3));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),building4) type: null */ in xml.nodes.objects[0].nodes.building4) {
				add(new Building(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 4));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),building5) type: null */ in xml.nodes.objects[0].nodes.building5) {
				add(new Building(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 5));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),building6) type: null */ in xml.nodes.objects[0].nodes.building6) {
				add(new Building(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 6));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),building7) type: null */ in xml.nodes.objects[0].nodes.building7) {
				add(new Building(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 7));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),building8) type: null */ in xml.nodes.objects[0].nodes.building8) {
				add(new Building(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 8));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),wire) type: null */ in xml.nodes.objects[0].nodes.wire) {
				add(new Wire(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.img)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),bed) type: null */ in xml.nodes.objects[0].nodes.bed) {
				add(new Bed(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),dresser) type: null */ in xml.nodes.objects[0].nodes.dresser) {
				add(new Dresser(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),bar) type: null */ in xml.nodes.objects[0].nodes.bar) {
				add(new Bar(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),barstool) type: null */ in xml.nodes.objects[0].nodes.barstool) {
				add(new Barstool(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),rock) type: null */ in xml.nodes.objects[0].nodes.rock) {
				add(new Rock(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 0));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),rock2) type: null */ in xml.nodes.objects[0].nodes.rock2) {
				add(new Rock(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 1));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),rock3) type: null */ in xml.nodes.objects[0].nodes.rock3) {
				add(new Rock(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 2));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),rock4) type: null */ in xml.nodes.objects[0].nodes.rock4) {
				add(new Rock(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 3));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),pole) type: null */ in xml.nodes.objects[0].nodes.pole) {
				add(new Pole(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),sword) type: null */ in xml.nodes.objects[0].nodes.sword) {
				add(new Sword(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),feather) type: null */ in xml.nodes.objects[0].nodes.feather) {
				add(new Feather(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),ghostspear) type: null */ in xml.nodes.objects[0].nodes.ghostspear) {
				add(new GhostSpear(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),ghostsword) type: null */ in xml.nodes.objects[0].nodes.ghostsword) {
				add(new GhostSword(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),darkshield) type: null */ in xml.nodes.objects[0].nodes.darkshield) {
				add(new DarkShield(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),darksuit) type: null */ in xml.nodes.objects[0].nodes.darksuit) {
				add(new DarkSuit(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),conch) type: null */ in xml.nodes.objects[0].nodes.conch) {
				add(new Conch(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),shield) type: null */ in xml.nodes.objects[0].nodes.shield) {
				add(new Shield(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),torchpickup) type: null */ in xml.nodes.objects[0].nodes.torchpickup) {
				add(new TorchPickup(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),fire) type: null */ in xml.nodes.objects[0].nodes.fire) {
				add(new Fire(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),button) type: null */ in xml.nodes.objects[0].nodes.button) {
				add(new Button(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tset)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),buttonroom) type: null */ in xml.nodes.objects[0].nodes.buttonroom) {
				add(new ButtonRoom(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tset), Std.parseInt(o.att.tag),
					Std.parseInt(o.att.flip) != 0, Std.parseInt(o.att.room)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),arrowtrap) type: null */ in xml.nodes.objects[0].nodes.arrowtrap) {
				add(new ArrowTrap(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tset), Std.parseInt(o.att.shoot) != 0));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),bosskey) type: null */ in xml.nodes.objects[0].nodes.bosskey) {
				add(new BossKey(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.keyType)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),totempart) type: null */ in xml.nodes.objects[0].nodes.totempart) {
				add(new BossTotemPart(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.totempart)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),health) type: null */ in xml.nodes.objects[0].nodes.health) {
				add(new HealthPickup(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),seed) type: null */ in xml.nodes.objects[0].nodes.seed) {
				add(new Seed(Std.parseInt(o.att.x), Std.parseInt(o.att.y), false, o.att.text, cutscene[2]));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),pull) type: null */ in xml.nodes.objects[0].nodes.pull) {
				add(new Pull(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.direction), Std.parseInt(o.att.force)));
			} // o.@direction goes from 0-1
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),fallrock) type: null */ in xml.nodes.objects[0].nodes.fallrock) {
				add(new FallRock(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tset), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),fallrocklarge) type: null */ in xml.nodes.objects[0].nodes.fallrocklarge) {
				add(new FallRockLarge(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tset), Std.parseInt(o.att.tag),
					Std.parseInt(o.att.bossrock) != 0, Std.parseInt(o.att.thirdboss) != 0));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),rocklock) type: null */ in xml.nodes.objects[0].nodes.rocklock) {
				add(new RockLock(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tset), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),lock) type: null */ in xml.nodes.objects[0].nodes.lock) {
				add(new Lock(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tset), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),pulser) type: null */ in xml.nodes.objects[0].nodes.pulser) {
				add(new Pulser(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tset)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),spinningaxe) type: null */ in xml.nodes.objects[0].nodes.spinningaxe) {
				add(new SpinningAxe(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.rate), Std.parseInt(o.att.colortype)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),lavachain) type: null */ in xml.nodes.objects[0].nodes.lavachain) {
				add(new LavaChain(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.dir)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),cover) type: null */ in xml.nodes.objects[0].nodes.cover) {
				add(new Cover(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tset)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),grasslock) type: null */ in xml.nodes.objects[0].nodes.grasslock) {
				add(new GrassLock(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tset), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),shieldlocknorm) type: null */ in xml.nodes.objects[0].nodes.shieldlocknorm) {
				add(new ShieldLock(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), 0));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),shieldlock) type: null */ in xml.nodes.objects[0].nodes.shieldlock) {
				add(new ShieldLock(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), 1));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),wandlock) type: null */ in xml.nodes.objects[0].nodes.wandlock) {
				add(new WandLock(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tset), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),bosslock) type: null */ in xml.nodes.objects[0].nodes.bosslock) {
				add(new BossLock(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.keyType), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),magicallock) type: null */ in xml.nodes.objects[0].nodes.magicallock) {
				add(new MagicalLock(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), 0));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),magicallockfire) type: null */ in xml.nodes.objects[0].nodes.magicallockfire) {
				add(new MagicalLock(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), 1));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),moonrock) type: null */ in xml.nodes.objects[0].nodes.moonrock) {
				add(new Moonrock(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),torch) type: null */ in xml.nodes.objects[0].nodes.torch) {
				add(new Torch(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.c)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),bonetorch) type: null */ in xml.nodes.objects[0].nodes.bonetorch) {
				add(new BoneTorch(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 0, Std.parseInt(o.att.c), Std.parseInt(o.att.flip) != 0));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),bonetorch2) type: null */ in xml.nodes.objects[0].nodes.bonetorch2) {
				add(new BoneTorch(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 1, Std.parseInt(o.att.c), Std.parseInt(o.att.flip) != 0));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),planttorch) type: null */ in xml.nodes.objects[0].nodes.planttorch) {
				add(new PlantTorch(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.c), Std.parseInt(o.att.flip) != 0,
					Std.parseInt(o.att.distance)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),lightpole) type: null */ in xml.nodes.objects[0].nodes.lightpole) {
				add(new LightPole(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tset), Std.parseInt(o.att.tag), Std.parseInt(o.att.c),
					Std.parseInt(o.att.invert) != 0));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),orb) type: null */ in xml.nodes.objects[0].nodes.orb) {
				add(new Orb(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.c)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),breakablerock) type: null */ in xml.nodes.objects[0].nodes.breakablerock) {
				add(new BreakableRock(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), 0));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),breakablerockghost) type: null */ in xml.nodes.objects[0].nodes.breakablerockghost) {
				add(new BreakableRock(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), 1));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),chest) type: null */ in xml.nodes.objects[0].nodes.chest) {
				add(new Chest(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),dungeonspire) type: null */ in xml.nodes.objects[0].nodes.dungeonspire) {
				add(new DungeonSpire(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),lightbosstotem) type: null */ in xml.nodes.objects[0].nodes.lightbosstotem) {
				add(new LightBossTotem(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),littlestones) type: null */ in xml.nodes.objects[0].nodes.littlestones) {
				add(new LittleStones(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),whirlpool) type: null */ in xml.nodes.objects[0].nodes.whirlpool) {
				add(new Whirlpool(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),pushableblock) type: null */ in xml.nodes.objects[0].nodes.pushableblock) {
				add(new PushableBlock(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),pushableblockfire) type: null */ in xml.nodes.objects[0].nodes.pushableblockfire) {
				add(new PushableBlockFire(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),pushableblockspear) type: null */ in xml.nodes.objects[0].nodes.pushableblockspear) {
				add(new PushableBlockSpear(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),stairsup) type: null */ in xml.nodes.objects[0].nodes.stairsup) {
				add(new Stairs(Std.parseInt(o.att.x), Std.parseInt(o.att.y), true, Std.parseInt(o.att.flip) != 0, Std.parseInt(o.att.to),
					Std.parseInt(o.att.playerx), Std.parseInt(o.att.playery), Std.parseInt(o.att.sign)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),stairsdown) type: null */ in xml.nodes.objects[0].nodes.stairsdown) {
				add(new Stairs(Std.parseInt(o.att.x), Std.parseInt(o.att.y), false, Std.parseInt(o.att.flip) != 0, Std.parseInt(o.att.to),
					Std.parseInt(o.att.playerx), Std.parseInt(o.att.playery), Std.parseInt(o.att.sign)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),teleporter) type: null */ in xml.nodes.objects[0].nodes.teleporter) {
				add(new Teleporter(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.to), Std.parseInt(o.att.playerx),
					Std.parseInt(o.att.playery), Std.parseInt(o.att.show) != 0, (Std.string(Std.parseInt(o.att.tag)) == "") ? -1 : Std.parseInt(o.att.tag),
					Std.parseInt(o.att.invert) != 0, Std.parseInt(o.att.sign)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),shieldboss) type: null */ in xml.nodes.objects[0].nodes.shieldboss) {
				add(new ShieldBoss(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),introchar) type: null */ in xml.nodes.objects[0].nodes.introchar) {
				add(new IntroCharacter(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), o.att.text, Std.parseInt(o.att.frames)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),rekcahdam) type: null */ in xml.nodes.objects[0].nodes.rekcahdam) {
				add(new Rekcahdam(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), o.att.text, Std.parseInt(o.att.frames)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),forestchar) type: null */ in xml.nodes.objects[0].nodes.forestchar) {
				add(new ForestCharacter(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), o.att.text, Std.parseInt(o.att.frames)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),karlore) type: null */ in xml.nodes.objects[0].nodes.karlore) {
				add(new Karlore(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), o.att.text, Std.parseInt(o.att.frames)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),adnanchar) type: null */ in xml.nodes.objects[0].nodes.adnanchar) {
				add(new AdnanCharacter(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), o.att.text, Std.parseInt(o.att.frames)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),watcher) type: null */ in xml.nodes.objects[0].nodes.watcher) {
				add(new Watcher(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), o.att.text, o.att.text1, Std.parseInt(o.att.frames)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),oracle) type: null */ in xml.nodes.objects[0].nodes.oracle) {
				add(new Oracle(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), o.att.text, o.att.text1, Std.parseInt(o.att.frames)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),witch) type: null */ in xml.nodes.objects[0].nodes.witch) {
				add(new Witch(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), o.att.text, Std.parseInt(o.att.frames)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),hermit) type: null */ in xml.nodes.objects[0].nodes.hermit) {
				add(new Hermit(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), o.att.text, Std.parseInt(o.att.frames)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),yeti) type: null */ in xml.nodes.objects[0].nodes.yeti) {
				add(new Yeti(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), o.att.text, Std.parseInt(o.att.frames)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),sensei) type: null */ in xml.nodes.objects[0].nodes.sensei) {
				add(new Sensei(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), o.att.text, Std.parseInt(o.att.frames)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),sign) type: null */ in xml.nodes.objects[0].nodes.sign) {
				add(new Sign(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), o.att.text, Std.parseInt(o.att.frames)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),totem) type: null */ in xml.nodes.objects[0].nodes.totem) {
				add(new Totem(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag), o.att.text, Std.parseInt(o.att.frames)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),wand) type: null */ in xml.nodes.objects[0].nodes.wand) {
				add(new Wand(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),firewand) type: null */ in xml.nodes.objects[0].nodes.firewand) {
				add(new FireWand(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),brickpole) type: null */ in xml.nodes.objects[0].nodes.brickpole) {
				add(new BrickPole(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),statue1) type: null */ in xml.nodes.objects[0].nodes.statue1) {
				add(new Statue(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 0, o.att.text, Std.parseInt(o.att.frames)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),statue2) type: null */ in xml.nodes.objects[0].nodes.statue2) {
				add(new Statue(Std.parseInt(o.att.x), Std.parseInt(o.att.y), 1, o.att.text, Std.parseInt(o.att.frames)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),brickwell) type: null */ in xml.nodes.objects[0].nodes.brickwell) {
				add(new BrickWell(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),finaldoor) type: null */ in xml.nodes.objects[0].nodes.finaldoor) {
				add(new FinalDoor(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),pod) type: null */ in xml.nodes.objects[0].nodes.pod) {
				add(new Pod(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),frozenboss) type: null */ in xml.nodes.objects[0].nodes.frozenboss) {
				add(new FrozenBoss(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),moonrockpile) type: null */ in xml.nodes.objects[0].nodes.moonrockpile) {
				add(new MoonrockPile(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),shieldstatue) type: null */ in xml.nodes.objects[0].nodes.shieldstatue) {
				add(new ShieldStatue(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),oraclestatue) type: null */ in xml.nodes.objects[0].nodes.oraclestatue) {
				add(new OracleStatue(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),ruinedpillar) type: null */ in xml.nodes.objects[0].nodes.ruinedpillar) {
				add(new RuinedPillar(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),wallflyer) type: null */ in xml.nodes.objects[0].nodes.wallflyer) {
				add(new WallFlyer(Std.parseInt(o.att.x), Std.parseInt(o.att.y)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),spinner) type: null */ in xml.nodes.objects[0].nodes.spinner) {
				add(new Spinner(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.tag)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),lightray) type: null */ in xml.nodes.objects[0].nodes.lightray) {
				add(new LightRay(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.color), Std.parseInt(o.att.alpha),
					Std.parseInt(o.att.width), Std.parseInt(o.att.height)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),shadow) type: null */ in xml.nodes.objects[0].nodes.shadow) {
				add(new Shadow(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.color), Std.parseInt(o.att.alpha), Std.parseInt(o.att.width),
					Std.parseInt(o.att.height)));
			}
			for (o /* AS3HX WARNING could not determine type for var: o exp: EField(EArray(EField(EIdent(xml),objects),EConst(CInt(0))),rope) type: null */ in xml.nodes.objects[0].nodes.rope) {
				var pt:Point;
				// get the end point of the electricity (via nodes)
				for (n in o.nodes.node) {
					pt = new Point(Std.parseFloat(n.att.x), Std.parseFloat(n.att.y));
					add(new RopeStart(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.int(pt.x), Std.parseInt(o.att.tset), Std.parseInt(o.att.tag)));
				}
			}
		}
		setFallFromCeiling = false;
	}
}
