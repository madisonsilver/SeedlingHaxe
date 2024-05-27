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
class Spinner extends Enemy
{
    @:meta(Embed(source="../../assets/graphics/Spinner.png"))
private var imgSpinner : Class<Dynamic>;
    private var sprSpinner : Spritemap = new Spritemap(imgSpinner, 18, 9);
    
    private var tag : Int;
    private var doActions : Bool = true;
    
    public var moveSpeed : Float = 1;
    private var runRange(default, never) : Int = 0;  //Range at which the Spinner will run after the character   
    private var hammerAngle : Float = 0;
    
    private var hitForce(default, never) : Float = 4;
    
    public function new(_x : Int, _y : Int, _tag : Int = -1)
    {
        super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprSpinner);
        
        v = new Point(moveSpeed * Math.cos(-Math.PI / 4), moveSpeed * Math.sin(-Math.PI / 4));
        
        sprSpinner.x = -5;
        sprSpinner.originX =Std.int( -sprSpinner.x);
        sprSpinner.y = -5;
        sprSpinner.originY =Std.int( -sprSpinner.y);
        
        tag = _tag;
        
        setHitbox(7, 7, 4, 4);
        
        activeOffScreen = true;
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
            Game.setPersistence(tag, false);
        }
    }
    
    override public function update() : Void
    {
        super.update();
        
        var hammerLength : Int = as3hx.Compat.parseInt(sprSpinner.width - sprSpinner.originX);
        hammerAngle = (Game.time % Game.timePerFrame) / Game.timePerFrame * 2 * Math.PI;
        var player : Player = try cast(FP.world.collideLine("Player", Std.int(x), Std.int(y), Std.int(x + hammerLength * Math.cos(hammerAngle)), Std.int(y + hammerLength * Math.sin(hammerAngle))), Player) catch(e:Dynamic) null;
        if (player != null)
        {
            player.hit(this, hitForce, new Point(x, y));
        }
        
        player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch(e:Dynamic) null;
        if (player != null)
        {
            var d : Float = FP.distance(x, y, player.x, player.y);
            if (d <= runRange && FP.world.collideLine("Solid", Std.int(x), Std.int(y), Std.int(player.x), Std.int(player.y))==null)
            {
                var a : Float = Math.atan2(player.y - y, player.x - x);
                var toV : Point = new Point(moveSpeed * Math.cos(a), moveSpeed * Math.sin(a));
                var pushed : Bool = v.length > moveSpeed;  //If we're already moving faster than we should...  
                v.x += FP.sign(toV.x - v.x) * moveSpeed;
                v.y += FP.sign(toV.y - v.y) * moveSpeed;
                if (!pushed && v.length > moveSpeed)
                {
                    v.normalize(moveSpeed);
                }
            }
        }
    }
    
    override public function render() : Void
    {
        var alpha : Float = sprSpinner.alpha;
        if (hits >= hitsMax)
        {
            sprSpinner.scale += 0.1;
            sprSpinner.alpha = Math.max(0, 2 - sprSpinner.scale) * alpha;
            sprSpinner.angle = -hammerAngle / Math.PI * 180;
            sprSpinner.frame = 1;
            sprSpinner.render(new Point(x, y), FP.camera);
            sprSpinner.alpha = alpha;
            sprSpinner.angle = 0;
            sprSpinner.frame = 0;
            sprSpinner.render(new Point(x, y), FP.camera);
        }
        else
        {
            sprSpinner.angle = -hammerAngle / Math.PI * 180;
            sprSpinner.frame = 1;
            sprSpinner.render(new Point(x, y), FP.camera);
            sprSpinner.angle = 0;
            sprSpinner.frame = 0;
            sprSpinner.render(new Point(x, y), FP.camera);
        }
        sprSpinner.alpha = alpha;
    }
    
    override public function friction() : Void
    {
        v.normalize(Math.max(v.length - f, moveSpeed));
        if (Math.abs(v.x) < 0.05)
        {
            v.x = 0;
        }
        if (Math.abs(v.y) < 0.05)
        {
            v.y = 0;
        }
    }
    
    override public function moveX(_xrel : Float) : Entity  //returns the object that is hit  
    {
        var i: Int = 0;
        while (i < Math.abs(_xrel))
        {
            var c : Entity = collideTypes(solids, x + Math.min(1, Math.abs(_xrel) - i) * FP.sign(_xrel), y);
            if (c == null)
            {
                x += Math.min(1, Math.abs(_xrel) - i) * FP.sign(_xrel);
            }
            else
            {
                v.x = -v.x;
                return c;
            }
            i += 1;
        }
        return null;
    }
    
    override public function moveY(_yrel : Float) : Entity  //returns the object that is hit  
    {
        var i: Int = 0;
        while (i < Math.abs(_yrel))
        {
            var c : Entity = collideTypes(solids, x, y + Math.min(1, Math.abs(_yrel) - i) * FP.sign(_yrel));
            if (c == null)
            {
                y += Math.min(1, Math.abs(_yrel) - i) * FP.sign(_yrel);
            }
            else
            {
                v.y = -v.y;
                return c;
            }
            i = i+1;
        }
        return null;
    }
}

