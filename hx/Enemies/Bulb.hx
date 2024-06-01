package enemies;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;
import scenery.Tile;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class Bulb extends Bob {
private var imgBulb:BitmapData;
	private var sprBulb:Spritemap;

private override function load_image_assets():Void {
imgBulb = Assets.getBitmapData("assets/graphics/Bulb.png");
}
	public function new(_x:Int, _y:Int) {

load_image_assets();
		sprBulb = new Spritemap(imgBulb, 16, 16, endAnim);
		super(_x, _y, sprBulb);

		sprBulb.centerOO();
		var animSpeed:Int = 8;
		sprBulb.add("walk", [0, 1, 2, 3, 4], animSpeed);
		sprBulb.add("drop", [5, 6, 7, 8, 9, 10, 11], animSpeed);
		sprBulb.add("die", [12, 13, 14, 15, 16, 17, 18], animSpeed);
		sprBulb.play("");
		setHitbox(12, 12, 6, 6);

		moveSpeed = 0.65;
		hitsMax = 1;
		sitFrames = [0, 3];
		hitsColor = normalColor;
	}

	override public function update():Void {
		if ((try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "drop"
			|| (try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "die") {
			var tile:Point = new Point((Math.floor(x / Tile.w) + 0.5) * Tile.w, (Math.floor(y / Tile.h) + 0.5) * Tile.h);
			v.x = tile.x - x;
			v.y = tile.y - y;
			v.normalize(Math.min(v.length, moveSpeed));
			mobileUpdate();
		} else {
			super.update();
			if (v.x >= moveSpeed / 2) {
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleX = Math.abs((try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleX);
			} else if (v.x <= -moveSpeed / 2) {
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleX = -Math.abs((try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleX);
			}
		}

		if (hits >= hitsMax && sprBulb.currentAnim != "drop" && sprBulb.currentAnim != "die") {
			sprBulb.play("drop");
			Music.playSound("Lava", 2);
		}
	}

	override public function startDeath(t:String = ""):Void {}

	override public function endAnim():Void {
		var _sw0_ = ((try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim);

		switch (_sw0_) {
			case "drop":
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("die");
				var tile:Tile = try cast(FP.world.collidePoint("Tile", x, y), Tile) catch (e:Dynamic) null;
				if (tile != null) {
					tile.t = 17;
				}
			case "die":
				FP.world.remove(this);
			default:
		}
	}

	override public function render():Void {
		super.render();
	}
}
