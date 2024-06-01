package puzzlements;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class BeamTower extends Entity {
	@:meta(Embed(source = "../../assets/graphics/BeamTower.png"))
	private var imgBeamTower:Class<Dynamic>;
	private var sprBeamTower:Spritemap;

	private var direction:Int;
	private var rate:Float;

	private var force(default, never):Int = 5;
	private var damage(default, never):Int = 1;

	private var playedSound:Bool = false;

	public function new(_x:Int, _y:Int, _startdirection:Int = 0, _rate:Float = 1, speed:Float = 1) {
		sprBeamTower = new Spritemap(imgBeamTower, 16, 40, animEnd);
		super(_x + 8, _y + 16, sprBeamTower);

		sprBeamTower.originX = 8;
		sprBeamTower.originY = 32;
		sprBeamTower.x = -sprBeamTower.originX;
		sprBeamTower.y = -sprBeamTower.originY;

		var animSpeed:Int = as3hx.Compat.parseInt(10 * speed);
		sprBeamTower.add("right", [1, 2], animSpeed);
		sprBeamTower.add("up", [3, 4], animSpeed);
		sprBeamTower.add("left", [5, 6], animSpeed);
		sprBeamTower.add("down", [7, 8], animSpeed);
		sprBeamTower.add("sit", [0, 0], animSpeed);
		sprBeamTower.play("right");

		setHitbox(16, 32, 8, 24);
		type = "Solid";

		direction = _startdirection;
		rate = _rate;

		layer = Std.int(-y);
	}

	override public function update():Void {
		if (Game.freezeObjects) {
			return;
		}
		super.update();
		if ((sprBeamTower.frame - 1) % 2 == 1)
			// Beaming
		{
			{
				if (!playedSound) {
					var p:Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch (e:Dynamic) null;
					var xT:Int = Std.int(x);
					var yT:Int = Std.int(y);
					if (p != null) {
						if (direction == 0) {
							xT = Std.int(Math.max(p.x, x));
						} else if (direction == 1) {
							yT = Std.int(Math.min(p.y, y));
						} else if (direction == 2) {
							xT = Std.int(Math.min(p.x, x));
						} else if (direction == 3) {
							yT = Std.int(Math.max(p.y, y));
						}
					}
					Music.playSoundDistPlayer(xT, yT, "Energy Beam");
					playedSound = true;
				}
				var rect:Rectangle = getRect(direction);
				var p:Player = try cast(FP.world.collideRect("Player", rect.x, rect.y, rect.width, rect.height), Player) catch (e:Dynamic) null;
				if (p != null) {
					p.hit(null, force, new Point(x, y), damage);
					Game.shake = 15;
				}
			}
		} else {
			playedSound = false;
		}

		var radius:Float = 0.3;
		var phases:Int = 100;
		var loops:Float = 2;
		y += radius * Math.sin(Game.worldFrame(phases, loops) / phases * 2 * Math.PI);
	}

	override public function render():Void {
		var a:Float = 0;
		if (sprBeamTower.currentAnim != "sit") {
			a = ((sprBeamTower.frame - 1) % 2 == 0) ? 0.1 : 1;
		}

		if (a > 0 && direction == 1) {
			drawLine(direction, a);
		}
		super.render();
		if (a > 0 && direction != 1) {
			drawLine(direction, a);
		}
	}

	private function drawLine(d:Int, a:Float):Void {
		if (Game.freezeObjects) {
			return;
		}
		var line:Array<Point> = new Array<Point>();
		var n:Int = ((d == 0 || d == 2)) ? 5 : 4;
		for (i in 0...n) {
			line = getLine(d, i);
			Draw.linePlus(Std.int(line[0].x), Std.int(line[0].y), Std.int(line[1].x), Std.int(line[1].y), ((i <= 0 || i >= n - 1)) ? 0xFF0000 : 0xFFFF00, a);
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			Draw.linePlus(Std.int(line[0].x), Std.int(line[0].y), Std.int(line[1].x), Std.int(line[1].y), ((i <= 0 || i >= n - 1)) ? 0xFF0000 : 0xFFFF00, a);
			Draw.resetTarget();
		}
	}

	private function getRect(d:Int):Rectangle {
		var line:Array<Array<Point>> = new Array<Array<Point>>();
		line.push(getLine(direction, 0));
		line.push(getLine(direction, 4));
		return new Rectangle(Math.min(line[0][0].x, line[1][1].x), Math.min(line[0][0].y, line[1][1].y), Math.abs(line[1][1].x - line[0][0].x),
			Math.abs(line[1][1].y - line[0][0].y));
	}

	/**
	 * Gets the line in a direction
	 * @param	d	The direction (0 = right, 1 = up, 2 = left, 3 = down)
	 * @param	n	Which line it is of the thickness of the laser
	 * return	Vector of two points where the first is the start point, and the second is the end point.
	 */
	private function getLine(d:Int, n:Int):Array<Point> {
		var line:Array<Point> = new Array<Point>();
		var from:Point = new Point(x, y - 8);
		var to:Point = new Point();
		switch (d) {
			case 0:
				from.x += 6;
				from.y -= 11 - n;
				to = new Point(FP.width, from.y);
			case 1:
				from.x -= 2 - n;
				from.y -= 11;
				to = new Point(from.x, 0);
			case 2:
				from.x -= 6;
				from.y -= 11 - n;
				to = new Point(0, from.y);
			case 3:
				from.x -= 2 - n;
				from.y -= 5;
				to = new Point(from.x, FP.height);
			default:
				to = from.clone();
		}
		line.push(from);
		line.push(to);

		return line;
	}

	public function animEnd():Void {
		if (sprBeamTower.currentAnim == "sit") {
			direction = as3hx.Compat.parseInt((direction + rate + 4) % 4);
			sprBeamTower.play(getAnimation(direction));
		} else {
			sprBeamTower.play("sit");
		}
	}

	private function getAnimation(d:Int):String {
		switch (d) {
			case 0:
				return "right";
			case 1:
				return "up";
			case 2:
				return "left";
			case 3:
				return "down";
			default:
				return "";
		}
	}
}
