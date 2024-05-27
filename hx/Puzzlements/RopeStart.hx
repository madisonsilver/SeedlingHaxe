package puzzlements;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class RopeStart extends Activators {
	@:meta(Embed(source = "../../assets/graphics/RopePulley.png"))
	private var imgRope:Class<Dynamic>;
	private var sprRope:Spritemap = new Spritemap(imgRope, 16, 16);

	private var tag:Int;
	private var xend:Int;

	public function new(_x:Int, _y:Int, _xend:Int, _t:Int, _tag:Int = -1) {
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprRope, _t);
		sprRope.centerOO();
		xend = as3hx.Compat.parseInt(_xend + Tile.w / 2);
		type = "Rope";
		setHitbox(_xend - _x + 16, 16, 8, 8);
		layer = Std.int(-(y - originY + height / 2));
		tag = _tag;
	}

	override public function check():Void {
		super.check();
		if (tag >= 0 && !Game.checkPersistence(tag)) {
			hit();
		}
	}

	public function hit():Void {
		if (!activate) {
			setHitbox(16, 16, 8, 8);
			activate = true;
			Game.setPersistence(tag, false);
			Music.playSound("Other", 3);
		}
	}

	override public function render():Void {
		if (!activate)
			// Rope part
		{
			sprRope.frame = 1;
			var i:Int = 0;
			while (i < xend - x) {
				sprRope.render(new Point(x + i, y), FP.camera);
				i += sprRope.width;
			}
			// Pulley part
			sprRope.frame = 0;
			sprRope.render(new Point(x, y), FP.camera);
			// Handle part
			sprRope.frame = 2;
			sprRope.render(new Point(xend, y), FP.camera);
		}
		// Pulley part
		else {
			sprRope.frame = 0;
			sprRope.render(new Point(x, y), FP.camera);
			// Handle part
			sprRope.frame = 3;
			sprRope.render(new Point(xend, y), FP.camera);
		}
	}

	override private function set_activate(a:Bool):Bool {
		_active = a;
		var v:Array<Activators> = new Array<Activators>();
		FP.world.getClass(Activators, v);
		for (i in 0...v.length) {
			if (v[i] != this && v[i].t == t) {
				v[i].activate = activate;
			}
		}
		return a;
	}
}
