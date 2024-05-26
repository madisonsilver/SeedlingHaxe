package scenery;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;

/**
	 * ...
	 * @author Time
	 */
class Dresser extends Entity
{
    @:meta(Embed(source="../../assets/graphics/Dresser.png"))
private var imgDresser : Class<Dynamic>;
    private var sprDresser : Image = new Image(imgDresser);
    
    public function new(_x : Int, _y : Int)
    {
        super(_x, _y, sprDresser);
        sprDresser.y = -8;
        sprDresser.originY = -sprDresser.y;
        setHitbox(32, 16);
        type = "Solid";
        layer = -(y - originY + height * 4 / 5);
    }
}

