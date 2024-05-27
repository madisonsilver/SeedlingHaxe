package enemies;

import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;
import net.flashpunk.utils.Draw;

/**
	 * ...
	 * @author Time
	 */
class LavaTrap extends Enemy
{
    @:meta(Embed(source="../../assets/graphics/LavaTrap.png"))
private var imgLavaTrap : Class<Dynamic>;
    private var sprLavaTrap : Spritemap = new Spritemap(imgLavaTrap, 16, 16, endAnim);
    @:meta(Embed(source="../../assets/graphics/LavaTrapTongue.png"))
private var imgLavaTrapTongue : Class<Dynamic>;
    private var sprLavaTrapTongue : Spritemap = new Spritemap(imgLavaTrapTongue, 32, 6, tongueOut);
    
    private var chompAnimSpeed(default, never) : Int = 10;
    private var tongueAnimSpeed(default, never) : Int = 30;
    private var chompRange(default, never) : Int = 32;  // The distance at which the lava trap will launch its tongue.  
    
    private var tongueLengths(default, never) : Array<Dynamic> = [32, 29, 22, 15, 10, 7];
    private var tongueAngle : Float = 0;
    private var attached : Player;
    private var wait : Bool = true;
    
    public function new(_x : Int, _y : Int)
    {
        super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprLavaTrap);
        
        sprLavaTrap.centerOO();
        //the animation "" will reset it to the world frame speed
        sprLavaTrap.add("chomp", [2], chompAnimSpeed);
        sprLavaTrap.add("die", [3, 4, 5, 6, 7, 8], chompAnimSpeed);
        sprLavaTrap.play("");
        
        sprLavaTrapTongue.add("out", [5, 2, 0], tongueAnimSpeed);
        sprLavaTrapTongue.add("in", [0, 1, 2, 3, 4, 5], tongueAnimSpeed);
        sprLavaTrapTongue.originY =Std.int( sprLavaTrapTongue.height / 2);
        sprLavaTrapTongue.y = -sprLavaTrapTongue.originY;
        
        setHitbox(10, 10, 5, 5);
        
        layer = Std.int(-(y - originY + height * 4 / 5));
    }
    
    override public function update() : Void
    {
        super.update();
        if (sprLavaTrap.currentAnim == "die")
        {
            return;
        }
        sprLavaTrapTongue.update();
        if (attached != null)
        {
            var ind : Int = getTongueLength();
            attached.x = x + tongueLengths[ind] * Math.cos(tongueAngle);
            attached.y = y + tongueLengths[ind] * Math.sin(tongueAngle);
            attached.onGround = false;
            if (ind >= tongueLengths.length - 1)
            {
                if (Player.hasDarkSuit)
                {
                    attached.onGround = true;
                    attached = null;
                    wait = true;
                }
                else
                {
                    attached.die();
                }
            }
        }
        else
        {
            var player : Player = try cast(FP.world.nearestToEntity("Player", this), Player) catch(e:Dynamic) null;
            if (player != null)
            {
                var d : Int =Std.int( FP.distance(x, y, player.x, player.y));
                if (d <= chompRange && !wait)
                {
                    if (sprLavaTrap.currentAnim == "")
                    {
                        tongueAngle = Math.atan2(player.y - y, player.x - x);
                    }
                    if (!FP.world.collideLine("Solid", Std.int(x), Std.int(y), Std.int(player.x), Std.int(player.y)) && sprLavaTrap.currentAnim != "chomp")
                    {
                        launch();
                        Music.playSoundDistPlayer(Std.int(x), Std.int(y), "Enemy Attack", 3);
                        sprLavaTrap.play("chomp");
                    }
                    else
                    {
                        sprLavaTrap.play("");
                    }
                }
                else
                {
                    if (d > chompRange)
                    {
                        wait = false;
                    }
                    sprLavaTrap.play("");
                }
            }
            else
            {
                sprLavaTrap.play("");
            }
            if (sprLavaTrap.currentAnim == "")
            {
                sprLavaTrap.frame = Game.worldFrame(2);
            }
        }
    }
    
    override public function startDeath(t : String = "") : Void
    {
        sprLavaTrap.play("die");
    }
    
    override public function render() : Void
    {
        super.render();
        if (sprLavaTrapTongue.currentAnim != "")
        {
            var ind : Int = getTongueLength();
            sprLavaTrapTongue.angle = tongueAngle * FP.DEG;
            sprLavaTrapTongue.render(new Point(x, y), FP.camera);
            Draw.setTarget((try cast(FP.world, Game) catch(e:Dynamic) null).nightBmp, FP.camera);
            sprLavaTrapTongue.render(new Point(x, y), FP.camera);
            Draw.resetTarget();
        }
    }
    
    private function launch() : Void
    {
        if (sprLavaTrapTongue.currentAnim == "")
        {
            sprLavaTrapTongue.play("out");
        }
        var ind : Int = getTongueLength();
        var pHit : Player = try cast(FP.world.collideLine("Player", Std.int(x), Std.int(y), Std.int(x + tongueLengths[ind] * Math.cos(tongueAngle)), Std.int(y + tongueLengths[ind] * Math.sin(tongueAngle))), Player) catch(e:Dynamic) null;
        if (pHit != null)
        {
            attached = pHit;
        }
    }
    
    public function getTongueLength() : Int
    {
        return as3hx.Compat.parseInt(sprLavaTrapTongue.frame / sprLavaTrapTongue.frameCount * tongueLengths.length);
    }
    
    override public function layering() : Void
    {
    }
    override public function knockback(f : Float = 0, p : Point = null) : Void
    {
    }
    override public function hitPlayer() : Void
    {
    }
    
    public function endAnim() : Void
    {
        var _sw7_ = (sprLavaTrap.currentAnim);        

        switch (_sw7_)
        {
            case "die":
                FP.world.remove(this);
            default:
        }
    }
    
    public function tongueOut() : Void
    {
        var _sw8_ = (sprLavaTrapTongue.currentAnim);        

        switch (_sw8_)
        {
            case "out":
                sprLavaTrapTongue.play("in");
            default:
                sprLavaTrapTongue.play("");
                sprLavaTrap.play("");
        }
    }
}

