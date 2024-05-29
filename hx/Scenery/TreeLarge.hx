package scenery;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.masks.Pixelmask;
import net.flashpunk.utils.Draw;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class TreeLarge extends Entity {
	@:meta(Embed(source = "../../assets/graphics/TreeLargeMask.png"))
	private var imgTreeLargeMask:Class<Dynamic>;
	@:meta(Embed(source = "../../assets/graphics/TreeLarge.png"))
	private var imgTreeLarge:Class<Dynamic>;
	private var sprTreeLarge:Spritemap ;

	private static var shine:Array<Dynamic> = [0, 1, 2, 3, 2, 1];
	private static inline var phases:Int = 100;
	private static inline var loops:Int = 3;

	public function new(_x:Int, _y:Int) {
sprTreeLarge =  new Spritemap(imgTreeLarge, 160, 192);
		super(_x + 80, _y + 96, sprTreeLarge);
		sprTreeLarge.centerOO();
		mask = new Pixelmask(imgTreeLargeMask, -80, -96); //
		type = "Solid";
		layer = Std.int(-(y - originY + 138));
		active = false;
	}

	override public function render():Void {
		drawTree(1);

		var minAlpha:Float = 0.5;
		var maxAlpha:Float = 1;
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		// drawTree(minAlpha + (maxAlpha - minAlpha) * (Math.sin(Game.worldFrame(phases, loops) / phases * 2 * Math.PI + Math.PI) + 1) / 2);
		Draw.resetTarget();
	}

	public function drawTree(alpha:Float):Void {
		var frame:Float = Game.worldFrame(phases, loops) / phases * shine.length;
		sprTreeLarge.alpha = alpha;
		sprTreeLarge.frame = shine[Math.floor(frame)];
		super.render();
		sprTreeLarge.alpha = alpha * (frame - Math.floor(frame));
		sprTreeLarge.frame = shine[Math.ceil(frame) % shine.length];
		super.render();
	}
}
