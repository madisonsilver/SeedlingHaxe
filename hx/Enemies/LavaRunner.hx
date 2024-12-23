package enemies;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;
import scenery.Tile;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class LavaRunner extends Bob {
	private var imgLavaRunner:BitmapData;
	private var sprLavaRunner:Spritemap;

	private static inline var waterFrameAddition:Int = 5;
	private static inline var swimSpeed:Float = 1;
	private static inline var normalSpeed:Float = 1.5;

	private var jumpV:Float = 0;
	private var g(default, never):Float = 0.2;
	private var angleSpin:Int = 10;
	private var startY:Int = 0;
	private var inAir:Bool = false;

	private override function load_image_assets():Void {
		super.load_image_assets();
		imgLavaRunner = Assets.getBitmapData("assets/graphics/LavaRunner.png");
	}

	public function new(_x:Int, _y:Int) {
		load_image_assets();
		sprLavaRunner = new Spritemap(imgLavaRunner, 20, 20, endAnim);
		super(_x, _y, sprLavaRunner);
		startY = Std.int(y);

		sprLavaRunner.centerOO();
		sprLavaRunner.add("walk", [0, 2, 3, 4], 15);
		sprLavaRunner.add("swim", [5, 7, 8, 9], 15);
		sprLavaRunner.add("die", [10, 11, 12, 13, 14, 15, 16, 17, 18], 15);
		sprLavaRunner.play("");
		setHitbox(12, 12, 6, 6);

		dieInLava = false;

		moveSpeed = normalSpeed;
		hitsMax = 2;

		solids.push("LavaBoss");
		solids.push("Enemy");
	}

	override public function update():Void {
		if (Game.freezeObjects) {
			return;
		}
		if (destroy || (try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "die") {
			super.update();
			return;
		}
		if (inAir) {
			collidable = false;
			jumpV += g;
			v.x = 0;
			v.y = jumpV;
			walk();
			sprLavaRunner.angle += angleSpin;
			mobileUpdate();
			if (y >= startY) {
				inAir = false;
			}
			layer = -(startY - originY + height + 6);
		} else {
			sprLavaRunner.angle = 0;
			collidable = true;
			super.update();
			if (v.x > moveSpeed / 2) {
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleX = Math.abs((try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleX);
			} else if (v.x < -moveSpeed / 2) {
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleX = -Math.abs((try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleX);
			}

			switch (getState()) {
				case 1:
					swim();
				case 17:
					swim();
				default:
					walk();
			}
		}
	}

	public function jump(right:Bool):Void {
		jumpV = -3;
		startY = Std.int(y + Tile.h);
		angleSpin *= Std.int((right ? 1 : 0) * 2 - 1);
		inAir = true;
	}

	public function swim():Void {
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("swim");
		sitFrames = [5, 6];
		moveSpeed = swimSpeed;
		animateNormally = false;
	}

	public function walk():Void {
		sitFrames = [0, 1];
		moveSpeed = normalSpeed;
		animateNormally = true;
	}

	override public function render():Void {
		super.render();
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		super.render();
		Draw.resetTarget();
	}
}
