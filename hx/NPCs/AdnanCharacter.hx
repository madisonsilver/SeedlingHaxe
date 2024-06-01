package nPCs;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class AdnanCharacter extends NPC {
private var imgAdnanCharacter:BitmapData;
	private var sprAdnanCharacter:Spritemap;
private var imgAdnanCharacterPic:BitmapData;
	private var sprAdnanCharacterPic:Image;

private override function load_image_assets():Void {
imgAdnanCharacter = Assets.getBitmapData("assets/graphics/NPCs/AdnanCharacter.png");
imgAdnanCharacterPic = Assets.getBitmapData("assets/graphics/NPCs/AdnanCharacterPic.png");
}
	public function new(_x:Int, _y:Int, _tag:Int = -1, _text:String = "", _talkingSpeed:Int = 10) {

load_image_assets();
		sprAdnanCharacter = new Spritemap(imgAdnanCharacter, 8, 8);
		sprAdnanCharacterPic = new Image(imgAdnanCharacterPic);
		super(_x, _y, sprAdnanCharacter, _tag, _text, _talkingSpeed);
		sprAdnanCharacter.add("talk", [0, 1, 0, 2], 5);
		myPic = sprAdnanCharacterPic;
	}

	override public function render():Void {
		if (talking) {
			sprAdnanCharacter.play("talk");
		} else {
			sprAdnanCharacter.frame = Game.worldFrame(2);
		}
		super.render();
	}
}
