package nPCs;

import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class ForestCharacter extends NPC {
	@:meta(Embed(source = "../../assets/graphics/NPCs/ForestCharacter.png"))
	private var imgForestChar:Class<Dynamic>;
	private var sprForestChar:Spritemap;
	@:meta(Embed(source = "../../assets/graphics/NPCs/ForestCharacterPic.png"))
	private var imgForestCharPic:Class<Dynamic>;
	private var sprForestCharPic:Image;

	public function new(_x:Int, _y:Int, _tag:Int = -1, _text:String = "", _talkingSpeed:Int = 10) {
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
