package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import puzzlements.Activators;
import scenery.Tile;
import net.flashpunk.FP;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class FallRock extends Activators {
private var imgRock:BitmapData;
	private var sprRock:Image;

	private var tag:Int;

	private var trigger:Bool = false;

	private var fallRate(default, never):Float = 0.6;
	private var vy:Float = 0;
	private var fallTo:Int;

	private var cameraTimerMax(default, never):Int = 90; // The length of time that the camera focuses after this hits
	private var cameraTimer:Int = 0;

	private var waitToFallTimerMax(default, never):Int = 60; // The length of time before the rock falls
	private var waitToFallTimer:Int = 0;

private function load_image_assets():Void {
imgRock = Assets.getBitmapData("assets/graphics/FallRock.png");
}
	public function new(_x:Int, _y:Int, _t:Int, _tag:Int = -1) {
load_image_assets();
		sprRock = new Image(imgRock);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprRock, _t);
		fallTo = Std.int(y);
		sprRock.centerOO();
		setHitbox(16, 16, 8, 8);
		type = "";
		tag = _tag;
		y = -16;
		if (!Game.checkPersistence(tag))
			// False = fell, true = not fallen
		{
			{
				y = fallTo;
				type = "Solid";
				_active = true;
			}
		}
		layer = -(fallTo - originY + height);
	}

	override public function update():Void {
		var p:Player;
		if (activate && y >= fallTo) {
			p = try cast(collide("Player", x, y), Player) catch (e:Dynamic) null;
			if (p != null) {
				p.y = y - originY + p.originY - p.height;
			}
		}
		if (!Game.checkPersistence(tag)) {
			if (trigger && y < fallTo) {
				Game.cameraTarget = new Point(x - FP.screen.width / 2, fallTo - FP.screen.height / 2);
				if (waitToFallTimer > 0) {
					waitToFallTimer--;
				} else {
					vy += fallRate;
					y += vy;
				}
				if (y >= fallTo) {
					cameraTimer = cameraTimerMax;
					y = fallTo;
					type = "Solid";
					Game.shake = 30;
					Music.playSound("Rock", 0);
					trigger = false;
				}
			} else if (cameraTimer > 0) {
				cameraTimer--;
			} else if (cameraTimer == 0) {
				cameraTimer = -1;
				Game.freezeObjects = false;
				Game.resetCamera();
			}
		}
		super.update();
	}

	public function fall():Void {
		Game.setPersistence(tag, false);
		trigger = true;
		Game.freezeObjects = true;
		waitToFallTimer = waitToFallTimerMax;
	}

	override private function set_activate(a:Bool):Bool {
		if (a && !_active) {
			fall();
			_active = a;
		}
		return a;
	}
}
