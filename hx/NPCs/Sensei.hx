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
class Sensei extends NPC {
	private var imgSensei:BitmapData;
	private var sprSensei:Spritemap;
	private var imgSenseiPic:BitmapData;
	private var sprSenseiPic:Image;

	private var standAnimFrames(default, never):Array<Dynamic> = [0, 1];

	private override function load_image_assets():Void {
		super.load_image_assets();
		imgSensei = Assets.getBitmapData("assets/graphics/NPCs/Sensei.png");
		imgSenseiPic = Assets.getBitmapData("assets/graphics/NPCs/SenseiPic.png");
	}

	public function new(_x:Int, _y:Int, _tag:Int = -1, _text:String = "", _talkingSpeed:Int = 10) {
		load_image_assets();
		sprSensei = new Spritemap(imgSensei, 8, 8);
		sprSenseiPic = new Image(imgSenseiPic);
		super(_x, _y, sprSensei, _tag, _text, _talkingSpeed);
		sprSensei.add("talk", [1, 2, 1, 0, 0], 15);
		myPic = sprSenseiPic;
	}

	override public function render():Void {
		if (talking) {
			sprSensei.play("talk");
		} else {
			sprSensei.frame = standAnimFrames[Game.worldFrame(standAnimFrames.length)];
		}
		super.render();
	}
}
