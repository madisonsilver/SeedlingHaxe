package net.flashpunk.graphics;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextLineMetrics;
import net.flashpunk.FP;
import net.flashpunk.Graphic;

/**
 * Used for drawing text using embedded fonts.
 */
class Text extends Image {
	public var text(get, set):String;
	public var font(get, set):String;
	public var size(get, set):Int;

	/**
	 * The font to assign to new Text objects.
	 */
	public static var static_font:String = "default";

	/**
	 * The font size to assign to new Text objects.
	 */
	public static var static_size:Int = 16;

	/**
	 * Constructor.
	 * @param	text		Text to display.
	 * @param	x			X offset.
	 * @param	y			Y offset.
	 * @param	width		Image width (leave as 0 to size to the starting text string).
	 * @param	height		Image height (leave as 0 to size to the starting text string).
	 */
	public function new(text:String, x:Float = 0, y:Float = 0, width:Int = 0, height:Int = 0) {
		_field.embedFonts = true;
		_field.defaultTextFormat = _form = new TextFormat(Text.static_font, Text.static_size, 0xFFFFFF);
		_field.text = _text = text;
		if (width == 0) {
			width = Std.int(_field.textWidth + 4);
		}
		if (height == 0) {
			height = Std.int(_field.textHeight + 4);
		}
		_source = new BitmapData(width, height, true, 0);
		super(_source);
		updateBuffer();
		this.x = x;
		this.y = y;
	}

	/** @private Updates the drawing buffer. */
	override public function updateBuffer():Void {
		_field.setTextFormat(_form);
		_field.width = _width = Std.int(_field.textWidth + 4);
		_field.height = _height = Std.int(_field.textHeight + 4);
		_source.fillRect(_sourceRect, 0);
		_source.draw(_field);
		super.updateBuffer();
	}

	/** @private Centers the Text's originX/Y to its center. */
	override public function centerOrigin():Void {
		originX = Std.int(_width / 2);
		originY = Std.int(_height / 2);
	}

	/**
	 * Text string.
	 */
	private function get_text():String {
		return _text;
	}

	private function set_text(value:String):String {
		if (_text == value) {
			return value;
		}
		_field.text = _text = value;
		updateBuffer();
		return value;
	}

	/**
	 * Font family.
	 */
	private function get_font():String {
		return _font;
	}

	private function set_font(value:String):String {
		if (_font == value) {
			return value;
		}
		_form.font = _font = value;
		updateBuffer();
		return value;
	}

	/**
	 * Font size.
	 */
	private function get_size():Int {
		return _size;
	}

	private function set_size(value:Int):Int {
		if (_size == value) {
			return value;
		}
		_form.size = _size = value;
		updateBuffer();
		return value;
	}

	/**
	 * Width of the text image.
	 */
	override private function get_width():Int {
		return _width;
	}

	/**
	 * Height of the text image.
	 */
	override private function get_height():Int {
		return _height;
	}

	// Text information.

	/** @private */
	private var _field:TextField = new TextField();

	/** @private */
	private var _width:Int = 0;

	/** @private */
	private var _height:Int = 0;

	/** @private */
	private var _form:TextFormat;

	/** @private */
	private var _text:String;

	/** @private */
	private var _font:String;

	/** @private */
	private var _size:Int = 0;

	// Default font family.
	// Use this option when compiling with Flex SDK 4
	// [Embed(source = '04B_03__.TTF', embedAsCFF="false", fontFamily = 'default')]
	// Use this option when compiling with Flex SDK <4
	@:meta(Embed(source = "04B_03__.TTF", fontFamily = "default"))
	/** @private */
	private static var _FONT_DEFAULT:Class<Dynamic>;
}
