package nPCs;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class Rekcahdam extends NPC {
private var imgRekcahdam:BitmapData;
	private var sprRekcahdam:Spritemap;
private var imgRekcahdamPic:BitmapData;
	private var sprRekcahdamPic:Image;

private override function load_image_assets():Void {
imgRekcahdam = Assets.getBitmapData("assets/graphics/NPCs/Rekcahdam.png");
imgRekcahdamPic = Assets.getBitmapData("assets/graphics/NPCs/RekcahdamPic.png");
}
	public function new(_x:Int, _y:Int, _tag:Int = -1, _text:String = "", _talkingSpeed:Int = 10) {
load_image_assets();
		sprRekcahdam = new Spritemap(imgRekcahdam, 9, 10);
		sprRekcahdamPic = new Image(imgRekcahdamPic);
		super(_x, _y, sprRekcahdam, _tag, _text, _talkingSpeed);
		sprRekcahdam.add("talk", [0, 1, 0], 5);

		myPic = sprRekcahdamPic;
	}

	override public function render():Void {
		if (talking) {
			sprRekcahdam.play("talk");
		} else {
			sprRekcahdam.frame = Game.worldFrame(2);
		}
		super.render();
	}
}
