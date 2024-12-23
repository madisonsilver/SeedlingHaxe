package nPCs;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.graphics.Spritemap;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class Totem extends NPC {
	private var imgTotem:BitmapData;
	private var sprTotem:Spritemap;

	private override function load_image_assets():Void {
		super.load_image_assets();
		imgTotem = Assets.getBitmapData("assets/graphics/Totem.png");
	}

	public function new(_x:Int, _y:Int, _tag:Int = -1, _text:String = "", _talkingSpeed:Int = 10) {
		load_image_assets();
		sprTotem = new Spritemap(imgTotem, 32, 64);
		// The weird tiles for the constructor are because NPC offsets by Tile.w/2, Tile.h/2 automagically.
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h * 5 / 2), sprTotem, _tag, _text, _talkingSpeed);
		facePlayer = false;

		sprTotem.originX = 16;
		sprTotem.x = -sprTotem.originX;
		sprTotem.originY = 48;
		sprTotem.y = -sprTotem.originY;
		setHitbox(Tile.w * 2, Tile.h * 2, Tile.w, Tile.h);
	}
}
