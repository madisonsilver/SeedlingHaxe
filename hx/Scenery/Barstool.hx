package scenery;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;

/**
	 * ...
	 * @author Time
	 */
class Barstool extends Entity
{
    @:meta(Embed(source="../../assets/graphics/Barstool.png"))
private var imgBarstool : Class<Dynamic>;
    private var sprBarstool : Image = new Image(imgBarstool);
    
    public function new(_x : Int, _y : Int)
    {
        super(_x + Tile.w / 4, _y + Tile.h / 4, sprBarstool);
        setHitbox(8, 8);
        sprBarstool.y = -4;
        sprBarstool.originY = -sprBarstool.y;
        type = "Solid";
        layer = Std.int(-(y - originY));
    }
}

