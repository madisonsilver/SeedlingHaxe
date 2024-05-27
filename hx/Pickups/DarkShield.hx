package pickups;

import net.flashpunk.graphics.Image;
import net.flashpunk.FP;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class DarkShield extends Pickup {
	@:meta(Embed(source = "../../assets/graphics/DarkShield.png"))
	private var imgDarkShield:Class<Dynamic>;
	private var sprDarkShield:Image = new Image(imgDarkShield);

	private var tag:Int;
	private var doActions:Bool = true;

	public function new(_x:Int, _y:Int, _tag:Int = -1) {
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprDarkShield, null, false);
		sprDarkShield.centerOO();
		setHitbox(9, 9, 5, 5);

		tag = _tag;

		special = true;
		text = "You got the Dark Shield!~It hurts what it touches.";
	}

	override public function check():Void {
		super.check();
		if (tag >= 0 && !Game.checkPersistence(tag)) {
			doActions = false;
			FP.world.remove(this);
		}
	}

	override public function removed():Void {
		if (doActions) {
			Player.hasDarkShield = true;
			Game.setPersistence(tag, false);
		}
	}
}
