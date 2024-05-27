package nPCs;

import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class AdnanCharacter extends NPC {
	@:meta(Embed(source = "../../assets/graphics/NPCs/AdnanCharacter.png"))
	private var imgAdnanCharacter:Class<Dynamic>;
	private var sprAdnanCharacter:Spritemap = new Spritemap(imgAdnanCharacter, 8, 8);
	@:meta(Embed(source = "../../assets/graphics/NPCs/AdnanCharacterPic.png"))
	private var imgAdnanCharacterPic:Class<Dynamic>;
	private var sprAdnanCharacterPic:Image = new Image(imgAdnanCharacterPic);

	public function new(_x:Int, _y:Int, _tag:Int = -1, _text:String = "", _talkingSpeed:Int = 10) {
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
