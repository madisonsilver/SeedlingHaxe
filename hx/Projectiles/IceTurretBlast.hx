package projectiles;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import enemies.Enemy;
import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;

/**
 * ...
 * @author Time
 */
class IceTurretBlast extends Mobile {
	private var imgIceBlast:BitmapData;
	private var sprIceBlast:Spritemap;

	private var hitables:Dynamic = ["Player", "Tree", "Solid", "Shield"];
	private var freezeTime(default, never):Int = 15;

	private function load_image_assets():Void {
		imgIceBlast = Assets.getBitmapData("assets/graphics/IceBlast.png");
	}

	public function new(_x:Int, _y:Int, _v:Point) {
		load_image_assets();
		sprIceBlast = new Spritemap(imgIceBlast, 16, 7);
		super(_x, _y, sprIceBlast);
		sprIceBlast.x = -8;
		sprIceBlast.originX = Std.int(-sprIceBlast.x);
		sprIceBlast.y = -4;
		sprIceBlast.originY = Std.int(-sprIceBlast.y);
		v = _v;
		f = 0;
		setHitbox(4, 4, 2, 2);
		type = "IceBlast";
		solids = [];
		if (v.length > 0) {
			sprIceBlast.angle = Math.atan2(-v.y, v.x) * 180 / Math.PI;
		}
		Music.playSoundDistPlayer(Std.int(x), Std.int(y), "Other", 2, 200, 0.4);
	}

	override public function update():Void {
		super.update();
		if (v.length > 0) {
			sprIceBlast.angle = Math.atan2(-v.y, v.x) * 180 / Math.PI;
			var hits:Array<Entity> = new Array<Entity>();
			collideTypesInto(hitables, x, y, hits);
			for (i in 0...hits.length) {
				var _sw2_ = (hits[i].type);

				switch (_sw2_) {
					case "Player":
						(try cast(hits[i], Player) catch (e:Dynamic) null).freeze(freezeTime);
						(try cast(hits[i], Player) catch (e:Dynamic) null).hit(null, 0, new Point(x, y));
					case "Enemy":
						(try cast(hits[i], Enemy) catch (e:Dynamic) null).hit(0, new Point(x, y));
					default:
				}
			}
			if (hits.length > 0) {
				FP.world.remove(this);
			}
		}
	}
}
