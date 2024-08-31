package net.flashpunk.utils;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.display.Stage;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.ui.Keyboard;
import openfl.utils.Dictionary;
import net.flashpunk.*;

/**
 * Static class updated by Engine. Use for defining and checking keyboard/mouse input.
 */
class Input {
	public static var mouseWheelDelta(get, never):Int;
	public static var mouseX(get, never):Int;
	public static var mouseY(get, never):Int;
	public static var mouseFlashX(get, never):Int;
	public static var mouseFlashY(get, never):Int;

	/**
	 * An updated string containing the last 100 characters pressed on the keyboard.
	 * Useful for creating text input fields, such as highscore entries, etc.
	 */
	public static var keyString:String = "";

	/**
	 * If the mouse button is down.
	 */
	public static var mouseDown:Bool = false;

	/**
	 * If the mouse button is up.
	 */
	public static var mouseUp:Bool = true;

	/**
	 * If the mouse button was pressed this frame.
	 */
	public static var mousePressed:Bool = false;

	/**
	 * If the mouse button was released this frame.
	 */
	public static var mouseReleased:Bool = false;

	/**
	 * If the mouse wheel was moved this frame.
	 */
	public static var mouseWheel:Bool = false;

	/**
	 * If the mouse wheel was moved this frame, this was the delta.
	 */
	private static function get_mouseWheelDelta():Int {
		if (mouseWheel) {
			mouseWheel = false;
			return _mouseWheelDelta;
		}
		return 0;
	}

	/**
	 * X position of the mouse on the screen.
	 */
	private static function get_mouseX():Int {
		return FP.screen.mouseX;
	}

	/**
	 * Y position of the mouse on the screen.
	 */
	private static function get_mouseY():Int {
		return FP.screen.mouseY;
	}

	/**
	 * The absolute mouse x position on the screen (unscaled).
	 */
	private static function get_mouseFlashX():Int {
		return Std.int(FP.stage.mouseX);
	}

	/**
	 * The absolute mouse y position on the screen (unscaled).
	 */
	private static function get_mouseFlashY():Int {
		return Std.int(FP.stage.mouseY);
	}

	/**
	 * Defines a new input.
	 * @param	name		String to map the input to.
	 * @param	...keys		The keys to use for the Input.
	 */
	public static function define(name:String, keys:Array<Int> = null):Void {
		_control[name] = keys;
	}

	/**
	 * If the input or key is held down.
	 * @param	input		An input name or key to check for.
	 * @return	True or false.
	 */
	public static function check(input:Dynamic):Bool {
		if (Std.is(input, String)) {
			var v:Array<Int> = _control[input];
			var i:Int = v.length;
			while (i-- != 0) {
				if (v[i] < 0) {
					if (_keyNum > 0) {
						return true;
					}
					continue;
				}
				if (_key[v[i]] != null) {
					return true;
				}
			}
			return false;
		}
		return (input < 0) ? _keyNum > 0 : _key[input];
	}

	/**
	 * If the input or key was pressed this frame.
	 * @param	input		An input name or key to check for.
	 * @return	True or false.
	 */
	public static function pressed(input:Dynamic):Bool {
		if (Std.is(input, String)) {
			var v:Array<Int> = _control[input];
			var i:Int = v.length;
			while (i-- != 0) {
				if ((v[i] < 0 && _press.length != 0) || _press.indexOf(v[i]) >= 0) {
					return true;
				}
			}
			return false;
		}
		return (input < 0 && _press.length != 0) || _press.indexOf(input) >= 0;
	}

	/**
	 * If the input or key was released this frame.
	 * @param	input		An input name or key to check for.
	 * @return	True or false.
	 */
	public static function released(input:Dynamic):Bool {
		if (Std.is(input, String)) {
			var v:Array<Int> = _control[input];
			var i:Int = v.length;
			while (i-- > 0) {
				if ((v[i] < 0 && _release.length > 0) || _release.indexOf(v[i]) >= 0) {
					return true;
				}
			}
			return false;
		}
		return (input < 0 && _release.length > 0) || _release.indexOf(input) >= 0;
	}

	/**
	 * Returns the keys mapped to the input name.
	 * @param	name		The input name.
	 * @return	A Vector of keys.
	 */
	public static function keys(name:String):Array<Int> {
		return _control[name];
	}

	/** @private Called by Engine to enable keyboard input on the stage. */
	public static function enable():Void {
		if (!_enabled && (FP.stage != null)) {
			FP.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			FP.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			FP.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			FP.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			FP.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			_enabled = true;
		}
	}

	/** @private Called by Engine to update the input. */
	public static function update():Void {
		while (_pressNum-- != 0) {
			_press[_pressNum] = -1;
		}
		_pressNum = 0;
		while (_releaseNum-- != 0) {
			_release[_releaseNum] = -1;
		}
		_releaseNum = 0;
		if (mousePressed) {
			mousePressed = false;
		}
		if (mouseReleased) {
			mouseReleased = false;
		}
	}

	/**
	 * Clears all input states.
	 */
	public static function clear():Void {
		_pressNum = 0;
		_press = [];
		_releaseNum = 0;
		_release = [];
		var i:Int = _key.length;
		while (i-- != 0) {
			_key[i] = false;
		}
		_keyNum = 0;
	}

	/** @private Event handler for key press. */
	private static function onKeyDown(e:KeyboardEvent = null):Void // get the keycode
	{
		var code:Int = e.keyCode;

		// update the keystring
		if (code == Key.BACKSPACE) {
			keyString = keyString.substring(0, keyString.length - 1);
		} else if ((code > 47 && code < 58) || (code > 64 && code < 91) || code == 32) {
			if (keyString.length > KEYSTRING_MAX) {
				keyString = keyString.substring(1);
			}
			var char:String = String.fromCharCode(code);
			if (e.shiftKey || Keyboard.capsLock) {
				char = char.toUpperCase();
			} else {
				char = char.toLowerCase();
			}
			keyString += char;
		}

		// update the keystate
		if (!_key[code]) {
			_key[code] = true;
			_keyNum++;
			_press[_pressNum++] = code;
		}
	}

	/** @private Event handler for key release. */
	private static function onKeyUp(e:KeyboardEvent):Void // get the keycode and update the keystate
	{
		var code:Int = e.keyCode;
		if (_key[code]) {
			_key[code] = false;
			_keyNum--;
			_release[_releaseNum++] = code;
		}
	}

	/** @private Event handler for mouse press. */
	private static function onMouseDown(e:MouseEvent):Void {
		if (!mouseDown) {
			mouseDown = true;
			mouseUp = false;
			mousePressed = true;
			mouseReleased = false;
		}
	}

	/** @private Event handler for mouse release. */
	private static function onMouseUp(e:MouseEvent):Void {
		mouseDown = false;
		mouseUp = true;
		mousePressed = false;
		mouseReleased = true;
	}

	/** @private Event handler for mouse wheel events */
	private static function onMouseWheel(e:MouseEvent):Void {
		mouseWheel = true;
		_mouseWheelDelta = e.delta;
	}

	// Max amount of characters stored by the keystring.

	/** @private */
	private static inline var KEYSTRING_MAX:Int = 100;

	// Input information.

	/** @private */
	private static var _enabled:Bool = false;

	/** @private */
	private static var _key:Array<Bool> = new Array<Bool>();

	/** @private */
	private static var _keyNum:Int = 0;

	/** @private */
	private static var _press:Array<Int> = new Array<Int>();

	/** @private */
	private static var _release:Array<Int> = new Array<Int>();

	/** @private */
	private static var _pressNum:Int = 0;

	/** @private */
	private static var _releaseNum:Int = 0;

	/** @private */
	private static var _control:Dictionary<String, Array<Int>> = new Dictionary();

	/** @private */
	private static var _mouseWheelDelta:Int = 0;

	public function new() {}
}
