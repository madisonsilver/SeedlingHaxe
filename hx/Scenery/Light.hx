package scenery;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import net.flashpunk.Entity;
import net.flashpunk.utils.Draw;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class Light extends Entity {
	private var radiusMax:Int;

	public var radiusMin:Int;
	public var alpha:Float;
	public var color:Int;

	private var frames:Int;
	private var loops:Int;
	private var smooth:Bool;

	public var i_radius_factor:Float = 0.5;
	public var darkLight:Bool = false;

	/**
	 * Sets the drawing target for Draw functions.
	 * @param	_x		x-position of the center of the light.
	 * @param	_y		y-position of the center of the light.
	 * @param	_f		the number of frames for the light.
	 * @param	_l		the number of animation loops for the frames to loop over.
	 * @param	_c		the color of the light.
	 * @param	_rmin	the minimum radius of the light.
	 * @param	_rmax	the maximum radius of the light.
	 * @param	_a		the alpha of each ring of the light.
	 * @param	_smooth	smoothens the animations between radius sizes.
	 */
	public function new(_x:Int, _y:Int, _f:Int = 1, _l:Int = 1, _c:Int = 0xFFFFFF, _smooth:Bool = false, _rmin:Int = 28, _rmax:Int = 32, _a:Float = 0.2) {
		super(_x, _y);
		color = _c;
		radiusMax = _rmax;
		radiusMin = _rmin;
		alpha = _a;
		frames = _f;
		loops = _l;
		smooth = _smooth;
	}

	override public function render():Void {
		if (!onScreen(radiusMax)) {
			return;
		}
		super.render();
		layer = Std.int(-FP.height * 3 / 2);
		if (darkLight) {
			draw();
		} else {
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			draw();
			Draw.resetTarget();
		}
	}

	public function draw():Void {
		var c_radius:Int;
		if (smooth) {
			c_radius = Std.int((radiusMax - radiusMin) * (Math.sin(Game.worldFrame(frames, loops) / (frames - 1) * 2 * Math.PI) + 1) / 2
				+ radiusMin);
		} else {
			c_radius = Std.int((radiusMax - radiusMin) * Game.worldFrame(frames, loops) / (frames - 1) + radiusMin);
		}
		Draw.circlePlus(Std.int(x), Std.int(y), c_radius, color, alpha);
		Draw.circlePlus(Std.int(x), Std.int(y), c_radius * i_radius_factor, color, alpha);
	}
}
