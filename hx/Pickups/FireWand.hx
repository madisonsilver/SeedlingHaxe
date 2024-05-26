package pickups;

import enemies.BossTotem;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;
import scenery.Tile;
import puzzlements.Activators;
import net.flashpunk.utils.Draw;

/**
	 * ...
	 * @author Time
	 */
class FireWand extends Pickup
{
    @:meta(Embed(source="../../assets/graphics/FireWandPickup.png"))
private var imgFireWandPickup : Class<Dynamic>;
    private var sprFireWandPickup : Spritemap = new Spritemap(imgFireWandPickup, 5, 9);
    
    private var tag : Int;
    private var doActions : Bool = true;
    
    private var alphaRate(default, never) : Float = 0.01;
    //When this is picked up, it will activate any tset = 0 object in the room.
    private var tset : Int = 0;
    
    public function new(_x : Int, _y : Int, _tag : Int = -1)
    {
        super(_x + Tile.w / 2, _y + Tile.h / 2, sprFireWandPickup, null, false);
        sprFireWandPickup.centerOO();
        setHitbox(8, 8, 4, 4);
        
        tag = _tag;
        
        special = true;
        text = "You got the Fire Wand!~It uses both Wand and Fire.";
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
            Player.hasFireWand = true;
            Game.setPersistence(tag, false);
        }
    }
    
    override public function update() : Void
    {
        var p : Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch(e:Dynamic) null;
        if (p != null && !p.fallFromCeiling)
        {
            if ((try cast(graphic, Spritemap) catch(e:Dynamic) null).alpha < 1)
            {
                (try cast(graphic, Spritemap) catch(e:Dynamic) null).alpha = Math.min((try cast(graphic, Spritemap) catch(e:Dynamic) null).alpha + alphaRate, 1);
                Game.freezeObjects = (try cast(graphic, Spritemap) catch(e:Dynamic) null).alpha < 1;
            }
            else
            {
                super.update();
            }
        }
    }
    override public function render() : Void
    {
        var frameCount : Int = 6;
        
        sprFireWandPickup.frame = Game.worldFrame(frameCount);
        sprFireWandPickup.y = -sprFireWandPickup.originY + 2 * Math.sin(2 * Math.PI * (Game.time % Game.timePerFrame) / Game.timePerFrame);
        super.render();
        
        var offsetX : Int = as3hx.Compat.parseInt(sprFireWandPickup.x + 3);
        var offsetY : Int = as3hx.Compat.parseInt(sprFireWandPickup.y + 1);
        var radiusMax : Int = 20;
        var radiusMin : Int = 14;
        var color : Int = 0xFF8800;
        var alpha : Float = (try cast(graphic, Spritemap) catch(e:Dynamic) null).alpha * 0.2;
        var frame : Int = sprFireWandPickup.frame;
        Draw.setTarget((try cast(FP.world, Game) catch(e:Dynamic) null).nightBmp, FP.camera);
        Draw.circlePlus(x + offsetX, y + offsetY, (radiusMax - radiusMin) * frame / (frameCount - 1) + radiusMin, color, alpha);
        Draw.circlePlus(x + offsetX, y + offsetY, ((radiusMax - radiusMin) * frame / (frameCount - 1) + radiusMin) / 2, color, alpha);
        Draw.resetTarget();
    }
}

