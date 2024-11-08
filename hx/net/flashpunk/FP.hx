package net.flashpunk;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import flash.display.BitmapData;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.media.SoundMixer;
import openfl.media.SoundTransform;
import openfl.system.System;
import openfl.utils.ByteArray;
import net.flashpunk.*;
import net.flashpunk.debug.Console;
import haxe.xml.Access;

/**
 * Static catch-all class used to access global properties and functions.
 */
class FP {
	public static var world(get, set):World;
	public static var volume(get, set):Float;
	public static var pan(get, set):Float;
	public static var randomSeed(get, set):Int;
	public static var random(get, never):Float;
	public static var console(get, never):Console;

	/**
	 * The FlashPunk major version.
	 */
	public static inline var VERSION:String = "1.4";

	/**
	 * Width of the game.
	 */
	public static var width:Int = 0;

	/**
	 * Height of the game.
	 */
	public static var height:Int = 0;

	/**
	 * If the game is running at a fixed framerate.
	 */
	public static var fixed:Bool;

	/**
	 * The framerate assigned to the stage.
	 */
	public static var frameRate:Float;

	/**
	 * The framerate assigned to the stage.
	 */
	public static var assignedFrameRate:Float;

	/**
	 * Time elapsed since the last frame (non-fixed framerate only).
	 */
	public static var elapsed:Float;

	/**
	 * Timescale applied to FP.elapsed (non-fixed framerate only).
	 */
	public static var rate:Float = 1;

	/**
	 * The Screen object, use to transform or offset the Screen.
	 */
	public static var screen:Screen;

	/**
	 * The current screen buffer, drawn to in the render loop.
	 */
	public static var buffer:BitmapData;

	/**
	 * A rectangle representing the size of the screen.
	 */
	public static var bounds:Rectangle;

	/**
	 * Point used to determine drawing offset in the render loop.
	 */
	public static var camera:Point = new Point();

	/**
	 * The currently active World object. When you set this, the World is flagged
	 * to switch, but won't actually do so until the end of the current frame.
	 */
	private static function get_world():World {
		return _world;
	}

	private static function set_world(value:World):World {
		if (_world == value) {
			return value;
		}
		_goto = value;
		return value;
	}

	/**
	 * Resets the camera position.
	 */
	public static function resetCamera():Void {
		camera.x = camera.y = 0;
	}

	/**
	 * Global volume factor for all sounds, a value from 0 to 1.
	 */
	private static function get_volume():Float {
		return _volume;
	}

	private static function set_volume(value:Float):Float {
		if (value < 0) {
			value = 0;
		}
		if (_volume == value) {
			return value;
		}
		_soundTransform.volume = _volume = value;
		SoundMixer.soundTransform = _soundTransform;
		return value;
	}

	/**
	 * Global panning factor for all sounds, a value from -1 to 1.
	 */
	private static function get_pan():Float {
		return _pan;
	}

	private static function set_pan(value:Float):Float {
		if (value < -1) {
			value = -1;
		}
		if (value > 1) {
			value = 1;
		}
		if (_pan == value) {
			return value;
		}
		_soundTransform.pan = _pan = value;
		SoundMixer.soundTransform = _soundTransform;
		return value;
	}

	/**
	 * Randomly chooses and returns one of the provided values.
	 * @param	...objs		The Objects you want to randomly choose from. Can be ints, Numbers, Points, etc.
	 * @return	A randomly chosen one of the provided parameters.
	 */
	@:generic public static function choose<T>(objs:Array<T> = null):T {
		return objs[rand(objs.length)];
	}

	/**
	 * Finds the sign of the provided value.
	 * @param	value		The Number to evaluate.
	 * @return	1 if value > 0, -1 if value < 0, and 0 when value == 0.
	 */
	public static function sign(value:Float):Int {
		return (value < 0) ? -1 : ((value > 0) ? 1 : 0);
	}

	/**
	 * Approaches the value towards the target, by the specified amount, without overshooting the target.
	 * @param	value	The starting value.
	 * @param	target	The target that you want value to approach.
	 * @param	amount	How much you want the value to approach target by.
	 * @return	The new value.
	 */
	public static function approach(value:Float, target:Float, amount:Float):Float {
		return (value < target) ? ((target < value + amount) ? target : value + amount) : ((target > value - amount) ? target : value - amount);
	}

	/**
	 * Linear interpolation between two values.
	 * @param	a		First value.
	 * @param	b		Second value.
	 * @param	t		Interpolation factor.
	 * @return	When t=0, returns a. When t=1, returns b. When t=0.5, will return halfway between a and b. Etc.
	 */
	public static function lerp(a:Float, b:Float, t:Float = 1):Float {
		return a + (b - a) * t;
	}

	/**
	 * Linear interpolation between two colors.
	 * @param	fromColor		First color.
	 * @param	toColor			Second color.
	 * @param	t				Interpolation value. Clamped to the range [0, 1].
	 * return	RGB component-interpolated color value.
	 */
	public static function colorLerp(fromColor:Int, toColor:Int, t:Float = 1):Int {
		if (t <= 0) {
			return fromColor;
		}
		if (t >= 1) {
			return toColor;
		}
		var a:Int = Std.int(fromColor >> 24) & 0xFF;
		var r:Int = Std.int(fromColor >> 16) & 0xFF;
		var g:Int = Std.int(fromColor >> 8) & 0xFF;
		var b:Int = fromColor & 0xFF;
		var dA:Int = Std.int((Std.int(toColor >> 24) & 0xFF) - a);
		var dR:Int = Std.int((Std.int(toColor >> 16) & 0xFF) - r);
		var dG:Int = Std.int((Std.int(toColor >> 8) & 0xFF) - g);
		var dB:Int = Std.int((toColor & 0xFF) - b);
		a += Std.int(dA * t);
		r += Std.int(dR * t);
		g += Std.int(dG * t);
		b += Std.int(dB * t);
		return Std.int(a << 24 | r << 16 | g << 8 | b);
	}

	/**
	 * Steps the object towards a point.
	 * @param	object		Object to move (must have an x and y property).
	 * @param	x			X position to step towards.
	 * @param	y			Y position to step towards.
	 * @param	distance	The distance to step (will not overshoot target).
	 */
	public static function stepTowards(object:Dynamic, x:Float, y:Float, distance:Float = 1):Void {
		point.x = x - object.x;
		point.y = y - object.y;
		if (point.length <= distance) {
			object.x = x;
			object.y = y;
			return;
		}
		point.normalize(distance);
		object.x += point.x;
		object.y += point.y;
	}

	/**
	 * Finds the angle (in degrees) from point 1 to point 2.
	 * @param	x1		The first x-position.
	 * @param	y1		The first y-position.
	 * @param	x2		The second x-position.
	 * @param	y2		The second y-position.
	 * @return	The angle from (x1, y1) to (x2, y2).
	 */
	public static function angle(x1:Float, y1:Float, x2:Float, y2:Float):Float {
		var a:Float = Math.atan2(y2 - y1, x2 - x1) * DEG;
		return (a < 0) ? a + 360 : a;
	}

	public static function angle_difference(a0:Float, a1:Float):Float {
		var d:Float = a0 - a1;
		if (d < -Math.PI) {
			d += 2 * Math.PI;
		}
		if (d > Math.PI) {
			d -= 2 * Math.PI;
		}
		return d;
	}

	/**
	 * Sets the x/y values of the provided object to a vector of the specified angle and length.
	 * @param	object		The object whose x/y properties should be set.
	 * @param	angle		The angle of the vector, in degrees.
	 * @param	length		The distance to the vector from (0, 0).
	 */
	public static function angleXY(object:Dynamic, angle:Float, length:Float = 1):Void {
		angle *= RAD;
		object.x = Math.cos(angle) * length;
		object.y = Math.sin(angle) * length;
	}

	/**
	 * Find the distance between two points.
	 * @param	x1		The first x-position.
	 * @param	y1		The first y-position.
	 * @param	x2		The second x-position.
	 * @param	y2		The second y-position.
	 * @return	The distance.
	 */
	public static function distance(x1:Float, y1:Float, x2:Float = 0, y2:Float = 0):Float {
		return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
	}

	/**
	 * Find the distance between two rectangles. Will return 0 if the rectangles overlap.
	 * @param	x1		The x-position of the first rect.
	 * @param	y1		The y-position of the first rect.
	 * @param	w1		The width of the first rect.
	 * @param	h1		The height of the first rect.
	 * @param	x2		The x-position of the second rect.
	 * @param	y2		The y-position of the second rect.
	 * @param	w2		The width of the second rect.
	 * @param	h2		The height of the second rect.
	 * @return	The distance.
	 */
	public static function distanceRects(x1:Float, y1:Float, w1:Float, h1:Float, x2:Float, y2:Float, w2:Float, h2:Float):Float {
		if (x1 < x2 + w2 && x2 < x1 + w1) {
			if (y1 < y2 + h2 && y2 < y1 + h1) {
				return 0;
			}
			if (y1 > y2) {
				return y1 - (y2 + h2);
			}
			return y2 - (y1 + h1);
		}
		if (y1 < y2 + h2 && y2 < y1 + h1) {
			if (x1 > x2) {
				return x1 - (x2 + w2);
			}
			return x2 - (x1 + w1);
		}
		if (x1 > x2) {
			if (y1 > y2) {
				return distance(x1, y1, x2 + w2, y2 + h2);
			}
			return distance(x1, y1 + h1, x2 + w2, y2);
		}
		if (y1 > y2) {
			return distance(x1 + w1, y1, x2, y2 + h2);
		}
		return distance(x1 + w1, y1 + h1, x2, y2);
	}

	/**
	 * Find the distance between a point and a rectangle. Returns 0 if the point is within the rectangle.
	 * @param	px		The x-position of the point.
	 * @param	py		The y-position of the point.
	 * @param	rx		The x-position of the rect.
	 * @param	ry		The y-position of the rect.
	 * @param	rw		The width of the rect.
	 * @param	rh		The height of the rect.
	 * @return	The distance.
	 */
	public static function distanceRectPoint(px:Float, py:Float, rx:Float, ry:Float, rw:Float, rh:Float):Float {
		if (px >= rx && px <= rx + rw) {
			if (py >= ry && py <= ry + rh) {
				return 0;
			}
			if (py > ry) {
				return py - (ry + rh);
			}
			return ry - py;
		}
		if (py >= ry && py <= ry + rh) {
			if (px > rx) {
				return px - (rx + rw);
			}
			return rx - px;
		}
		if (px > rx) {
			if (py > ry) {
				return distance(px, py, rx + rw, ry + rh);
			}
			return distance(px, py, rx + rw, ry);
		}
		if (py > ry) {
			return distance(px, py, rx, ry + rh);
		}
		return distance(px, py, rx, ry);
	}

	/**
	 * Clamps the value within the minimum and maximum values.
	 * @param	value		The Number to evaluate.
	 * @param	min			The minimum range.
	 * @param	max			The maximum range.
	 * @return	The clamped value.
	 */
	public static function clamp(value:Float, min:Float, max:Float):Float {
		if (max > min) {
			value = (value < max) ? value : max;
			return (value > min) ? value : min;
		}
		value = (value < min) ? value : min;
		return (value > max) ? value : max;
	}

	/**
	 * Transfers a value from one scale to another scale. For example, scale(.5, 0, 1, 10, 20) == 15, and scale(3, 0, 5, 100, 0) == 40.
	 * @param	value		The value on the first scale.
	 * @param	min			The minimum range of the first scale.
	 * @param	max			The maximum range of the first scale.
	 * @param	min2		The minimum range of the second scale.
	 * @param	max2		The maximum range of the second scale.
	 * @return	The scaled value.
	 */
	public static function scale(value:Float, min:Float, max:Float, min2:Float, max2:Float):Float {
		return min2 + ((value - min) / (max - min)) * (max2 - min2);
	}

	/**
	 * Transfers a value from one scale to another scale, but clamps the return value within the second scale.
	 * @param	value		The value on the first scale.
	 * @param	min			The minimum range of the first scale.
	 * @param	max			The maximum range of the first scale.
	 * @param	min2		The minimum range of the second scale.
	 * @param	max2		The maximum range of the second scale.
	 * @return	The scaled and clamped value.
	 */
	public static function scaleClamp(value:Float, min:Float, max:Float, min2:Float, max2:Float):Float {
		value = min2 + ((value - min) / (max - min)) * (max2 - min2);
		if (max2 > min2) {
			value = (value < max2) ? value : max2;
			return (value > min2) ? value : min2;
		}
		value = (value < min2) ? value : min2;
		return (value > max2) ? value : max2;
	}

	/**
	 * The random seed used by FP's random functions.
	 */
	private static function get_randomSeed():Int {
		return _getSeed;
	}

	private static function set_randomSeed(value:Int):Int {
		_seed = Std.int(clamp(value, 1, 2147483646));
		_getSeed = _seed;
		return value;
	}

	/**
	 * Randomizes the random seed using Flash's Math.random() function.
	 */
	public static function randomizeSeed():Void {
		randomSeed = Std.int(2147483647 * Math.random());
	}

	/**
	 * A pseudo-random Number produced using FP's random seed, where 0 <= Number < 1.
	 */
	private static function get_random():Float {
		_seed = (_seed * 16807) % 2147483647;
		return _seed / 2147483647;
	}

	/**
	 * Returns a pseudo-random uint.
	 * @param	amount		The returned uint will always be 0 <= uint < amount.
	 * @return	The uint.
	 */
	public static function rand(amount:Int):Int {
		_seed = (_seed * 16807) % 2147483647;
		return Std.int((_seed / 2147483647) * amount);
	}

	/**
	 * Returns the next item after current in the list of options.
	 * @param	current		The currently selected item (must be one of the options).
	 * @param	options		An array of all the items to cycle through.
	 * @param	loop		If true, will jump to the first item after the last item is reached.
	 * @return	The next item in the list.
	 */
	public static function next(current:Dynamic, options:Array<Dynamic>, loop:Bool = true):Dynamic {
		if (loop) {
			return options[(Lambda.indexOf(options, current) + 1) % options.length];
		}
		return options[(cast(Math.max(Lambda.indexOf(options, current) + 1, options.length - 1)) : Int)];
	}

	/**
	 * Returns the item previous to the current in the list of options.
	 * @param	current		The currently selected item (must be one of the options).
	 * @param	options		An array of all the items to cycle through.
	 * @param	loop		If true, will jump to the last item after the first is reached.
	 * @return	The previous item in the list.
	 */
	public static function prev(current:Dynamic, options:Array<Dynamic>, loop:Bool = true):Dynamic {
		if (loop) {
			return options[((Lambda.indexOf(options, current) - 1) + options.length) % options.length];
		}
		return options[Std.int(Math.max(Lambda.indexOf(options, current) - 1, 0))];
	}

	/**
	 * Swaps the current item between a and b. Useful for quick state/string/value swapping.
	 * @param	current		The currently selected item.
	 * @param	a			Item a.
	 * @param	b			Item b.
	 * @return	Returns a if current is b, and b if current is a.
	 */
	public static function swap(current:Dynamic, a:Dynamic, b:Dynamic):Dynamic {
		return (current == a) ? b : a;
	}

	/**
	 * Creates a color value by combining the chosen RGB values.
	 * @param	R		The red value of the color, from 0 to 255.
	 * @param	G		The green value of the color, from 0 to 255.
	 * @param	B		The blue value of the color, from 0 to 255.
	 * @return	The color uint.
	 */
	public static function getColorRGB(R:Int = 0, G:Int = 0, B:Int = 0):Int {
		return Std.int(R << 16 | G << 8 | B);
	}

	/**
	 * Finds the red factor of a color.
	 * @param	color		The color to evaluate.
	 * @return	A uint from 0 to 255.
	 */
	public static function getRed(color:Int):Int {
		return Std.int(Std.int(color >> 16) & 0xFF);
	}

	/**
	 * Finds the green factor of a color.
	 * @param	color		The color to evaluate.
	 * @return	A uint from 0 to 255.
	 */
	public static function getGreen(color:Int):Int {
		return Std.int(Std.int(color >> 8) & 0xFF);
	}

	/**
	 * Finds the blue factor of a color.
	 * @param	color		The color to evaluate.
	 * @return	A uint from 0 to 255.
	 */
	public static function getBlue(color:Int):Int {
		return Std.int(color & 0xFF);
	}

	/**
	 * Fetches a stored BitmapData object represented by the source.
	 * @param	source		Embedded Bitmap class.
	 * @return	The stored BitmapData object.
	 */
	public static function getBitmap(source:Class<Dynamic>):BitmapData {
		if (_bitmap[Std.string(source)] != null) {
			return _bitmap[Std.string(source)];
		}
		return (_bitmap[Std.string(source)] = (Type.createInstance(source, [])).bitmapData);
	}

	/**
	 * Sets a time flag.
	 * @return	Time elapsed (in milliseconds) since the last time flag was set.
	 */
	public static function timeFlag():Int {
		var t:Int = Math.round(haxe.Timer.stamp() * 1000);
		var e:Int = Std.int(t - _time);
		_time = t;
		return e;
	}

	/**
	 * The global Console object.
	 */
	private static function get_console():Console {
		if (_console == null) {
			_console = new Console();
		}
		return _console;
	}

	/**
	 * Logs data to the console.
	 * @param	...data		The data parameters to log, can be variables, objects, etc. Parameters will be separated by a space (" ").
	 */
	public static function log(data:Array<Dynamic> = null):Void {
		if (_console != null) {
			if (data.length > 1) {
				var i:Int = 0;
				var s:String = "";
				while (i < data.length) {
					if (i > 0) {
						s += " ";
					}
					s += Std.string(data[i++]);
				}
				_console.log([s]);
			} else {
				_console.log([data[0]]);
			}
		}
	}

	/**
	 * Adds properties to watch in the console's debug panel.
	 * @param	...properties		The properties (strings) to watch.
	 */
	public static function watch(properties:Array<Dynamic> = null):Void {
		if (_console != null) {
			if (properties.length > 1) {
				_console.watch(properties);
			} else {
				_console.watch(properties[0]);
			}
		}
	}

	/**
	 * Loads the file as an XML object.
	 * @param	file		The embedded file to load.
	 * @return	An XML object representing the file.
	 */
	public static function getXML(file:Class<Dynamic>):Access {
		var bytes:ByteArray = Type.createInstance(file, []);
		return new Access(Xml.parse(bytes.readUTFBytes(bytes.length)));
	}

	/**
	 * Shuffles the elements in the array.
	 * @param	a		The Object to shuffle (an Array or Vector).
	 */
	public static function shuffle(a:Dynamic):Void {
		if (Std.isOfType(a, Array) || Std.isOfType(a, Array /*Vector.<T> call?*/)) {
			var i:Int = a.length;
			var j:Int = 0;
			var t:Dynamic;
			while (--i > 0) {
				t = a[i];
				a[i] = a[j = FP.rand(i + 1)];
				a[j] = t;
			}
		}
	}

	// World information.

	/** @private */ @:allow(net.flashpunk)
	private static var _world:World;

	/** @private */ @:allow(net.flashpunk)
	private static var _goto:World;

	// Console information.

	/** @private */ @:allow(net.flashpunk)
	private static var _console:Console;

	// Time information.

	/** @private */ @:allow(net.flashpunk)
	private static var _time:Int = 0;

	/** @private */
	public static var _updateTime:Int = 0;

	/** @private */
	public static var _renderTime:Int = 0;

	/** @private */
	public static var _gameTime:Int = 0;

	/** @private */
	public static var _flashTime:Int = 0;

	// Bitmap storage.

	/** @private */
	private static var _bitmap:Map<String, BitmapData>;

	// Pseudo-random number generation (the seed is set in Engine's contructor).

	/** @private */
	private static var _seed:Int = 0;

	/** @private */
	private static var _getSeed:Int = 0;

	// Volume control.

	/** @private */
	private static var _volume:Float = 1;

	/** @private */
	private static var _pan:Float = 0;

	/** @private */
	private static var _soundTransform:SoundTransform = new SoundTransform();

	// Used for rad-to-deg and deg-to-rad conversion.

	/** @private */
	public static var DEG:Float = -180 / Math.PI;

	/** @private */
	public static var RAD:Float = Math.PI / -180;

	// Global Flash objects.

	/** @private */
	public static var stage:Stage;

	/** @private */
	public static var engine:Engine;

	// Global objects used for rendering, collision, etc.

	/** @private */
	public static var point:Point = new Point();

	/** @private */
	public static var point2:Point = new Point();

	/** @private */
	public static var zero:Point = new Point();

	/** @private */
	public static var rect:Rectangle = new Rectangle();

	/** @private */
	public static var matrix:Matrix = new Matrix();

	/** @private */
	public static var sprite:Sprite = new Sprite();

	/** @private */
	public static var entity:Entity;

	public function new() {}
}
