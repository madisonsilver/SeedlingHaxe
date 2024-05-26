package net.flashpunk.masks;

import net.flashpunk.*;

/**
	 * Uses parent's hitbox to determine collision. This class is used
	 * internally by FlashPunk, you don't need to use this class because
	 * this is the default behaviour of Entities without a Mask object.
	 */
class Hitbox extends Mask
{
    public var x(get, set) : Int;
    public var y(get, set) : Int;
    public var width(get, set) : Int;
    public var height(get, set) : Int;

    /**
		 * Constructor.
		 * @param	width		Width of the hitbox.
		 * @param	height		Height of the hitbox.
		 * @param	x			X offset of the hitbox.
		 * @param	y			Y offset of the hitbox.
		 */
    public function new(width : Int = 1, height : Int = 1, x : Int = 0, y : Int = 0)
    {
        super();
        _width = width;
        _height = height;
        _x = x;
        _y = y;
        _check[Mask] = collideMask;
        _check[Hitbox] = collideHitbox;
    }
    
    /** @private Collides against an Entity. */
    private override function collideMask(other : Mask) : Bool
    {
        return parent.x + _x + _width > other.parent.x - other.parent.originX && parent.y + _y + _height > other.parent.y - other.parent.originY && parent.x + _x < other.parent.x - other.parent.originX + other.parent.width && parent.y + _y < other.parent.y - other.parent.originY + other.parent.height;
    }
    
    /** @private Collides against a Hitbox. */
    private function collideHitbox(other : Hitbox) : Bool
    {
        return parent.x + _x + _width > other.parent.x + other._x && parent.y + _y + _height > other.parent.y + other._y && parent.x + _x < other.parent.x + other._x + other._width && parent.y + _y < other.parent.y + other._y + other._height;
    }
    
    /**
		 * X offset.
		 */
    private function get_x() : Int
    {
        return _x;
    }
    private function set_x(value : Int) : Int
    {
        if (_x == value)
        {
            return value;
        }
        _x = value;
        if (list != null)
        {
            list.update();
        }
        else if (parent != null)
        {
            update();
        }
        return value;
    }
    
    /**
		 * Y offset.
		 */
    private function get_y() : Int
    {
        return _y;
    }
    private function set_y(value : Int) : Int
    {
        if (_y == value)
        {
            return value;
        }
        _y = value;
        if (list != null)
        {
            list.update();
        }
        else if (parent != null)
        {
            update();
        }
        return value;
    }
    
    /**
		 * Width.
		 */
    private function get_width() : Int
    {
        return _width;
    }
    private function set_width(value : Int) : Int
    {
        if (_width == value)
        {
            return value;
        }
        _width = value;
        if (list != null)
        {
            list.update();
        }
        else if (parent != null)
        {
            update();
        }
        return value;
    }
    
    /**
		 * Height.
		 */
    private function get_height() : Int
    {
        return _height;
    }
    private function set_height(value : Int) : Int
    {
        if (_height == value)
        {
            return value;
        }
        _height = value;
        if (list != null)
        {
            list.update();
        }
        else if (parent != null)
        {
            update();
        }
        return value;
    }
    
    /** @private Updates the parent's bounds for this mask. */
    override private function update() : Void
    // update entity bounds
    {
        
        parent.originX = -_x;
        parent.originY = -_y;
        parent.width = _width;
        parent.height = _height;
        
        // update parent list
        if (list != null)
        {
            list.update();
        }
    }
    
    // Hitbox information.
    /** @private */@:allow(net.flashpunk.masks)
    private var _width : Int;
    /** @private */@:allow(net.flashpunk.masks)
    private var _height : Int;
    /** @private */@:allow(net.flashpunk.masks)
    private var _x : Int;
    /** @private */@:allow(net.flashpunk.masks)
    private var _y : Int;
}
