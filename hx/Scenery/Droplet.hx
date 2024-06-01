package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class Droplet extends Entity {
	private var g(default, never):Float = 0.1;
	private var frameRate(default, never):Float = 0.6;
	private var maxDist(default, never):Int = 80;

	private var startY:Int;
	private var endY:Int;
	private var v:Point = new Point();
	private var frame:Float = 0;
	private var color:Int;

	private var player:Player;

	public function new(_x:Int, _y:Int, _height:Int, _color:Int) {

		super(_x, _y - _height);
		startY = Std.int(y);
		endY = _y;
		layer = -startY;

		color = _color;

		v.y = 1;
	}

	override public function added():Void {
		super.added();
		var checkW:Int = 6;
		var tileHit:Tile = try cast(FP.world.collideRect("Tile", x - checkW / 2, endY, checkW, 1), Tile) catch (e:Dynamic) null;
		if (FP.world.collideRect("Solid", x - checkW / 2, endY, checkW, 1) != null
			|| (tileHit != null && tileHit.t == 6 /* PIT */) != null || tileHit == null) {
			FP.world.remove(this);
		} else {
			var tileHitTemp:Tile;
			while (true) {
				if (tileHit != null && (tileHit.t == 9 || tileHit.t == 10 || tileHit.t == 13 || tileHit.t == 25))
					// Cliff, Stairs, Cave, Waterfall (vertical parts)
				{
					{
						endY += Tile.h;
					}
				} else if (tileHit != null && (tileHit.t == 6 /* Pit */)) {
					FP.world.remove(this);
					break;
				} else {
					break;
				}
				tileHit = try cast(FP.world.collideRect("Tile", x - checkW / 2, endY, checkW, 1), Tile) catch (e:Dynamic) null;
			}
		}
	}

	override public function update():Void {
		v.y += g;

		x += v.x;
		y += v.y;

		if (y >= endY) {
			y = endY;
			frame += frameRate;
			if (frame >= Game.sprDroplet.frameCount) {
				FP.world.remove(this);
			}
		}

		player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch (e:Dynamic) null;
	}

	override public function render():Void {
		Game.sprDroplet.alpha = (y - startY) / (endY - startY);
		if (player != null) {
			Game.sprDroplet.alpha *= Math.max(1 - FP.distance(x, y, player.x, player.y) / maxDist, 0);
		}
		Game.sprDroplet.frame = Std.int(frame);
		Game.sprDroplet.color = color;
		Game.sprDroplet.render(new Point(x, y), FP.camera);

		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		Game.sprDroplet.render(new Point(x, y), FP.camera);
		Draw.resetTarget();
	}
}
