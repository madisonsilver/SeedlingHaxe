package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class PlantTorch extends Entity {
private var imgPlantTorch:BitmapData;
	private var sprPlantTorch:Spritemap;

	private var frames(default, never):Array<Dynamic> = [0, 1, 2, 1];
	private var loops(default, never):Float = 1;
	private var myLight:Light;

	private var distance:Int; // The maximal distance that any light is shown to the player

	// (This light turns off when the player gets far away)

private function load_image_assets():Void {
imgPlantTorch = Assets.getBitmapData("assets/graphics/PlantTorch.png");
}
	public function new(_x:Int, _y:Int, _color:Int = 0xFFFFFF, _flipped:Bool = false, _distance:Int = 100) {

load_image_assets();
		sprPlantTorch = new Spritemap(imgPlantTorch, 16, 16);
		super(_x + Tile.w / 2, _y + Tile.h / 2, sprPlantTorch);
		sprPlantTorch.originX = 8;
		sprPlantTorch.originY = 8;
		sprPlantTorch.x = -sprPlantTorch.originX;
		sprPlantTorch.y = -sprPlantTorch.originY;

		distance = _distance;

		setHitbox(16, 16, 8, 8);
		type = "Solid";

		if (_flipped) {
			sprPlantTorch.scaleX = -Math.abs(sprPlantTorch.scaleX);
		}

		var lightOffset:Point = new Point(0, -5);
		FP.world.add(myLight = new Light(Std.int(x + lightOffset.x * sprPlantTorch.scaleX), Std.int(y + lightOffset.y), 100, Std.int(loops), _color, true));
	}

	override public function render():Void {
		var p:Player = try cast(FP.world.nearestToEntity("Player", this), Player) catch (e:Dynamic) null;
		if (myLight != null && p != null) {
			myLight.alpha = 0.2 * Math.pow(Math.max(1 - FP.distance(x, y, p.x, p.y) / distance, 0), 2);
		}
		sprPlantTorch.frame = frames[Game.worldFrame(frames.length, loops)];
		super.render();
	}
}
