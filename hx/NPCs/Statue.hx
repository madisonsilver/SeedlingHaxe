package nPCs;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.masks.Pixelmask;
import net.flashpunk.utils.Draw;
import net.flashpunk.FP;
import scenery.Tile;

/**
	 * ...
	 * @author Time
	 */
class Statue extends NPC
{
    private var frame : Int;
    
    public function new(_x : Int, _y : Int, _t : Int = 0, _text : String = "", _talkingSpeed : Int = 10)
    {
        super(_x + Tile.w, Std.int(_y - Tile.h / 2 + Tile.h * as3hx.Compat.parseInt(_t == 0)), Game.sprStatues, -1, _text, _talkingSpeed, 34);
        facePlayer = false;
        frame = _t;
        type = "Solid";
        align = "CENTER";
        talkRange = 32;
    }
    
    override public function render() : Void
    {
        var w : Int = (try cast(graphic, Image) catch(e:Dynamic) null).width;
        
        switch (frame)
        {
            case 0:
                graphic.y = -24;
                setHitbox(w, 32, Std.int(w / 2), 16);
            case 1:
                graphic.y = -16;
                setHitbox(w, 24, Std.int(w / 2));
        }
        (try cast(graphic, Spritemap) catch(e:Dynamic) null).frame = frame;
        super.render();
    }
    
    override public function layering() : Void
    {
        switch (frame)
        {
            case 0:
                layer = Std.int(-(y - originY + height - 8));
            case 1:
                layer = Std.int(-(y - originY + height - 24));
            default:
                layer = Std.int(-(y - originY + height));
        }
    }
}

