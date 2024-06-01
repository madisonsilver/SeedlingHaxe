package net.flashpunk.graphics;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.errors.Error;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import net.flashpunk.Graphic;
import net.flashpunk.FP;

/**
 * A canvas to which Tiles can be drawn for fast multiple tile rendering.
 */
class Tilemap extends Canvas {
	public var tileWidth(get, never):Int;
	public var tileHeight(get, never):Int;

	/**
	 * If x/y positions should be used instead of columns/rows.
	 */
	public var usePositions:Bool;

	/**
	 * Constructor.
	 * @param	tileset			The source tileset image.
	 * @param	width			Width of the tilemap, in pixels.
	 * @param	height			Height of the tilemap, in pixels.
	 * @param	tileWidth		Tile width.
	 * @param	tileHeight		Tile height.
	 */
	public function new(tileset:Dynamic, width:Int, height:Int, tileWidth:Int, tileHeight:Int) {


		// set some tilemap information
		_width = as3hx.Compat.parseInt(width - (width % tileWidth));
		_height = as3hx.Compat.parseInt(height - (height % tileHeight));
		_columns = as3hx.Compat.parseInt(_width / tileWidth);
		_rows = as3hx.Compat.parseInt(_height / tileHeight);
		_map = new BitmapData(_columns, _rows, false, 0);
		_tile = new Rectangle(0, 0, tileWidth, tileHeight);

		// create the canvas
		_maxWidth -= as3hx.Compat.parseInt(_maxWidth % tileWidth);
		_maxHeight -= as3hx.Compat.parseInt(_maxHeight % tileHeight);
		super(_width, _height);

		// load the tileset graphic
		if (Std.is(tileset, Class)) {
			_set = FP.getBitmap(tileset);
		} else if (Std.is(tileset, BitmapData)) {
			_set = tileset;
		}
		if (_set == null) {
			throw new Error("Invalid tileset graphic provided.");
		}
		_setColumns = as3hx.Compat.parseInt(_set.width / tileWidth);
		_setRows = as3hx.Compat.parseInt(_set.height / tileHeight);
		_setCount = _setColumns * _setRows;
	}

	/**
	 * Sets the index of the tile at the position.
	 * @param	column		Tile column.
	 * @param	row			Tile row.
	 * @param	index		Tile index.
	 */
	public function setTile(column:Int, row:Int, index:Int = 0):Void {
		if (usePositions) {
			column /= _tile.width;
			row /= _tile.height;
		}
		index %= _setCount;
		column %= _columns;
		row %= _rows;
		_tile.x = (index % _setColumns) * _tile.width;
		_tile.y = as3hx.Compat.parseInt(index / _setColumns) * _tile.height;
		_map.setPixel(column, row, index);
		draw(column * _tile.width, row * _tile.height, _set, _tile);
	}

	/**
	 * Clears the tile at the position.
	 * @param	column		Tile column.
	 * @param	row			Tile row.
	 */
	public function clearTile(column:Int, row:Int):Void {
		if (usePositions) {
			column /= _tile.width;
			row /= _tile.height;
		}
		column %= _columns;
		row %= _rows;
		_tile.x = column * _tile.width;
		_tile.y = row * _tile.height;
		fill(_tile, 0);
	}

	/**
	 * Gets the tile index at the position.
	 * @param	column		Tile column.
	 * @param	row			Tile row.
	 * @return	The tile index.
	 */
	public function getTile(column:Int, row:Int):Int {
		if (usePositions) {
			column /= _tile.width;
			row /= _tile.height;
		}
		return _map.getPixel(column % _columns, row % _rows);
	}

	/**
	 * Sets a region of tiles to the index.
	 * @param	column		First tile column.
	 * @param	row			First tile row.
	 * @param	width		Width in tiles.
	 * @param	height		Height in tiles.
	 * @param	index		Tile index.
	 */
	public function setRegion(column:Int, row:Int, width:Int = 1, height:Int = 1, index:Int = 0):Void {
		if (usePositions) {
			column /= _tile.width;
			row /= _tile.height;
			width /= _tile.width;
			height /= _tile.height;
		}
		column %= _columns;
		row %= _rows;
		var c:Int = column;
		var r:Int = as3hx.Compat.parseInt(column + width);
		var b:Int = as3hx.Compat.parseInt(row + height);
		var u:Bool = usePositions;
		usePositions = false;
		while (row < b) {
			while (column < r) {
				setTile(column, row, index);
				column++;
			}
			column = c;
			row++;
		}
		usePositions = u;
	}

	/**
	 * Clears the region of tiles.
	 * @param	column		First tile column.
	 * @param	row			First tile row.
	 * @param	width		Width in tiles.
	 * @param	height		Height in tiles.
	 */
	public function clearRegion(column:Int, row:Int, width:Int = 1, height:Int = 1):Void {
		if (usePositions) {
			column /= _tile.width;
			row /= _tile.height;
			width /= _tile.width;
			height /= _tile.height;
		}
		column %= _columns;
		row %= _rows;
		var c:Int = column;
		var r:Int = as3hx.Compat.parseInt(column + width);
		var b:Int = as3hx.Compat.parseInt(row + height);
		var u:Bool = usePositions;
		usePositions = false;
		while (row < b) {
			while (column < r) {
				clearTile(column, row);
				column++;
			}
			column = c;
			row++;
		}
		usePositions = u;
	}

	/**
	 * Loads the Tilemap tile index data from a string.
	 * @param str			The string data, which is a set of tile values separated by the columnSep and rowSep strings.
	 * @param columnSep		The string that separates each tile value on a row, default is ",".
	 * @param rowSep			The string that separates each row of tiles, default is "\n".
	 */
	public function loadFromString(str:String, columnSep:String = ",", rowSep:String = "\n"):Void {
		var row:Array<Dynamic> = str.split(rowSep);
		var rows:Int = row.length;
		var col:Array<Dynamic>;
		var cols:Int;
		var x:Int;
		var y:Int;
		for (y in 0...rows) {
			if (row[y] == "") {
				continue;
			}
			col = row[y].split(columnSep);
			cols = col.length;
			for (x in 0...cols) {
				if (col[x] == "") {
					continue;
				}
				setTile(x, y, as3hx.Compat.parseInt(col[x]));
			}
		}
	}

	/**
	 * Saves the Tilemap tile index data to a string.
	 * @param columnSep		The string that separates each tile value on a row, default is ",".
	 * @param rowSep			The string that separates each row of tiles, default is "\n".
	 */
	public function saveToString(columnSep:String = ",", rowSep:String = "\n"):String {
		var s:String = "";
		var x:Int;
		var y:Int;
		for (y in 0..._rows) {
			for (x in 0..._columns) {
				s += getTile(x, y);
				if (x != _columns - 1) {
					s += columnSep;
				}
			}
			if (y != _rows - 1) {
				s += rowSep;
			}
		}
		return s;
	}

	/**
	 * Gets the index of a tile, based on its column and row in the tileset.
	 * @param	tilesColumn		Tileset column.
	 * @param	tilesRow		Tileset row.
	 * @return	Index of the tile.
	 */
	public function getIndex(tilesColumn:Int, tilesRow:Int):Int {
		return as3hx.Compat.parseInt((tilesRow % _setRows) * _setColumns + (tilesColumn % _setColumns));
	}

	/**
	 * The tile width.
	 */
	private function get_tileWidth():Int {
		return _tile.width;
	}

	/**
	 * The tile height.
	 */
	private function get_tileHeight():Int {
		return _tile.height;
	}

	// Tilemap information.

	/** @private */
	private var _map:BitmapData;

	/** @private */
	private var _columns:Int;

	/** @private */
	private var _rows:Int;

	// Tileset information.

	/** @private */
	private var _set:BitmapData;

	/** @private */
	private var _setColumns:Int;

	/** @private */
	private var _setRows:Int;

	/** @private */
	private var _setCount:Int;

	/** @private */
	private var _tile:Rectangle;

	// Global objects.

	/** @private */
	private var _point:Point = FP.point;

	/** @private */
	private var _rect:Rectangle = FP.rect;
}
