package enemies;

import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;

/**
	 * ...
	 * @author Time
	 */
class SandTrap extends Enemy
{
    @:meta(Embed(source="../../assets/graphics/SandTrap.png"))
private var imgSandTrap : Class<Dynamic>;
    private var sprSandTrap : Spritemap = new Spritemap(imgSandTrap, 14, 14, endAnim);
    
    private var chompAnimSpeed(default, never) : Int = 10;
    private var chompRange(default, never) : Int = 20;  // The distance at which the cactus will start chomping from a player  
    
    private var tag : Int;
    
    public function new(_x : Int, _y : Int, _tag : Int = -1, _g : Spritemap = null)
    {
        if (_g == null)
        {
            _g = sprSandTrap;
        }
        super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), _g);
        
        (try cast(graphic, Spritemap) catch(e:Dynamic) null).centerOO();
        //the animation "" will reset it to the world frame speed
        (try cast(graphic, Spritemap) catch(e:Dynamic) null).add("chomp", [0, 1, 2, 3, 2, 1], chompAnimSpeed);
        (try cast(graphic, Spritemap) catch(e:Dynamic) null).add("hit", [1]);
        (try cast(graphic, Spritemap) catch(e:Dynamic) null).add("die", [4, 5, 6, 7, 8, 9], 10);
        
        setHitbox(16, 16, 8, 8);
        
        layer = Std.int(-(y - originY + height * 4 / 5));
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
    
    override public function update() : Void
    {
        super.update();
        if ((try cast(graphic, Spritemap) catch(e:Dynamic) null).currentAnim == "die")
        {
            return;
        }
        
        var player : Player = try cast(FP.world.nearestToEntity("Player", this), Player) catch(e:Dynamic) null;
        if (player != null)
        {
            var d : Int =Std.int( FP.distance(x, y, player.x, player.y));
            if (d <= chompRange && (try cast(graphic, Spritemap) catch(e:Dynamic) null).currentAnim != "chomp")
            {
                Music.playSoundDistPlayer(Std.int(x), Std.int(y), "Enemy Attack", 3);
                (try cast(graphic, Spritemap) catch(e:Dynamic) null).play("chomp");
            }
        }
        if ((try cast(graphic, Spritemap) catch(e:Dynamic) null).currentAnim == "")
        {
            (try cast(graphic, Spritemap) catch(e:Dynamic) null).frame = Game.worldFrame(2);
        }
    }
    
    override public function layering() : Void
    {
    }
    
    override public function knockback(f : Float = 0, p : Point = null) : Void
    {
    }
    
    override public function removed() : Void
    {
        super.removed();
        Game.setPersistence(tag, false);
    }
    
    override public function startDeath(t : String = "") : Void
    {
        (try cast(graphic, Spritemap) catch(e:Dynamic) null).play("die");
        dieEffects(t);
    }
    
    public function endAnim() : Void
    {
        var _sw10_ = ((try cast(graphic, Spritemap) catch(e:Dynamic) null).currentAnim);        

        switch (_sw10_)
        {
            case "die":
                FP.world.remove(this);
            default:
                (try cast(graphic, Spritemap) catch(e:Dynamic) null).play("");
        }
    }
}

