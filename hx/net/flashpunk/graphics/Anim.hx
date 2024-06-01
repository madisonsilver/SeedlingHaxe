package net.flashpunk.graphics;
import openfl.utils.Assets;import openfl.display.BitmapData;

/**
 * Template used by Spritemap to define animations. Don't create
 * these yourself, instead you can fetch them with Spritemap's add().
 */
class Anim {
	public var name(get, never):String;
	public var frames(get, never):Array<Dynamic>;
	public var frameRate(get, never):Float;
	public var frameCount(get, never):Int;
	public var loop(get, never):Bool;

	/**
	 * Constructor.
	 * @param	name		Animation name.
	 * @param	frames		Array of frame indices to animate.
	 * @param	frameRate	Animation speed.
	 * @param	loop		If the animation should loop.
	 */
	public function new(name:String, frames:Array<Dynamic>, frameRate:Float = 0, loop:Bool = true) {

		_name = name;
		_frames = frames;
		_frameRate = frameRate;
		_loop = loop;
		_frameCount = frames.length;
	}

	/**
	 * Plays the animation.
	 * @param	reset		If the animation should force-restart if it is already playing.
	 */
	public function play(reset:Bool = false):Void {
		_parent.play(_name, reset);
	}

	/**
	 * Name of the animation.
	 */
	private function get_name():String {
		return _name;
	}

	/**
	 * Array of frame indices to animate.
	 */
	private function get_frames():Array<Dynamic> {
		return _frames;
	}

	/**
	 * Animation speed.
	 */
	private function get_frameRate():Float {
		return _frameRate;
	}

	/**
	 * Amount of frames in the animation.
	 */
	private function get_frameCount():Int {
		return _frameCount;
	}

	/**
	 * If the animation loops.
	 */
	private function get_loop():Bool {
		return _loop;
	}

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _parent:Spritemap;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _name:String;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _frames:Array<Dynamic>;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _frameRate:Float;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _frameCount:Int;

	/** @private */ @:allow(net.flashpunk.graphics)
	private var _loop:Bool;
}
