package scenery;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class BoneTorch extends Entity {
	@:meta(Embed(source = "../../assets/graphics/BoneTorch.png"))
	private var imgBoneTorch:Class<Dynamic>;
	@:meta(Embed(source = "../../assets/graphics/BoneTorch2.png"))
	private var imgBoneTorch2:Class<Dynamic>;
	private var sprBoneTorch:Spritemap;

	private var frames(default, never):Array<Dynamic> = [0, 1, 2, 1];
	private var loops(default, never):Int = 2;

	public function new(_x:Int, _y:Int, _type:Int = 0, _color:Int = 0xFFFFFF, _flipped:Bool = false) {
		var lightOffset:Point = new Point();
		switch (_type) {
			case 0:
				sprBoneTorch = new Spritemap(imgBoneTorch, 16, 24);
				lightOffset = new Point();
			default:
				sprBoneTorch = new Spritemap(imgBoneTorch2, 16, 24);
				lightOffset = new Point(-1, -11);
		}
		super(_x + Tile.w / 2, _y + Tile.h / 2, sprBoneTorch);
		sprBoneTorch.originX = 8;
		sprBoneTorch.originY = 16;
		sprBoneTorch.x = -sprBoneTorch.originX;
		sprBoneTorch.y = -sprBoneTorch.originY;

		setHitbox(16, 16, 8, 8);
		type = "Solid";

		if (_flipped) {
			sprBoneTorch.scaleX = -Math.abs(sprBoneTorch.scaleX);
		}
		FP.world.add(new Light(Std.int(x + lightOffset.x * sprBoneTorch.scaleX), Std.int(y + lightOffset.y), frames.length, loops, _color, false));

		layer = Std.int(-(y - originY + height));
	}

	override public function render():Void {
		sprBoneTorch.frame = frames[Game.worldFrame(frames.length, loops)];
		super.render();
	}
}
