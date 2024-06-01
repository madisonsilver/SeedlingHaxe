package nPCs;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import net.flashpunk.Sfx;
import pickups.DarkSword;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class Witch extends NPC {
	private var imgWitch:BitmapData;
	private var sprWitch:Spritemap;
	private var imgWitchPic:BitmapData;
	private var sprWitchPic:Image;

	private var textExtra(default,
		never):String = "Oh, you found the wand!~You must be very powerful and your goals noble.~Here is an enchantment to improve your sword!";
	private var textExtra1(default, never):String = "May you do only good with that sword.~I presume you can be trusted?";

	private override function load_image_assets():Void {
		super.load_image_assets();
		imgWitch = Assets.getBitmapData("assets/graphics/NPCs/Witch.png");
		imgWitchPic = Assets.getBitmapData("assets/graphics/NPCs/WitchPic.png");
	}

	public function new(_x:Int, _y:Int, _tag:Int = -1, _text:String = "", _talkingSpeed:Int = 10) {
		load_image_assets();
		sprWitch = new Spritemap(imgWitch, 16, 13);
		sprWitchPic = new Image(imgWitchPic);
		super(_x, _y, sprWitch, _tag, _text, _talkingSpeed);
		sprWitch.add("talk", [0, 1], 5);
		myPic = sprWitchPic;
	}

	override public function update():Void {
		if (Main.hasWand) {
			if (Main.hasDarkSword) {
				prepNewText(textExtra1);
			} else {
				prepNewText(textExtra);
			}
		}
		super.update();
	}

	override public function doneTalking():Void {
		if (Main.hasWand && !Main.hasDarkSword) {
			var p:Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch (e:Dynamic) null;
			FP.world.add(new DarkSword(Std.int(p.x - Tile.w / 2), Std.int(p.y - Tile.h / 2)));
		}
	}

	override public function render():Void {
		if (talking) {
			sprWitch.play("talk");
		} else {
			sprWitch.frame = Game.worldFrame(2);
		}
		super.render();
	}
}
