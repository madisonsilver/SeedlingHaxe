package projectiles;

import enemies.Enemy;
import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;

/**
	 * ...
	 * @author Time
	 */
class Bomb extends Mobile
{
    @:meta(Embed(source="../../assets/graphics/Bomb.png"))
private var imgBomb : Class<Dynamic>;
    private var sprBomb : Spritemap = new Spritemap(imgBomb, 16, 16);
    
    private var hitables : Dynamic = ["Player", "Enemy", "ShieldBoss"];
    
    private var scaleMin(default, never) : Float = 0.5;
    private var scaleMax(default, never) : Float = 1.5;
    private var scale : Float = 0.5;
    
    private var tMax(default, never) : Int = 30;
    private var t : Int = tMax;
    
    public function new(_x : Int, _y : Int, _p : Point)
    {
        super(_x, _y, sprBomb);
        sprBomb.centerOO();
        v = new Point(_p.x - x, _p.y - y);
        v.normalize(v.length / tMax);
        f = 0;
        setHitbox(sprBomb.width, sprBomb.height, Std.int(sprBomb.width / 2), Std.int(sprBomb.height / 2));
        type = "Bomb";
        solids = [];
    }
    
    override public function update() : Void
    {
        super.update();
        if (t > 0)
        {
            t--;
            scale = (scaleMax - scaleMin) * (Math.sin(t / tMax * Math.PI) + 1) / 2 + scaleMin;
        }
        else
        {
            FP.world.remove(this);
        }
        sprBomb.scale = scale;
        sprBomb.angle += 15;
    }
    
    override public function layering() : Void
    {
        layer = -FP.height;
    }
    
    override public function removed() : Void
    {
        super.removed();
        FP.world.add(new Explosion(Std.int(x), Std.int(y), hitables, 24));
    }
}

