package puzzlements;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import scenery.Tile;
import net.flashpunk.FP;

/**
	 * ...
	 * @author Time
	 */
class MagicalLock extends Entity
{
    @:meta(Embed(source="../../assets/graphics/MagicalLock.png"))
private var imgMagicalLock : Class<Dynamic>;
    private var sprMagicalLock : Spritemap = new Spritemap(imgMagicalLock, 22, 21, animEnd);
    @:meta(Embed(source="../../assets/graphics/MagicalLockFire.png"))
private var imgMagicalLockFire : Class<Dynamic>;
    private var sprMagicalLockFire : Spritemap = new Spritemap(imgMagicalLockFire, 22, 21, animEnd);
    
    private var tag : Int;
    private var lockType : Int;
    
    public function new(_x : Int, _y : Int, _tag : Int = -1, _type : Int = 0)
    {
        super(_x + Tile.w / 2, _y + Tile.h / 2);
        
        switch (_type)
        {
            case 0:
                graphic = sprMagicalLock;
            case 1:
                graphic = sprMagicalLockFire;
            default:
        }
        
        (try cast(graphic, Spritemap) catch(e:Dynamic) null).centerOO();
        (try cast(graphic, Spritemap) catch(e:Dynamic) null).add("destroy", [3, 4, 5, 6, 7, 8, 9], 15);
        
        setHitbox(16, 16, 8, 8);
        type = "Solid";
        tag = _tag;
        
        lockType = _type;
        
        layer = -(y - originY + height);
    }
    
    override public function check() : Void
    {
        super.check();
        if (tag >= 0 && !Game.checkPersistence(tag))
        {
            FP.world.remove(this);
        }
    }
    
    public function animEnd() : Void
    {
        FP.world.remove(this);
    }
    
    public function hit(_t : Int) : Void
    {
        if (lockType <= _t)
        
        //If the type of shot is more powerful than this lock, break it (so the firewand breaks both locks)
{            
            {
                Music.playSoundDistPlayer(x, y, "Lock");
                Game.setPersistence(tag, false);
                (try cast(graphic, Spritemap) catch(e:Dynamic) null).play("destroy");
            }
        }
    }
    
    override public function render() : Void
    {
        if ((try cast(graphic, Spritemap) catch(e:Dynamic) null).currentAnim != "destroy")
        {
            (try cast(graphic, Spritemap) catch(e:Dynamic) null).frame = Game.worldFrame(3);
        }
        super.render();
    }
}

