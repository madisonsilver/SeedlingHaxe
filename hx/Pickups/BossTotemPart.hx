package pickups;

import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;

/**
	 * ...
	 * @author Time
	 */
class BossTotemPart extends Pickup
{
    @:meta(Embed(source="../../assets/graphics/BossTotemParts.png"))
private var imgBossTotemPart : Class<Dynamic>;
    private var sprBossTotemPart : Spritemap = new Spritemap(imgBossTotemPart, 24, 24);
    
    private var totemPart : Int;
    private var doActions : Bool = true;
    
    public function new(_x : Int, _y : Int, _t : Int)
    {
        super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprBossTotemPart, new Point(), false);
        sprBossTotemPart.frame = _t;
        sprBossTotemPart.centerOO();
        setHitbox(16, 16, 8, 8);
        totemPart = _t;
        layer = Std.int(-(y - originY + height));
        
        special = true;
    }
    
    override public function check() : Void
    {
        super.check();
        if (Player.hasTotemPart(totemPart))
        {
            doActions = false;
            FP.world.remove(this);
        }
    }
    
    override public function removed() : Void
    {
        if (doActions)
        {
            Player.hasTotemPartSet(totemPart, true);
        }
    }
}

