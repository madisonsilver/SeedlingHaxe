package net.flashpunk;

import openfl.errors.Error;

/**
	 * Updateable Tween container.
	 */
class Tweener
{
    /**
		 * If the Tweener should update.
		 */
    public var active : Bool = true;
    
    /**
		 * If the Tweener should clear on removal. For Entities, this is when they are
		 * removed from a World, and for World this is when the active World is switched.
		 */
    public var autoClear : Bool = false;
    
    /**
		 * Constructor.
		 */
    public function new()
    {
    }
    
    /**
		 * Updates the Tween container.
		 */
    public function update() : Void
    {
    }
    
    /**
		 * Adds a new Tween.
		 * @param	t			The Tween to add.
		 * @param	start		If the Tween should call start() immediately.
		 * @return	The added Tween.
		 */
    public function addTween(t : Tween, start : Bool = false) : Tween
    {
        if (t._parent != null)
        {
            throw new Error("Cannot add a Tween object more than once.");
        }
        t._parent = this;
        t._next = _tween;
        if (_tween != null)
        {
            _tween._prev = t;
        }
        _tween = t;
        if (start)
        {
            _tween.start();
        }
        return t;
    }
    
    /**
		 * Removes a Tween.
		 * @param	t		The Tween to remove.
		 * @return	The removed Tween.
		 */
    public function removeTween(t : Tween) : Tween
    {
        if (t._parent != this)
        {
            throw new Error("Core object does not contain Tween.");
        }
        if (t._next != null)
        {
            t._next._prev = t._prev;
        }
        if (t._prev != null)
        {
            t._prev._next = t._next;
        }
        else
        {
            _tween = t._next;
        }
        t._next = t._prev = null;
        t._parent = null;
        t.active = false;
        return t;
    }
    
    /**
		 * Removes all Tweens.
		 */
    public function clearTweens() : Void
    {
        var t : Tween = _tween;
        var n : Tween;
        while (t != null)
        {
            n = t._next;
            removeTween(t);
            t = n;
        }
    }
    
    /** 
		 * Updates all contained tweens.
		 */
    public function updateTweens() : Void
    {
        var t : Tween = _tween;
        while (t != null)
        {
            if (t.active)
            {
                t.update();
                if (t._finish)
                {
                    t.finish();
                }
            }
            t = t._next;
        }
    }
    
    // List information.
    /** @private */@:allow(net.flashpunk)
    private var _tween : Tween;
}
