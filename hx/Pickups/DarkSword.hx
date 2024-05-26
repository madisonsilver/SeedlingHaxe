package pickups;

import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import nPCs.Help;
import scenery.Tile;
import scenery.Moonrock;

/**
	 * ...
	 * @author Time
	 */
class DarkSword extends Pickup
{
    @:meta(Embed(source="../../assets/graphics/SwordDark.png"))
private var imgDarkSword : Class<Dynamic>;
    private var sprDarkSword : Spritemap = new Spritemap(imgDarkSword, 16, 16);
    
    private var tag : Int;
    private var doActions : Bool = true;
    
    public function new(_x : Int, _y : Int, _tag : Int = -1)
    {
        super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprDarkSword, null, false);
        sprDarkSword.centerOO();
        setHitbox(8, 8, 4, 4);
        
        tag = _tag;
        
        special = true;
        text = "You got the dark sword!~It does more damage.";
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
            Player.hasDarkSword = true;
            if (Game.checkPersistence(tag))
            {
                Game.setPersistence(tag, false);
                Main.unlockMedal(Main.badges[12]);
            }
        }
    }
    override public function update() : Void
    {
        super.update();
    }
    override public function render() : Void
    {
        sprDarkSword.frame = Game.worldFrame(3);
        super.render();
    }
}

