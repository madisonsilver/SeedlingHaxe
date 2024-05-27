package nPCs;

import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class Sensei extends NPC {
	@:meta(Embed(source = "../../assets/graphics/NPCs/Sensei.png"))
	private var imgSensei:Class<Dynamic>;
	private var sprSensei:Spritemap = new Spritemap(imgSensei, 8, 8);
	@:meta(Embed(source = "../../assets/graphics/NPCs/SenseiPic.png"))
	private var imgSenseiPic:Class<Dynamic>;
	private var sprSenseiPic:Image = new Image(imgSenseiPic);

	private var standAnimFrames(default, never):Array<Dynamic> = [0, 1];

	public function new(_x:Int, _y:Int, _tag:Int = -1, _text:String = "", _talkingSpeed:Int = 10) {
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
