package projectiles;

import enemies.Enemy;
import enemies.LavaBoss;
import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Draw;

/**
	 * ...
	 * @author Time
	 */
class BossTotemShot extends Mobile
{
    @:meta(Embed(source="../../assets/graphics/BossTotemShot.png"))
private var imgBossTotemShot : Class<Dynamic>;
    private var sprBossTotemShot : Spritemap = new Spritemap(imgBossTotemShot, 20, 20);
    
    public var hitables : Dynamic = ["Player", "Solid"];
    private var roomBottom(default, never) : Int = 384;  // THE BOTTOM WALL OF THE ROOM TO DESTROY AT  
    private var spinRate(default, never) : Int = -6;
    
    public function new(_x : Int, _y : Int, _v : Point)
    {
        super(_x, _y, sprBossTotemShot);
        sprBossTotemShot.centerOO();
        sprBossTotemShot.add("fly", [0, 1, 2], 10);
        sprBossTotemShot.play("fly");
        v = _v;
        f = 0;
        setHitbox(16, 16, 8, 8);
        type = "BossTotemShot";
        solids = [];
        if (v.length > 0)
        {
            imageAngle();
        }
    }
    
    override public function update() : Void
    {
        super.update();
        if (v.length > 0)
        {
            imageAngle();
            var hits : Array<Entity> = new Array<Entity>();
            collideTypesInto(hitables, x, y, hits);
            destroy = false;
            var flipped : Bool = false;
            for (i in 0...hits.length)
            {
                var _sw1_ = (hits[i].type);                

                switch (_sw1_)
                {
                    case "Player":
                        (try cast(hits[i], Player) catch(e:Dynamic) null).hit(null, v.length, new Point(x, y));
                        destroy = true;
                    case "Solid":
                        if (!flipped)
                        {
                            v.x = -v.x;
                            flipped = true;
                        }
                    default:
                }
            }
            if (destroy || y - originY + height >= roomBottom)
            {
                FP.world.add(new Explosion(Std.int(x + v.x), Std.int(y + v.y), hitables, 24, 1));
                FP.world.remove(this);
            }
        }
        if (!onScreen((try cast(graphic, Spritemap) catch(e:Dynamic) null).width))
        {
            FP.world.remove(this);
        }
    }
    
    public function imageAngle() : Void
    {
        (try cast(graphic, Image) catch(e:Dynamic) null).angle += spinRate * FP.sign(v.x);
    }
    
    override public function render() : Void
    {
        super.render();
        Draw.setTarget((try cast(FP.world, Game) catch(e:Dynamic) null).nightBmp, FP.camera);
        super.render();
        Draw.resetTarget();
    }
}

