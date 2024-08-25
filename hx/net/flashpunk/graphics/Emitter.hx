package net.flashpunk.graphics;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.utils.Dictionary;
import openfl.errors.Error;
import haxe.Constraints.Function;
import openfl.display.BitmapData;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import net.flashpunk.FP;
import net.flashpunk.Graphic;
import net.flashpunk.utils.Input;
import net.flashpunk.utils.Key;
import net.flashpunk.utils.Draw;

/**
 * Particle emitter used for emitting and rendering particle sprites.
 * Good rendering performance with large amounts of particles.
 */
class Emitter extends Graphic {
	public var particleCount(get, never):Int;

	/**
	 * Constructor. Sets the source image to use for newly added particle types.
	 * @param	source			Source image.
	 * @param	frameWidth		Frame width.
	 * @param	frameHeight		Frame height.
	 */
	public function new(source:Dynamic, frameWidth:Int = 0, frameHeight:Int = 0) {
		super();
		setSource(source, frameWidth, frameHeight);
		active = true;
	}

	/**
	 * Changes the source image to use for newly added particle types.
	 * @param	source			Source image.
	 * @param	frameWidth		Frame width.
	 * @param	frameHeight		Frame height.
	 */
	public function setSource(source:Dynamic, frameWidth:Int = 0, frameHeight:Int = 0):Void {
		if (Std.is(source, Class)) {
			_source = FP.getBitmap(source);
		} else if (Std.is(source, BitmapData)) {
			_source = source;
		}
		if (_source == null) {
			throw new Error("Invalid source image.");
		}
		_width = _source.width;
		_height = _source.height;
		_frameWidth = (frameWidth != 0) ? frameWidth : _width;
		_frameHeight = (frameHeight != 0) ? frameHeight : _height;
		_frameCount = Std.int(Std.int(_width / _frameWidth) * Std.int(_height / _frameHeight));
	}

	override public function update():Void // quit if there are no particles
	{
		if (_particle == null) {
			return;
		}

		// particle info
		var e:Float = (FP.fixed) ? 1 : FP.elapsed;
		var p:Particle = _particle;
		var n:Particle;
		var t:Float;

		// loop through the particles
		while (p != null)
			// update time scale
		{
			p._time += e;
			t = p._time / p._duration;

			// remove on time-out
			if (p._time >= p._duration) {
				if (p._next != null) {
					p._next._prev = p._prev;
				}
				if (p._prev != null) {
					p._prev._next = p._next;
				} else {
					_particle = p._next;
				}
				n = p._next;
				p._next = _cache;
				p._prev = null;
				_cache = p;
				p = n;
				_particleCount--;
				continue;
			}

			// get next particle
			p = p._next;
		}
	}

	/** @private Renders the particles. */
	override public function render(point:Point, camera:Point):Void // quit if there are no particles
	{
		if (_particle == null) {
			return;
		}

		// get rendering position
		point.x += x - camera.x * scrollX;
		point.y += y - camera.y * scrollY;

		// particle info
		var t:Float;
		var td:Float;
		var p:Particle = _particle;
		var type:ParticleType;
		var rect:Rectangle;

		// loop through the particles
		while (p != null)
			// get time scale
		{
			t = p._time / p._duration;

			// get particle type
			type = p._type;
			rect = type._frame;

			// get position
			td = ((type._ease == null)) ? t : type._ease(t);
			_point.x = point.x + p._x + p._moveX * td;
			_point.y = point.y + p._y + p._moveY * td;

			// get frame
			rect.x = rect.width * type._frames[Std.int(td * type._frameCount)];
			rect.y = Std.int(rect.x / type._width) * rect.height;
			rect.x %= type._width;

			// draw particle
			if (type._buffer != null)
				// get alpha
			{
				_tint.alphaMultiplier = type._alpha + type._alphaRange * (((type._alphaEase == null)) ? t : type._alphaEase(t));

				// get color
				td = ((type._colorEase == null)) ? t : type._colorEase(t);
				_tint.redMultiplier = type._red + type._redRange * td;
				_tint.greenMultiplier = type._green + type._greenRange * td;
				_tint.blueMultiplier = type._blue + type._blueRange * td;
				type._buffer.fillRect(type._bufferRect, 0);
				type._buffer.copyPixels(type._source, rect, FP.zero);
				type._buffer.colorTransform(type._bufferRect, _tint);

				// draw particle
				Draw._target.copyPixels(type._buffer, type._bufferRect, _point, null, null, true);
			} else {
				Draw._target.copyPixels(type._source, rect, _point, null, null, true);
			}

			// get next particle
			p = p._next;
		}
	}

	/**
	 * Creates a new Particle type for this Emitter.
	 * @param	name		Name of the particle type.
	 * @param	frames		Array of frame indices for the particles to animate.
	 * @return	A new ParticleType object.
	 */
	public function newType(name:String, frames:Array<Dynamic> = null):ParticleType {
		if (_types[name] != null) {
			throw new Error("Cannot add multiple particle types of the same name");
		}
		_types[name] = new ParticleType(name, frames, _source, _frameWidth, _frameHeight);
		return _types[name];
	}

	/**
	 * Defines the motion range for a particle type.
	 * @param	name			The particle type.
	 * @param	angle			Launch Direction.
	 * @param	distance		Distance to travel.
	 * @param	duration		Particle duration.
	 * @param	angleRange		Random amount to add to the particle's direction.
	 * @param	distanceRange	Random amount to add to the particle's distance.
	 * @param	durationRange	Random amount to add to the particle's duration.
	 * @param	ease			Optional easer function.
	 * @return	This ParticleType object.
	 */
	public function setMotion(name:String, angle:Float, distance:Float, duration:Float, angleRange:Float = 0, distanceRange:Float = 0,
			durationRange:Float = 0, ease:Function = null):ParticleType {
		return _types[name].setMotion(angle, distance, duration, angleRange, distanceRange, durationRange, ease);
	}

	/**
	 * Sets the alpha range of the particle type.
	 * @param	name		The particle type.
	 * @param	start		The starting alpha.
	 * @param	finish		The finish alpha.
	 * @param	ease		Optional easer function.
	 * @return	This ParticleType object.
	 */
	public function setAlpha(name:String, start:Float = 1, finish:Float = 0, ease:Function = null):ParticleType {
		return _types[name].setAlpha(start, finish, ease);
	}

	/**
	 * Sets the color range of the particle type.
	 * @param	name		The particle type.
	 * @param	start		The starting color.
	 * @param	finish		The finish color.
	 * @param	ease		Optional easer function.
	 * @return	This ParticleType object.
	 */
	public function setColor(name:String, start:Int = 0xFFFFFF, finish:Int = 0, ease:Function = null):ParticleType {
		return _types[name].setColor(start, finish, ease);
	}

	/**
	 * Emits a particle.
	 * @param	name		Particle type to emit.
	 * @param	x			X point to emit from.
	 * @param	y			Y point to emit from.
	 * @return
	 */
	public function emit(name:String, x:Float, y:Float):Particle {
		if (_types[name] == null) {
			throw new Error("Particle type \"" + name + "\" does not exist.");
		}
		var p:Particle;
		var type:ParticleType = _types[name];

		if (_cache != null) {
			p = _cache;
			_cache = p._next;
		} else {
			p = new Particle();
		}
		p._next = _particle;
		p._prev = null;
		if (p._next != null) {
			p._next._prev = p;
		}

		p._type = type;
		p._time = 0;
		p._duration = type._duration + type._durationRange * FP.random;
		var a:Float = type._angle + type._angleRange * FP.random;
		var d:Float = type._distance + type._distanceRange * FP.random;
		p._moveX = Math.cos(a) * d;
		p._moveY = Math.sin(a) * d;
		p._x = x;
		p._y = y;
		_particleCount++;
		return (_particle = p);
	}

	/**
	 * Amount of currently existing particles.
	 */
	private function get_particleCount():Int {
		return _particleCount;
	}

	// Particle infromation.

	/** @private */
	private var _types:Dictionary<String, ParticleType> = new Dictionary();

	/** @private */
	private var _particle:Particle;

	/** @private */
	private var _cache:Particle;

	/** @private */
	private var _particleCount:Int = 0;

	// Source information.

	/** @private */
	private var _source:BitmapData;

	/** @private */
	private var _width:Int = 0;

	/** @private */
	private var _height:Int = 0;

	/** @private */
	private var _frameWidth:Int = 0;

	/** @private */
	private var _frameHeight:Int = 0;

	/** @private */
	private var _frameCount:Int = 0;

	// Drawing information.

	/** @private */
	private var _point:Point = new Point();

	/** @private */
	private var _tint:ColorTransform = new ColorTransform();

	/** @private */
	private static var SIN:Float = Math.PI / 2;
}
