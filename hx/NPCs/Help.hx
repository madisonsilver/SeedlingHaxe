package nPCs;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.graphics.Text;
import net.flashpunk.utils.Key;
import net.flashpunk.utils.Input;
import net.flashpunk.FP;
import net.flashpunk.utils.Draw;

/**
	 * ...
	 * @author Time
	 */
class Help extends Entity
{
    @:meta(Embed(source="../../assets/graphics/Help.png"))
private var imgHelp : Class<Dynamic>;
    private var sprHelp : Spritemap = new Spritemap(imgHelp, 67, 44);
    //Inventory
    //Mute
    //Move
    //Attack
    private static var keys : Array<Dynamic> = [[Key.V, Key.V], [Key.ANY, Key.M], [Key.RIGHT, Key.UP, Key.LEFT, Key.DOWN], [Key.X, Key.C]];
    private var remove : Bool = false;
    private var button : Bool;
    private var pt : Point;
    
    private var disappearRate : Float = 0.1;
    private var scMax(default, never) : Float = 1.5;
    private var scMin(default, never) : Float = 1;
    private var scRate : Float = 0.01;
    private var sc : Float = scMin;
    
    private var timeExtraHelp : Int = 240;
    private var texts(default, never) : Array<Dynamic> = ["press V", "press M to mute", "press an arrow key", "press X or C"];
    
    public function new(_t : Int = 0, _button : Bool = true, _p : Point = null)
    {
        super(0, 0, sprHelp);
        sprHelp.frame = _t;
        sprHelp.centerOO();
        
        button = _button;
        
        layer = -FP.height * 2;
        visible = false;
        
        if (_p != null)
        {
            pt = _p.clone();
        }
        else
        {
            var margin : Int = 16;
            pt = new Point(FP.screen.width / 2, FP.screen.height - sprHelp.height / 2 - margin);
        }
        
        if (sprHelp.frame == 1)
        {
            timeExtraHelp = 0;
            disappearRate = 0.0075;
        }
    }
    
    override public function update() : Void
    {
        super.update();
        
        if (timeExtraHelp > 0)
        {
            timeExtraHelp--;
        }
        
        sc += scRate;
        if (sc <= scMin)
        {
            sc = scMin;
            scRate = -scRate;
        }
        else if (sc >= scMax)
        {
            sc = scMax;
            scRate = -scRate;
        }
        sprHelp.color = FP.colorLerp(0xFFFFFF, 0x0000FF, Math.sin(sc / (scMax - scMin) * Math.PI));
        
        if (button)
        {
            var hitKey : Bool = false;
            for (i in 0...keys[sprHelp.frame].length)
            {
                if (Input.pressed(keys[sprHelp.frame][i]))
                {
                    hitKey = true;
                    break;
                }
            }
            
            if (hitKey)
            {
                remove = true;
            }
            Game.freezeObjects = true;
            if (remove)
            {
                sprHelp.alpha -= disappearRate;
                if (sprHelp.frame != 1)
                {
                    Game.freezeObjects = false;
                }
                if (sprHelp.alpha <= 0)
                {
                    if (sprHelp.frame == 0)
                    {
                        Game.inventory.open = true;
                    }
                    Game.freezeObjects = false;
                    FP.world.remove(this);
                }
            }
        }
    }
    
    override public function render() : Void
    {
        if (timeExtraHelp <= 0)
        {
            Text.size = 8;
            var t : Text = new Text(texts[sprHelp.frame]);
            Text.size = 16;
            
            var ptText : Point = new Point(pt.x - t.width / 2, FP.screen.height - t.height);
            t.alpha = sprHelp.alpha;
            t.color = sprHelp.color;
            t.render(new Point(ptText.x - 1, ptText.y), new Point());
            t.render(new Point(ptText.x + 1, ptText.y), new Point());
            t.render(new Point(ptText.x, ptText.y - 1), new Point());
            t.render(new Point(ptText.x, ptText.y + 1), new Point());
            t.color = 0;
            t.render(ptText.clone(), new Point());
            Draw.setTarget((try cast(FP.world, Game) catch(e:Dynamic) null).nightBmp, new Point());
            t.render(ptText.clone(), new Point());
            Draw.resetTarget();
        }
        
        if (sprHelp.frame != 1)
        {
            sprHelp.render(pt.clone(), new Point());
            Draw.setTarget((try cast(FP.world, Game) catch(e:Dynamic) null).nightBmp, new Point());
            sprHelp.render(pt.clone(), new Point());
            Draw.resetTarget();
        }
    }
}

