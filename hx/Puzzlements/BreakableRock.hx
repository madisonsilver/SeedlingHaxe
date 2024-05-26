package puzzlements;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;

/**
	 * ...
	 * @author Time
	 */
class BreakableRock extends Entity
{
    @:meta(Embed(source="../../assets/graphics/BreakableRock.png"))
private var imgBreakableRock : Class<Dynamic>;
    private var sprBreakableRock : Spritemap = new Spritemap(imgBreakableRock, 16, 16, endAnim);
    @:meta(Embed(source="../../assets/graphics/BreakableRockGhost.png"))
private var imgBreakableRockGhost : Class<Dynamic>;
    private var sprBreakableRockGhost : Spritemap = new Spritemap(imgBreakableRockGhost, 16, 16, endAnim);
    
    private var tag : Int;
    private var rockType : Int;
    
    public function new(_x : Int, _y : Int, _tag : Int = -1, _type : Int = 0)
    {
        super(_x + Tile.w / 2, _y + Tile.h / 2);
        
        switch (_type)
        {
            case 0:
                graphic = sprBreakableRock;
            case 1:
                graphic = sprBreakableRockGhost;
            default:
        }
        
        rockType = _type;
        
        (try cast(graphic, Spritemap) catch(e:Dynamic) null).centerOO();
        (try cast(graphic, Spritemap) catch(e:Dynamic) null).add("break", [0, 1, 2, 3], 20);
        type = "Solid";  //Was "Rock"; If it's buggy, that might be why  
        setHitbox(16, 16, 8, 8);
        layer = Std.int(-(y - originY + height));
        tag = _tag;
    }
    
    override public function check() : Void
    {
        super.check();
        if (tag >= 0 && !Game.checkPersistence(tag))
        {
            FP.world.remove(this);
        }
    }
    
    public function hit(_t : Int) : Void
    {
        if (rockType <= _t)
        
        //If the type of hit is more powerful than this rock, break it (so the ghostsword breaks both locks)
{            
            {
                if ((try cast(graphic, Spritemap) catch(e:Dynamic) null).currentAnim != "break")
                {
                    Music.playSound("Rock", 1);
                }
                (try cast(graphic, Spritemap) catch(e:Dynamic) null).play("break");
            }
        }
    }
    
    public function endAnim() : Void
    {
        Game.setPersistence(tag, false);
        FP.world.remove(this);
    }
}

