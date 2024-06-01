package puzzlements;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.graphics.Spritemap;

/**
 * ...
 * @author Time
 */
class ShieldLock extends Lock {
	private var imgShieldLockNorm:BitmapData;
	private var sprShieldLockNorm:Spritemap;
	private var imgShieldLock:BitmapData;
	private var sprShieldLock:Spritemap;

	private var p:Player;
	private var shieldType:Int;

	/**
	 * @param	_x		The x-placement of the block
	 * @param	_y		The y-placement of the block
	 * @param	_tag	The tag for saving
	 * @param	_type	Represents which shield type (0=normal, 1=dark)
	 */
	private override function load_image_assets():Void {
		imgShieldLockNorm = Assets.getBitmapData("assets/graphics/ShieldLockNorm.png");
		imgShieldLock = Assets.getBitmapData("assets/graphics/ShieldLock.png");
	}

	public function new(_x:Int, _y:Int, _tag:Int = -1, _type:Int = 1) {
		load_image_assets();
		sprShieldLockNorm = new Spritemap(imgShieldLockNorm, 16, 16);
		sprShieldLock = new Spritemap(imgShieldLock, 16, 16);
		super(_x, _y, -2, _tag, (_type == 0) ? sprShieldLockNorm : sprShieldLock);
		shieldType = _type;
	}

	override public function update():Void {
		p = try cast(collide("Player", x - 1, y), Player) catch (e:Dynamic) null;
		if (p != null && !activate && ((Player.hasDarkShield && shieldType == 1) || (Player.hasShield && shieldType == 0))) {
			p.y = y - originY + 7;
			p.directionFace = 0;
			p.receiveInput = false;
			activate = true;
		}
		activationStep();
	}

	override public function turnOff():Void {
		super.turnOff();
		if (p != null) {
			p.directionFace = -1;
			p.receiveInput = true;
		}
	}
}
