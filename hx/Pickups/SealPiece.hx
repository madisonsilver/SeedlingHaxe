package pickups;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class SealPiece extends Pickup {
	private var imgSeal:BitmapData;
	private var sprSeal:Spritemap;

	private var index:Int = -1;

	private function load_image_assets():Void {
		imgSeal = Assets.getBitmapData("assets/graphics/Seal.png");
	}

	public function new(_x:Int, _y:Int, _v:Point = null) {
		load_image_assets();
		sprSeal = new Spritemap(imgSeal, 4, 4);
		super(_x, _y, sprSeal, _v);
		sprSeal.centerOO();
		type = "Seal";
		setHitbox(4, 4, 2, 2);

		special = true;
		text = "";
		mySound = Music.sndOSealPiece;

		// Doesn't work for some reason
		Music.bkgdVolumeMaxExtern = 0; // Shut off background sound. Restored by SealController
		Music.fadeVolumeMaxExtern = 0;
	}

	override public function render():Void {
		sprSeal.frame = Game.worldFrame(sprSeal.frameCount);
		super.render();
	}

	override public function removed():Void {
		FP.world.add(new SealController());
		/*while (index < 0 || !SealController.getSealPart(index))
			{
				index = Math.floor(Math.random() * SealController.SEALS);
		}*/
		super.removed();
	}
}
