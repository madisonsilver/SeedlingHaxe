package net.flashpunk.graphics;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.errors.Error;
import haxe.Constraints.Function;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.SpreadMethod;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import net.flashpunk.FP;
import openfl.utils.Dictionary;

/**
 * Performance-optimized animated Image. Can have multiple animations,
 * which draw frames from the provided source image to the screen.
 */
class Spritemap extends Image {
	public var frame(get, set):Int;
	public var index(get, set):Int;
	public var frameCount(get, never):Int;
	public var columns(get, never):Int;
	public var rows(get, never):Int;
	public var currentAnim(get, never):String;

	/**
	 * If the animation has stopped.
	 */
	public var complete:Bool = true;

	/**
	 * Optional callback function for animation end.
	 */
	public var callback:Function;

	/**
	 * Animation speed factor, alter this to speed up/slow down all animations.
	 */
	public var rate:Float = 1;

	/**
	 * Constructor.
	 * @param	source			Source image.  (Class or BitmapData)
	 * @param	frameWidth		Frame width.
	 * @param	frameHeight		Frame height.
	 * @param	callback		Optional callback function for animation end.
	 */
	public function new(source:Dynamic, frameWidth:Int = 0, frameHeight:Int = 0, callback:Function = null) {
		_rect = new Rectangle(0, 0, frameWidth, frameHeight);
		super(source, _rect);
		if (frameWidth == 0) {
			_rect.width = this.source.width;
		}
		if (frameHeight == 0) {
			_rect.height = this.source.height;
		}
		_width = this.source.width;
		_height = this.source.height;
		_columns = Std.int(_width / _rect.width);
		_rows = Std.int(_height / _rect.height);
		_frameCount = Std.int(_columns * _rows);
		this.callback = callback;
		updateBuffer();
		active = true;
	}

	/**
	 * Updates the spritemap's buffer.
	 */
	override public function updateBuffer():Void // get position of the current frame
	{
		_rect.x = _rect.width * _frame;
		_rect.y = Std.int(_rect.x / _width) * _rect.height;
		_rect.x %= _width;
		if (_flipped) {
			_rect.x = (_width - _rect.width) - _rect.x;
		}

		// update the buffer
		super.updateBuffer();
	}

	/** @private Updates the animation. */
	override public function update():Void {
		if (_anim != null && !complete) {
			_timer += ((FP.fixed) ? _anim._frameRate : _anim._frameRate * FP.elapsed) * rate;
			if (_timer >= 1) {
				while (_timer >= 1) {
					_timer--;
					_index++;
					if (_index == _anim._frameCount) {
						if (_anim._loop) {
							_index = 0;
							if (callback != null) {
								callback();
							}
						} else {
							_index = _anim._frameCount - 1;
							complete = true;
							if (callback != null) {
								callback();
							}
							break;
						}
					}
				}
				if (_anim != null) {
					_frame = Std.int(_anim._frames[_index]);
				}
				updateBuffer();
			}
		}
	}

	/**
	 * Add an Animation.
	 * @param	name		Name of the animation.
	 * @param	frames		Array of frame indices to animate through.
	 * @param	frameRate	Animation speed.
	 * @param	loop		If the animation should loop.
	 * @return	A new Anim object for the animation.
	 */
	public function add(name:String, frames:Array<Dynamic>, frameRate:Float = 0, loop:Bool = true):Anim {
		if (_anims[name] != null) {
			throw new Error("Cannot have multiple animations with the same name");
		}
		_anims[name] = new Anim(name, frames, frameRate, loop);
		_anims[name]._parent = this;
		return _anims[name];
	}

	/**
	 * Plays an animation.
	 * @param	name		Name of the animation to play.
	 * @param	reset		If the animation should force-restart if it is already playing.
	 * @return	Anim object representing the played animation.
	 */
	public function play(name:String = "", reset:Bool = false):Anim {
		if (!reset && _anim != null && _anim._name == name) {
			return _anim;
		}
		_anim = _anims[name];
		if (_anim == null) {
			_frame = _index = 0;
			complete = true;
			updateBuffer();
			return null;
		}
		_index = 0;
		_timer = 0;
		_frame = Std.int(_anim._frames[0]);
		complete = false;
		updateBuffer();
		return _anim;
	}

	/**
	 * Gets the frame index based on the column and row of the source image.
	 * @param	column		Frame column.
	 * @param	row			Frame row.
	 * @return	Frame index.
	 */
	public function getFrame(column:Int = 0, row:Int = 0):Int {
		return Std.int((row % _rows) * _columns + (column % _columns));
	}

	/**
	 * Sets the current display frame based on the column and row of the source image.
	 * When you set the frame, any animations playing will be stopped to force the frame.
	 * @param	column		Frame column.
	 * @param	row			Frame row.
	 */
	public function setFrame(column:Int = 0, row:Int = 0):Void {
		_anim = null;
		var frame:Int = Std.int((row % _rows) * _columns + (column % _columns));
		if (_frame == frame) {
			return;
		}
		_frame = frame;
		updateBuffer();
	}

	/**
	 * Assigns the Spritemap to a random frame.
	 */
	public function randFrame():Void {
		frame = FP.rand(_frameCount);
	}

	/**
	 * Sets the current frame index. When you set this, any
	 * animations playing will be stopped to force the frame.
	 */
	private function get_frame():Int {
		return _frame;
	}

	private function set_frame(value:Int):Int {
		_anim = null;
		value %= _frameCount;
		if (value < 0) {
			value = Std.int(_frameCount + value);
		}
		if (_frame == value) {
			return value;
		}
		_frame = value;
		updateBuffer();
		return value;
	}

	/**
	 * Current index of the playing animation.
	 */
	private function get_index():Int {
		return (_anim != null) ? _index : 0;
	}

	private function set_index(value:Int):Int {
		if (_anim == null) {
			return value;
		}
		value %= _anim._frameCount;
		if (_index == value) {
			return value;
		}
		_index = value;
		_frame = Std.int(_anim._frames[_index]);
		updateBuffer();
		return value;
	}

	/**
	 * The amount of frames in the Spritemap.
	 */
	private function get_frameCount():Int {
		return _frameCount;
	}

	/**
	 * Columns in the Spritemap.
	 */
	private function get_columns():Int {
		return _columns;
	}

	/**
	 * Rows in the Spritemap.
	 */
	private function get_rows():Int {
		return _rows;
	}

	/**
	 * The currently playing animation.
	 */
	private function get_currentAnim():String {
		return (_anim != null) ? _anim._name : "";
	}

	// Spritemap information.

	/** @private */
	private var _rect:Rectangle;

	/** @private */
	private var _width:Int;

	/** @private */
	private var _height:Int;

	/** @private */
	private var _columns:Int;

	/** @private */
	private var _rows:Int;

	/** @private */
	private var _frameCount:Int;

	/** @private */
	private var _anims:Dictionary<String, Anim> = new Dictionary();

	/** @private */
	private var _anim:Anim;

	/** @private */
	private var _index:Int;

	/** @private */
	private var _frame:Int;

	/** @private */
	private var _timer:Float = 0;
}
