package pickups;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class BossTotemPart extends Pickup {
	private var imgBossTotemPart:BitmapData;
	private var sprBossTotemPart:Spritemap;

	private var totemPart:Int;
	private var doActions:Bool = true;

	private function load_image_assets():Void {
		imgBossTotemPart = Assets.getBitmapData("assets/graphics/BossTotemParts.png");
	}

	public function new(_x:Int, _y:Int, _t:Int) {
		load_image_assets();
		sprBossTotemPart = new Spritemap(imgBossTotemPart, 24, 24);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprBossTotemPart, new Point(), false);
		sprBossTotemPart.frame = _t;
		sprBossTotemPart.centerOO();
		setHitbox(16, 16, 8, 8);
		totemPart = _t;
		layer = Std.int(-(y - originY + height));

		special = true;
	}

	override public function check():Void {
		super.check();
		if (Player.hasTotemPart(totemPart)) {
			doActions = false;
			FP.world.remove(this);
		}
	}

	override public function removed():Void {
		if (doActions) {
			Player.hasTotemPartSet(totemPart, true);
		}
	}
}
