package projectiles;

import enemies.Enemy;
import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class TurretSpit extends Mobile {
	@:meta(Embed(source = "../../assets/graphics/TurretSpit.png"))
	private var imgTurretSpit:Class<Dynamic>;
	private var sprTurretSpit:Spritemap;

	public var hitables:Dynamic = ["Player", "Tree", "Solid", "Shield"];

	public function new(_x:Int, _y:Int, _v:Point) {
		sprTurretSpit = new Spritemap(imgTurretSpit, 12, 8);
		super(_x, _y, sprTurretSpit);
		sprTurretSpit.x = -8;
		sprTurretSpit.originX = Std.int(-sprTurretSpit.x);
		sprTurretSpit.y = -4;
		sprTurretSpit.originY = Std.int(-sprTurretSpit.y);
		v = _v;
		f = 0;
		setHitbox(4, 4, 2, 2);
		type = "TurretSpit";
		solids = [];
		if (v.length > 0) {
			sprTurretSpit.angle = Math.atan2(-v.y, v.x) * 180 / Math.PI;
		}
		Music.playSoundDistPlayer(Std.int(x), Std.int(y), "Turret Shoot");
	}

	override public function update():Void {
		super.update();
		if (v.length > 0) {
			imageAngle();
			var hits:Array<Entity> = new Array<Entity>();
			collideTypesInto(hitables, x, y, hits);
			for (i in 0...hits.length) {
				var _sw4_ = (hits[i].type);

				switch (_sw4_) {
					case "Player":
						(try cast(hits[i], Player) catch (e:Dynamic) null).hit(null, v.length, new Point(x, y));
					case "Enemy":
						(try cast(hits[i], Enemy) catch (e:Dynamic) null).hit(v.length, new Point(x, y));
					default:
				}
			}
			if (hits.length > 0) {
				FP.world.remove(this);
			}
		}
		if (!onScreen((try cast(graphic, Spritemap) catch (e:Dynamic) null).width)) {
			FP.world.remove(this);
		}
	}

	public function imageAngle():Void {
		(try cast(graphic, Image) catch (e:Dynamic) null).angle = Math.atan2(-v.y, v.x) * 180 / Math.PI;
	}

	override public function render():Void {
		super.render();
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		(try cast(graphic, Image) catch (e:Dynamic) null).alpha = 0.1;
		super.render();
		(try cast(graphic, Image) catch (e:Dynamic) null).alpha = 1;
		Draw.resetTarget();
	}
}
