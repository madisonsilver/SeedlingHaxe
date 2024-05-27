package nPCs;

import openfl.geom.Point;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import net.flashpunk.graphics.Text;
import net.flashpunk.utils.Draw;
import pickups.Seed;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class Watcher extends NPC {
	@:meta(Embed(source = "../../assets/graphics/NPCs/Watcher.png"))
	private var imgWatcher:Class<Dynamic>;
	private var sprWatcher:Spritemap = new Spritemap(imgWatcher, 12, 15);
	@:meta(Embed(source = "../../assets/graphics/NPCs/WatcherPic.png"))
	private var imgWatcherPic:Class<Dynamic>;
	private var sprWatcherPic:Image = new Image(imgWatcherPic);

	private var seedIndexMin(default, never):Int = 9; // The minimum index of talking at which the seed is shown
	private var seedIndexMax(default, never):Int = 19; // The maximum index of talking at which the seed is shown
	private var seedFrame(default, never):Int = 6; // The frame of the animation where he holds out the seed.
	private var normalFrames(default, never):Int = 6;
	private var dieFrames(default, never):Dynamic = [7, 8, 9];

	private var hits:Int = 0;
	private var hitsTimerMax(default, never):Int = 25;
	private var hitsTimer:Int = 0;

	private var seed:Seed;
	private var createdSeed:Bool = false; // For the final seed

	private var text:String;
	private var text1:String;

	public function new(_x:Int, _y:Int, _tag:Int = -1, _text:String = "", _text1:String = "", _talkingSpeed:Int = 4) {
		super(_x, _y, sprWatcher, _tag, (Game.checkPersistence(_tag)) ? _text : _text1, _talkingSpeed);
		text = _text;
		text1 = _text1;

		myPic = sprWatcherPic;
		facePlayer = false;
		keyNeeded = !Game.checkPersistence(tag);

		type = "Watcher";
		setHitbox(16, 16, 8, 8);
	}

	override public function check():Void {}

	/*
		if (tag1 >= 0 && !Game.checkPersistence(tag1))
		{
			FP.world.remove(this);
		}
	}*/
	override public function update():Void {
		if (Game.checkPersistence(tag)) {
			super.update();
		}
		if (text != "" && talking && Game.checkPersistence(tag) && myCurrentText >= seedIndexMin && myCurrentText <= seedIndexMax) {
			sprWatcher.frame = seedFrame;
			if (seed == null) {
				FP.world.add(seed = new Seed(Std.int(x - 18), Std.int(y - 8), false));
			}
		} else {
			var p:Player = try cast(FP.world.nearestToEntity("Player", this), Player) catch (e:Dynamic) null;
			if (p != null) {
				sprWatcher.frame = Std.int(((Math.atan2(y - p.y, p.x - x) + 2 * Math.PI) / (2 * Math.PI) * normalFrames + normalFrames) % normalFrames);
			}
			if (seed != null) {
				seed.destroySilently();
				seed = null;
			}
		}
		if (hitsTimer > 0) {
			hitsTimer--;
		}
		if (hits > 0) {
			if (hits > dieFrames.length) {
				if (!createdSeed) {
					var p = try cast(FP.world.nearestToEntity("Player", this), Player) catch (e:Dynamic) null;
					if (p != null) {
						FP.world.add(new Seed(Std.int(p.x - 8), Std.int(p.y - 8), true,
							"The seed, covered in the blood of the Watcher, seems almost to cower from your grasp.~This was supposed to be a triumph..."));
						createdSeed = true;
					}
				}
				sprWatcher.frame = sprWatcher.frameCount - 1;
			} else {
				sprWatcher.frame = Reflect.field(dieFrames, Std.string(hits - 1));
			}
		}
		(text == "") ? layer = Std.int(-(y + Tile.h * 8)) : layer = Std.int(-(y - originY + height * 2 / 3));
		visible = Player.hasShield;
	}

	public function hit():Void {
		if (!Game.checkPersistence(tag) && hitsTimer <= 0 && text != "") {
			hits++;
			hitsTimer = hitsTimerMax;
		}
	}

	override public function doneTalking():Void {
		super.doneTalking();
		if (Game.checkPersistence(tag)) {
			Game.setPersistence(tag, false);
		}
	}
}
