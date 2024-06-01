package nPCs;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class Oracle extends NPC {
	private var imgOracle:BitmapData;
	private var sprOracle:Spritemap;
	private var imgOraclePic:BitmapData;
	private var sprOraclePic:Image;

	private var wakenDistance(default, never):Int = 48;

	private var text:String;
	private var text1:String;

	private var text2(default, never):String = "You have brought the seed. Good work.~Your purpose is fulfilled, but now you are not needed.~Goodbye.";

	private override function load_image_assets():Void {
		imgOracle = Assets.getBitmapData("assets/graphics/NPCs/Oracle.png");
		imgOraclePic = Assets.getBitmapData("assets/graphics/NPCs/OraclePic.png");
	}

	public function new(_x:Int, _y:Int, _tag:Int = -1, _text:String = "", _text1:String = "", _talkingSpeed:Int = 10) {
		load_image_assets();
		sprOracle = new Spritemap(imgOracle, 16, 24, animEnd);
		sprOraclePic = new Image(imgOraclePic);
		super(_x, _y, sprOracle, _tag, (Game.cutscene[1] != null) ? text2 : ((Game.checkPersistence(_tag)) ? _text : _text1), _talkingSpeed);
		if (Game.cutscene[1] != null) {
			text = text1 = text2;
		} else {
			text = _text;
			text1 = _text1;
		}

		sprOracle.y = -16;
		sprOracle.originY = Std.int(-sprOracle.y);
		setHitbox(16, 16, 8, 8);

		sprOracle.add("waken", [0, 1, 2], 5);
		sprOracle.add("fallAsleep", [2, 1, 0], 5);
		sprOracle.add("sleep", [0]);
		sprOracle.add("awake", [3]);
		sprOracle.add("talk", [3, 4, 5], 5);

		sprOracle.play("sleep");

		facePlayer = false;
		charToTalkMargin = 10;

		myPic = sprOraclePic;
	}

	override public function render():Void {
		if (talking) {
			sprOracle.play("talk");
		} else {
			var player:Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch (e:Dynamic) null;
			if (player != null) {
				var d:Int = Std.int(FP.distance(x, y, player.x, player.y));
				if (d <= wakenDistance) {
					if (sprOracle.currentAnim != "awake") {
						sprOracle.play("waken");
					}
				} else if (sprOracle.currentAnim != "sleep") {
					sprOracle.play("fallAsleep");
				}
			}
		}
		super.render();
	}

	override public function check():Void {}

	override public function talking_extras():Void {}

	override public function doneTalking():Void {
		super.doneTalking();
		if (Game.cutscene[1] != null) {
			var p:Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch (e:Dynamic) null;
			if (p == null || p.graphic != p.sprShrumDark) {
				exitToMenu();
			} else {
				p.sprShrumDark.play("die");
			}
		} else if (Game.checkPersistence(tag)) {
			Game.setPersistence(tag, false);
			Main.unlockMedal(Main.badges[0]);
		}
		prepNewText(text1);
	}

	private function exitToMenu():Void {
		Game.menu = true;
		FP.world = new Game((try cast(FP.world, Game) catch (e:Dynamic) null).level, Std.int(Game.currentPlayerPosition.x),
			Std.int(Game.currentPlayerPosition.y));
	}

	public function animEnd():Void {
		var _sw0_ = (sprOracle.currentAnim);

		switch (_sw0_) {
			case "waken":
				sprOracle.play("awake");
			case "fallAsleep":
				sprOracle.play("sleep");
			default:
		}
	}
}
