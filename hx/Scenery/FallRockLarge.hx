package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import enemies.BobBoss;
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
 * 
 */
class FallRockLarge extends Activators {
private var imgRockLarge:BitmapData;
	private var sprRock:Image;

	private var bossRock:Bool;
	private var thirdBoss:Bool;

	private var tag:Int;

	private var trigger:Bool = false;

	private var fallRate(default, never):Float = 0.6;
	private var vy:Float = 0;
	private var fallTo:Int;

	private var cameraTimerMax(default, never):Int = 90; // The length of time that the camera focuses after this hits
	private var cameraTimer:Int = -1;

	private var waitToFallTimerMax(default, never):Int = 60; // The length of time before the rock falls
	private var waitToFallTimer:Int = 0;

private function load_image_assets():Void {
imgRockLarge = Assets.getBitmapData("assets/graphics/FallRockLarge.png");
}
	public function new(_x:Int, _y:Int, _t:Int, _tag:Int = -1, _bRock:Bool = false, _tboss:Bool = false) {
load_image_assets();
		sprRock = new Image(imgRockLarge);
		super(_x + Tile.w, _y + Tile.h, sprRock, _t);
		bossRock = _bRock;
		fallTo = Std.int(y);
		sprRock.centerOO();
		setHitbox(32, 32, 16, 16);
		type = "";
		tag = _tag;
		thirdBoss = _tboss;
		y = -32;
		if (!Game.checkPersistence(tag))
			// False = fell, true = not fallen
		{
			{
				y = fallTo;
				type = "Solid";
				_active = true; // Set it back to having fallen.
				cameraTimer = 0;
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
		} else if (bossRock) {
			p = try cast(FP.world.nearestToEntity("Player", this), Player) catch (e:Dynamic) null;
			if (p != null) {
				if (!p.fallFromCeiling && p.y < fallTo - sprRock.height / 2 - 8) {
					activate = true;
				}
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
					Music.playSound("Rock", 0, 1.5);
					trigger = false;
				}
			} else if (cameraTimer > 0) {
				cameraTimer--;
			} else if (cameraTimer == 0) {
				if (bossRock && thirdBoss) {
					FP.world.add(new BobBoss(72, 72)); // Create the third dungeon boss when this falls.
					(try cast(FP.world, Game) catch (e:Dynamic) null).playerPosition = new Point(72, 104);
				}
				Game.freezeObjects = false;
				Game.resetCamera();
				cameraTimer = -1;
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
