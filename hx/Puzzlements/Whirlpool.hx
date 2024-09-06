package puzzlements;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class Whirlpool extends Entity {
	private var imgWhirlpool:BitmapData;
	private var sprWhirlpool:Spritemap;

	private var whirlFrames(default, never):Array<Dynamic> = [0, 1, 2, 1, 0, 1, 2, 1, 0, 1, 2, 1, 0, 1, 2, 1];
	private var spinRate:Int = 20;
	private var deathCount:Int = 0;

	private var timerSetGrow(default, never):Int = 150;
	private var timerSetLive(default, never):Int = 60;
	private var timerSetDies(default, never):Int = 30;
	private var timerSet:Int = 0;
	private var useTimer:Bool;

	private var maxAlpha(default, never):Float = 0.5;

	private function load_image_assets():Void {
		imgWhirlpool = Assets.getBitmapData("assets/graphics/Whirlpool.png");
	}

	public function new(_x:Int, _y:Int, _timer:Bool = false) {
		load_image_assets();
		sprWhirlpool = new Spritemap(imgWhirlpool, 32, 32);
		timerSet = timerSetGrow + timerSetLive + timerSetDies;
		super(_x + Tile.w, _y + Tile.h, sprWhirlpool);

		useTimer = _timer;

		sprWhirlpool.centerOO();
		sprWhirlpool.angle = Math.random() * 360;
		sprWhirlpool.alpha = maxAlpha;
		setHitbox(sprWhirlpool.width, sprWhirlpool.height, sprWhirlpool.originX, sprWhirlpool.originY);

		update();
	}

	override public function update():Void {
		if (timerSet > 0 && useTimer) {
			timerSet--;
		}

		if (timerSet >= timerSetLive + timerSetDies && useTimer)
			// During the growth portion
		{
			{
				sprWhirlpool.scale = 1 - (timerSet - timerSetLive - timerSetDies) / timerSetGrow;
				sprWhirlpool.alpha = maxAlpha * (1 - (timerSet - timerSetLive - timerSetDies) / timerSetGrow);
			}
		} else if (timerSet >= timerSetDies || !useTimer)
			// During the life portion
		{
			{
				sprWhirlpool.scale = 1;
				sprWhirlpool.alpha = maxAlpha;

				var player:Player = try cast(collide("Player", x, y), Player) catch (e:Dynamic) null;
				if (player != null
					&& FP.distance(x, y, player.x,
						player.y) < ((try cast(graphic, Image) catch (e:Dynamic) null).width - (try cast(graphic, Image) catch (e:Dynamic) null)
							.originX) * (try cast(graphic, Image) catch (e:Dynamic) null).scale) {
					var a:Float = Math.atan2(player.y - y, player.x - x);
					var r:Int = Std.int(FP.distance(x, y, player.x, player.y));
					player.x -= r * Math.cos(a);
					player.y -= r * Math.sin(a);
					r *= Std.int(0.999);
					a -= spinRate / 180 * Math.PI;
					player.x += r * Math.cos(a);
					player.y += r * Math.sin(a);

					if (r <= 1) {
						if (deathCount > 0) {
							deathCount--;
						} else {
							player.drown();
						}
					}
				}
			}
		} else if (timerSet > 0)
			// During the death portion
		{
			{
				sprWhirlpool.scale = timerSet / timerSetDies;
				sprWhirlpool.alpha = maxAlpha * timerSet / timerSetDies;
			}
		} else {
			FP.world.remove(this);
			return;
		}
		super.update();
	}

	override public function render():Void {
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).frame = whirlFrames[Game.worldFrame(whirlFrames.length)];
		(try cast(graphic, Image) catch (e:Dynamic) null).angle += spinRate;
		super.render();
	}
}
