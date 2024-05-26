package pickups;

import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;
import scenery.Tile;
import scenery.Moonrock;

/**
	 * ...
	 * @author Time
	 */
class Shield extends Pickup
{
    @:meta(Embed(source="../../assets/graphics/Shield.png"))
private var imgShield : Class<Dynamic>;
    private var sprShield : Spritemap = new Spritemap(imgShield, 7, 7);
    
    private var tag : Int;
    private var doActions : Bool = true;
    
    public function new(_x : Int, _y : Int, _tag : Int = -1)
    {
        super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprShield, null, false);
        sprShield.centerOO();
        setHitbox(8, 8, 4, 4);
        
        tag = _tag;
        
        special = true;
        text = "You got the shield!~It protects you when moving.";
    }
    
    override public function check() : Void
    {
        super.check();
        if (tag >= 0 && !Game.checkPersistence(tag))
        {
            doActions = false;
            FP.world.remove(this);
        }
    }
    
    override public function removed() : Void
    {
        if (doActions)
        {
            Player.hasShield = true;
            Moonrock.beam = true;
            Game.setPersistence(tag, false);
        }
    }
}

