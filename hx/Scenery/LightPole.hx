package scenery;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import net.flashpunk.utils.Draw;
import puzzlements.Activators;

/**
 * ...
 * @author Time
 */
class LightPole extends Activators {
private var imgLightPole:BitmapData;
	private var sprLightPole:Image;

	private var loops(default, never):Float = 1.5;
	private var lightAlpha(default, never):Float = 0.5;
	private var hitsTimerMax(default, never):Int = 25;

	private var hitsTimer:Int = 0;

	private var myLight:Light;
	private var color:Int;
	private var startY:Int;
	private var tag:Int;
	private var invert:Bool;

private function load_image_assets():Void {
imgLightPole = Assets.getBitmapData("assets/graphics/LightPole.png");
}
	public function new(_x:Int, _y:Int, _t:Int = 0, _tag:Int = -1, _color:Int = 0xFFFFFF, _invert:Bool = false) {
load_image_assets();
		sprLightPole = new Image(imgLightPole);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprLightPole, _t);
		startY = Std.int(y);
		sprLightPole.centerOO();

		tag = _tag;
		layer = Std.int(-(y - sprLightPole.originY + sprLightPole.height));

		color = _color;
		FP.world.add(myLight = new Light(Std.int(x), Std.int(y), 100, Std.int(loops), color, true, 28, 32, lightAlpha));
		myLight.layer = layer - 1;
		myLight.i_radius_factor = 0.8;

		type = "LightPole";
		setHitbox(10, 12, 5, 6);

		invert = _invert;

		activate = !Game.checkPersistence(tag);
	}

	override public function update():Void {
		super.update();
		hitUpdate();
	}

	override public function render():Void {
		y = startY - sprLightPole.originY + 2 * Math.sin(2 * Math.PI * (Game.time % Game.timePerFrame) / Game.timePerFrame);
		var p:Player = try cast(FP.world.nearestToEntity("Player", this), Player) catch (e:Dynamic) null;
		if (myLight != null && p != null) {
			myLight.x = x;
			myLight.y = y;
		}
		super.render();
		if (hitsTimer <= 0 && activate) {
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
	}

	public function hit():Void {
		if (hitsTimer <= 0)
			// && tSet == -1) //Can only hit the light if it's not wired to a button.
		{
			{
				activate = !activate;
				hitsTimer = hitsTimerMax;
			}
		}
	}

	public function hitUpdate():Void {
		if (hitsTimer > 0) {
			hitsTimer--;
		}
	}

	override private function set_activate(a:Bool):Bool {
		_active = a;
		Game.setPersistence(tag, !activate);
		if (myLight != null) {
			var _a:Bool = _active;
			if (invert) {
				_a = !_a;
			}
			if (_a) {
				myLight.color = color;
				myLight.alpha = lightAlpha;
				myLight.darkLight = false;
			} else {
				myLight.color = 0x000000;
				myLight.alpha = 0.8;
				myLight.darkLight = true;
			}
		}
		return a;
	}
}
