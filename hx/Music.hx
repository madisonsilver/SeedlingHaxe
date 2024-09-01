import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.utils.Dictionary;
import openfl.events.Event;
import net.flashpunk.Sfx;
import net.flashpunk.FP;
import net.flashpunk.utils.Input;
import net.flashpunk.utils.Key;
import openfl.media.Sound;

/**
 * ...
 * @author Time
 */
class Music {
	private static var sndSword1:Sound;
	private static var sndSword2:Sound;
	private static var sndSword3:Sound;
	private static var sndStab1:Sound;
	private static var sndStab2:Sound;
	private static var sndStab3:Sound;
	private static var sndSplash1:Sound;
	private static var sndSplash2:Sound;
	private static var sndSwim1:Sound;
	private static var sndArrow1:Sound;
	private static var sndArrow2:Sound;
	private static var sndSwitch1:Sound;
	private static var sndEnemyHit1:Sound;
	private static var sndEnemyHit2:Sound;
	private static var sndMetal1:Sound;
	private static var sndEnemyHop1:Sound;
	private static var sndEnemyHop2:Sound;
	private static var sndChest1:Sound;
	private static var sndLock1:Sound;
	private static var sndRock1:Sound;
	private static var sndRock2:Sound;
	private static var sndDrill1:Sound;
	private static var sndEnergyBeam1:Sound;
	private static var sndEnergyPulse1:Sound;
	private static var sndExplosion1:Sound;
	private static var sndEnemyFall1:Sound;
	private static var sndPushRock1:Sound;
	private static var sndEnemyDie1:Sound;
	private static var sndRoom1:Sound;
	private static var sndRoom2:Sound;
	private static var sndRoom3:Sound;
	private static var sndRoom4:Sound;
	private static var sndHurt1:Sound;
	private static var sndGroundHit1:Sound;
	private static var sndGroundHit2:Sound;
	private static var sndPlayerFall1:Sound;
	private static var sndBossDie1:Sound;
	private static var sndBossDie2:Sound;
	private static var sndBossDie3:Sound;
	private static var sndBossDie4:Sound;
	private static var sndBossDie5:Sound;
	private static var sndEnemyAttack1:Sound;
	private static var sndEnemyAttack2:Sound;
	private static var sndEnemyAttack3:Sound;
	private static var sndEnemyAttack4:Sound;
	private static var sndBoss6Move1:Sound;
	private static var sndBoss6Move2:Sound;
	private static var sndBoss6Move3:Sound;
	private static var sndWandFire1:Sound;
	private static var sndWandFizzle1:Sound;
	private static var sndTurretShoot1:Sound;
	private static var sndWind1:Sound;
	private static var sndWind2:Sound;
	private static var sndBurn1:Sound;
	private static var sndPunch1:Sound;
	private static var sndTentacle1:Sound;
	private static var sndFire1:Sound;
	private static var sndLava1:Sound;
	private static var sndLava2:Sound;
	private static var sndLava3:Sound;
	private static var sndLight1:Sound;
	private static var sndText1:Sound;
	private static var sndText2:Sound;
	private static var sndOther1:Sound;
	private static var sndOther2:Sound;
	private static var sndOther3:Sound;
	private static var sndOther4:Sound;
	private static var sndOther5:Sound;

	private static var currentSet:String = "";
	private static var currentIndex:Int = -1;

	private static var setNames:Array<String> = new Array<String>();
	private static var soundsO:Dictionary<String, Array<Sfx>> = new Dictionary();
	private static var soundSwords:Array<Sound>;
	private static var soundStabs:Array<Sound>;
	private static var soundSplash:Array<Sound>;
	private static var soundSwim:Array<Sound>;
	private static var soundArrow:Array<Sound>;
	private static var soundSwitch:Array<Sound>;
	private static var soundDrill:Array<Sound>;
	private static var soundEnemyHit:Array<Sound>;
	private static var soundMetal:Array<Sound>;
	private static var soundEnemyHop:Array<Sound>;
	private static var soundChest:Array<Sound>;
	private static var soundRock:Array<Sound>;
	private static var soundLock:Array<Sound>;
	private static var soundEnergyBeam:Array<Sound>;
	private static var soundEnergyPulse:Array<Sound>;
	private static var soundExplosion:Array<Sound>;
	private static var soundEnemyFall:Array<Sound>;
	private static var soundPushRock:Array<Sound>;
	private static var soundEnemyDie:Array<Sound>;
	private static var soundRoom:Array<Sound>;
	private static var soundHurt:Array<Sound>;
	private static var soundGroundHit:Array<Sound>;
	private static var soundPlayerFall:Array<Sound>;
	private static var soundBossDie:Array<Sound>;
	private static var soundEnemyAttack:Array<Sound>;
	private static var soundBoss6Move:Array<Sound>;
	private static var soundWandFire:Array<Sound>;
	private static var soundWandFizzle:Array<Sound>;
	private static var soundTurretShoot:Array<Sound>;
	private static var soundWind:Array<Sound>;
	private static var soundBurn:Array<Sound>;
	private static var soundPunch:Array<Sound>;
	private static var soundTentacle:Array<Sound>;
	private static var soundFire:Array<Sound>;
	private static var soundLava:Array<Sound>;
	private static var soundLight:Array<Sound>;
	private static var soundText:Array<Sound>;
	private static var soundOther:Array<Sound>;
	private static var sounds:Dictionary<String, Array<Sound>> = new Dictionary();
	private static var sndYesMaster:Sound;
	public static var sndOYesMaster:Sfx;

	private static var sndFoundIt:Sound;
	public static var sndOFoundIt:Sfx;

	private static var sndSealPiece:Sound;
	public static var sndOSealPiece:Sfx;

	private static var sndSeal:Sound;
	public static var sndOSeal:Sfx;

	private static var sndKey:Sound;
	public static var sndOKey:Sfx;

	private static var sndMenu:Sound;
	public static var sndOMenu:Sfx;

	private static var sndTheme:Sound;
	public static var sndOTheme:Sfx;

	private static var sndThemeNight:Sound;
	public static var sndOThemeNight:Sfx;

	private static var sndMyLifesPurpose:Sound;
	public static var sndOMyLifesPurpose:Sfx;

	private static var sndTheWatcher:Sound;
	public static var sndOTheWatcher:Sfx;

	private static var sndMyFirstDungeon:Sound;
	public static var sndOMyFirstDungeon:Sfx;

	private static var sndStuckInTheForest:Sound;
	public static var sndOStuckInTheForest:Sfx;

	private static var sndMysteriousMagic:Sound;
	public static var sndOMysteriousMagic:Sfx;

	private static var sndColdBlooded:Sound;
	public static var sndOColdBlooded:Sfx;

	private static var sndShadow:Sound;
	public static var sndOShadow:Sfx;

	private static var sndLavaIsHot:Sound;
	public static var sndOLavaIsHot:Sfx;

	private static var sndTheSky:Sound;
	public static var sndOTheSky:Sfx;

	private static var sndBoss:Sound;
	public static var sndOBoss:Sfx;

	public static var songs:Array<Sfx>;

	private static var overSong:Sfx; // The song that gets played over the background song on interruption
	private static var bkgdSong:Sfx; // The song that represents the currently playing background music
	private static var fadeSong:Sfx; // The song that represents the new song that will be played once the background music
	//		fades out.
	public static var bkgdVolumeDefault:Float = 1; // Value 0-1 for the default volume of bkgdVolume
	public static var bkgdVolumeMaxExtern:Float = 1; // The maximum volume for the background music, as set by outside objects
	public static var bkgdVolumeMax:Float = 0.5; // The maximum volume for the background music
	private static var bkgdVolume:Float = 0; // Value that is used to set the background music's volume
	public static var fadeVolumeDefault:Float = 1; // Value 0-1 for the default volume of fadeVolume
	public static var fadeVolumeMaxExtern:Float = 1; // The maximum volume for the fade-in music, as set by outside objects
	private static var fadeVolumeMax:Float = 0.5; // The maximum volume for the fade-in music
	private static var fadeVolume:Float = 0; // Value that is used to set the fade-in music's volume

	private static var fadeRate:Float = 0;
	private static var crossover:Bool = false;

	public static function load_audio_assets():Void {
		sndSword1 = Assets.getSound("assets/sound/Sword1.ogg");
		sndSword2 = Assets.getSound("assets/sound/Sword2.ogg");
		sndSword3 = Assets.getSound("assets/sound/Sword3.ogg");
		sndStab1 = Assets.getSound("assets/sound/Unapproved/stab1.ogg");
		sndStab2 = Assets.getSound("assets/sound/Unapproved/stab2.ogg");
		sndStab3 = Assets.getSound("assets/sound/Unapproved/stab3.ogg");
		sndSplash1 = Assets.getSound("assets/sound/splash1.ogg");
		sndSplash2 = Assets.getSound("assets/sound/splash2.ogg");
		sndSwim1 = Assets.getSound("assets/sound/swim.ogg");
		sndArrow1 = Assets.getSound("assets/sound/arrowLaunch.ogg");
		sndArrow2 = Assets.getSound("assets/sound/arrowHit.ogg");
		sndSwitch1 = Assets.getSound("assets/sound/switch.ogg");
		sndEnemyHit1 = Assets.getSound("assets/sound/smallEnemyHit.ogg");
		sndEnemyHit2 = Assets.getSound("assets/sound/bigEnemyHit.ogg");
		sndMetal1 = Assets.getSound("assets/sound/metalHit.ogg");
		sndEnemyHop1 = Assets.getSound("assets/sound/enemyhop.ogg");
		sndEnemyHop2 = Assets.getSound("assets/sound/bigenemyhop.ogg");
		sndChest1 = Assets.getSound("assets/sound/chest.ogg");
		sndLock1 = Assets.getSound("assets/sound/bigLock.ogg");
		sndRock1 = Assets.getSound("assets/sound/BigRockHit.ogg");
		sndRock2 = Assets.getSound("assets/sound/rockcrumble.ogg");
		sndDrill1 = Assets.getSound("assets/sound/drill.ogg");
		sndEnergyBeam1 = Assets.getSound("assets/sound/energyBeam.ogg");
		sndEnergyPulse1 = Assets.getSound("assets/sound/energyPulse.ogg");
		sndExplosion1 = Assets.getSound("assets/sound/explosion.ogg");
		sndEnemyFall1 = Assets.getSound("assets/sound/enemyfall.ogg");
		sndPushRock1 = Assets.getSound("assets/sound/pushrock.ogg");
		sndEnemyDie1 = Assets.getSound("assets/sound/smallenemydie.ogg");
		sndRoom1 = Assets.getSound("assets/sound/nextroom.ogg");
		sndRoom2 = Assets.getSound("assets/sound/upstairs.ogg");
		sndRoom3 = Assets.getSound("assets/sound/downstairs.ogg");
		sndRoom4 = Assets.getSound("assets/sound/Unapproved/teleport.ogg");
		sndHurt1 = Assets.getSound("assets/sound/hurt.ogg");
		sndGroundHit1 = Assets.getSound("assets/sound/groundhit.ogg");
		sndGroundHit2 = Assets.getSound("assets/sound/groundhit2.ogg");
		sndPlayerFall1 = Assets.getSound("assets/sound/playerfall.ogg");
		sndBossDie1 = Assets.getSound("assets/sound/Unapproved/boss4die.ogg");
		sndBossDie2 = Assets.getSound("assets/sound/Unapproved/boss4die2.ogg");
		sndBossDie3 = Assets.getSound("assets/sound/Unapproved/boss6die.ogg");
		sndBossDie4 = Assets.getSound("assets/sound/Unapproved/boss5rise.ogg");
		sndBossDie5 = Assets.getSound("assets/sound/Unapproved/boss5die.ogg");
		sndEnemyAttack1 = Assets.getSound("assets/sound/Unapproved/boss4beam.ogg");
		sndEnemyAttack2 = Assets.getSound("assets/sound/Unapproved/boss4beam2.ogg");
		sndEnemyAttack3 = Assets.getSound("assets/sound/Unapproved/boss4shoot.ogg");
		sndEnemyAttack4 = Assets.getSound("assets/sound/Unapproved/enemyChomp.ogg");
		sndBoss6Move1 = Assets.getSound("assets/sound/Unapproved/boss6move.ogg");
		sndBoss6Move2 = Assets.getSound("assets/sound/Unapproved/boss6move1.ogg");
		sndBoss6Move3 = Assets.getSound("assets/sound/Unapproved/boss6move2.ogg");
		sndWandFire1 = Assets.getSound("assets/sound/wandfire.ogg");
		sndWandFizzle1 = Assets.getSound("assets/sound/wandfizzle.ogg");
		sndTurretShoot1 = Assets.getSound("assets/sound/Unapproved/turretFire.ogg");
		sndWind1 = Assets.getSound("assets/sound/wind.ogg");
		sndWind2 = Assets.getSound("assets/sound/ArcticWind.ogg");
		sndBurn1 = Assets.getSound("assets/sound/TreeBurning.ogg");
		sndPunch1 = Assets.getSound("assets/sound/punch.ogg");
		sndTentacle1 = Assets.getSound("assets/sound/monstersplash.ogg");
		sndFire1 = Assets.getSound("assets/sound/fireattack.ogg");
		sndLava1 = Assets.getSound("assets/sound/LavaPunch.ogg");
		sndLava2 = Assets.getSound("assets/sound/LavaClap.ogg");
		sndLava3 = Assets.getSound("assets/sound/Pop.ogg");
		sndLight1 = Assets.getSound("assets/sound/Light.ogg");
		sndText1 = Assets.getSound("assets/sound/text.wav"); //The ogg transformation corrupted the file
		sndText2 = Assets.getSound("assets/sound/Unapproved/textNext.ogg");
		sndOther1 = Assets.getSound("assets/sound/Unapproved/boss4start.ogg");
		sndOther2 = Assets.getSound("assets/sound/Unapproved/boss4walk.ogg");
		sndOther3 = Assets.getSound("assets/sound/Unapproved/turretIceFire.ogg");
		sndOther4 = Assets.getSound("assets/sound/Unapproved/ropeCut.ogg");
		sndOther5 = Assets.getSound("assets/sound/Unapproved/crusher.ogg");
		sndYesMaster = Assets.getSound("assets/sound/Yes, Master.ogg");
		sndFoundIt = Assets.getSound("assets/sound/Found It!.ogg");
		sndSealPiece = Assets.getSound("assets/sound/One Piece.ogg");
		sndSeal = Assets.getSound("assets/sound/Of The Puzzle.ogg");
		sndKey = Assets.getSound("assets/sound/The Key.ogg");
		sndMenu = Assets.getSound("assets/sound/In The Beginning.ogg");
		sndTheme = Assets.getSound("assets/sound/A Warrior's Journey.ogg");
		sndThemeNight = Assets.getSound("assets/sound/Warriors Don't Sleep.ogg");
		sndMyLifesPurpose = Assets.getSound("assets/sound/My Life's Purpose.ogg");
		sndTheWatcher = Assets.getSound("assets/sound/The Watcher.ogg");
		sndMyFirstDungeon = Assets.getSound("assets/sound/My First Dungeon.ogg");
		sndStuckInTheForest = Assets.getSound("assets/sound/Stuck In The Forest.ogg");
		sndMysteriousMagic = Assets.getSound("assets/sound/Mysterious Magic.ogg");
		sndColdBlooded = Assets.getSound("assets/sound/Cold Blooded.ogg");
		sndShadow = Assets.getSound("assets/sound/How To Lose Your Shadow 101.ogg");
		sndLavaIsHot = Assets.getSound("assets/sound/Lava Is Hot.ogg");
		sndTheSky = Assets.getSound("assets/sound/The Sky.ogg");
		sndBoss = Assets.getSound("assets/sound/Fight Me Like A Boss.ogg");
	}

	public static function initialize_audio_assets():Void {
		sndOYesMaster = new Sfx(sndYesMaster);
		sndOFoundIt = new Sfx(sndFoundIt);
		sndOSealPiece = new Sfx(sndSealPiece);
		sndOSeal = new Sfx(sndSeal);
		sndOKey = new Sfx(sndKey);
		sndOMenu = new Sfx(sndMenu);
		sndOTheme = new Sfx(sndTheme);
		sndOThemeNight = new Sfx(sndThemeNight);
		sndOMyLifesPurpose = new Sfx(sndMyLifesPurpose);
		sndOTheWatcher = new Sfx(sndTheWatcher);
		sndOMyFirstDungeon = new Sfx(sndMyFirstDungeon);
		sndOStuckInTheForest = new Sfx(sndStuckInTheForest);
		sndOMysteriousMagic = new Sfx(sndMysteriousMagic);
		sndOColdBlooded = new Sfx(sndColdBlooded);
		sndOShadow = new Sfx(sndShadow);
		sndOLavaIsHot = new Sfx(sndLavaIsHot);
		sndOTheSky = new Sfx(sndTheSky);
		sndOBoss = new Sfx(sndBoss);
	}

	public static function initialize_sound_arrays() {
		soundSwords = [sndSword1, sndSword2, sndSword3];
		soundStabs = [sndStab1, sndStab2, sndStab3];
		soundSplash = [sndSplash1, sndSplash2];
		soundSwim = [sndSwim1];
		soundArrow = [sndArrow1, sndArrow2];
		soundSwitch = [sndSwitch1];
		soundDrill = [sndDrill1, sndDrill1];
		soundEnemyHit = [sndEnemyHit1, sndEnemyHit2];
		soundMetal = [sndMetal1];
		soundEnemyHop = [sndEnemyHop1, sndEnemyHop2];
		soundChest = [sndChest1];
		soundRock = [sndRock1, sndRock2];
		soundLock = [sndLock1];
		soundEnergyBeam = [sndEnergyBeam1, sndEnergyBeam1, sndEnergyBeam1];
		soundEnergyPulse = [sndEnergyPulse1, sndEnergyPulse1];
		soundExplosion = [sndExplosion1, sndExplosion1, sndExplosion1];
		soundEnemyFall = [sndEnemyFall1, sndEnemyFall1, sndEnemyFall1];
		soundPushRock = [sndPushRock1];
		soundEnemyDie = [sndEnemyDie1, sndEnemyDie1];
		soundRoom = [sndRoom1, sndRoom2, sndRoom3, sndRoom4];
		soundHurt = [sndHurt1];
		soundGroundHit = [sndGroundHit1, sndGroundHit2];
		soundPlayerFall = [sndPlayerFall1];
		soundBossDie = [sndBossDie1, sndBossDie2, sndBossDie3, sndBossDie4, sndBossDie5];
		soundEnemyAttack = [sndEnemyAttack1, sndEnemyAttack2, sndEnemyAttack3, sndEnemyAttack4];
		soundBoss6Move = [
			sndBoss6Move1,
			sndBoss6Move2,
			sndBoss6Move3,
			sndBoss6Move1,
			sndBoss6Move2,
			sndBoss6Move3
		];
		soundWandFire = [sndWandFire1, sndWandFire1];
		soundWandFizzle = [sndWandFizzle1, sndWandFizzle1];
		soundTurretShoot = [sndTurretShoot1, sndTurretShoot1, sndTurretShoot1];
		soundWind = [sndWind1, sndWind2];
		soundBurn = [sndBurn1];
		soundPunch = [sndPunch1];
		soundTentacle = [sndTentacle1, sndTentacle1, sndTentacle1, sndTentacle1];
		soundFire = [sndFire1];
		soundLava = [sndLava1, sndLava2, sndLava3];
		soundLight = [sndLight1];
		soundText = [sndText1, sndText2];
		soundOther = [sndOther1, sndOther2, sndOther3, sndOther4, sndOther5];
	}

	public function new() {}

	public static function begin():Void // called by Main
	{
		load_audio_assets();
		initialize_audio_assets();
		initialize_sound_arrays();
		songs = [
			sndOTheme, sndOThemeNight, sndOMenu, sndOYesMaster, sndOMyLifesPurpose, sndOTheWatcher, sndOMyFirstDungeon, sndOStuckInTheForest,
			sndOMysteriousMagic, sndOColdBlooded, sndOShadow, sndOLavaIsHot, sndOTheSky, sndOBoss
		];

		sounds["Sword"] = soundSwords;
		sounds["Stab"] = soundStabs;
		sounds["Splash"] = soundSplash;
		sounds["Swim"] = soundSwim;
		sounds["Arrow"] = soundArrow;
		sounds["Switch"] = soundSwitch;
		sounds["Drill"] = soundDrill;
		sounds["Enemy Hit"] = soundEnemyHit;
		sounds["Metal Hit"] = soundMetal;
		sounds["Enemy Hop"] = soundEnemyHop;
		sounds["Chest"] = soundChest;
		sounds["Rock"] = soundRock;
		sounds["Lock"] = soundLock;
		sounds["Energy Beam"] = soundEnergyBeam;
		sounds["Energy Pulse"] = soundEnergyPulse;
		sounds["Explosion"] = soundExplosion;
		sounds["Enemy Fall"] = soundEnemyFall;
		sounds["Push Rock"] = soundPushRock;
		sounds["Enemy Die"] = soundEnemyDie;
		sounds["Room"] = soundRoom;
		sounds["Hurt"] = soundHurt;
		sounds["Ground Hit"] = soundGroundHit;
		sounds["Player Fall"] = soundPlayerFall;
		sounds["Boss Die"] = soundBossDie;
		sounds["Enemy Attack"] = soundEnemyAttack;
		sounds["Boss 6 Move"] = soundBoss6Move;
		sounds["Wand Fire"] = soundWandFire;
		sounds["Wand Fizzle"] = soundWandFizzle;
		sounds["Turret Shoot"] = soundTurretShoot;
		sounds["Wind"] = soundWind;
		sounds["Burn"] = soundBurn;
		sounds["Punch"] = soundPunch;
		sounds["Tentacle"] = soundTentacle;
		sounds["Fire"] = soundFire;
		sounds["Lava"] = soundLava;
		sounds["Light"] = soundLight;
		sounds["Text"] = soundText;
		sounds["Other"] = soundOther;

		for (key in sounds.iterator()) {
			setNames.push(key);
			soundsO[key] = [];
			for (j in 0...sounds[key].length) {
				soundsO[key][j] = new Sfx(sounds[key][j]);
			}
		}
	}

	public static function update():Void // Updated in Main
	{
		if (bkgdSong != null && bkgdSong != fadeSong) {
			bkgdSong.volume = bkgdVolumeDefault;
			bkgdSong.volume *= bkgdVolumeMax;
			bkgdSong.volume *= bkgdVolumeMaxExtern;
			if (bkgdSong == sndOTheme) {
				sndOThemeNight.volume = 1 - bkgdVolumeDefault;
				sndOThemeNight.volume *= bkgdVolumeMax;
				sndOThemeNight.volume *= bkgdVolumeMaxExtern;
			} else if (bkgdSong == sndOMenu) {
				bkgdSong.volume *= 1.5;
			}
		}

		if (fadeSong != null) {
			fadeSong.volume = fadeVolumeDefault;
			fadeSong.volume *= fadeVolumeMax;
			fadeSong.volume *= fadeVolumeMaxExtern;
			if (fadeSong == sndOTheme) {
				sndOThemeNight.volume = 1 - fadeVolumeDefault;
				sndOThemeNight.volume *= fadeVolumeMax;
				sndOThemeNight.volume *= fadeVolumeMaxExtern;
			}
		}

		if (overSong != null)
			// If we have an oversong playing, turn off everything else.
		{
			{
				bkgdVolume = 0;
				fadeVolume = 0;
			}
		}

		if (fadeRate > 0) {
			if (bkgdSong != null && bkgdSong != fadeSong) {
				bkgdVolume -= fadeRate;
				if (bkgdVolume <= 0) {
					bkgdSong.stop();
					if (bkgdSong == sndOTheme) {
						sndOThemeNight.stop();
					}
				}
			}
			if ((crossover) ? true : ((bkgdSong != null) ? bkgdVolume <= 0 : true)) {
				fadeVolume += fadeRate;
			}
			if (fadeVolume >= 1) {
				bkgdVolume = 1;
				fadeVolume = 0;
				fadeRate = 0;
				bkgdSong = fadeSong;
				fadeSong = null;
			}
		}

		if (bkgdSong != null && bkgdSong != fadeSong) {
			bkgdSong.volume *= bkgdVolume;
			if (bkgdSong == sndOTheme) {
				sndOThemeNight.volume *= bkgdVolume;
			}
		}

		if (fadeSong != null) {
			fadeSong.volume *= fadeVolume;
			if (fadeSong == sndOTheme) {
				sndOThemeNight.volume *= fadeVolume;
			}
		}
	}

	/**
	 * Stops all background music.
	 */
	public static function stop(over:Bool = true, bkgd:Bool = true, fade:Bool = true):Void {
		if (overSong != null && over) {
			overSong.stop();
			overSong = null;
		}
		if (bkgdSong != null && bkgd) {
			bkgdSong.stop();
			if (bkgdSong == sndOTheme) {
				sndOThemeNight.stop();
			}
			bkgdSong = null;
		}
		if (fadeSong != null && fade) {
			fadeSong.stop();
			if (fadeSong == sndOTheme) {
				sndOThemeNight.stop();
			}
			fadeSong = null;
		}
	}

	/**
	 * Only for interruption sounds--does not treat the new sound like a background sound.
	 * @param	s		The new sound to play
	 */
	public static function abruptThenFade(s:Sfx, vol:Float = 1):Void // return; //So that sounds are off!
	{
		if (bkgdSong != null) {
			bkgdVolume = 0;
		}
		if (overSong != null) {
			overSong.stop();
		}
		overSong = s;
		overSong.complete = fadeOnComplete;
		overSong.play(vol);
	}

	public static function fadeOnComplete():Void {
		if (bkgdSong != null) {
			fadeToLoop(bkgdSong);
		}
		bkgdSong = overSong = null;
	}

	/**
	 * Stops the background music and plays the given Sfx
	 * @param	s		Sound to play
	 * @param	vol		Volume
	 * @param	pan		Pan
	 */
	public static function play(s:Sfx, vol:Float = 1, pan:Float = 0):Void // return; //So that sounds are off!
	{
		if (bkgdSong != null) {
			bkgdSong.stop();
			if (bkgdSong == sndOTheme) {
				sndOThemeNight.stop();
			}
		}
		bkgdSong = s;
		bkgdSong.play(vol, pan);
		if (bkgdSong == sndOTheme) {
			sndOThemeNight.play(vol, pan);
		}
		bkgdVolume = vol;
	}

	/**
	 * Stops the background music and plays the given Sfx
	 * @param	s		Sound to loop
	 * @param	vol		Volume
	 * @param	pan		Pan
	 */
	public static function loop(s:Sfx, vol:Float = 1, pan:Float = 0):Void // return; //So that sounds are off!
	{
		if (bkgdSong != null) {
			bkgdSong.stop();
			if (bkgdSong == sndOTheme) {
				sndOThemeNight.stop();
			}
		}
		bkgdSong = s;
		bkgdSong.loop(vol, pan);
		if (bkgdSong == sndOTheme) {
			sndOThemeNight.loop(vol, pan);
		}
		bkgdVolume = vol;
	}

	/**
	 * Fades from the backgroundMusic into snd1
	 * @param	snd1		The song to fade into
	 * @param	_rate		The speed to fade (0 stays on snd0, 1 goes immediately so snd1)
	 * @param	_crossover	Whether the songs will play at the same time while fading
	 */
	public static function fadeToLoop(snd1:Sfx = null, _rate:Float = 0.1, _crossover:Bool = false):Void // return; //So that sounds are off!
	{
		if (_rate <= 0) {
			return;
		}
		if (_rate >= 1) {
			loop(snd1);
			return;
		}

		if (fadeSong != null) {
			fadeSong.stop();
			if (fadeSong == sndOTheme) {
				sndOThemeNight.stop();
			}
		}
		fadeSong = snd1;
		if (fadeSong != null) {
			if (!fadeSong.playing) {
				fadeSong.play();
				if (fadeSong == sndOTheme) {
					sndOThemeNight.play();
				}
			}
			fadeSong.complete = playBKGD;
			fadeSong.volume = 0;
		}
		fadeVolume = 0;

		fadeRate = _rate;
		crossover = _crossover;
	}

	public static function playBKGD():Void {
		play(bkgdSong);
	}

	/**
	 * Plays a sound from a set, such as "Swords", with index intInd (-1 picks a random sound from the set)
	 * @param	strInd	the set to play from
	 * @param	intInd	the index of the sound to play (-1 for random other than the one last played)
	 * @return	the sound that is played
	 */
	public static function playSound(strInd:String, intInd:Int = -1, vol:Float = 1, pan:Float = 0):Sfx {
		var cplayIndex:Int = 0;
		if (intInd == -1) {
			do {
				cplayIndex = Math.floor(Math.random() * sounds[strInd].length);
			} while ((cplayIndex == currentIndex && sounds[strInd].length > 1 && currentSet == strInd));
		} else {
			cplayIndex = Std.int(Math.min(Math.max(intInd, 0), sounds[strInd].length - 1));
		}
		currentSet = strInd;
		currentIndex = cplayIndex;
		trace(soundsO);
		trace(soundsO[currentSet]);
		trace(soundsO[currentSet][currentIndex]);
		trace(currentSet);
		trace(currentIndex);
		soundsO[currentSet][currentIndex].play(vol, pan);
		return soundsO[currentSet][currentIndex];
	}

	/**
	 * Plays a sound from a set, such as "Swords", with index intInd (-1 picks a random sound from the set)
	 * @param	x			the x-position of the sound
	 * @param	y			the y-position of the sound
	 * @param	strInd		the set to play from
	 * @param	intInd		the index of the sound to play (-1 for random other than the one last played)
	 * @param	_distance	the distance from the sound at which the volume is zero
	 * @return	the sound that is played
	 */
	public static function playSoundDistPlayer(x:Int, y:Int, strInd:String, intInd:Int = -1, _distance:Int = 80, volMax:Float = 1):Sfx {
		var pan:Float = 0;
		var vol:Float = 1;
		var p:Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch (e:Dynamic) null;
		if (p != null) {
			pan = Math.min(Math.max((x - p.x) / (FP.width / 2), -1), 1);
			vol = Math.max(1 - FP.distance(x, y, p.x, p.y) / _distance, 0);
		}
		vol *= volMax;
		return playSound(strInd, intInd, vol, pan);
	}

	/**
	 * Stops a sound from a set, such as "Swords", with index intInd (-1 stops all sounds in the set)
	 * @param	strInd	the set to stop from
	 * @param	intInd	the index of the sound to stop (-1 for all sounds in the set)
	 */
	public static function stopSound(strInd:String, intInd:Int = -1):Void {
		if (intInd == -1) {
			for (i in 0...sounds[strInd].length) {
				soundsO[strInd][i].stop();
			}
		} else {
			soundsO[strInd][Std.int(Math.min(Math.max(intInd, 0), sounds[strInd].length - 1))].stop();
		}
	}

	/**
	 * Sets the volume of a sound from a set, such as "Swords", with index intInd (-1 sets all sounds in the set)
	 * @param	strInd	the set
	 * @param	intInd	the index of the sound to set the volume for (-1 for all sounds in the set)
	 */
	public static function volumeSound(strInd:String, intInd:Int = -1, vol:Float = 1):Void {
		if (intInd == -1) {
			for (i in 0...sounds[strInd].length) {
				soundsO[strInd][i].volume = vol;
			}
		} else {
			soundsO[strInd][Std.int(Math.min(Math.max(intInd, 0), sounds[strInd].length - 1))].volume = Std.int(Std.int(Std.int(vol)));
		}
	}

	/**
	 * Whether or not a sound in a set, or a particular sound, is playing
	 * @param	strInd	the sound set
	 * @param	intInd	the index of the sound (-1 is for the whole set)
	 * @return	whether or not a sound in the set is playing
	 */
	public static function soundIsPlaying(strInd:String, intInd:Int = -1):Bool {
		if (intInd == -1) {
			for (i in 0...sounds[strInd].length) {
				if (soundsO[strInd][i].playing) {
					return true;
				}
			}
			return false;
		} else {
			return soundsO[strInd][Std.int(Math.min(Math.max(intInd, 0), sounds[strInd].length - 1))].playing;
		}
	}

	/**
	 * The (maximal) current position of any sound in a set (or a particular sound)
	 * @param	strInd	the sound set
	 * @param	intInd	the index of the sound (-1 is for the whole set)
	 * @return	the maximal position of a sound in the set
	 */
	public static function soundPosition(strInd:String, intInd:Int = -1):Float {
		if (intInd == -1) {
			var soundPos:Float = 0;
			for (i in 0...sounds[strInd].length) {
				soundPos = Math.max(soundPos, soundsO[strInd][i].position);
			}
			return soundPos;
		} else {
			return soundsO[strInd][Std.int(Math.min(Math.max(intInd, 0), sounds[strInd].length - 1))].position;
		}
	}

	/**
	 * The (maximal) current percentage position of any sound in a set (or a particular sound)
	 * @param	strInd	the sound set
	 * @param	intInd	the index of the sound (-1 is for the whole set)
	 * @return	the maximal percentage position of a sound in the set
	 */
	public static function soundPercentage(strInd:String, intInd:Int = -1):Float {
		if (intInd == -1) {
			var soundPos:Float = 0;
			for (i in 0...sounds[strInd].length) {
				soundPos = Math.max(soundPos, soundsO[strInd][i].position / soundsO[strInd][i].length);
			}
			return soundPos;
		} else {
			return soundsO[strInd][Std.int(Math.min(Math.max(intInd, 0),
				sounds[strInd].length - 1))].position / soundsO[strInd][Std.int(Math.min(Math.max(intInd, 0), sounds[strInd].length - 1))].length;
		}
	}
}
