package enemies;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;
import pickups.Coin;
import net.flashpunk.utils.Draw;

/**
	 * ...
	 * @author Time
	 */
class WallFlyer extends Enemy
{
    @:meta(Embed(source="../../assets/graphics/WallFlyer.png"))
private var imgWallFlyer : Class<Dynamic>;
    private var sprWallFlyer : Spritemap = new Spritemap(imgWallFlyer, 20, 16, endAnim);
    
    public var moveSpeed : Float = 4;
    private var coins : Int = 4 + Math.random() * 4;  //The number of coins to throw upon death  
    private var attackRange : Int = FP.screen.width;  //The range at which the wall flyer will jump if the player is intersecting.  
    private var vTriggered : Point = new Point();  // The vector of motion of the wall flyer when it is triggered by the player.  
    
    public function new(_x : Int, _y : Int)
    {
        super(_x + Tile.w / 2, _y + Tile.h / 2, sprWallFlyer);
        
        v = new Point();
        sprWallFlyer.centerOO();
        sprWallFlyer.x = -12;
        sprWallFlyer.originX = -sprWallFlyer.x;
        sprWallFlyer.add("jump", [0, 1, 2, 3], 15);
        sprWallFlyer.add("jumping", [3, 4], 7);
        sprWallFlyer.add("die", [5, 6, 7, 8], 10);
        
        f = 0;
        
        setHitbox(14, 14, 7, 7);
    }
    
    override public function check() : Void
    {
        super.check();
        v = decideMotion(-moveSpeed);
    }
    
    override public function startDeath(t : String = "") : Void
    {
        (try cast(graphic, Spritemap) catch(e:Dynamic) null).play("die");
        dieEffects(t);
    }
    
    override public function update() : Void
    {
        super.update();
        if (destroy || sprWallFlyer.currentAnim == "die")
        {
            return;
        }
        
        vTriggered = decideMotion(moveSpeed);
        if (vTriggered.length > 0)
        {
            var player : Player = try cast(FP.world.collideLine("Player", x, y, x + attackRange * (vTriggered.x / vTriggered.length), y + attackRange * (vTriggered.y / vTriggered.length)), Player) catch(e:Dynamic) null;
            if (player != null)
            {
                v = vTriggered;
                sprWallFlyer.play("jump");
            }
        }
        if (v.length > 0)
        {
            activeOffScreen = true;
        }
        else
        {
            activeOffScreen = false;
        }
    }
    
    override public function render() : Void
    {
        if (!destroy && sprWallFlyer.currentAnim != "die")
        {
            if (vTriggered.length > 0)
            {
                sprWallFlyer.angle = -Math.atan2(vTriggered.y, vTriggered.x) * 180 / Math.PI;
            }
            else if (v.length > 0)
            {
                sprWallFlyer.angle = -Math.atan2(v.y, v.x) * 180 / Math.PI;
            }
            if (v.length == 0)
            {
                sprWallFlyer.frame = Game.worldFrame(2);
            }
        }
        super.render();
    }
    
    public function endAnim() : Void
    {
        if (sprWallFlyer.currentAnim == "jump")
        {
            sprWallFlyer.play("jumping");
        }
        else if (sprWallFlyer.currentAnim == "die")
        {
            destroy = true;
            sprWallFlyer.play("");
            sprWallFlyer.frame = sprWallFlyer.frameCount - 1;
        }
    }
    
    public function decideMotion(speed : Float) : Point
    {
        var ang : Float = 0;
        var d : Int = 0;
        var types : Dynamic = ["Solid", "Tree"];
        if (collideTypes(types, x + width, y))
        {
            d += 1;
        }
        if (collideTypes(types, x, y - height))
        {
            d += 2;
        }
        if (collideTypes(types, x - width, y))
        {
            d += 4;
        }
        if (collideTypes(types, x, y + height))
        {
            d += 8;
        }
        switch (d)
        {
            case 1:
                ang = Math.PI;
            case 2:
                ang = Math.PI * 3 / 2;
            case 3:
                ang = Math.PI * 5 / 4;
            case 4:
                ang = 0;
            case 5:
                ang = 0;
            case 6:
                ang = Math.PI * 7 / 4;
            case 7:
                ang = Math.PI * 3 / 2;
            case 8:
                ang = Math.PI / 2;
            case 9:
                ang = Math.PI * 3 / 4;
            case 10:
                ang = Math.PI / 2;
            case 11:
                ang = Math.PI;
            case 12:
                ang = Math.PI / 4;
            case 13:
                ang = Math.PI / 2;
            case 14:
                ang = 0;
            default:
                return new Point();
        }
        return new Point(speed * Math.cos(ang), -speed * Math.sin(ang));
    }
    
    override public function knockback(f : Float = 0, p : Point = null) : Void
    {
        v.x = -v.x;
        v.y = -v.y;
    }
    
    override public function moveX(_xrel : Float) : Entity  //returns the object that is hit  
    {
        for (i in 0...Math.abs(_xrel))
        {
            var c : Entity = collideTypes(solids, x + Math.min(1, Math.abs(_xrel) - i) * FP.sign(_xrel), y);
            if (c == null)
            {
                x += Math.min(1, Math.abs(_xrel) - i) * FP.sign(_xrel);
            }
            else
            {
                if (c.type == "Player")
                {
                    v.x = -v.x;
                    v.y = -v.y;
                }
                else
                {
                    v.x = 0;
                    v.y = 0;
                }
                return c;
            }
        }
        return null;
    }
    
    override public function moveY(_yrel : Float) : Entity  //returns the object that is hit  
    {
        for (i in 0...Math.abs(_yrel))
        {
            var c : Entity = collideTypes(solids, x, y + Math.min(1, Math.abs(_yrel) - i) * FP.sign(_yrel));
            if (c == null)
            {
                y += Math.min(1, Math.abs(_yrel) - i) * FP.sign(_yrel);
            }
            else
            {
                if (c.type == "Player")
                {
                    v.x = -v.x;
                    v.y = -v.y;
                }
                else
                {
                    v.x = 0;
                    v.y = 0;
                }
                return c;
            }
        }
        return null;
    }
}

