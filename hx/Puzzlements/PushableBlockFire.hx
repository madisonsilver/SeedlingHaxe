package puzzlements;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Input;
import net.flashpunk.utils.Key;
import net.flashpunk.FP;
import scenery.Tile;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class PushableBlockFire extends Mobile {
private var imgPushableBlockFire:BitmapData;
	private var sprPushableBlockFire:Spritemap;

	private var moveSpeed(default, never):Float = 0.5;
	private var tile:Point; // The middle of the tile that you want to move toward
	private var vMusicCheck:Point = new Point();

	public var moveTypes:Array<Dynamic> = ["Fire", "Pulse"];

private function load_image_assets():Void {
imgPushableBlockFire = Assets.getBitmapData("assets/graphics/PushableBlockFire.png");
}
	public function new(_x:Int, _y:Int) {
load_image_assets();
		sprPushableBlockFire = new Spritemap(imgPushableBlockFire, 16, 16);
		super(_x, _y, sprPushableBlockFire);
		sprPushableBlockFire.color = 0xFF0000;
		setHitbox(16, 16);
		type = "Solid";
		solids.push("Enemy", "Player");

		tile = getPos(Std.int(x), Std.int(y));
	}

	override public function input():Void {
		if (gridPos(Std.int(x), Std.int(y)).equals(new Point(x, y))) {
			var myTile:Tile = try cast(FP.world.nearestToPoint("Tile", x - originX + width / 2, y - originY + height / 2), Tile) catch (e:Dynamic) null;
			if (myTile != null) {
				if (myTile.t == 1 || myTile.t == 17 || myTile.t == 6)
					// Water && Lava && Pit
				{
					{
						destroy = true;
					}
				}
			}
		}
		vMusicCheck = v.clone();
		v.x = moveSpeed * FP.sign(tile.x - x - Tile.w / 2);
		v.y = moveSpeed * FP.sign(tile.y - y - Tile.h / 2);

		if (collideTypes(solids, gridPos(Std.int(x), Std.int(y)).x, gridPos(Std.int(x), Std.int(y)).y) == null) {
			if (Math.abs(v.x) <= 0.01) {
				x = Std.int(as3hx.Compat.parseInt(gridPos(Std.int(x), Std.int(y)).x));
			}
			if (Math.abs(v.y) <= 0.01) {
				y = Std.int(as3hx.Compat.parseInt(gridPos(Std.int(x), Std.int(y)).y));
			}
		}
	}

	public function gridPos(_x:Int, _y:Int):Point {
		return new Point(Math.floor(_x / Tile.w) * Tile.w, Math.floor(_y / Tile.h) * Tile.h);
	}

	public function getPos(_x:Int, _y:Int):Point {
		return new Point((Math.floor(_x / Tile.w) + 0.5) * Tile.w, (Math.floor(_y / Tile.h) + 0.5) * Tile.h);
	}

	public function hit(p:Point, t:String, _relative:Bool = false):Void {
		if (v.length > 0)
			// Don't reset if we're already moving
		{
			return;
		}

		if (_relative) {
			tile.x = getPos(Std.int(x), Std.int(y)).x - p.x * Tile.w;
			tile.y = getPos(Std.int(x), Std.int(y)).y - p.y * Tile.h;
			return;
		}
		var cont:Bool = false;
		for (i in 0...moveTypes.length) {
			if (t == moveTypes[i]) {
				cont = true;
				break;
			}
		}
		if (cont) {
			var a:Float = Math.atan2(-(y - originY + height / 2) + p.y, p.x - (x - originX + width / 2));
			var bothRange:Float = 0.1; // This range determines when both horizontal and vertical movement will occur.
			if (Math.abs(Math.sin(a)) - bothRange < Math.abs(Math.cos(a))) {
				if (Math.cos(a) > 0) {
					tile.x = getPos(Std.int(x), Std.int(y)).x - Tile.w;
				} else {
					tile.x = getPos(Std.int(x), Std.int(y)).x + Tile.w;
				}
			}
			if (Math.abs(Math.sin(a)) > Math.abs(Math.cos(a)) - bothRange) {
				if (Math.sin(a) > 0) {
					tile.y = getPos(Std.int(x), Std.int(y)).y - Tile.h;
				} else {
					tile.y = getPos(Std.int(x), Std.int(y)).y + Tile.h;
				}
			}
		}
	}

	override public function update():Void {
		friction();
		input();
		// If we're going to hit something, get rid of our velocity.
		if (moveX(v.x) != null) {
			tile.x = getPos(Std.int(x), Std.int(y)).x;
		}
		if (moveY(v.y) != null) {
			tile.y = getPos(Std.int(x), Std.int(y)).y;
		}
		if (!tile.equals(getPos(Std.int(x + Tile.w / 2), Std.int(y + Tile.h / 2))) && vMusicCheck.equals(new Point())) {
			Music.playSound("Push Rock", -1, 0.5);
		}
		layering();
		death();
	}

	override public function render():Void {
		sprPushableBlockFire.frame = Game.worldFrame(sprPushableBlockFire.frameCount);
		super.render();
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		super.render();
		Draw.resetTarget();
	}
}
