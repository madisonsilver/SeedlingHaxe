package puzzlements;
import openfl.utils.Assets;import openfl.display.BitmapData;

import enemies.*;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;
import net.flashpunk.utils.Draw;
import openfl.display.BlendMode;

/**
 * ...
 * @author Time
 */
class RockLock extends Activators {
private var imgRockLock:BitmapData;
	private var sprRockLock:Image;

	private var normType:String = "Solid";
	private var tag:Int;

private function load_image_assets():Void {
imgRockLock = Assets.getBitmapData("assets/graphics/RockLock.png");
}
	public function new(_x:Int, _y:Int, _t:Int, _tag:Int = -1) {

load_image_assets();
		sprRockLock = new Image(imgRockLock);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprRockLock, _t);
		sprRockLock.centerOO();
		setHitbox(16, 16, 8, 8);
		type = normType;
		tag = _tag;
	}

	override public function check():Void {
		super.check();
		if (tag >= 0 && !Game.checkPersistence(tag)) {
			FP.world.remove(this);
		}
	}

	override private function set_activate(a:Bool):Bool {
		if (!_active && a) {
			Music.playSoundDistPlayer(Std.int(x), Std.int(y), "Lock");
		}
		_active = a;
		return a;
	}

	override public function update():Void {
		super.update();
		if (tSet == -1 && (try cast(FP.world, Game) catch (e:Dynamic) null).totalEnemies() == 0) {
			activate = true;
		}
		if (activate) {
			if (sprRockLock.alpha > 0) {
				sprRockLock.alpha -= 0.01;
				if (sprRockLock.alpha <= 0) {
					type = "";
					sprRockLock.alpha = 0;
					Game.setPersistence(tag, false);
				}
			}
		} else if (!Game.checkPersistence(tag)) {
			type = normType;
			sprRockLock.alpha = 1;
			Game.setPersistence(tag, true);
		}
	}

	override public function render():Void {
		if (activate) {
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
		(try cast(graphic, Image) catch (e:Dynamic) null).blend = (activate) ? BlendMode.INVERT : BlendMode.NORMAL;
		super.render();
		(try cast(graphic, Image) catch (e:Dynamic) null).blend = BlendMode.NORMAL;
	}
}
