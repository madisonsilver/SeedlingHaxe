package scenery;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Draw;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class Orb extends Entity {
	@:meta(Embed(source = "../../assets/graphics/Orb.png"))
	private var imgOrb:Class<Dynamic>;
	private var sprOrb:Spritemap;

	private var radiusMax:Int = 48;
	private var radiusMin:Int = 40;
	private var alpha:Float = 0.2;
	private var color:Int;

	private var startX:Int;
	private var startY:Int;

	private var moveRadius(default, never):Int = 5;
	private var phases(default, never):Int = 100;
	private var loops(default, never):Int = 4;
	private var randVal(default, never):Float = Math.random();
	private var myLight:Light;

	public function new(_x:Int, _y:Int, _c:Int = 0xFFFFFF) {
		sprOrb = new Spritemap(imgOrb, 8, 8);
		super(_x, _y, sprOrb);
		startX = Std.int(x);
		startY = Std.int(y);

		color = _c;
		layer = Std.int(-(y - sprOrb.originY + sprOrb.height + Tile.h / 2));

		sprOrb.centerOO();
		sprOrb.color = color;

		FP.world.add(myLight = new Light(Std.int(x), Std.int(y), 60, 2, color, true, radiusMin, radiusMax, alpha));
	}

	override public function update():Void {
		super.update();

		x = startX + moveRadius * Math.sin((Game.worldFrame(phases, loops) / (phases - 1) + randVal) * 4 * Math.PI);
		y = startY + moveRadius * Math.sin((Game.worldFrame(phases, loops) / (phases - 1) + randVal) * 2 * Math.PI);

		if (myLight != null) {
			myLight.x = x;
			myLight.y = y;
		}
	}

	override public function render():Void {
		sprOrb.frame = Game.worldFrame(sprOrb.frameCount, loops);
		super.render();
	}
}
