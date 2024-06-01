package projectiles;
import openfl.utils.Assets;import openfl.display.BitmapData;

import enemies.Enemy;
import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;

/**
 * ...
 * @author Time
 */
class Arrow extends Mobile {
private var imgArrow:BitmapData;
	private var sprArrow:Image;

	private var hitables:Dynamic = ["Player", "Enemy", "Tree", "Solid", "Shield"];
	private var die:Bool = false;

private function load_image_assets():Void {
imgArrow = Assets.getBitmapData("assets/graphics/Arrow.png");
}
	public function new(_x:Int, _y:Int, _v:Point) {
load_image_assets();
		sprArrow = new Image(imgArrow);
		super(_x, _y, sprArrow);
		sprArrow.centerOO();
		v = _v;
		f = 0;
		setHitbox(4, 4, 2, 2);
		type = "Arrow";
		solids = [];
		if (v.length > 0) {
			sprArrow.angle = Math.atan2(-v.y, v.x) * 180 / Math.PI;
		}
	}

	override public function update():Void {
		super.update();
		if (v.length > 0) {
			sprArrow.angle = Math.atan2(-v.y, v.x) * 180 / Math.PI;
			var hits:Array<Entity> = new Array<Entity>();
			collideTypesInto(hitables, x, y, hits);
			for (i in 0...hits.length) {
				var _sw0_ = (hits[i].type);

				switch (_sw0_) {
					case "Player":
						(try cast(hits[i], Player) catch (e:Dynamic) null).hit(null, v.length, new Point(x, y));
					case "Enemy":
						(try cast(hits[i], Enemy) catch (e:Dynamic) null).hit(v.length, new Point(x, y));
					default:
				}
			}
			if (hits.length > 0) {
				Music.playSoundDistPlayer(Std.int(x), Std.int(y), "Arrow", 1);
				v.x = v.y = 0;
				die = true;
			}
		}
		if (die) {
			(try cast(graphic, Image) catch (e:Dynamic) null).alpha -= 0.1;
			if ((try cast(graphic, Image) catch (e:Dynamic) null).alpha <= 0) {
				FP.world.remove(this);
			}
		}
		if (x > FP.width || x < 0 || y < 0 || y > FP.height) {
			FP.world.remove(this);
		}
	}
}
