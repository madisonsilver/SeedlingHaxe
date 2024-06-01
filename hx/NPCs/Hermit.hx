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
class Hermit extends NPC {
	private var imgHermit:BitmapData;
	private var sprHermit:Spritemap;
	private var imgHermitPic:BitmapData;
	private var sprHermitPic:Image;

	private var standAnimFrames(default, never):Array<Dynamic> = [0, 2];

	private override function load_image_assets():Void {
		super.load_image_assets();
		imgHermit = Assets.getBitmapData("assets/graphics/NPCs/Hermit.png");
		imgHermitPic = Assets.getBitmapData("assets/graphics/NPCs/HermitPic.png");
	}

	public function new(_x:Int, _y:Int, _tag:Int = -1, _text:String = "", _talkingSpeed:Int = 10) {
		load_image_assets();
		sprHermit = new Spritemap(imgHermit, 10, 12);
		sprHermitPic = new Image(imgHermitPic);
		super(_x, _y, sprHermit, _tag, _text, _talkingSpeed);
		sprHermit.add("talk", [1, 2, 3, 0, 0], 15);
		myPic = sprHermitPic;
	}

	override public function render():Void {
		if (talking) {
			sprHermit.play("talk");
		} else {
			sprHermit.frame = standAnimFrames[Game.worldFrame(standAnimFrames.length)];
		}
		super.render();
	}
}
