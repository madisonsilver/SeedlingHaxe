package puzzlements;
import openfl.utils.Assets;import openfl.display.BitmapData;

import enemies.Enemy;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import net.flashpunk.utils.Draw;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class LavaChain extends Entity {
private var imgLavaChain:BitmapData;
	private var sprLavaChain:Spritemap;

	private static var hitables:Dynamic = ["Player", "Enemy"];
	private static inline var force:Int = 5;
	private static inline var damage:Int = 1;

	private var loops(default, never):Int = 2;
	private var direction:Int;

private function load_image_assets():Void {
imgLavaChain = Assets.getBitmapData("assets/graphics/LavaChain.png");
}
	public function new(_x:Int, _y:Int, _d:Int) {

load_image_assets();
		sprLavaChain = new Spritemap(imgLavaChain, 64, 16, animEnd);
		super(_x + Tile.w / 2, _y + Tile.h / 2, sprLavaChain);

		direction = _d;

		sprLavaChain.originX = 8;
		sprLavaChain.originY = 8;
		sprLavaChain.x = -sprLavaChain.originX;
		sprLavaChain.y = -sprLavaChain.originY;

		sprLavaChain.add("sit", [0]);
		sprLavaChain.add("extend", [1, 2], 15);
		sprLavaChain.add("hit", [3, 4, 5, 5, 5, 5, 4, 3], 15);
		sprLavaChain.add("retract", [6, 7, 8, 9, 10, 11, 12], 25);

		type = "Solid";
		setHitbox(16, 16, 8, 8);
		layer = Std.int(-(y - originY + height));
	}

	override public function update():Void {
		super.update();
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).angle = 90 * direction;
		if (Game.worldFrame(Main.FPS, loops) == 0) {
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("extend");
		}
		if ((try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "hit"
			|| (try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "extend") {
			reach();
		}
	}

	override public function render():Void {
		super.render();

		if ((try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "hit") {
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
	}

	public function reach():Void {
		var rect:Rectangle = getRect(direction);
		for (i in 0...hitables.length) {
			var hit:Entity = FP.world.collideRect(Reflect.field(hitables, Std.string(i)), rect.x, rect.y, rect.width, rect.height);
			if (hit != null) {
				var hitPos:Point = getHitPos(new Point(hit.x, hit.y), direction);
				if (Std.is(hit, Enemy)) {
					(try cast(hit, Enemy) catch (e:Dynamic) null).hit(force, hitPos, damage, "LavaChain");
				} else if (Std.is(hit, Player)) {
					(try cast(hit, Player) catch (e:Dynamic) null).hit(null, force, hitPos, damage);
				}
			}
		}
	}

	public function getRect(_d:Int):Rectangle {
		var w:Int = as3hx.Compat.parseInt((try cast(graphic, Image) catch (e:Dynamic) null).width - Tile.w);
		var h:Int = 4;
		var rect:Rectangle;
		switch (_d) {
			case 0:
				rect = new Rectangle(x - originX + width, y - originY + height / 2 - h / 2, w, h);
			case 1:
				rect = new Rectangle(x - originX + width / 2 - h / 2, y - originY - w, h, w);
			case 2:
				rect = new Rectangle(x - originX - w, y - originY + height / 2 - h / 2, w, h);
			case 3:
				rect = new Rectangle(x - originX + width / 2 - h / 2, y - originY + height, h, w);
			default:
				rect = new Rectangle();
		}
		return rect;
	}

	public function getHitPos(_p:Point, _d:Int):Point {
		var pos:Point;
		/*switch(_d)
			{
				case 0:
				case 2:
					pos = new Point(_p.x, y); break;
				case 1:
				case 3:
					pos = new Point(x, _p.y); break;
				default:
					pos = new Point;
		}*/
		pos = new Point(x, y);
		return pos;
	}

	public function animEnd():Void {
		var g:Spritemap = try cast(graphic, Spritemap) catch (e:Dynamic) null;
		var _sw0_ = (g.currentAnim);

		switch (_sw0_) {
			case "extend":
				g.play("hit");
			case "hit":
				g.play("retract");
			case "retract":
				g.play("sit");
			default:
		}
	}
}
