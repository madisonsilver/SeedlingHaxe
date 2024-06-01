package puzzlements;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;
import scenery.Tile;
import projectiles.Arrow;

/**
 * ...
 * @author Time
 */
class ArrowTrap extends Activators {
private var imgArrowTrap:BitmapData;
	private var sprArrowTrap:Spritemap;

	private var shootTimer:Int = 0;
	private var shootTimerMax(default, never):Int = 10;
	private var shootDefault:Bool; // Whether it should default to shooting when not activated or vice versa

private function load_image_assets():Void {
imgArrowTrap = Assets.getBitmapData("assets/graphics/ArrowTrap.png");
}
	public function new(_x:Int, _y:Int, _t:Int = 0, _shoot:Bool = false) {
load_image_assets();
		sprArrowTrap = new Spritemap(imgArrowTrap, 16, 5);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + sprArrowTrap.height / 2), sprArrowTrap, _t);
		sprArrowTrap.centerOO();
		layer = Std.int(-(y - originY + height));
		shootDefault = _shoot;
	}

	override public function update():Void {
		if ((activate && !shootDefault) || (!activate && shootDefault)) {
			shoot();
		} else {
			shootTimer = 0;
		}
	}

	override public function render():Void {
		sprArrowTrap.frame = Game.worldFrame(sprArrowTrap.frameCount);
		super.render();
	}

	public function shoot():Void {
		if (shootTimer > 0) {
			shootTimer--;
		} else {
			Music.playSoundDistPlayer(Std.int(x), Std.int(y), "Arrow", 0);
			FP.world.add(new Arrow(Std.int(x - sprArrowTrap.width / 4), Std.int(y - 2), new Point(0, 5)));
			FP.world.add(new Arrow(Std.int(x), Std.int(y - 2), new Point(0, 5)));
			FP.world.add(new Arrow(Std.int(x + sprArrowTrap.width / 4), Std.int(y - 2), new Point(0, 5)));
			shootTimer = shootTimerMax;
		}
	}
}
