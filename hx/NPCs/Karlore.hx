package nPCs;

import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class Karlore extends NPC {
	@:meta(Embed(source = "../../assets/graphics/NPCs/Karlore.png"))
	private var imgKarlore:Class<Dynamic>;
	private var sprKarlore:Spritemap;
	@:meta(Embed(source = "../../assets/graphics/NPCs/KarlorePic.png"))
	private var imgKarlorePic:Class<Dynamic>;
	private var sprKarlorePic:Image;

	public function new(_x:Int, _y:Int, _tag:Int = -1, _text:String = "", _talkingSpeed:Int = 10) {
		sprKarlore = new Spritemap(imgKarlore, 20, 20);
		sprKarlorePic = new Image(imgKarlorePic);
		super(_x, _y, sprKarlore, _tag, _text, _talkingSpeed);
		sprKarlore.add("talk", [0, 1], 5);
		myPic = sprKarlorePic;

		setHitbox(16, 16, 8, 8);
	}

	override public function added():Void {
		super.added();
		if (Player.hasFire) {
			FP.world.remove(this);
		}
	}

	override public function doneTalking():Void {
		super.doneTalking();
		Main.unlockMedal(Main.badges[1]);
	}

	override public function render():Void {
		if (talking) {
			sprKarlore.play("talk");
		} else {
			sprKarlore.frame = Game.worldFrame(2);
		}
		super.render();
	}
}
