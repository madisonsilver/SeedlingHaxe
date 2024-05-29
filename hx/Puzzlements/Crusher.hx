package puzzlements;

import enemies.Enemy;
import enemies.IceTurret;
import openfl.geom.Point;
import net.flashpunk.Entity;
import scenery.Tile;
import net.flashpunk.FP;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class Crusher extends Activators {
	@:meta(Embed(source = "../../assets/graphics/Crusher.png"))
	private var imgCrusher:Class<Dynamic>;
	private var sprCrusher:Spritemap = new Spritemap(imgCrusher, 32, 32);

	private var hitables(default, never):Dynamic = ["Player", "Solid", "Enemy", "ShieldBoss"];
	private var solids(default, never):Dynamic = ["Solid"];
	private var intDist(default, never):Int = 64;
	private var speed(default, never):Int = 1; // The speed of the crusher when it moves.
	private var spinRate(default, never):Int = 8;

	/* Utility constant for collisions */
	private var directions(default, never):Array<Dynamic> = [new Point(1, 0), new Point(0, -1), new Point(-1, 0), new Point(0, 1)];

	private var v:Point = new Point();

	private var force:Int = 1;
	private var damage:Int = 1000; // KILL EVERYTHING

	public function new(_x:Int, _y:Int, _t:Int) {
		super(_x + Tile.w, _y + Tile.h, sprCrusher, _t);
		(try cast(graphic, Image) catch (e:Dynamic) null).centerOO();
		setHitbox(32, 32, 16, 16);
		type = "Solid";
	}

	override public function update():Void {
		super.update();
		if (activate || t == -1) {
			var roundedPos:Point = new Point(Math.round(x / Tile.w) * Tile.w, Math.round(y / Tile.h) * Tile.h);
			if (v.x == 0 && v.y == 0) {
				x = roundedPos.x;
				y = roundedPos.y;
				var p:Player = try cast(FP.world.nearestToEntity("Player", this), Player) catch (e:Dynamic) null;
				if (p != null) {
					var checkMovement:Bool = true;
					type = "BS";
					var c:Entity = FP.world.collideLine("Solid", Std.int(x), Std.int(y), Std.int(p.x), Std.int(p.y));
					type = "Solid";
					if (c == null) {
						for (i in 0...directions.length) {
							var offsetX:Int = as3hx.Compat.parseInt(-originX + intDist * ((directions[i].x < 0) ? directions[i].x : 0));
							var offsetY:Int = as3hx.Compat.parseInt(-originY + intDist * ((directions[i].y < 0) ? directions[i].y : 0));
							var w:Int = as3hx.Compat.parseInt(width + intDist * Math.abs(directions[i].x));
							var h:Int = as3hx.Compat.parseInt(height + intDist * Math.abs(directions[i].y));
							if (FP.world.collideRect("Player", x + offsetX, y + offsetY, w, h) != null) {
								v.x = directions[i].x * speed;
								v.y = directions[i].y * speed;
							}
						}
					}
				}
			} else if (Music.soundPercentage("Other", 4) >= 0.1 || !Music.soundIsPlaying("Other", 4)) {
				Music.playSoundDistPlayer(Std.int(x), Std.int(y), "Other", 4, 120, 0.5);
			}
			moveX(v.x);
			moveY(v.y);
			hit();
		}
	}

	public function hit():Void {
		var v:Array<Entity> = new Array<Entity>();
		for (i in 0...hitables.length) {
			collideInto(Reflect.field(hitables, Std.string(i)), x, y, v);
		}
		for (c in v) {
			if (Std.is(c, Player)) {
				(try cast(c, Player) catch (e:Dynamic) null).hit(null, force, new Point(x, y), damage);
			} else if (Std.is(c, Enemy)) {
				(try cast(c, Enemy) catch (e:Dynamic) null).hit(force, new Point(x, y), damage, "Crusher");
			}
		}
	}

	override public function render():Void {
		(try cast(graphic, Image) catch (e:Dynamic) null).angle += (v.length > 0) ? spinRate : 0;
		if (v.length == 0) {
			(try cast(graphic, Image) catch (e:Dynamic) null).angle = 0;
		}
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		super.render();
		for (i in 0...directions.length) {
			var offsetX:Int = as3hx.Compat.parseInt(-originX + intDist * ((directions[i].x < 0) ? directions[i].x : 0));
			var offsetY:Int = as3hx.Compat.parseInt(-originY + intDist * ((directions[i].y < 0) ? directions[i].y : 0));
			var w:Int = as3hx.Compat.parseInt(width + intDist * Math.abs(directions[i].x));
			var h:Int = as3hx.Compat.parseInt(height + intDist * Math.abs(directions[i].y));
			Draw.rect(Std.int(x + offsetX), Std.int(y + offsetY), w, h);
		}
		Draw.resetTarget();
		super.render();
	}

	public function moveX(_xrel:Float):Entity // returns the object that is hit
	{
		var i : Int = 0;
		while (i < Math.abs(_xrel)) {
			var c:Entity = collideTypes(solids, x + Math.min(1, Math.abs(_xrel) - i) * FP.sign(_xrel), y);
			if (c == null) {
				x += Math.min(1, Math.abs(_xrel) - i) * FP.sign(_xrel);
			} else {
				v.x = 0;
				return c;
			}
			i += 1;
		}
		return null;
	}

	public function moveY(_yrel:Float):Entity // returns the object that is hit
	{
		var i: Int = 0;
		while (i < Math.abs(_yrel)) {
			var c:Entity = collideTypes(solids, x, y + Math.min(1, Math.abs(_yrel) - i) * FP.sign(_yrel));
			if (c == null) {
				y += Math.min(1, Math.abs(_yrel) - i) * FP.sign(_yrel);
			} else {
				v.y = 0;
				return c;
			}
			i+= 1;
		}
		return null;
	}
}
