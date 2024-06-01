package net.flashpunk;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import haxe.Constraints.Function;
import openfl.events.Event;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.utils.Dictionary;

/**
 * Sound effect object used to play embedded sounds.
 */
class Sfx {
	public var volume(get, set):Float;
	public var pan(get, set):Float;
	public var playing(get, never):Bool;
	public var position(get, never):Float;
	public var length(get, never):Float;

	/**
	 * Optional callback function for when the sound finishes playing.
	 */
	public var complete:Function;

	/**
	 * Creates a sound effect from an embedded source. Store a reference to
	 * this object so that you can play the sound using play() or loop().
	 * @param	source		The embedded sound class to use.
	 * @param	complete	Optional callback function for when the sound finishes playing.
	 */
	public function new(source:Sound, complete:Function = null) {
		_sound = source;
		this.complete = complete;
	}

	/**
	 * Plays the sound once.
	 * @param	vol		Volume factor, a value from 0 to 1.
	 * @param	pan		Panning factor, a value from -1 to 1.
	 */
	public function play(vol:Float = 1, pan:Float = 0):Void {
		if (_channel != null) {
			stop();
		}
		_vol = _transform.volume = (vol < 0) ? 0 : vol;
		_pan = _transform.pan = pan < -(1) ? -1 : ((pan > 1) ? 1 : pan);
		_channel = _sound.play(0, 0, _transform);
		_channel.addEventListener(Event.SOUND_COMPLETE, onComplete);
		_position = 0;
		_looping = false;
	}

	/**
	 * Plays the sound looping. Will loop continuously until you call stop(), play(), or loop() again.
	 * @param	vol		Volume factor, a value from 0 to 1.
	 * @param	pan		Panning factor, a value from -1 to 1.
	 */
	public function loop(vol:Float = 1, pan:Float = 0):Void {
		if (_channel != null) {
			stop();
		}
		_vol = _transform.volume = (vol < 0) ? 0 : vol;
		_pan = _transform.pan = pan < -(1) ? -1 : ((pan > 1) ? 1 : pan);
		_channel = _sound.play(0, 0xFFFFFF, _transform);
		_channel.addEventListener(Event.SOUND_COMPLETE, onComplete);
		_position = 0;
		_looping = true;
	}

	/**
	 * Stops the sound if it is currently playing.
	 * @return
	 */
	public function stop():Bool {
		if (_channel == null) {
			return false;
		}
		_position = _channel.position;
		_channel.removeEventListener(Event.SOUND_COMPLETE, onComplete);
		_channel.stop();
		_channel = null;
		return true;
	}

	/**
	 * Resumes the sound from the position stop() was called on it.
	 */
	public function resume():Void {
		_channel = _sound.play(_position, (_looping) ? 0xFFFFFF : 0, _transform);
		_channel.addEventListener(Event.SOUND_COMPLETE, onComplete);
	}

	/** @private Event handler for sound completion. */
	private function onComplete(e:Event = null):Void {
		if (!_looping) {
			_channel.removeEventListener(Event.SOUND_COMPLETE, onComplete);
			_channel.stop();
			_channel = null;
			_position = 0;
		}
		if (complete != null) {
			complete();
		}
	}

	/**
	 * Alter the volume factor (a value from 0 to 1) of the sound during playback.
	 */
	private function get_volume():Float {
		return _vol;
	}

	private function set_volume(value:Float):Float {
		if (value < 0) {
			value = 0;
		}
		if (_channel == null || _vol == value) {
			return value;
		}
		_vol = _transform.volume = value;
		_channel.soundTransform = _transform;
		return value;
	}

	/**
	 * Alter the panning factor (a value from -1 to 1) of the sound during playback.
	 */
	private function get_pan():Float {
		return _pan;
	}

	private function set_pan(value:Float):Float {
		if (value < -1) {
			value = -1;
		}
		if (value > 1) {
			value = 1;
		}
		if (_channel == null || _pan == value) {
			return value;
		}
		_pan = _transform.pan = value;
		_channel.soundTransform = _transform;
		return value;
	}

	/**
	 * If the sound is currently playing.
	 */
	private function get_playing():Bool {
		return _channel != null;
	}

	/**
	 * Position of the currently playing sound, in seconds.
	 */
	private function get_position():Float {
		return ((_channel != null) ? _channel.position : _position) / 1000;
	}

	/**
	 * Length of the sound, in seconds.
	 */
	private function get_length():Float {
		return _sound.length / 1000;
	}

	// Sound infromation.

	/** @private */
	private var _vol:Float = 1;

	/** @private */
	private var _pan:Float = 0;

	/** @private */
	private var _sound:Sound;

	/** @private */
	public var _channel:SoundChannel;

	/** @private */
	private var _transform:SoundTransform = new SoundTransform();

	/** @private */
	private var _position:Float = 0;

	/** @private */
	private var _looping:Bool;

	// Stored Sound objects.

	/** @private */
	private static var _sounds:Dictionary<Class<Dynamic>, Dynamic> = new Dictionary();
}
