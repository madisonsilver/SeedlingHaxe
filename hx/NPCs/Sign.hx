package nPCs;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.graphics.Spritemap;

/**
 * ...
 * @author Time
 */
class Sign extends NPC {
private var imgSign:BitmapData;
	private var sprSign:Spritemap;

private override function load_image_assets():Void {
imgSign = Assets.getBitmapData("assets/graphics/Sign.png");
}
	public function new(_x:Int, _y:Int, _tag:Int = -1, _text:String = "", _talkingSpeed:Int = 10) {
load_image_assets();
		sprSign = new Spritemap(imgSign, 16, 16);
		super(_x, _y, sprSign, _tag, _text, _talkingSpeed);
		facePlayer = false;
	}
}
