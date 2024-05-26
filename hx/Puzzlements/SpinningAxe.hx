package puzzlements;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import net.flashpunk.FP;
import net.flashpunk.utils.Draw;
import scenery.Tile;

/**
	 * ...
	 * @author Time
	 */
class SpinningAxe extends Entity
{
    @:meta(Embed(source="../../assets/graphics/SpinningAxe.png"))
private var imgSpinningAxe : Class<Dynamic>;
    @:meta(Embed(source="../../assets/graphics/SpinningAxeRed.png"))
private var imgSpinningAxeRed : Class<Dynamic>;
    private var sprSpinningAxe : Image;
    
    private var length(default, never) : Int = 32;
    private var endRectSide(default, never) : Int = 12;
    
    private var spinRate : Float;
    private var force : Int = 5;
    private var damage : Int = 1;
    
    public function new(_x : Int, _y : Int, _rate : Int, _colorType : Int = 0)
    {
        switch (_colorType)
        {
            case 1:
                sprSpinningAxe = new Image(imgSpinningAxeRed);
            default:
                sprSpinningAxe = new Image(imgSpinningAxe);
        }
        super(_x + Tile.w / 2, _y + Tile.h / 2, sprSpinningAxe);
        sprSpinningAxe.originX = 4;
        sprSpinningAxe.originY =Std.int( sprSpinningAxe.height / 2);
        sprSpinningAxe.x = -sprSpinningAxe.originX;
        sprSpinningAxe.y = -sprSpinningAxe.originY;
        
        setHitbox(8, 8, 4, 4);
        type = "Solid";
        
        spinRate = _rate;
    }
    
    override public function update() : Void
    {
        super.update();
        
        sprSpinningAxe.angle += spinRate;
        
        var a : Float = -sprSpinningAxe.angle / 180 * Math.PI;
        var p : Player = try cast(FP.world.collideLine("Player", Std.int(x), Std.int(y), Std.int(x + length * Math.cos(a)), Std.int(y + length * Math.sin(a))), Player) catch(e:Dynamic) null;
        if (p == null)
        {
            p = try cast(FP.world.collideRect("Player", x - endRectSide / 2, y - endRectSide / 2, endRectSide, endRectSide), Player) catch(e:Dynamic) null;
        }
        hitPlayer(p, a);
        
        layer = Std.int(-(y + length));
    }
    
    public function hitPlayer(p : Player, a : Float) : Void
    {
        if (p != null)
        {
            var m : Float = Math.tan(a + 2 * spinRate / 180 * Math.PI);
            var a : Float = p.x;
            var b : Float = p.y;
            var c : Float = y - m * x;
            var _x : Float = (m * (b - c) + a) / (m * m + 1);
            
            p.hit(null, force, new Point(_x, b + (a - _x) / m), damage);
        }
    }
}

