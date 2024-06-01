package net.flashpunk.debug;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFormat;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.utils.Draw;
import net.flashpunk.utils.Input;
import net.flashpunk.utils.Key;

/**
 * FlashPunk debug console; can use to log information or pause the game and view/move Entities and step the frame.
 */
class Console {
	public var visible(get, set):Bool;
	public var paused(get, set):Bool;
	public var debug(get, set):Bool;

	private var width(get, never):Int;
	private var height(get, never):Int;

	/**
	 * The key used to toggle the Console on/off. Tilde (~) by default.
	 */
	public var toggleKey:Int = 192;

	/**
	 * Constructor.
	 */
	public function new() {


		Input.define("_ARROWS", [Key.RIGHT, Key.LEFT, Key.DOWN, Key.UP]);
	}

	/**
	 * Logs data to the console.
	 * @param	...data		The data parameters to log, can be variables, objects, etc. Parameters will be separated by a space (" ").
	 */
	public function log(data:Array<Dynamic> = null):Void {
		var s:String;
		if (data.length > 1) {
			s = "";
			var i:Int = 0;
			while (i < data.length) {
				if (i > 0) {
					s += " ";
				}
				s += Std.string(data[i++]);
			}
		} else {
			s = Std.string(data[0]);
		}
		if (s.indexOf("\n") >= 0) {
			var a:Array<Dynamic> = s.split("\n");
			for (s in a) {
				LOG.push(s);
			}
		} else {
			LOG.push(s);
		}
		if (_enabled && _sprite.visible) {
			updateLog();
		}
	}

	/**
	 * Adds properties to watch in the console's debug panel.
	 * @param	...properties		The properties (strings) to watch.
	 */
	public function watch(properties:Array<Dynamic> = null):Void {
		var i:String;
		if (properties.length > 1) {
			for (i in properties) {
				WATCH_LIST.push(i);
			}
		} else if (Std.is(properties[0], Array)) {
			for (i in (cast properties[0] : Array<Dynamic>)) {
				WATCH_LIST.push(i);
			}
		}
	}

	/**
	 * Enables the console.
	 */
	public function enable():Void // Quit if the console is already enabled.
	{
		if (_enabled) {
			return;
		}

		// Enable it and add the Sprite to the stage.
		_enabled = true;
		FP.engine.addChild(_sprite);

		// Used to determine some text sizing.
		var big:Bool = width >= 480;

		// The transparent FlashPunk logo overlay bitmap.
		_sprite.addChild(_back);
		_back.bitmapData = new BitmapData(width, height, true, 0xFFFFFFFF);
		var b:BitmapData = Type.createInstance(CONSOLE_LOGO, []).bitmapData;
		FP.matrix.identity();
		FP.matrix.tx = Math.max((_back.bitmapData.width - b.width) / 2, 0);
		FP.matrix.ty = Math.max((_back.bitmapData.height - b.height) / 2, 0);
		FP.matrix.scale(Math.min(width / _back.bitmapData.width, 1), Math.min(height / _back.bitmapData.height, 1));
		_back.bitmapData.draw(b, FP.matrix, null, BlendMode.MULTIPLY);
		_back.bitmapData.draw(_back.bitmapData, null, null, BlendMode.INVERT);
		_back.bitmapData.colorTransform(_back.bitmapData.rect, new ColorTransform(1, 1, 1, 0.5));

		// The entity and selection sprites.
		_sprite.addChild(_entScreen);
		_entScreen.addChild(_entSelect);

		// The entity count text.
		_sprite.addChild(_entRead);
		_entRead.addChild(_entReadText);
		_entReadText.defaultTextFormat = format(16, 0xFFFFFF, "right");
		_entReadText.embedFonts = true;
		_entReadText.width = 100;
		_entReadText.height = 20;
		_entRead.x = width - _entReadText.width;

		// The entity count panel.
		_entRead.graphics.clear();
		_entRead.graphics.beginFill(0, .5);
		_entRead.graphics.drawRoundRectComplex(0, 0, _entReadText.width, 20, 0, 0, 20, 0);

		// The FPS text.
		_sprite.addChild(_fpsRead);
		_fpsRead.addChild(_fpsReadText);
		_fpsReadText.defaultTextFormat = format(16);
		_fpsReadText.embedFonts = true;
		_fpsReadText.width = 70;
		_fpsReadText.height = 20;
		_fpsReadText.x = 2;
		_fpsReadText.y = 1;

		// The FPS and frame timing panel.
		_fpsRead.graphics.clear();
		_fpsRead.graphics.beginFill(0, .75);
		_fpsRead.graphics.drawRoundRectComplex(0, 0, (big) ? 200 : 100, 20, 0, 0, 0, 20);

		// The frame timing text.
		if (big) {
			_sprite.addChild(_fpsInfo);
		}
		_fpsInfo.addChild(_fpsInfoText0);
		_fpsInfo.addChild(_fpsInfoText1);
		_fpsInfoText0.defaultTextFormat = format(8, 0xAAAAAA);
		_fpsInfoText1.defaultTextFormat = format(8, 0xAAAAAA);
		_fpsInfoText0.embedFonts = true;
		_fpsInfoText1.embedFonts = true;
		_fpsInfoText0.width = _fpsInfoText1.width = 60;
		_fpsInfoText0.height = _fpsInfoText1.height = 20;
		_fpsInfo.x = 75;
		_fpsInfoText1.x = 60;

		// The output log text.
		_sprite.addChild(_logRead);
		_logRead.addChild(_logReadText0);
		_logRead.addChild(_logReadText1);
		_logReadText0.defaultTextFormat = format(16, 0xFFFFFF);
		_logReadText1.defaultTextFormat = format((big) ? 16 : 8, 0xFFFFFF);
		_logReadText0.embedFonts = true;
		_logReadText1.embedFonts = true;
		_logReadText0.selectable = false;
		_logReadText0.width = 80;
		_logReadText0.height = 20;
		_logReadText1.width = width;
		_logReadText0.x = 2;
		_logReadText0.y = 3;
		_logReadText0.text = "OUTPUT:";
		_logHeight = height - 60;
		_logBar = new Rectangle(8, 24, 16, _logHeight - 8);
		_logBarGlobal = _logBar.clone();
		_logBarGlobal.y += 40;
		_logLines = (cast _logHeight / ((big) ? 16.5 : 8.5) : Int);

		// The debug text.
		_sprite.addChild(_debRead);
		_debRead.addChild(_debReadText0);
		_debRead.addChild(_debReadText1);
		_debReadText0.defaultTextFormat = format(16, 0xFFFFFF);
		_debReadText1.defaultTextFormat = format(8, 0xFFFFFF);
		_debReadText0.embedFonts = true;
		_debReadText1.embedFonts = true;
		_debReadText0.selectable = false;
		_debReadText0.width = 80;
		_debReadText0.height = 20;
		_debReadText1.width = 160;
		_debReadText1.height = as3hx.Compat.parseInt(height / 4);
		_debReadText0.x = 2;
		_debReadText0.y = 3;
		_debReadText1.x = 2;
		_debReadText1.y = 24;
		_debReadText0.text = "DEBUG:";
		_debRead.y = height - (_debReadText1.y + _debReadText1.height);

		// The button panel buttons.
		_sprite.addChild(_butRead);
		_butRead.addChild(_butDebug = Type.createInstance(CONSOLE_DEBUG, []));
		_butRead.addChild(_butOutput = Type.createInstance(CONSOLE_OUTPUT, []));
		_butRead.addChild(_butPlay = Type.createInstance(CONSOLE_PLAY, [])).x = 20;
		_butRead.addChild(_butPause = Type.createInstance(CONSOLE_PAUSE, [])).x = 20;
		_butRead.addChild(_butStep = Type.createInstance(CONSOLE_STEP, [])).x = 40;
		updateButtons();

		// The button panel.
		_butRead.graphics.clear();
		_butRead.graphics.beginFill(0, .75);
		_butRead.graphics.drawRoundRectComplex(-20, 0, 100, 20, 0, 0, 20, 20);

		// Set the state to unpaused.
		paused = false;
	}

	/**
	 * If the console should be visible.
	 */
	private function get_visible():Bool {
		return _sprite.visible;
	}

	private function set_visible(value:Bool):Bool {
		_sprite.visible = value;
		if (_enabled && value) {
			updateLog();
		}
		return value;
	}

	/**
	 * Console update, called by game loop.
	 */
	public function update():Void // Quit if the console isn't enabled.
	{
		if (!_enabled) {
			return;
		}

		// If the console is paused.
		if (_paused)
			// Update buttons.
		{
			updateButtons();

			// While in debug mode.
			if (_debug)
				// While the game is paused.
			{
				if (FP.engine.paused)
					// When the mouse is pressed.
				{
					if (Input.mousePressed)
						// Mouse is within clickable area.
					{
						if (Input.mouseFlashY > 20 && (Input.mouseFlashX > _debReadText1.width || Input.mouseFlashY < _debRead.y)) {
							if (Input.check(Key.SHIFT)) {
								if (SELECT_LIST.length != 0) {
									startDragging();
								} else {
									startPanning();
								}
							} else {
								startSelection();
							}
						}
					}
					// Update mouse movement functions.
					else {
						if (_selecting) {
							updateSelection();
						}
						if (_dragging) {
							updateDragging();
						}
						if (_panning) {
							updatePanning();
						}
					}

					// Select all Entities
					if (Input.pressed(Key.A)) {
						selectAll();
					}

					// If the shift key is held.
					if (Input.check(Key.SHIFT))
						// If Entities are selected.
					{
						if (SELECT_LIST.length != 0)
							// Move Entities with the arrow keys.
						{
							if (Input.pressed("_ARROWS")) {
								updateKeyMoving();
							}
						}
						// Pan the camera with the arrow keys.
						else {
							if (Input.check("_ARROWS")) {
								updateKeyPanning();
							}
						}
					}
				}
				// Update info while the game runs.
				else {
					updateEntityLists(FP.world.count != ENTITY_LIST.length);
					renderEntities();
					updateFPSRead();
					updateEntityCount();
				}

				// Update debug panel.
				updateDebugRead();
			}
			// log scrollbar
			else {
				if (_scrolling) {
					updateScrolling();
				} else if (Input.mousePressed) {
					startScrolling();
				}
			}
		}
		// Update info while the game runs.
		else {
			updateFPSRead();
			updateEntityCount();
		}

		// Console toggle.
		if (Input.pressed(toggleKey)) {
			paused = !_paused;
		}
	}

	/**
	 * If the Console is currently in paused mode.
	 */
	private function get_paused():Bool {
		return _paused;
	}

	private function set_paused(value:Bool):Bool // Quit if the console isn't enabled.
	{
		if (!_enabled) {
			return value;
		}

		// Set the console to paused.
		_paused = value;
		FP.engine.paused = value;

		// Panel visibility.
		_back.visible = value;
		_entScreen.visible = value;
		_butRead.visible = value;

		// If the console is paused.
		if (value)
			// Set the console to paused mode.
		{
			if (_debug) {
				debug = true;
			} else {
				updateLog();
			}
		}
		// Set the console to running mode.
		else {
			_debRead.visible = false;
			_logRead.visible = true;
			updateLog();
			while (ENTITY_LIST.length > 0) {
				ENTITY_LIST.pop();
			}
			while (SCREEN_LIST.length > 0) {
				SCREEN_LIST.pop();
			}
			while (SELECT_LIST.length > 0) {
				SELECT_LIST.pop();
			}
		}
		return value;
	}

	/**
	 * If the Console is currently in debug mode.
	 */
	private function get_debug():Bool {
		return _debug;
	}

	private function set_debug(value:Bool):Bool // Quit if the console isn't enabled.
	{
		if (!_enabled) {
			return value;
		}

		// Set the console to debug mode.
		_debug = value;
		_debRead.visible = value;
		_logRead.visible = !value;

		// Update console state.
		if (value) {
			updateEntityLists();
		} else {
			updateLog();
		}
		renderEntities();
		return value;
	}

	/** @private Steps the frame ahead. */
	private function stepFrame():Void {
		FP.engine.update();
		FP.engine.render();
		updateEntityCount();
		updateEntityLists();
		renderEntities();
	}

	/** @private Starts Entity dragging. */
	private function startDragging():Void {
		_dragging = true;
		_entRect.x = Input.mouseX;
		_entRect.y = Input.mouseY;
	}

	/** @private Updates Entity dragging. */
	private function updateDragging():Void {
		moveSelected((cast Input.mouseX - _entRect.x:Int), (cast Input.mouseY - _entRect.y:Int));
		_entRect.x = Input.mouseX;
		_entRect.y = Input.mouseY;
		if (Input.mouseReleased) {
			_dragging = false;
		}
	}

	/** @private Move the selected Entitites by the amount. */
	private function moveSelected(xDelta:Int, yDelta:Int):Void {
		for (e /* AS3HX WARNING could not determine type for var: e exp: EIdent(SELECT_LIST) type: null */ in SELECT_LIST) {
			e.x += xDelta;
			e.y += yDelta;
		}
		FP.engine.render();
		renderEntities();
		updateEntityLists(true);
	}

	/** @private Starts camera panning. */
	private function startPanning():Void {
		_panning = true;
		_entRect.x = Input.mouseX;
		_entRect.y = Input.mouseY;
	}

	/** @private Updates camera panning. */
	private function updatePanning():Void {
		if (Input.mouseReleased) {
			_panning = false;
		}
		panCamera((cast _entRect.x - Input.mouseX:Int), (cast _entRect.y - Input.mouseY:Int));
		_entRect.x = Input.mouseX;
		_entRect.y = Input.mouseY;
	}

	/** @private Pans the camera. */
	private function panCamera(xDelta:Int, yDelta:Int):Void {
		FP.camera.x += xDelta;
		FP.camera.y += yDelta;
		FP.engine.render();
		updateEntityLists(true);
		renderEntities();
	}

	/** @private Sets the camera position. */
	private function setCamera(x:Int, y:Int):Void {
		FP.camera.x = x;
		FP.camera.y = y;
		FP.engine.render();
		updateEntityLists(true);
		renderEntities();
	}

	/** @private Starts Entity selection. */
	private function startSelection():Void {
		_selecting = true;
		_entRect.x = Input.mouseFlashX;
		_entRect.y = Input.mouseFlashY;
		_entRect.width = 0;
		_entRect.height = 0;
	}

	/** @private Updates Entity selection. */
	private function updateSelection():Void {
		_entRect.width = Input.mouseFlashX - _entRect.x;
		_entRect.height = Input.mouseFlashY - _entRect.y;
		if (Input.mouseReleased) {
			selectEntities(_entRect);
			renderEntities();
			_selecting = false;
			_entSelect.graphics.clear();
		} else {
			_entSelect.graphics.clear();
			_entSelect.graphics.lineStyle(1, 0xFFFFFF);
			_entSelect.graphics.drawRect(_entRect.x, _entRect.y, _entRect.width, _entRect.height);
		}
	}

	/** @private Selects the Entitites in the rectangle. */
	private function selectEntities(rect:Rectangle):Void {
		if (rect.width < 0) {
			rect.x -= (rect.width = -rect.width);
		} else if (rect.width == 0) {
			rect.width = 1;
		}
		if (rect.height < 0) {
			rect.y -= (rect.height = -rect.height);
		} else if (rect.height == 0) {
			rect.height = 1;
		}

		FP.rect.width = FP.rect.height = 6;
		var sx:Float = FP.screen.scaleX * FP.screen.scale;
		var sy:Float = FP.screen.scaleY * FP.screen.scale;
		var e:Entity;

		if (Input.check(Key.CONTROL))
			// Append selected Entitites with new selections.
		{
			for (e /* AS3HX WARNING could not determine type for var: e exp: EIdent(SCREEN_LIST) type: null */ in SCREEN_LIST) {
				if (SELECT_LIST.indexOf(e) < 0) {
					FP.rect.x = (e.x - FP.camera.x) * sx - 3;
					FP.rect.y = (e.y - FP.camera.y) * sy - 3;
					if (rect.intersects(FP.rect)) {
						SELECT_LIST.push(e);
					}
				}
			}
		}
		// Replace selections with new selections.
		else {
			while (SELECT_LIST.length > 0) {
				SELECT_LIST.pop();
			}
			for (e /* AS3HX WARNING could not determine type for var: e exp: EIdent(SCREEN_LIST) type: null */ in SCREEN_LIST) {
				FP.rect.x = (e.x - FP.camera.x) * sx - 3;
				FP.rect.y = (e.y - FP.camera.y) * sy - 3;
				if (rect.intersects(FP.rect)) {
					SELECT_LIST.push(e);
				}
			}
		}
	}

	/** @private Selects all entities on screen. */
	private function selectAll():Void {
		while (SELECT_LIST.length > 0) {
			SELECT_LIST.pop();
		}
		for (e /* AS3HX WARNING could not determine type for var: e exp: EIdent(SCREEN_LIST) type: null */ in SCREEN_LIST) {
			SELECT_LIST.push(e);
		}
		renderEntities();
	}

	/** @private Starts log text scrolling. */
	private function startScrolling():Void {
		if (LOG.length > _logLines) {
			_scrolling = _logBarGlobal.contains(Input.mouseFlashX, Input.mouseFlashY);
		}
	}

	/** @private Updates log text scrolling. */
	private function updateScrolling():Void {
		_scrolling = Input.mouseDown;
		_logScroll = FP.scaleClamp(Input.mouseFlashY, _logBarGlobal.y, _logBarGlobal.bottom, 0, 1);
		updateLog();
	}

	/** @private Moves Entities with the arrow keys. */
	private function updateKeyMoving():Void {
		FP.point.x = ((Input.pressed(Key.RIGHT)) ? 1 : 0) - ((Input.pressed(Key.LEFT)) ? 1 : 0);
		FP.point.y = ((Input.pressed(Key.DOWN)) ? 1 : 0) - ((Input.pressed(Key.UP)) ? 1 : 0);
		if (FP.point.x != 0 || FP.point.y != 0) {
			moveSelected((cast FP.point.x : Int), (cast FP.point.y : Int));
		}
	}

	/** @private Pans the camera with the arrow keys. */
	private function updateKeyPanning():Void {
		FP.point.x = ((Input.check(Key.RIGHT)) ? 1 : 0) - ((Input.check(Key.LEFT)) ? 1 : 0);
		FP.point.y = ((Input.check(Key.DOWN)) ? 1 : 0) - ((Input.check(Key.UP)) ? 1 : 0);
		if (FP.point.x != 0 || FP.point.y != 0) {
			panCamera((cast FP.point.x : Int), (cast FP.point.y : Int));
		}
	}

	/** @private Update the Entity list information. */
	private function updateEntityLists(fetchList:Bool = true):Void // If the list should be re-populated.
	{
		if (fetchList) {
			while (ENTITY_LIST.length > 0) {
				ENTITY_LIST.pop();
			}
			FP.world.getAll(ENTITY_LIST);
		}

		// Update the list of Entities on screen.
		while (SCREEN_LIST.length > 0) {
			SCREEN_LIST.pop();
		}
		for (e /* AS3HX WARNING could not determine type for var: e exp: EIdent(ENTITY_LIST) type: null */ in ENTITY_LIST) {
			if (e.collideRect(e.x, e.y, FP.camera.x, FP.camera.y, FP.width, FP.height)) {
				SCREEN_LIST.push(e);
			}
		}
	}

	/** @private Renders the Entities positions and hitboxes. */
	private function renderEntities():Void // If debug mode is on.
	{
		_entScreen.visible = _debug;
		if (_debug) {
			var g:Graphics = _entScreen.graphics;
			var sx:Float = FP.screen.scaleX * FP.screen.scale;
			var sy:Float = FP.screen.scaleY * FP.screen.scale;
			g.clear();
			for (e /* AS3HX WARNING could not determine type for var: e exp: EIdent(SCREEN_LIST) type: null */ in SCREEN_LIST)
				// If the Entity is not selected.
			{
				if (SELECT_LIST.indexOf(e) < 0)
					// Draw the normal hitbox and position.
				{
					if (e.width != 0 && e.height != 0) {
						g.lineStyle(1, 0xFF0000);
						g.drawRect((e.x - e.originX - FP.camera.x) * sx, (e.y - e.originY - FP.camera.y) * sy, e.width * sx, e.height * sy);
					}
					g.lineStyle(1, 0x00FF00);
					g.drawRect((e.x - FP.camera.x) * sx - 3, (e.y - FP.camera.y) * sy - 3, 6, 6);
				}
				// Draw the selected hitbox and position.
				else {
					if (e.width != 0 && e.height != 0) {
						g.lineStyle(1, 0xFFFFFF);
						g.drawRect((e.x - e.originX - FP.camera.x) * sx, (e.y - e.originY - FP.camera.y) * sy, e.width * sx, e.height * sy);
					}
					g.lineStyle(1, 0xFFFFFF);
					g.drawRect((e.x - FP.camera.x) * sx - 3, (e.y - FP.camera.y) * sy - 3, 6, 6);
				}
			}
		}
	}

	/** @private Updates the log window. */
	private function updateLog():Void // If the console is paused.
	{
		if (_paused)
			// Draw the log panel.
		{
			_logRead.y = 40;
			_logRead.graphics.clear();
			_logRead.graphics.beginFill(0, .75);
			_logRead.graphics.drawRoundRectComplex(0, 0, _logReadText0.width, 20, 0, 20, 0, 0);
			_logRead.graphics.drawRect(0, 20, width, _logHeight);

			// Draw the log scrollbar.
			_logRead.graphics.beginFill(0x202020, 1);
			_logRead.graphics.drawRoundRectComplex(_logBar.x, _logBar.y, _logBar.width, _logBar.height, 8, 8, 8, 8);

			// If the log has more lines than the display limit.
			if (LOG.length > _logLines)
				// Draw the log scrollbar handle.
			{
				_logRead.graphics.beginFill(0xFFFFFF, 1);
				var h:Int = (cast FP.clamp(_logBar.height * (_logLines / LOG.length), 12, _logBar.height - 4) : Int);
				var y:Int = as3hx.Compat.parseInt(_logBar.y + 2 + (_logBar.height - 16) * _logScroll);
				_logRead.graphics.drawRoundRectComplex(_logBar.x + 2, y, 12, 12, 6, 6, 6, 6);
			}

			// Display the log text lines.
			if (LOG.length != 0) {
				var i:Int = (LOG.length > _logLines) ? Math.round((LOG.length - _logLines) * _logScroll) : 0;
				var n:Int = as3hx.Compat.parseInt(i + Math.min(_logLines, LOG.length));
				var s:String = "";
				while (i < n) {
					s += LOG[i++] + "\n";
				}
				_logReadText1.text = s;
			} else {
				_logReadText1.text = "";
			}

			// Indent the text for the scrollbar and size it to the log panel.
			_logReadText1.height = _logHeight;
			_logReadText1.x = 32;
			_logReadText1.y = 24;

			// Make text selectable in paused mode.
			_fpsReadText.selectable = true;
			_fpsInfoText0.selectable = true;
			_fpsInfoText1.selectable = true;
			_entReadText.selectable = true;
			_debReadText1.selectable = true;
		}
		// Draw the single-line log panel.
		else {
			_logRead.y = height - 40;
			_logReadText1.height = 20;
			_logRead.graphics.clear();
			_logRead.graphics.beginFill(0, .75);
			_logRead.graphics.drawRoundRectComplex(0, 0, _logReadText0.width, 20, 0, 20, 0, 0);
			_logRead.graphics.drawRect(0, 20, width, 20);

			// Draw the single-line log text with the latests logged text.
			_logReadText1.text = (LOG.length != 0) ? LOG[LOG.length - 1] : "";
			_logReadText1.x = 2;
			_logReadText1.y = 21;

			// Make text non-selectable while running.
			_logReadText1.selectable = false;
			_fpsReadText.selectable = false;
			_fpsInfoText0.selectable = false;
			_fpsInfoText1.selectable = false;
			_entReadText.selectable = false;
			_debReadText0.selectable = false;
			_debReadText1.selectable = false;
		}
	}

	/** @private Update the FPS/frame timing panel text. */
	private function updateFPSRead():Void {
		_fpsReadText.text = "FPS: " + Std.string(FP.frameRate);
		_fpsInfoText0.text = "Update: " + Std.string(FP._updateTime) + "ms\n" + "Render: " + Std.string(FP._renderTime) + "ms";
		_fpsInfoText1.text = "Game: " + Std.string(FP._gameTime) + "ms\n" + "Flash: " + Std.string(FP._flashTime) + "ms";
	}

	/** @private Update the debug panel text. */
	private function updateDebugRead():Void // Find out the screen size and set the text.
	{
		var big:Bool = width >= 480;

		// Update the Debug read text.
		var s:String = "Mouse: " + Std.string(FP.world.mouseX) + ", " + Std.string(FP.world.mouseY) + "\nCamera: " + Std.string(FP.camera.x) + ", "
			+ Std.string(FP.camera.y);
		if (SELECT_LIST.length != 0) {
			if (SELECT_LIST.length > 1) {
				s += "\n\nSelected: " + Std.string(SELECT_LIST.length);
			} else {
				var e:Entity = SELECT_LIST[0];
				s += "\n\n- " + Std.string(e) + " -\n";
				for (i /* AS3HX WARNING could not determine type for var: i exp: EIdent(WATCH_LIST) type: null */ in WATCH_LIST) {
					if (Reflect.hasField(e, i)) {
						s += "\n" + i + ": " + Std.string(Reflect.field(e, i));
					}
				}
			}
		}

		// Set the text and format.
		_debReadText1.text = s;
		_debReadText1.setTextFormat(format((big) ? 16 : 8));
		_debReadText1.width = Math.max(_debReadText1.textWidth + 4, _debReadText0.width);
		_debReadText1.height = _debReadText1.y + _debReadText1.textHeight + 4;

		// The debug panel.
		_debRead.y = as3hx.Compat.parseInt(height - _debReadText1.height);
		_debRead.graphics.clear();
		_debRead.graphics.beginFill(0, .75);
		_debRead.graphics.drawRoundRectComplex(0, 0, _debReadText0.width, 20, 0, 20, 0, 0);
		_debRead.graphics.drawRoundRectComplex(0, 20, _debReadText1.width + 20, height - _debRead.y - 20, 0, 20, 0, 0);
	}

	/** @private Updates the Entity count text. */
	private function updateEntityCount():Void {
		_entReadText.text = Std.string(FP.world.count) + " Entities";
	}

	/** @private Updates the Button panel. */
	private function updateButtons():Void // Button visibility.
	{
		_butRead.x = _fpsInfo.x + _fpsInfo.width + as3hx.Compat.parseInt((_entRead.x - (_fpsInfo.x + _fpsInfo.width)) / 2) - 30;
		_butDebug.visible = !_debug;
		_butOutput.visible = _debug;
		_butPlay.visible = FP.engine.paused;
		_butPause.visible = !FP.engine.paused;

		// Debug/Output button.
		if (_butDebug.bitmapData.rect.contains(_butDebug.mouseX, _butDebug.mouseY)) {
			_butDebug.alpha = _butOutput.alpha = 1;
			if (Input.mousePressed) {
				debug = !_debug;
			}
		} else {
			_butDebug.alpha = _butOutput.alpha = .5;
		}

		// Play/Pause button.
		if (_butPlay.bitmapData.rect.contains(_butPlay.mouseX, _butPlay.mouseY)) {
			_butPlay.alpha = _butPause.alpha = 1;
			if (Input.mousePressed) {
				FP.engine.paused = !FP.engine.paused;
				renderEntities();
			}
		} else {
			_butPlay.alpha = _butPause.alpha = .5;
		}

		// Frame step button.
		if (_butStep.bitmapData.rect.contains(_butStep.mouseX, _butStep.mouseY)) {
			_butStep.alpha = 1;
			if (Input.mousePressed) {
				stepFrame();
			}
		} else {
			_butStep.alpha = .5;
		}
	}

	/** @private Gets a TextFormat object with the formatting. */
	private function format(size:Int = 16, color:Int = 0xFFFFFF, align:String = "left"):TextFormat {
		_format.size = size;
		_format.color = color;
		_format.align = align;
		return _format;
	}

	/**
	 * Get the unscaled screen size for the Console.
	 */
	private function get_width():Int {
		return as3hx.Compat.parseInt(FP.screen.width * FP.screen.scaleX * FP.screen.scale);
	}

	private function get_height():Int {
		return as3hx.Compat.parseInt(FP.screen.height * FP.screen.scaleY * FP.screen.scale);
	}

	// Console state information.

	/** @private */
	private var _enabled:Bool;

	/** @private */
	private var _paused:Bool;

	/** @private */
	private var _debug:Bool;

	/** @private */
	private var _scrolling:Bool;

	/** @private */
	private var _selecting:Bool;

	/** @private */
	private var _dragging:Bool;

	/** @private */
	private var _panning:Bool;

	// Console display objects.

	/** @private */
	private var _sprite:Sprite = new Sprite();

	/** @private */
	private var _format:TextFormat = new TextFormat("console");

	/** @private */
	private var _back:Bitmap = new Bitmap();

	// FPS panel information.

	/** @private */
	private var _fpsRead:Sprite = new Sprite();

	/** @private */
	private var _fpsReadText:TextField = new TextField();

	/** @private */
	private var _fpsInfo:Sprite = new Sprite();

	/** @private */
	private var _fpsInfoText0:TextField = new TextField();

	/** @private */
	private var _fpsInfoText1:TextField = new TextField();

	// Output panel information.

	/** @private */
	private var _logRead:Sprite = new Sprite();

	/** @private */
	private var _logReadText0:TextField = new TextField();

	/** @private */
	private var _logReadText1:TextField = new TextField();

	/** @private */
	private var _logHeight:Int;

	/** @private */
	private var _logBar:Rectangle;

	/** @private */
	private var _logBarGlobal:Rectangle;

	/** @private */
	private var _logScroll:Float = 0;

	// Entity count panel information.

	/** @private */
	private var _entRead:Sprite = new Sprite();

	/** @private */
	private var _entReadText:TextField = new TextField();

	// Debug panel information.

	/** @private */
	private var _debRead:Sprite = new Sprite();

	/** @private */
	private var _debReadText0:TextField = new TextField();

	/** @private */
	private var _debReadText1:TextField = new TextField();

	/** @private */
	private var _debWidth:Int;

	// Button panel information

	/** @private */
	private var _butRead:Sprite = new Sprite();

	/** @private */
	private var _butDebug:Bitmap;

	/** @private */
	private var _butOutput:Bitmap;

	/** @private */
	private var _butPlay:Bitmap;

	/** @private */
	private var _butPause:Bitmap;

	/** @private */
	private var _butStep:Bitmap;

	// Entity selection information.

	/** @private */
	private var _entScreen:Sprite = new Sprite();

	/** @private */
	private var _entSelect:Sprite = new Sprite();

	/** @private */
	private var _entRect:Rectangle = new Rectangle();

	// Log information.

	/** @private */
	private var _logLines:Int = 33;

	/** @private */
	private var LOG(default, never):Array<String> = new Array<String>();

	// Entity lists.

	/** @private */
	private var ENTITY_LIST(default, never):Array<Entity> = new Array<Entity>();

	/** @private */
	private var SCREEN_LIST(default, never):Array<Entity> = new Array<Entity>();

	/** @private */
	private var SELECT_LIST(default, never):Array<Entity> = new Array<Entity>();

	// Watch information.

	/** @private */
	private var WATCH_LIST(default, never):Array<String> = ["x", "y"];

	// Embedded assets.
	@:meta(Embed(source = "../graphics/04B_03__.TTF", fontFamily = "console"))
	private var FONT_SMALL(default, never):Class<Dynamic>;
	@:meta(Embed(source = "console_logo.png"))
	private var CONSOLE_LOGO(default, never):Class<Dynamic>;
	@:meta(Embed(source = "console_debug.png"))
	private var CONSOLE_DEBUG(default, never):Class<Dynamic>;
	@:meta(Embed(source = "console_output.png"))
	private var CONSOLE_OUTPUT(default, never):Class<Dynamic>;
	@:meta(Embed(source = "console_play.png"))
	private var CONSOLE_PLAY(default, never):Class<Dynamic>;
	@:meta(Embed(source = "console_pause.png"))
	private var CONSOLE_PAUSE(default, never):Class<Dynamic>;
	@:meta(Embed(source = "console_step.png"))
	private var CONSOLE_STEP(default, never):Class<Dynamic>;
}
