package scenery;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import net.flashpunk.utils.Draw;

/**
	 * ...
	 * @author Time
	 */
class SlashHit extends Entity
{
    @:meta(Embed(source="../../assets/graphics/SlashHit.png"))
private var imgSlashHit : Class<Dynamic>;
    private var sprSlashHit : Spritemap = new Spritemap(imgSlashHit, 32, 16, endAnim);
    
    public function new(_x : Int, _y : Int, _scx : Float)
    {
        super(_x, _y, sprSlashHit);
        sprSlashHit.centerOO();
        sprSlashHit.add("slash", [0, 1], 15);
        sprSlashHit.play("slash");
        sprSlashHit.scale = _scx / sprSlashHit.width + 0.35;
        layer = -(y + Tile.h * 3 / 2);
    }
    
    override public function render() : Void
    {
        super.render();
        Draw.setTarget((try cast(FP.world, Game) catch(e:Dynamic) null).nightBmp, FP.camera);
        super.render();
        Draw.resetTarget();
    }
    
    public function endAnim() : Void
    {
        FP.world.remove(this);
    }
}

