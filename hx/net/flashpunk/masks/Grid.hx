package net.flashpunk.masks;

import openfl.errors.Error;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import net.flashpunk.*;

/**
 * Uses a hash grid to determine collision, faster than
 * using hundreds of Entities for tiled levels, etc.
 */
class Grid extends Hitbox {
	public var data(get, never):BitmapData;
	public var columns(get, never):Int;
	public var rows(get, never):Int;

	/**
	 * If x/y positions should be used instead of columns/rows.
	 */
	public var usePositions:Bool;

	/**
	 * Constructor.
	 * @param	width			Width of the grid, in pixels.
	 * @param	height			Height of the grid, in pixels.
	 * @param	cellWidth		Width of a grid cell, in pixels.
	 * @param	cellHeight		Height of a grid cell, in pixels.
	 * @param	x				X offset of the grid.
	 * @param	y				Y offset of the grid.
	 */
	public function new(width:Int, height:Int, cellWidth:Int, cellHeight:Int, x:Int = 0, y:Int = 0) {
		super();
		// check for illegal grid size
		if (width == 0 || height == 0 || cellWidth == 0 || cellHeight == 0) {
			throw new Error("Illegal Grid, sizes cannot be 0.");
		}

		// set grid properties
		_columns = width / cellWidth;
		_rows = height / cellHeight;
		_data = new BitmapData(_columns, _rows, true, 0);
		_cell = new Rectangle(0, 0, cellWidth, cellHeight);
		_x = x;
		_y = y;
		_width = width;
		_height = height;

		// set callback functions
		_check[Mask] = collideMask;
		_check[Hitbox] = collideHitbox;
		_check[Pixelmask] = collidePixelmask;
	}

	/** @private Collides against an Entity. */
	private function collideMask(other:Mask):Bool {
		_rect.x = other.parent.x - other.parent.originX - parent.x + parent.originX;
		_rect.y = other.parent.y - other.parent.originY - parent.y + parent.originY;
		_point.x = as3hx.Compat.parseInt((_rect.x + other.parent.width - 1) / _cell.width) + 1;
		_point.y = as3hx.Compat.parseInt((_rect.y + other.parent.height - 1) / _cell.height) + 1;
		_rect.x = as3hx.Compat.parseInt(_rect.x / _cell.width);
		_rect.y = as3hx.Compat.parseInt(_rect.y / _cell.height);
		_rect.width = _point.x - _rect.x;
		_rect.height = _point.y - _rect.y;
		return _data.hitTest(FP.zero, 1, _rect);
	}

	/** @private Collides against a Hitbox. */
	private function collideHitbox(other:Hitbox):Bool {
		_rect.x = other.parent.x + other._x - parent.x - _x;
		_rect.y = other.parent.y + other._y - parent.y - _y;
		_point.x = as3hx.Compat.parseInt((_rect.x + other._width - 1) / _cell.width) + 1;
		_point.y = as3hx.Compat.parseInt((_rect.y + other._height - 1) / _cell.height) + 1;
		_rect.x = as3hx.Compat.parseInt(_rect.x / _cell.width);
		_rect.y = as3hx.Compat.parseInt(_rect.y / _cell.height);
		_rect.width = _point.x - _rect.x;
		_rect.height = _point.y - _rect.y;
		return _data.hitTest(FP.zero, 1, _rect);
	}

	/** @private Collides against a Pixelmask. */
	private function collidePixelmask(other:Pixelmask):Bool {
		var x1:Int = as3hx.Compat.parseInt(other.parent.x + other._x - parent.x - _x);
		var y1:Int = as3hx.Compat.parseInt(other.parent.y + other._y - parent.y - _y);
		var x2:Int = as3hx.Compat.parseInt((x1 + other._width - 1) / _cell.width);
		var y2:Int = as3hx.Compat.parseInt((y1 + other._height - 1) / _cell.height);
		_point.x = x1;
		_point.y = y1;
		x1 /= _cell.width;
		y1 /= _cell.height;
		_cell.x = x1 * _cell.width;
		_cell.y = y1 * _cell.height;
		var xx:Int = x1;
		while (y1 <= y2) {
			while (x1 <= x2) {
				if (_data.getPixel32(x1, y1)) {
					if (other._data.hitTest(_point, 1, _cell)) {
						return true;
					}
				}
				x1++;
				_cell.x += _cell.width;
			}
			x1 = xx;
			y1++;
			_cell.x = x1 * _cell.width;
			_cell.y += _cell.height;
		}
		return false;
	}

	/**
	 * The grid data.
	 */
	private function get_data():BitmapData {
		return _data;
	}

	/**
	 * Sets the value of the cell.
	 * @param	x		Cell column.
	 * @param	y		Cell row.
	 * @param	fill	Fill value.
	 */
	public function setCell(x:Int = 0, y:Int = 0, solid:Bool = true):Void {
		if (usePositions) {
			x /= _cell.width;
			y /= _cell.height;
		}
		_data.setPixel32(x, y, (solid) ? 0xFFFFFFFF : 0);
	}

	/**
	 * Sets the value of a rectangle region of cells.
	 * @param	x			First column.
	 * @param	y			First row.
	 * @param	width		Columns to fill.
	 * @param	height		Rows to fill.
	 * @param	fill		Value to fill.
	 */
	public function setRect(x:Int = 0, y:Int = 0, width:Int = 1, height:Int = 1, solid:Bool = true):Void {
		if (usePositions) {
			x /= _cell.width;
			y /= _cell.height;
			width /= _cell.width;
			height /= _cell.height;
		}
		_rect.x = x;
		_rect.y = y;
		_rect.width = width;
		_rect.height = height;
		_data.fillRect(_rect, (solid) ? 0xFFFFFFFF : 0);
	}

	/**
	 * Gets the value of a cell.
	 * @param	x		Cell column.
	 * @param	y		Cell row.
	 * @return	Cell value.
	 */
	public function getCell(x:Int = 0, y:Int = 0):Bool {
		if (usePositions) {
			x /= _cell.width;
			y /= _cell.height;
		}
		return _data.getPixel32(x, y) > 0;
	}

	/**
	 * How many columns the grid has
	 */
	private function get_columns():Int {
		return _columns;
	}

	/**
	 * How many rows the grid has.
	 */
	private function get_rows():Int {
		return _rows;
	}

	// Grid information.

	/** @private */
	private var _data:BitmapData;

	/** @private */
	private var _columns:Int;

	/** @private */
	private var _rows:Int;

	/** @private */
	private var _cell:Rectangle;

	/** @private */
	private var _rect:Rectangle = FP.rect;

	/** @private */
	private var _point:Point = FP.point;

	/** @private */
	private var _point2:Point = FP.point2;
}
