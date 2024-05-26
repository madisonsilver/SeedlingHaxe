package scenery;

import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import net.flashpunk.Entity;
import net.flashpunk.utils.Draw;
import net.flashpunk.FP;
import openfl.display.BlendMode;

/**
	 * ...
	 * @author Time
	 */
class Shadow extends Entity
{
    private var c : Int;
    private var a : Float;
    private var w : Int;
    private var h : Int;
    private var myBmp : BitmapData;
    private var myMatrix : Matrix;
    
    public function new(_x : Int, _y : Int, _c : Int, _a : Float, _w : Int, _h : Int)
    {
        super(_x, _y);
        c = _c;
        a = _a;
        w = _w;
        h = _h;
        layer = -(y);
        
        myBmp = new BitmapData(w, h, true, as3hx.Compat.parseInt(a * 255) * 0x01000000 + c);
    }
    
    override public function render() : Void
    {
        if (y + h > FP.camera.y && x + w > FP.camera.x && y < FP.camera.y + FP.screen.height && x < FP.camera.x + FP.screen.width)
        
        //Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
{            
            //Draw.rect(x, y, w, h, c, a);
            //Draw.resetTarget();
            myMatrix = new Matrix();
            myMatrix.translate(x - FP.camera.x, y - FP.camera.y);
            (try cast(FP.world, Game) catch(e:Dynamic) null).nightBmp.draw(myBmp, myMatrix);
        }
    }
}

