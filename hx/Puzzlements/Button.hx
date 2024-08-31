package puzzlements;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class Button extends Activators {
	private var imgButton:BitmapData;
	private var sprButton:Spritemap;

	private var hitables:Dynamic = ["Player", "Enemy", "Solid"]; // Things that push down the button

	private function load_image_assets():Void {
		imgButton = Assets.getBitmapData("assets/graphics/Button.png");
	}

	public function new(_x:Int, _y:Int, _t:Int) {
		load_image_assets();
		sprButton = new Spritemap(imgButton, 8, 8);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprButton, _t);
		sprButton.centerOO();
		setHitbox(8, 6, 4, 3);
		type = "Button";
		layer = Std.int(-y);
	}

	override public function update():Void {
		var v:Array<Entity> = new Array<Entity>();
		collideTypesInto(hitables, x, y, v);
		var tempCheck:Bool = false;
		for (c in v) {
			if (c != null && !(Std.isOfType(c, Cover))) {
				tempCheck = true;
			}
		}
		activate = tempCheck;
	}

	override private function set_activate(a:Bool):Bool {
		if (_active != a) {
			Music.playSoundDistPlayer(Std.int(x), Std.int(y), "Switch");
		}
		_active = a;
		activateAll(this, t, activate);
		sprButton.frame = (_active ? 1 : 0);
		return a;
	}

	public static function activateAll(_exclude:Activators, _t:Int, _activate:Bool):Void {
		var v:Array<Activators> = new Array<Activators>();
		FP.world.getClass(Activators, v);
		for (i in 0...v.length) {
			if (v[i] != _exclude && v[i].t == _t) {
				v[i].activate = _activate;
			}
		}
	}
}
