package enemies;

import net.flashpunk.graphics.Spritemap;

/**
	 * ...
	 * @author Time
	 */
class Squishle extends Enemy
{
    @:meta(Embed(source="../../assets/graphics/Squishle.png"))
private var imgSquishle : Class<Dynamic>;
    private var sprSquishle : Spritemap = new Spritemap(imgSquishle, 16, 11);
    
    private var sittingAnim(default, never) : Array<Dynamic> = [2, 3];
    private var loops(default, never) : Int = 1;
    
    public function new(_x : Int, _y : Int)
    {
        super(_x, _y, sprSquishle);
        sprSquishle.add("run", [0, 1, 2, 3, 4], 10);
        
        sprSquishle.play("");
    }
    
    override public function render() : Void
    {
        if (sprSquishle.currentAnim == "")
        {
            sprSquishle.frame = sittingAnim[Game.worldFrame(sittingAnim.length, loops)];
        }
        super.render();
    }
}

