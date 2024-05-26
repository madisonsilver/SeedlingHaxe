package puzzlements;

import net.flashpunk.Entity;
import net.flashpunk.Graphic;

/**
	 * ...
	 * @author Time
	 */
class Activators extends Entity
{
    public var activate(get, set) : Bool;
    public var t(get, set) : Int;

    public var _active : Bool = false;
    public var tSet : Int;
    
    public function new(_x : Int, _y : Int, _g : Graphic, _t : Int)
    {
        super(_x, _y, _g);
        t = _t;
    }
    
    private function set_activate(a : Bool) : Bool
    {
        _active = a;
        return a;
    }
    
    private function get_activate() : Bool
    {
        return _active;
    }
    
    private function set_t(_t : Int) : Int
    {
        tSet = _t;
        return _t;
    }
    
    private function get_t() : Int
    {
        return tSet;
    }
}

