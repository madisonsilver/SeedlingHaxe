package scenery;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;

/**
	 * ...
	 * @author Time
	 */
class RuinedPillar extends Entity
{
    
    @:meta(Embed(source="../../assets/graphics/RuinedPillar.png"))
private var imgRuinedPillar : Class<Dynamic>;
    private var sprRuinedPillar : Spritemap = new Spritemap(imgRuinedPillar, 32, 48);
    
    public function new(_x : Int, _y : Int)
    {
        super(_x, _y, sprRuinedPillar);
        sprRuinedPillar.y = -16;
        sprRuinedPillar.originY = -sprRuinedPillar.y;
        setHitbox(32, 32);
        type = "Solid";
        layer = Std.int(-(y - originY + height * 4 / 5));
    }
}

