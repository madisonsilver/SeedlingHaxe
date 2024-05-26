package scenery;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;

/**
	 * ...
	 * @author Time
	 */
class Bar extends Entity
{
    @:meta(Embed(source="../../assets/graphics/Bar.png"))
private var imgBar : Class<Dynamic>;
    private var sprBar : Image = new Image(imgBar);
    
    public function new(_x : Int, _y : Int)
    {
        super(_x, _y, sprBar);
        setHitbox(64, 16);
        sprBar.y = -4;
        sprBar.originY = -sprBar.y;
        type = "Solid";
        layer = Std.int(-(y - originY + height * 4 / 5));
    }
}

