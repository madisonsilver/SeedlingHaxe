package nPCs;

import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
	 * ...
	 * @author Time
	 */
class Rekcahdam extends NPC
{
    @:meta(Embed(source="../../assets/graphics/NPCs/Rekcahdam.png"))
private var imgRekcahdam : Class<Dynamic>;
    private var sprRekcahdam : Spritemap = new Spritemap(imgRekcahdam, 9, 10);
    @:meta(Embed(source="../../assets/graphics/NPCs/RekcahdamPic.png"))
private var imgRekcahdamPic : Class<Dynamic>;
    private var sprRekcahdamPic : Image = new Image(imgRekcahdamPic);
    
    public function new(_x : Int, _y : Int, _tag : Int = -1, _text : String = "", _talkingSpeed : Int = 10)
    {
        super(_x, _y, sprRekcahdam, _tag, _text, _talkingSpeed);
        sprRekcahdam.add("talk", [0, 1, 0], 5);
        
        myPic = sprRekcahdamPic;
    }
    
    override public function render() : Void
    {
        if (talking)
        {
            sprRekcahdam.play("talk");
        }
        else
        {
            sprRekcahdam.frame = Game.worldFrame(2);
        }
        super.render();
    }
}

