package net.flashpunk.masks;

import openfl.errors.Error;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import net.flashpunk.*;

/**
	 * A bitmap mask used for pixel-perfect collision. 
	 */
class Pixelmask extends Hitbox
{
    public var data(get, set) : BitmapData;

    /**
		 * Alpha threshold of the bitmap used for collision.
		 */
    public var threshold : Int = 1;
    
    /**
		 * Constructor.
		 * @param	source		The image to use as a mask.
		 * @param	x			X offset of the mask.
		 * @param	y			Y offset of the mask.
		 */
    public function new(source : Dynamic, x : Int = 0, y : Int = 0)
    {
        super();
        // fetch mask data
        if (Std.is(source, BitmapData))
        {
            _data = source;
        }
        if (Std.is(source, Class))
        {
            _data = FP.getBitmap(source);
        }
        if (_data == null)
        {
            throw new Error("Invalid Pixelmask source image.");
        }
        
        // set mask properties
        _width = data.width;
        _height = data.height;
        _x = x;
        _y = y;
        
        // set callback functions
        _check[Mask] = collideMask;
        _check[Pixelmask] = collidePixelmask;
        _check[Hitbox] = collideHitbox;
    }
    
    /** @private Collide against an Entity. */
    private override function collideMask(other : Mask) : Bool
    {
        _point.x = parent.x + _x;
        _point.y = parent.y + _y;
        _rect.x = other.parent.x - other.parent.originX;
        _rect.y = other.parent.y - other.parent.originY;
        _rect.width = other.parent.width;
        _rect.height = other.parent.height;
        return _data.hitTest(_point, threshold, _rect);
    }
    
    /** @private Collide against a Hitbox. */
    private override function collideHitbox(other : Hitbox) : Bool
    {
        _point.x = parent.x + _x;
        _point.y = parent.y + _y;
        _rect.x = other.parent.x + other._x;
        _rect.y = other.parent.y + other._y;
        _rect.width = other._width;
        _rect.height = other._height;
        return _data.hitTest(_point, threshold, _rect);
    }
    
    /** @private Collide against a Pixelmask. */
    private function collidePixelmask(other : Pixelmask) : Bool
    {
        _point.x = parent.x + _x;
        _point.y = parent.y + _y;
        _point2.x = other.parent.x + other._x;
        _point2.y = other.parent.y + other._y;
        return _data.hitTest(_point, threshold, other._data, _point2, other.threshold);
    }
    
    /**
		 * Current BitmapData mask.
		 */
    private function get_data() : BitmapData
    {
        return _data;
    }
    private function set_data(value : BitmapData) : BitmapData
    {
        _data = value;
        _width = value.width;
        _height = value.height;
        update();
        return value;
    }
    
    // Pixelmask information.
    /** @private */@:allow(net.flashpunk.masks)
    private var _data : BitmapData;
    
    // Global objects.
    /** @private */private var _rect : Rectangle = FP.rect;
    /** @private */private var _point : Point = FP.point;
    /** @private */private var _point2 : Point = FP.point2;
}
