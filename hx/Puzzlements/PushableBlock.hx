package puzzlements;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Input;
import net.flashpunk.utils.Key;
import net.flashpunk.FP;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class PushableBlock extends Mobile {
private var imgPushableBlock:BitmapData;
	private var sprPushableBlock:Spritemap;

	private var moveSpeed(default, never):Float = 0.5;
	private var cTile:Point;
	private var lTile:Point;
	private var tile:Point;

private function load_image_assets():Void {
imgPushableBlock = Assets.getBitmapData("assets/graphics/PushableBlock.png");
}
	public function new(_x:Int, _y:Int) {
load_image_assets();
		sprPushableBlock = new Spritemap(imgPushableBlock, 16, 16);
		super(_x, _y, sprPushableBlock);
		setHitbox(16, 16);
		type = "Solid";
		solids.push("Enemy", "Player");

		tile = new Point(Math.floor(x / Tile.w), Math.floor(y / Tile.h));
		cTile = tile;
		lTile = tile;
	}

	override public function input():Void {
		lTile = cTile;
		cTile = new Point(Math.ceil(x / Tile.w), Math.ceil(y / Tile.h));
		var c:Player = try cast(collide("Player", x - 1, y), Player) catch (e:Dynamic) null;
		if (c != null && c.v.x > 0) {
			tile.x = cTile.x + 1;
		}
		c = try cast(collide("Player", x + 1, y), Player) catch (e:Dynamic) null;
		if (c != null && c.v.x < 0) {
			tile.x = cTile.x - 1;
		}
		c = try cast(collide("Player", x, y - 1), Player) catch (e:Dynamic) null;
		if (c != null && c.v.y > 0) {
			tile.y = cTile.y + 1;
		}
		c = try cast(collide("Player", x, y + 1), Player) catch (e:Dynamic) null;
		if (c != null && c.v.y < 0) {
			tile.y = cTile.y - 1;
		}
		v.x = moveSpeed * FP.sign(tile.x - cTile.x);
		if (collideTypes(solids, gridPos(Std.int(x), Std.int(y)).x, gridPos(Std.int(x), Std.int(y)).y) == null) {
			if (v.x == 0) {
				x = (gridPos(Std.int(x), Std.int(y)).x);
			}
		}
		v.y = moveSpeed * FP.sign(tile.y - cTile.y);
		if (collideTypes(solids, gridPos(Std.int(x), Std.int(y)).x, gridPos(Std.int(x), Std.int(y)).y) == null) {
			if (v.y == 0) {
				y = (gridPos(Std.int(x), Std.int(y)).y);
			}
		}

		if (x == Math.floor(x / Tile.w) * Tile.w && y == Math.floor(y / Tile.h) * Tile.h)
			// cTile.x != lTile.x || cTile.y != lTile.y)
		{
			{
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
				if (v.length > 0 && collideTypes(solids, x + v.x, y + v.y) == null) {
					Music.playSound("Push Rock", -1, 0.5);
				}
			}
		}
	}

	public function gridPos(_x:Int, _y:Int):Point {
		return new Point(Math.floor(_x / Tile.w) * Tile.w, Math.floor(_y / Tile.h) * Tile.h);
	}

	override public function update():Void {
		friction();
		input();
		// If we're going to hit something, get rid of our velocity.
		if (moveX(v.x) != null) {
			tile.x = cTile.x;
		}
		if (moveY(v.y) != null) {
			tile.y = cTile.y;
		}
		layering();
		death();
	}

	override public function render():Void {
		sprPushableBlock.frame = Game.worldFrame(sprPushableBlock.frameCount);
		super.render();
	}
}
