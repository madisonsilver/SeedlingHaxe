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
class Karlore extends NPC {
	private var imgKarlore:BitmapData;
	private var sprKarlore:Spritemap;
	private var imgKarlorePic:BitmapData;
	private var sprKarlorePic:Image;

	private override function load_image_assets():Void {
		super.load_image_assets();
		imgKarlore = Assets.getBitmapData("assets/graphics/NPCs/Karlore.png");
		imgKarlorePic = Assets.getBitmapData("assets/graphics/NPCs/KarlorePic.png");
	}

	public function new(_x:Int, _y:Int, _tag:Int = -1, _text:String = "", _talkingSpeed:Int = 10) {
		load_image_assets();
		sprKarlore = new Spritemap(imgKarlore, 20, 20);
		sprKarlorePic = new Image(imgKarlorePic);
		super(_x, _y, sprKarlore, _tag, _text, _talkingSpeed);
		sprKarlore.add("talk", [0, 1], 5);
		myPic = sprKarlorePic;

		setHitbox(16, 16, 8, 8);
	}

	override public function added():Void {
		super.added();
		if (Player.hasFire) {
			FP.world.remove(this);
		}
	}

	override public function doneTalking():Void {
		super.doneTalking();
		Main.unlockMedal(Main.badges[1]);
	}

	override public function render():Void {
		if (talking) {
			sprKarlore.play("talk");
		} else {
			sprKarlore.frame = Game.worldFrame(2);
		}
		super.render();
	}
}
