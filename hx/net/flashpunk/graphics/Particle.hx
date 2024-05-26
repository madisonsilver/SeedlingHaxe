package net.flashpunk.graphics;

import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
	 * Used by the Emitter class to track an existing Particle.
	 */
class Particle
{
    /**
		 * Constructor.
		 */
    public function new()
    {
    }
    
    // Particle information.
    /** @private */@:allow(net.flashpunk.graphics)
    private var _type : ParticleType;
    /** @private */@:allow(net.flashpunk.graphics)
    private var _time : Float;
    /** @private */@:allow(net.flashpunk.graphics)
    private var _duration : Float;
    
    // Motion information.
    /** @private */@:allow(net.flashpunk.graphics)
    private var _x : Float;
    /** @private */@:allow(net.flashpunk.graphics)
    private var _y : Float;
    /** @private */@:allow(net.flashpunk.graphics)
    private var _moveX : Float;
    /** @private */@:allow(net.flashpunk.graphics)
    private var _moveY : Float;
    
    // List information.
    /** @private */@:allow(net.flashpunk.graphics)
    private var _prev : Particle;
    /** @private */@:allow(net.flashpunk.graphics)
    private var _next : Particle;
}
