package net.flashpunk;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.MovieClip;
import openfl.display.StageAlign;
import openfl.display.StageDisplayState;
import openfl.display.StageQuality;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.geom.Rectangle;
import openfl.utils.Timer;
import net.flashpunk.utils.Draw;
import net.flashpunk.utils.Input;

/**
 * Main game Sprite class, added to the Flash Stage. Manages the game loop.
 */
class Engine extends MovieClip {
	/**
	 * If the game should stop updating/rendering.
	 */
	public var paused:Bool = false;

	/**
	 * Constructor. Defines startup information about your game.
	 * @param	width			The width of your game.
	 * @param	height			The height of your game.
	 * @param	frameRate		The game framerate, in frames per second.
	 * @param	fixed			If a fixed-framerate should be used.
	 */
	public function new(width:Int, height:Int, frameRate:Float = 60, fixed:Bool = false) {
		super();
		// global game properties
		FP.width = width;
		FP.height = height;
		FP.assignedFrameRate = frameRate;
		FP.fixed = fixed;

		// global game objects
		FP.engine = this;
		FP.screen = new Screen();
		FP.bounds = new Rectangle(0, 0, width, height);
		FP._world = new World();

		// miscellanious startup stuff
		if (FP.randomSeed == 0) {
			FP.randomizeSeed();
		}
		FP.entity = new Entity();
		FP._time = Math.round(haxe.Timer.stamp() * 1000);

		// on-stage event listener
		addEventListener(Event.ADDED_TO_STAGE, onStage);
	}

	/**
	 * Override this, called after Engine has been added to the stage.
	 */
	public function init():Void {}

	/**
	 * Updates the game, updating the World and Entities.
	 */
	public function update():Void {
		if (FP._world.active) {
			if (FP._world._tween != null) {
				FP._world.updateTweens();
			}
			FP._world.update();
		}
		FP._world.updateLists();
		if (FP._goto != null) {
			checkWorld();
		}
	}

	/**
	 * Renders the game, rendering the World and Entities.
	 */
	public function render():Void // timing stuff
	{
		var t:Float = Math.round(haxe.Timer.stamp() * 1000);
		if (_frameLast == 0) {
			_frameLast = Std.int(t);
		}

		// render loop
		FP.screen.swap();
		Draw.resetTarget();
		FP.screen.refresh();
		if (FP._world.visible) {
			FP._world.render();
		}
		FP.screen.redraw();

		// more timing stuff
		t = Math.round(haxe.Timer.stamp() * 1000);
		_frameListSum += (_frameList[_frameList.length] = Std.int(t - _frameLast));
		if (_frameList.length > 10) {
			_frameListSum -= _frameList.shift();
		}
		FP.frameRate = 1000 / (_frameListSum / _frameList.length);
		_frameLast = Std.int(t);
	}

	/**
	 * Sets the game's stage properties. Override this to set them differently.
	 */
	public function setStageProperties():Void {
		stage.frameRate = FP.assignedFrameRate;
		stage.align = StageAlign.TOP_LEFT;
		stage.quality = StageQuality.HIGH;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.displayState = StageDisplayState.NORMAL;
	}

	/** @private Event handler for stage entry. */
	private function onStage(e:Event = null):Void // remove event listener
	{
		removeEventListener(Event.ADDED_TO_STAGE, onStage);

		// set stage properties
		FP.stage = stage;
		setStageProperties();

		// enable input
		Input.enable();

		// switch worlds
		if (FP._goto != null) {
			checkWorld();
		}

		// game start
		init();

		// start game loop
		_rate = 1000 / FP.assignedFrameRate;
		if (FP.fixed)
			// fixed framerate
		{
			_skip = _rate * MAX_FRAMESKIP;
			_last = _prev = Math.round(haxe.Timer.stamp() * 1000);
			_timer = new Timer(TICK_RATE);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		// nonfixed framerate
		else {
			_last = Math.round(haxe.Timer.stamp() * 1000);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}

	/** @private Framerate independent game loop. */
	private function onEnterFrame(e:Event):Void // update timer
	{
		_time = _gameTime = Math.round(haxe.Timer.stamp() * 1000);
		FP._flashTime = Std.int(_time - _flashTime);
		_updateTime = Std.int(_time);
		FP.elapsed = (_time - _last) / 1000;
		if (FP.elapsed > MAX_ELAPSED) {
			FP.elapsed = MAX_ELAPSED;
		}
		FP.elapsed *= FP.rate;
		_last = _time;

		// update console
		if (FP._console != null) {
			FP._console.update();
		}

		// update loop
		if (!paused) {
			update();
		}

		// update input
		Input.update();

		// update timer
		_time = _renderTime = Math.round(haxe.Timer.stamp() * 1000);
		FP._updateTime = Std.int(_time - _updateTime);

		// render loop
		if (!paused) {
			render();
		}

		// update timer
		_time = _flashTime = Math.round(haxe.Timer.stamp() * 1000);
		FP._renderTime = Std.int(_time - _renderTime);
		FP._gameTime = Std.int(_time - _gameTime);
	}

	/** @private Fixed framerate game loop. */
	private function onTimer(e:TimerEvent):Void // update timer
	{
		_time = Math.round(haxe.Timer.stamp() * 1000);
		_delta += (_time - _last);
		_last = _time;

		// quit if a frame hasn't passed
		if (_delta < _rate) {
			return;
		}

		// update timer
		_gameTime = Std.int(_time);
		FP._flashTime = Std.int(_time) - _flashTime;

		// update console
		if (FP._console != null) {
			FP._console.update();
		}

		// update loop
		if (_delta > _skip) {
			_delta = _skip;
		}
		while (_delta > _rate)
			// update timer
		{
			_updateTime = Std.int(_time);
			_delta -= _rate;
			FP.elapsed = (_time - _prev) / 1000;
			if (FP.elapsed > MAX_ELAPSED) {
				FP.elapsed = MAX_ELAPSED;
			}
			FP.elapsed *= FP.rate;
			_prev = _time;

			// update loop
			if (!paused) {
				update();
			}

			// update input
			Input.update();

			// update timer
			_time = Math.round(haxe.Timer.stamp() * 1000);
			FP._updateTime = Std.int(_time - _updateTime);
		}

		// update timer
		_renderTime = Std.int(_time);

		// render loop
		if (!paused) {
			render();
		}

		// update timer
		_time = _flashTime = Math.round(haxe.Timer.stamp() * 1000);
		FP._renderTime = Std.int(_time - _renderTime);
		FP._gameTime = Std.int(_time - _gameTime);
	}

	/** @private Switch Worlds if they've changed. */
	private function checkWorld():Void {
		if (FP._goto == null) {
			return;
		}
		FP._world.end();
		if (FP._world != null && FP._world.autoClear && FP._world._tween != null) {
			FP._world.clearTweens();
		}
		FP._world = FP._goto;
		FP._goto = null;
		FP._world.updateLists();
		FP._world.begin();
		FP._world.updateLists();
	}

	// Timing information.

	/** @private */
	private var _delta:Float = 0;

	/** @private */
	private var _time:Float;

	/** @private */
	private var _last:Float;

	/** @private */
	private var _timer:Timer;

	/** @private */
	private var _rate:Float;

	/** @private */
	private var _skip:Float;

	/** @private */
	private var _prev:Float;

	// Debug timing information.

	/** @private */
	private var _updateTime:Int = 0;

	/** @private */
	private var _renderTime:Int = 0;

	/** @private */
	private var _gameTime:Int = 0;

	/** @private */
	private var _flashTime:Int = 0;

	// Game constants.

	/** @private */
	private var MAX_ELAPSED(default, never):Float = 0.0333;

	/** @private */
	private var MAX_FRAMESKIP(default, never):Float = 5;

	/** @private */
	private var TICK_RATE(default, never):Int = 4;

	// FrameRate tracking.

	/** @private */
	private var _frameLast:Int = 0;

	/** @private */
	private var _frameListSum:Int = 0;

	/** @private */
	private var _frameList:Array<Int> = new Array<Int>();
}
