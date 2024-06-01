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
class IntroCharacter extends NPC {
	private var imgIntroChar:BitmapData;
	private var sprIntroChar:Spritemap;
	private var imgIntroCharPic:BitmapData;
	private var sprIntroCharPic:Image;

	private override function load_image_assets():Void {
		super.load_image_assets();
		imgIntroChar = Assets.getBitmapData("assets/graphics/NPCs/IntroCharacter.png");
		imgIntroCharPic = Assets.getBitmapData("assets/graphics/NPCs/IntroCharacterPic.png");
	}

	public function new(_x:Int, _y:Int, _tag:Int = -1, _text:String = "", _talkingSpeed:Int = 10) {
		load_image_assets();
		sprIntroChar = new Spritemap(imgIntroChar, 8, 8);
		sprIntroCharPic = new Image(imgIntroCharPic);
		super(_x, _y, sprIntroChar, _tag, _text, _talkingSpeed);
		sprIntroChar.add("talk", [0, 1, 0, 2], 5);

		myPic = sprIntroCharPic;
	}

	override public function render():Void {
		if (talking) {
			sprIntroChar.play("talk");
		} else {
			sprIntroChar.frame = Game.worldFrame(2);
		}
		super.render();
	}
}
