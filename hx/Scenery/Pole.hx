package scenery;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;

/**
	 * ...
	 * @author Time
	 */
class Pole extends Entity
{
    private var img : Int = 0;
    
    public function new(_x : Int, _y : Int)
    {
        super(_x + Tile.w / 2, _y + Tile.h / 2);
        setHitbox(16, 16, 8, 8);
        type = "Solid";
        layer = Std.int(-(y - originY + height));
    }
    
    override public function render() : Void
    {
        Game.sprPole.frame = img;
        Game.sprPole.render(new Point(x, y), FP.camera);
    }
    
    override public function check() : Void
    {
        img = 0;
        var c : Entity = collide("Solid", x + 1, y);
        if (c != null && Std.is(c, Pole))
        {
            img++;
        }
        c = collide("Solid", x - 1, y);
        if (c != null && Std.is(c, Pole))
        {
            img += 2;
        }
        c = collide("Solid", x, y + 1);
        if (c != null && Std.is(c, Pole))
        {
            img += 4;
        }
    }
}

