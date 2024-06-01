package pickups;
import openfl.utils.Assets;import openfl.display.BitmapData;

import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class TorchPickup extends Pickup {
private var imgTorchPickup:BitmapData;
	private var sprTorchPickup:Spritemap;

	private var tag:Int;
	private var doActions:Bool = true;

private function load_image_assets():Void {
imgTorchPickup = Assets.getBitmapData("assets/graphics/TorchPickup.png");
}
	public function new(_x:Int, _y:Int, _tag:Int = -1) {

load_image_assets();
		sprTorchPickup = new Spritemap(imgTorchPickup, 12, 12);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprTorchPickup, null, false);
		sprTorchPickup.centerOO();
		setHitbox(8, 8, 4, 4);

		tag = _tag;

		special = true;
		text = "You got the light!~It lights your path with color.";

		layer = Tile.LAYER;
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
			Main.unlockMedal(Main.badges[3]);
			Player.hasTorch = true;
			Game.setPersistence(tag, false);
		}
	}

	override public function update():Void {
		super.update();
	}

	override public function render():Void {
		super.render();
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		super.render();
		Draw.resetTarget();
	}

	override public function pick_up():Void {
		sprTorchPickup.frame = 1;
		super.pick_up();
	}
}
