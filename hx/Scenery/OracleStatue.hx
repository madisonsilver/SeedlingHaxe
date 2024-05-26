package scenery;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;

/**
	 * ...
	 * @author Time
	 */
class OracleStatue extends Entity
{
    
    @:meta(Embed(source="../../assets/graphics/OracleStatue.png"))
private var imgOracleStatue : Class<Dynamic>;
    private var sprOracleStatue : Spritemap = new Spritemap(imgOracleStatue, 32, 48);
    
    public function new(_x : Int, _y : Int)
    {
        super(_x, _y, sprOracleStatue);
        sprOracleStatue.y = -16;
        sprOracleStatue.originY = -sprOracleStatue.y;
        setHitbox(32, 32);
        type = "Solid";
        layer = Std.int(-(y - originY + height * 4 / 5));
    }
    
    override public function render() : Void
    {
        sprOracleStatue.frame = Game.worldFrame(sprOracleStatue.frameCount);
        super.render();
    }
}

