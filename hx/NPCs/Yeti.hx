package nPCs;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class Yeti extends NPC {
private var imgYeti:BitmapData;
	private var sprYeti:Spritemap;
private var imgYetiPic:BitmapData;
	private var sprYetiPic:Image;

	private var createdPortal:Bool = false;

private override function load_image_assets():Void {
imgYeti = Assets.getBitmapData("assets/graphics/NPCs/Yeti.png");
imgYetiPic = Assets.getBitmapData("assets/graphics/NPCs/YetiPic.png");
}
	public function new(_x:Int, _y:Int, _tag:Int = -1, _text:String = "", _talkingSpeed:Int = 10) {
load_image_assets();
		sprYeti = new Spritemap(imgYeti, 10, 12);
		sprYetiPic = new Image(imgYetiPic);
		super(_x, _y, sprYeti, _tag, _text, _talkingSpeed);
		sprYeti.add("talk", [0, 1], 5);

		myPic = sprYetiPic;
	}

	override public function render():Void {
		if (talking) {
			sprYeti.play("talk");
		} else {
			sprYeti.frame = Game.worldFrame(2);
		}
		super.render();
	}

	override public function doneTalking():Void {
		super.doneTalking();
		if (!createdPortal) {
			createdPortal = true;
			Game.setPersistence(tag, false);
			// In order for this to work, the portal in DeadBoss.oel must have tag "1"
			Game.setPersistence(1, false);
		}
	}
}
