package enemies;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
	 * ...
	 * @author Time
	 */
class Tentacle extends Enemy
{
    @:meta(Embed(source="../../assets/graphics/Tentacle.png"))
private var imgTentacle : Class<Dynamic>;
    private var sprTentacle : Spritemap = new Spritemap(imgTentacle, 80, 49, animEnd);
    
    private var right : Bool;
    private var hitRect : Rectangle;
    private var parent : TentacleBeast;
    
    private var force(default, never) : Int = 2;
    
    public function new(_x : Int, _y : Int, _parent : TentacleBeast = null, _right : Bool = true)
    {
        super(_x, _y, sprTentacle);
        
        parent = _parent;
        right = _right;
        
        sprTentacle.originX = 8;
        sprTentacle.originY = 47;
        sprTentacle.x = -sprTentacle.originX;
        sprTentacle.y = -sprTentacle.originY;
        
        var dAnimSpeed : Int = 10;
        var dSitAnimSpeed : Int = 5;
        sprTentacle.add("rise", [0, 1, 2, 3, 4], dAnimSpeed);
        sprTentacle.add("sit", [5, 6, 5, 6, 5, 6], dSitAnimSpeed);
        sprTentacle.add("hit", [7, 8, 9, 10, 11], dAnimSpeed);
        sprTentacle.add("hitting", [12], dAnimSpeed);
        sprTentacle.add("sink", [13, 14, 15, 16], dAnimSpeed);
        sprTentacle.add("cut", [17, 18, 19, 20], dAnimSpeed);
        sprTentacle.play("rise");
        
        hitRect = new Rectangle(66 * as3hx.Compat.parseInt(!right), 6, 66, 8);
        
        setHitbox(16, 4, 8, 2);
        
        sprTentacle.scaleX = 2 * as3hx.Compat.parseInt(right) - 1;
        type = "Enemy";
        
        hitsMax = 1;
        
        layer = -(y - originY + height);
    }
    
    override public function update() : Void
    {
        if (Game.freezeObjects)
        {
            sprTentacle.rate = 0;
            return;
        }
        sprTentacle.rate = 1;
        
        canHit = sprTentacle.currentAnim == "sit";
        
        if (sprTentacle.currentAnim == "hitting")
        {
            var p : Player = try cast(FP.world.collideRect("Player", x - hitRect.x, y - hitRect.y, hitRect.width, hitRect.height), Player) catch(e:Dynamic) null;
            if (p != null)
            {
                p.hit(this, force, new Point(x, y), damage);
            }
        }
        hitUpdate();
        if (destroy)
        {
            sprTentacle.play("cut");
            sprTentacle.alpha -= 0.01;
            if (sprTentacle.alpha <= 0)
            {
                if (parent != null)
                {
                    parent.maxTentacles--;
                    parent.maxWhirlpools++;
                }
                FP.world.remove(this);
            }
        }
    }
    
    override public function knockback(f : Float = 0, p : Point = null) : Void
    {
    }
    
    public function animEnd() : Void
    {
        var _sw12_ = (sprTentacle.currentAnim);        

        switch (_sw12_)
        {
            case "rise":
                sprTentacle.play("sit");
            case "sit":
                sprTentacle.play("hit");
            case "hit":
                sprTentacle.play("hitting");
                Music.playSoundDistPlayer(x, y, "Tentacle");
            case "hitting":
                sprTentacle.play("sink");
            case "sink":
                FP.world.remove(this);
            default:
                sprTentacle.play("cut");
        }
    }
    
    override public function startDeath(t : String = "") : Void
    {
        destroy = true;
        dieEffects(t, 24, sprTentacle.scaleX * 8, -8);
    }
}

