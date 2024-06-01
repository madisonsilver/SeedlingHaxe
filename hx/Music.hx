import openfl.utils.Assets;import openfl.display.BitmapData;
import openfl.utils.Dictionary;
import openfl.events.Event;
import net.flashpunk.Sfx;
import net.flashpunk.FP;
import net.flashpunk.utils.Input;
import net.flashpunk.utils.Key;

/**
 * ...
 * @author Time
 */
class Music {
	@:meta(Embed(source = "../assets/sound/Sword1.mp3"))
	private static var sndSword1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Sword2.mp3"))
	private static var sndSword2:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Sword3.mp3"))
	private static var sndSword3:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/stab1.mp3"))
	private static var sndStab1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/stab2.mp3"))
	private static var sndStab2:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/stab3.mp3"))
	private static var sndStab3:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/splash1.mp3"))
	private static var sndSplash1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/splash2.mp3"))
	private static var sndSplash2:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/swim.mp3"))
	private static var sndSwim1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/arrowLaunch.mp3"))
	private static var sndArrow1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/arrowHit.mp3"))
	private static var sndArrow2:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/switch.mp3"))
	private static var sndSwitch1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/smallEnemyHit.mp3"))
	private static var sndEnemyHit1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/bigEnemyHit.mp3"))
	private static var sndEnemyHit2:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/metalHit.mp3"))
	private static var sndMetal1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/enemyhop.mp3"))
	private static var sndEnemyHop1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/bigenemyhop.mp3"))
	private static var sndEnemyHop2:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/chest.mp3"))
	private static var sndChest1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/bigLock.mp3"))
	private static var sndLock1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/BigRockHit.mp3"))
	private static var sndRock1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/rockcrumble.mp3"))
	private static var sndRock2:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/drill.mp3"))
	private static var sndDrill1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/energyBeam.mp3"))
	private static var sndEnergyBeam1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/energyPulse.mp3"))
	private static var sndEnergyPulse1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/explosion.mp3"))
	private static var sndExplosion1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/enemyfall.mp3"))
	private static var sndEnemyFall1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/pushrock.mp3"))
	private static var sndPushRock1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/smallenemydie.mp3"))
	private static var sndEnemyDie1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/nextroom.mp3"))
	private static var sndRoom1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/upstairs.mp3"))
	private static var sndRoom2:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/downstairs.mp3"))
	private static var sndRoom3:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/teleport.mp3"))
	private static var sndRoom4:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/hurt.mp3"))
	private static var sndHurt1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/groundhit.mp3"))
	private static var sndGroundHit1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/groundhit2.mp3"))
	private static var sndGroundHit2:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/playerfall.mp3"))
	private static var sndPlayerFall1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/boss4die.mp3"))
	private static var sndBossDie1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/boss4die2.mp3"))
	private static var sndBossDie2:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/boss6die.mp3"))
	private static var sndBossDie3:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/boss5rise.mp3"))
	private static var sndBossDie4:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/boss5die.mp3"))
	private static var sndBossDie5:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/boss4beam.mp3"))
	private static var sndEnemyAttack1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/boss4beam2.mp3"))
	private static var sndEnemyAttack2:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/boss4shoot.mp3"))
	private static var sndEnemyAttack3:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/enemyChomp.mp3"))
	private static var sndEnemyAttack4:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/boss6move.mp3"))
	private static var sndBoss6Move1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/boss6move1.mp3"))
	private static var sndBoss6Move2:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/boss6move2.mp3"))
	private static var sndBoss6Move3:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/wandfire.mp3"))
	private static var sndWandFire1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/wandfizzle.mp3"))
	private static var sndWandFizzle1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/turretFire.mp3"))
	private static var sndTurretShoot1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/wind.mp3"))
	private static var sndWind1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/ArcticWind.mp3"))
	private static var sndWind2:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/TreeBurning.mp3"))
	private static var sndBurn1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/punch.mp3"))
	private static var sndPunch1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/monstersplash.mp3"))
	private static var sndTentacle1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/fireattack.mp3"))
	private static var sndFire1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/LavaPunch.mp3"))
	private static var sndLava1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/LavaClap.mp3"))
	private static var sndLava2:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Pop.mp3"))
	private static var sndLava3:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Light.mp3"))
	private static var sndLight1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/text.mp3"))
	private static var sndText1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/textNext.mp3"))
	private static var sndText2:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/boss4start.mp3"))
	private static var sndOther1:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/boss4walk.mp3"))
	private static var sndOther2:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/turretIceFire.mp3"))
	private static var sndOther3:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/ropeCut.mp3"))
	private static var sndOther4:Class<Dynamic>;
	@:meta(Embed(source = "../assets/sound/Unapproved/crusher.mp3"))
	private static var sndOther5:Class<Dynamic>;

	private static var currentSet:String = "";
	private static var currentIndex:Int = -1;

	private static var setNames:Array<String> = new Array<String>();
	private static var soundsO:Dictionary<String, Array<Dynamic>> = new Dictionary();
	private static var soundSwords:Array<Dynamic> = [sndSword1, sndSword2, sndSword3];
	private static var soundStabs:Array<Dynamic> = [sndStab1, sndStab2, sndStab3];
	private static var soundSplash:Array<Dynamic> = [sndSplash1, sndSplash2];
	private static var soundSwim:Array<Dynamic> = [sndSwim1];
	private static var soundArrow:Array<Dynamic> = [sndArrow1, sndArrow2];
	private static var soundSwitch:Array<Dynamic> = [sndSwitch1];
	private static var soundDrill:Array<Dynamic> = [sndDrill1, sndDrill1];
	private static var soundEnemyHit:Array<Dynamic> = [sndEnemyHit1, sndEnemyHit2];
	private static var soundMetal:Array<Dynamic> = [sndMetal1];
	private static var soundEnemyHop:Array<Dynamic> = [sndEnemyHop1, sndEnemyHop2];
	private static var soundChest:Array<Dynamic> = [sndChest1];
	private static var soundRock:Array<Dynamic> = [sndRock1, sndRock2];
	private static var soundLock:Array<Dynamic> = [sndLock1];
	private static var soundEnergyBeam:Array<Dynamic> = [sndEnergyBeam1, sndEnergyBeam1, sndEnergyBeam1];
	private static var soundEnergyPulse:Array<Dynamic> = [sndEnergyPulse1, sndEnergyPulse1];
	private static var soundExplosion:Array<Dynamic> = [sndExplosion1, sndExplosion1, sndExplosion1];
	private static var soundEnemyFall:Array<Dynamic> = [sndEnemyFall1, sndEnemyFall1, sndEnemyFall1];
	private static var soundPushRock:Array<Dynamic> = [sndPushRock1];
	private static var soundEnemyDie:Array<Dynamic> = [sndEnemyDie1, sndEnemyDie1];
	private static var soundRoom:Array<Dynamic> = [sndRoom1, sndRoom2, sndRoom3, sndRoom4];
	private static var soundHurt:Array<Dynamic> = [sndHurt1];
	private static var soundGroundHit:Array<Dynamic> = [sndGroundHit1, sndGroundHit2];
	private static var soundPlayerFall:Array<Dynamic> = [sndPlayerFall1];
	private static var soundBossDie:Array<Dynamic> = [sndBossDie1, sndBossDie2, sndBossDie3, sndBossDie4, sndBossDie5];
	private static var soundEnemyAttack:Array<Dynamic> = [sndEnemyAttack1, sndEnemyAttack2, sndEnemyAttack3, sndEnemyAttack4];
	private static var soundBoss6Move:Array<Dynamic> = [
		sndBoss6Move1,
		sndBoss6Move2,
		sndBoss6Move3,
		sndBoss6Move1,
		sndBoss6Move2,
		sndBoss6Move3
	];
	private static var soundWandFire:Array<Dynamic> = [sndWandFire1, sndWandFire1];
	private static var soundWandFizzle:Array<Dynamic> = [sndWandFizzle1, sndWandFizzle1];
	private static var soundTurretShoot:Array<Dynamic> = [sndTurretShoot1, sndTurretShoot1, sndTurretShoot1];
	private static var soundWind:Array<Dynamic> = [sndWind1, sndWind2];
	private static var soundBurn:Array<Dynamic> = [sndBurn1];
	private static var soundPunch:Array<Dynamic> = [sndPunch1];
	private static var soundTentacle:Array<Dynamic> = [sndTentacle1, sndTentacle1, sndTentacle1, sndTentacle1];
	private static var soundFire:Array<Dynamic> = [sndFire1];
	private static var soundLava:Array<Dynamic> = [sndLava1, sndLava2, sndLava3];
	private static var soundLight:Array<Dynamic> = [sndLight1];
	private static var soundText:Array<Dynamic> = [sndText1, sndText2];
	private static var soundOther:Array<Dynamic> = [sndOther1, sndOther2, sndOther3, sndOther4, sndOther5];
	private static var sounds:Dictionary<String, Array<Dynamic>> = new Dictionary();
	@:meta(Embed(source = "../assets/sound/Yes, Master.mp3"))
	private static var sndYesMaster:Class<Dynamic>;
	public static var sndOYesMaster:Sfx = new Sfx(sndYesMaster);

	@:meta(Embed(source = "../assets/sound/Found It!.mp3"))
	private static var sndFoundIt:Class<Dynamic>;
	public static var sndOFoundIt:Sfx = new Sfx(sndFoundIt);

	@:meta(Embed(source = "../assets/sound/One Piece.mp3"))
	private static var sndSealPiece:Class<Dynamic>;
	public static var sndOSealPiece:Sfx = new Sfx(sndSealPiece);

	@:meta(Embed(source = "../assets/sound/Of The Puzzle.mp3"))
	private static var sndSeal:Class<Dynamic>;
	public static var sndOSeal:Sfx = new Sfx(sndSeal);

	@:meta(Embed(source = "../assets/sound/The Key.mp3"))
	private static var sndKey:Class<Dynamic>;
	public static var sndOKey:Sfx = new Sfx(sndKey);

	@:meta(Embed(source = "../assets/sound/In The Beginning.mp3"))
	private static var sndMenu:Class<Dynamic>;
	public static var sndOMenu:Sfx = new Sfx(sndMenu);

	@:meta(Embed(source = "../assets/sound/A Warrior's Journey.mp3"))
	private static var sndTheme:Class<Dynamic>;
	public static var sndOTheme:Sfx = new Sfx(sndTheme);

	@:meta(Embed(source = "../assets/sound/Warriors Don't Sleep.mp3"))
	private static var sndThemeNight:Class<Dynamic>;
	public static var sndOThemeNight:Sfx = new Sfx(sndThemeNight);

	@:meta(Embed(source = "../assets/sound/My Life's Purpose.mp3"))
	private static var sndMyLifesPurpose:Class<Dynamic>;
	public static var sndOMyLifesPurpose:Sfx = new Sfx(sndMyLifesPurpose);

	@:meta(Embed(source = "../assets/sound/The Watcher.mp3"))
	private static var sndTheWatcher:Class<Dynamic>;
	public static var sndOTheWatcher:Sfx = new Sfx(sndTheWatcher);

	@:meta(Embed(source = "../assets/sound/My First Dungeon.mp3"))
	private static var sndMyFirstDungeon:Class<Dynamic>;
	public static var sndOMyFirstDungeon:Sfx = new Sfx(sndMyFirstDungeon);

	@:meta(Embed(source = "../assets/sound/Stuck In The Forest.mp3"))
	private static var sndStuckInTheForest:Class<Dynamic>;
	public static var sndOStuckInTheForest:Sfx = new Sfx(sndStuckInTheForest);

	@:meta(Embed(source = "../assets/sound/Mysterious Magic.mp3"))
	private static var sndMysteriousMagic:Class<Dynamic>;
	public static var sndOMysteriousMagic:Sfx = new Sfx(sndMysteriousMagic);

	@:meta(Embed(source = "../assets/sound/Cold Blooded.mp3"))
	private static var sndColdBlooded:Class<Dynamic>;
	public static var sndOColdBlooded:Sfx = new Sfx(sndColdBlooded);

	@:meta(Embed(source = "../assets/sound/How To Lose Your Shadow 101.mp3"))
	private static var sndShadow:Class<Dynamic>;
	public static var sndOShadow:Sfx = new Sfx(sndShadow);

	@:meta(Embed(source = "../assets/sound/Lava Is Hot.mp3"))
	private static var sndLavaIsHot:Class<Dynamic>;
	public static var sndOLavaIsHot:Sfx = new Sfx(sndLavaIsHot);

	@:meta(Embed(source = "../assets/sound/The Sky.mp3"))
	private static var sndTheSky:Class<Dynamic>;
	public static var sndOTheSky:Sfx = new Sfx(sndTheSky);

	@:meta(Embed(source = "../assets/sound/Fight Me Like A Boss.mp3"))
	private static var sndBoss:Class<Dynamic>;
	public static var sndOBoss:Sfx = new Sfx(sndBoss);

	public static var songs:Array<Dynamic> = [
		sndOTheme, sndOThemeNight, sndOMenu, sndOYesMaster, sndOMyLifesPurpose, sndOTheWatcher, sndOMyFirstDungeon, sndOStuckInTheForest, sndOMysteriousMagic,
		sndOColdBlooded, sndOShadow, sndOLavaIsHot, sndOTheSky, sndOBoss
	];

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

	public function new() {}

	public static function begin():Void // called by Main
	{
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
		var cplayIndex:Int;
		if (intInd == -1) {
			do {
				cplayIndex = Math.floor(Math.random() * sounds[strInd].length);
			} while ((cplayIndex == currentIndex && sounds[strInd].length > 1 && currentSet == strInd));
		} else {
			cplayIndex = Std.int(Math.min(Math.max(intInd, 0), sounds[strInd].length - 1));
		}
		currentSet = strInd;
		currentIndex = cplayIndex;
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
