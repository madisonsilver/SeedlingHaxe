package enemies;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import scenery.Light;
import net.flashpunk.FP;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class DarkTrap extends SandTrap {
	private var imgDarkTrap:BitmapData;
	private var sprDarkTrap:Spritemap;

	private var deathCounter:Int = 30;
	private var startDying:Bool = false;

	private override function load_image_assets():Void {
		super.load_image_assets();
		imgDarkTrap = Assets.getBitmapData("assets/graphics/DarkTrap.png");
	}

	public function new(_x:Int, _y:Int, _tag:Int = -1) {
		load_image_assets();
		sprDarkTrap = new Spritemap(imgDarkTrap, 14, 14, endAnim);
		super(_x, _y, _tag, sprDarkTrap);

		sprDarkTrap.add("die1", [4, 0, 1, 0, 4, 5, 4, 5, 6, 7, 8, 9, 10, 11], 10);
	}

	override public function update():Void {
		var v:Array<Light> = new Array<Light>();
		FP.world.getClass(Light, cast v);
		for (light in v) {
			if (!(Std.isOfType(light, PlayerLight))
				&& FP.distance(x, y, light.x, light.y) <= light.radiusMin
				&& !light.darkLight
				&& !startDying) {
				Music.playSound("Enemy Die", 0);
				startDying = true;
			}
		}
		if (startDying) {
			if (deathCounter > 0) {
				deathCounter--;
			} else {
				sprDarkTrap.play("die1");
			}
		} else {
			super.update();
		}
	}

	override public function hit(f:Float = 0, p:Point = null, d:Float = 1, t:String = ""):Void {}

	override public function render():Void {
		super.render();
		if ((try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "die1") {
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
	}

	override public function endAnim():Void {
		var _sw1_ = ((try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim);

		switch (_sw1_) {
			case "die1":
				FP.world.remove(this);
			default:
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("");
		}
	}
}
