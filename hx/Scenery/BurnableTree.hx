package scenery;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;

/**
 * ...
 * @author Time
 */
class BurnableTree extends Tree {
	private var imgBurnableTreeBurn:BitmapData;
	private var sprBurnableTreeBurn:Spritemap;

	private var tag:Int = 0;
	private var burn:Bool = false;

	private function load_image_assets():Void {
		imgBurnableTreeBurn = Assets.getBitmapData("assets/graphics/BurnableTreeBurn.png");
	}

	public function new(_x:Int, _y:Int, _tag:Int = -1) {
		load_image_assets();
		sprBurnableTreeBurn = new Spritemap(imgBurnableTreeBurn, 32, 32, burnEnd);
		super(_x, _y, false, sprBurnableTreeBurn);
		tag = _tag;
		active = true;
		type = "Solid"; // NOT a tree.  Done so it doesn't loop with the other trees.
		sprBurnableTreeBurn.centerOO();
		sprBurnableTreeBurn.add("burn", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 15);
	}

	override public function hit(t:String = ""):Void {
		if (t == "Fire" && !burn) {
			Music.playSound("Burn", 0);
			burn = true;
			sprBurnableTreeBurn.play("burn");
		}
	}

	public function burnEnd():Void {
		die();
	}

	override public function render():Void {
		graphic.render(new Point(x, y), FP.camera);
	}

	override public function removed():Void {
		super.removed();
		Game.setPersistence(tag, false);
		resetSurroundingTreeFrames();
	}

	override public function check():Void {
		super.check();
		if (tag >= 0 && !Game.checkPersistence(tag)) {
			die();
		}
	}

	public function die():Void {
		type = "";
		FP.world.remove(this);
	}

	override public function getFrame():Int {
		return 0;
	}

	public function resetSurroundingTreeFrames():Void {
		var trees:Array<Entity> = new Array<Entity>();
		var c:Entity;
		c = collide("Tree", x - 1, y);
		if (c != null) {
			trees.push(c);
		}
		c = collide("Tree", x + 1, y);
		if (c != null) {
			trees.push(c);
		}
		c = collide("Tree", x, y - 1);
		if (c != null) {
			trees.push(c);
		}
		c = collide("Tree", x, y + 1);
		if (c != null) {
			trees.push(c);
		}

		for (t in trees) {
			if (Std.is(t, Tree) && t != this) {
				(try cast(t, Tree) catch (e:Dynamic) null).frame = (try cast(t, Tree) catch (e:Dynamic) null).getFrame();
			}
		}
	}
}
