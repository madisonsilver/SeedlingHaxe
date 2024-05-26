package pickups;

import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
	 * ...
	 * @author Time
	 */
class Coin extends Pickup
{
    @:meta(Embed(source="../../assets/graphics/Coin.png"))
private var imgCoin : Class<Dynamic>;
    private var sprCoin : Spritemap = new Spritemap(imgCoin, 4, 4);
    
    public function new(_x : Int, _y : Int, _v : Point = null)
    {
        super(_x, _y, sprCoin, _v);
        sprCoin.centerOO();
        type = "Coin";
        setHitbox(4, 4, 2, 2);
    }
    
    override public function render() : Void
    {
        sprCoin.frame = Game.worldFrame(sprCoin.frameCount);
        super.render();
    }
}

