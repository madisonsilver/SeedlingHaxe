package net.flashpunk.graphics;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import haxe.Constraints.Function;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import net.flashpunk.FP;

/**
 * Template used to define a particle type used by the Emitter class. Instead
 * of creating this object yourself, fetch one with Emitter's add() function.
 */
class ParticleType {
	/**
	 * Constructor.
	 * @param	name			Name of the particle type.
	 * @param	frames			Array of frame indices to animate through.
	 * @param	source			Source image.
	 * @param	frameWidth		Frame width.
	 * @param	frameHeight		Frame height.
	 * @param	frameCount		Frame count.
	 */
	public function new(name:String, frames:Array<Dynamic>, source:BitmapData, frameWidth:Int, frameHeight:Int) {
		_name = name;
		_source = source;
		_width = source.width;
		_frame = new Rectangle(0, 0, frameWidth, frameHeight);
		_frames = frames;
		_frameCount = frames.length;
	}

	/**
	 * Defines the motion range for this particle type.
	 * @param	angle			Launch Direction.
	 * @param	distance		Distance to travel.
	 * @param	duration		Particle duration.
	 * @param	angleRange		Random amount to add to the particle's direction.
	 * @param	distanceRange	Random amount to add to the particle's distance.
	 * @param	durationRange	Random amount to add to the particle's duration.
	 * @param	ease			Optional easer function.
	 * @return	This ParticleType object.
	 */
	public function setMotion(angle:Float, distance:Float, duration:Float, angleRange:Float = 0, distanceRange:Float = 0, durationRange:Float = 0,
			ease:Function = null):ParticleType {
		_angle = angle * FP.RAD;
		_distance = distance;
		_duration = duration;
		_angleRange = angleRange * FP.RAD;
		_distanceRange = distanceRange;
		_durationRange = durationRange;
		_ease = ease;
		return this;
	}

	/**
	 * Defines the motion range for this particle type based on the vector.
	 * @param	x				X distance to move.
	 * @param	y				Y distance to move.
	 * @param	duration		Particle duration.
	 * @param	durationRange	Random amount to add to the particle's duration.
	 * @param	ease			Optional easer function.
	 * @return	This ParticleType object.
	 */
	public function setMotionVector(x:Float, y:Float, duration:Float, durationRange:Float = 0, ease:Function = null):ParticleType {
		_angle = Math.atan2(y, x);
		_angleRange = 0;
		_duration = duration;
		_durationRange = durationRange;
		_ease = ease;
		return this;
	}

	/**
	 * Sets the alpha range of this particle type.
	 * @param	start		The starting alpha.
	 * @param	finish		The finish alpha.
	 * @param	ease		Optional easer function.
	 * @return	This ParticleType object.
	 */
	public function setAlpha(start:Float = 1, finish:Float = 0, ease:Function = null):ParticleType {
		start = (start < 0) ? 0 : ((start > 1) ? 1 : start);
		finish = (finish < 0) ? 0 : ((finish > 1) ? 1 : finish);
		_alpha = start;
		_alphaRange = finish - start;
		_alphaEase = ease;
		createBuffer();
		return this;
	}

	/**
	 * Sets the color range of this particle type.
	 * @param	start		The starting color.
	 * @param	finish		The finish color.
	 * @param	ease		Optional easer function.
	 * @return	This ParticleType object.
	 */
	public function setColor(start:Int = 0xFFFFFF, finish:Int = 0, ease:Function = null):ParticleType {
		start = start & 0xFFFFFF;
		finish = finish & 0xFFFFFF;
		_red = (Std.int(start >> 16) & 0xFF) / 255;
		_green = (Std.int(start >> 8) & 0xFF) / 255;
		_blue = (start & 0xFF) / 255;
		_redRange = (Std.int(finish >> 16) & 0xFF) / 255 - _red;
		_greenRange = (Std.int(finish >> 8) & 0xFF) / 255 - _green;
		_blueRange = (finish & 0xFF) / 255 - _blue;
		_colorEase = ease;
		createBuffer();
		return this;
	}

	/** @private Creates the buffer if it doesn't exist. */
	private function createBuffer():Void {
		if (_buffer != null) {
			return;
		}
		_buffer = new BitmapData(Std.int(_frame.width), Std.int(_frame.height), true, 0);
		_bufferRect = _buffer.rect;
	}

	// Particle information.

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _name:String;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _source:BitmapData;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _width:Int;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _frame:Rectangle;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _frames:Array<Dynamic>;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _frameCount:Int;

	// Motion information.

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _angle:Float;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _angleRange:Float;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _distance:Float;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _distanceRange:Float;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _duration:Float;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _durationRange:Float;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _ease:Function;

	// Alpha information.

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _alpha:Float = 1;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _alphaRange:Float = 0;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _alphaEase:Function;

	// Color information.

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _red:Float = 1;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _redRange:Float = 0;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _green:Float = 1;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _greenRange:Float = 0;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _blue:Float = 1;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _blueRange:Float = 0;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _colorEase:Function;

	// Buffer information.

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _buffer:BitmapData;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _bufferRect:Rectangle;
}
