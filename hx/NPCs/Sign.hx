package nPCs;

import net.flashpunk.graphics.Spritemap;

/**
 * ...
 * @author Time
 */
class Sign extends NPC {
	@:meta(Embed(source = "../../assets/graphics/Sign.png"))
	private var imgSign:Class<Dynamic>;
	private var sprSign:Spritemap;

	public function new(_x:Int, _y:Int, _tag:Int = -1, _text:String = "", _talkingSpeed:Int = 10) {
		sprSign = new Spritemap(imgSign, 16, 16);
		super(_x, _y, sprSign, _tag, _text, _talkingSpeed);
		facePlayer = false;
	}
}
