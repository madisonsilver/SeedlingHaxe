package nPCs;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class ForestCharacter extends NPC {
private var imgForestChar:BitmapData;
	private var sprForestChar:Spritemap;
private var imgForestCharPic:BitmapData;
	private var sprForestCharPic:Image;

private override function load_image_assets():Void {
imgForestChar = Assets.getBitmapData("assets/graphics/NPCs/ForestCharacter.png");
imgForestCharPic = Assets.getBitmapData("assets/graphics/NPCs/ForestCharacterPic.png");
}
	public function new(_x:Int, _y:Int, _tag:Int = -1, _text:String = "", _talkingSpeed:Int = 10) {

load_image_assets();
		sprForestChar = new Spritemap(imgForestChar, 8, 9);
		sprForestCharPic = new Image(imgForestCharPic);
		super(_x, _y, sprForestChar, _tag, _text, _talkingSpeed);
		sprForestChar.add("talk", [0, 1], 5);
		myPic = sprForestCharPic;
	}

	override public function render():Void {
		if (talking) {
			sprForestChar.play("talk");
		} else {
			sprForestChar.frame = Game.worldFrame(2);
		}
		super.render();
	}
}
