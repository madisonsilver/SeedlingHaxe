package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class RockFall extends Mobile {
private var imgRockFall:BitmapData;
	private var sprRockFall:Spritemap;

	private var fallHeight(default, never):Int = 96;
	private var g:Float = 0.05;
	private var force(default, never):Int = 3;
	private var damage(default, never):Int = 1;
	private var angleRate:Int = 5;
	private var goto:Int;
	private var startingSpeed:Float = 6;

private function load_image_assets():Void {
imgRockFall = Assets.getBitmapData("assets/graphics/RockFall.png");
}
	public function new(_x:Int, _y:Int) {
load_image_assets();
		sprRockFall = new Spritemap(imgRockFall, 64, 32, endAnim);
		super(_x, _y - fallHeight, sprRockFall);
		goto = _y;

		angleRate *= Std.int(FP.choose([1, -1]));

		sprRockFall.centerOO();
		sprRockFall.scale = Math.random() / 2 + 0.25;
		sprRockFall.scaleX = FP.choose([1, -1]);
		sprRockFall.add("break", [0, 1, 2, 3, 4, 5, 6, 7], 15);

		setHitbox(Std.int(32 * sprRockFall.scale), Std.int(16 * sprRockFall.scale));
		setHitbox(width, height, Std.int(width / 2), Std.int(-sprRockFall.scale * sprRockFall.height / 2 + height));

		v.y = startingSpeed;
		f = 0;

		type = "";
	}

	override public function added():Void {
		super.added();
		solids = []; // "Enemy", "Pod", "Solid"];
		if (collideTypes(solids, x, y) != null) {
			active = false;
			visible = false;
			FP.world.remove(this);
		}
		solids = [];
	}

	override public function update():Void {
		v.y += g;
		super.update();

		if (y > goto) {
			v.y = 0;
			g = 0;
			y = goto;
			Game.shake += sprRockFall.scale + 1;
			var p:Player = try cast(collide("Player", x, y), Player) catch (e:Dynamic) null;
			if (p != null) {
				p.hit(null, force, new Point(x, y), damage);
			}
			sprRockFall.play("break");
			Music.playSound("Rock", 0);
		}
	}

	override public function layering():Void {
		layer = -goto;
	}

	override public function render():Void // Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
	{
		var m:Int = 4;
		Draw.rect(Std.int(x - originX + m), Std.int(goto - 1 - m / 2 + height * 2 / 3), width - m * 2, Std.int(height / 2 + m), 0x000000, 0.5);
		Draw.rect(Std.int(x - originX), Std.int(goto - 1 + height * 2 / 3), width, Std.int(height / 2), 0x000000, 0.5);
		// Draw.resetTarget();
		if (!Game.freezeObjects) {
			if (sprRockFall.currentAnim == "break") {
				sprRockFall.alpha = 1;
				sprRockFall.angle = 0;
			} else {
				sprRockFall.angle += angleRate;
				sprRockFall.alpha = Math.min(1, 1 - (goto - y) / fallHeight);
			}
		}
		super.render();
	}

	public function endAnim():Void {
		FP.world.remove(this);
	}
}
