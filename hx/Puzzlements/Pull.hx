package puzzlements;

import net.flashpunk.Entity;
import scenery.Tile;
import net.flashpunk.FP;
import net.flashpunk.utils.Draw;

/**
	 * ...
	 * @author Time
	 */
class Pull extends Entity
{
    private var direction : Float;  //the direction that it will pull whatever object it touches (radians)  
    private var force : Float;
    
    private var alpha : Float = 0;
    private var radius : Float = 0;
    
    private var radiusRate(default, never) : Float = 0.5;  //The rate at which the radius increases, per colliding object.  
    private var pullables(default, never) : Dynamic = ["Player", "Enemy", "Solid"];
    private var color(default, never) : Int = 0xFF0000;
    private var maxEntitiesAlpha(default, never) : Int = 3;  //The number of colliding entities at which the alpha will be one.  
    
    public function new(_x : Int, _y : Int, _d : Float, _f : Float)
    {
        super(_x, _y);
        setHitbox(Tile.w, Tile.h);
        type = "Pull";
        direction = _d * Math.PI * 2;
        force = _f;
    }
    
    override public function update() : Void
    {
        var v : Array<Entity> = new Array<Entity>();
        collideTypesInto(pullables, x, y, v);
        alpha = v.length / maxEntitiesAlpha;
        for (e in v)
        {
            e.x += force * Math.cos(direction);
            e.y -= force * Math.sin(direction);
            
            radius += radiusRate;
        }
        if (v.length <= 0)
        {
            radius = 0;
        }
        else
        {
            radius = radius % (Math.sqrt(width * width + height * height) / 2);
        }
    }
    
    override public function render() : Void
    {
        Draw.setTarget((try cast(FP.world, Game) catch(e:Dynamic) null).nightBmp, FP.camera);
        Draw.circlePlus(x - originX + width / 2, y - originY + height / 2, radius, color, alpha);
        Draw.resetTarget();
    }
}

