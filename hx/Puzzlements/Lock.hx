package puzzlements;
import openfl.utils.Assets;import openfl.display.BitmapData;

import enemies.*;
import net.flashpunk.Graphic;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;
import openfl.display.BlendMode;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class Lock extends Activators {
private var imgLock:BitmapData;

	public var sprLock:Spritemap;

	private var normType:String = "Solid";
	private var tag:Int;

	private var hitables:Dynamic = ["Player", "Enemy", "Solid"];

private function load_image_assets():Void {
imgLock = Assets.getBitmapData("assets/graphics/Lock.png");
}
	public function new(_x:Int, _y:Int, _t:Int, _tag:Int = -1, _g:Graphic = null) {
load_image_assets();
		sprLock = new Spritemap(imgLock, 16, 16);
		if (_g == null) {
			_g = sprLock;
		}
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), _g, _t);
		(try cast(graphic, Image) catch (e:Dynamic) null).centerOO();
		setHitbox(16, 16, 8, 8);
		type = normType;
		tag = _tag;
		layer = Std.int(-y);
	}

	override public function check():Void {
		super.check();
		if (tag >= 0 && tSet < 0 && !Game.checkPersistence(tag)) {
			FP.world.remove(this);
		}
	}

	override public function update():Void {
		super.update();
		checkEnemies();
		activationStep();
	}

	override private function set_activate(a:Bool):Bool {
		if (!_active && a) {
			Music.playSoundDistPlayer(Std.int(x), Std.int(y), "Lock");
		}
		_active = a;
		return a;
	}

	public function activationStep():Void {
		if (activate) {
			if ((try cast(graphic, Image) catch (e:Dynamic) null).alpha > 0) {
				(try cast(graphic, Image) catch (e:Dynamic) null).alpha -= 0.01;
			} else {
				turnOff();
			}
		} else {
			if (type == normType) {
				(try cast(graphic, Image) catch (e:Dynamic) null).alpha = 1;
			}
			if (collideTypes(hitables, x, y) == null) {
				returnToNormal();
			}
		}
	}

	public function turnOff():Void {
		if (type == normType) {
			type = "";
			(try cast(graphic, Image) catch (e:Dynamic) null).alpha = 0;
			Game.setPersistence(tag, false);
		}
	}

	public function returnToNormal():Void {
		if (type == "") {
			type = normType;
			Game.setPersistence(tag, true);
		}
	}

	public function checkEnemies():Void {
		if (tSet == -1 && (try cast(FP.world, Game) catch (e:Dynamic) null).totalEnemies() == 0) {
			activate = true;
		}
	}

	override public function render():Void {
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).frame = Game.worldFrame((try cast(graphic, Spritemap) catch (e:Dynamic) null).frameCount);

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
