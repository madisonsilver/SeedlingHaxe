package nPCs;

import net.flashpunk.graphics.Spritemap;
import scenery.Tile;

/**
	 * ...
	 * @author Time
	 */
class Totem extends NPC
{
    @:meta(Embed(source="../../assets/graphics/Totem.png"))
private var imgTotem : Class<Dynamic>;
    private var sprTotem : Spritemap = new Spritemap(imgTotem, 32, 64);
    
    public function new(_x : Int, _y : Int, _tag : Int = -1, _text : String = "", _talkingSpeed : Int = 10)
    {
        super();
        //The weird tiles for the constructor are because NPC offsets by Tile.w/2, Tile.h/2 automagically.
        super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h * 5 / 2), sprTotem, _tag, _text, _talkingSpeed);
        facePlayer = false;
        
        sprTotem.originX = 16;
        sprTotem.x = -sprTotem.originX;
        sprTotem.originY = 48;
        sprTotem.y = -sprTotem.originY;
        setHitbox(Tile.w * 2, Tile.h * 2, Tile.w, Tile.h);
    }
}

