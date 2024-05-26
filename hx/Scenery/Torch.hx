package scenery;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Draw;
import net.flashpunk.FP;

/**
	 * ...
	 * @author Time
	 */
class Torch extends Entity
{
    @:meta(Embed(source="../../assets/graphics/Torch.png"))
private var imgTorch : Class<Dynamic>;
    private var sprTorch : Spritemap = new Spritemap(imgTorch, 4, 10);
    
    private var color : Int;
    
    public function new(_x : Int, _y : Int, _c : Int = 0xFFFFFF)
    {
        super(_x + Tile.w / 2, _y + Tile.h / 2, sprTorch);
        sprTorch.centerOO();
        color = _c;
        layer = Std.int(-(y - sprTorch.originY + sprTorch.height + Tile.h / 2));
        FP.world.add(new Light(Std.int(x), Std.int(y), sprTorch.frameCount, 1, color, false));
    }
    
    override public function render() : Void
    {
        sprTorch.frame = Game.worldFrame(sprTorch.frameCount);
        super.render();
    }
}

