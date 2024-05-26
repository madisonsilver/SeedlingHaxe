package nPCs;

import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;

/**
	 * ...
	 * @author Time
	 */
class Yeti extends NPC
{
    @:meta(Embed(source="../../assets/graphics/NPCs/Yeti.png"))
private var imgYeti : Class<Dynamic>;
    private var sprYeti : Spritemap = new Spritemap(imgYeti, 10, 12);
    @:meta(Embed(source="../../assets/graphics/NPCs/YetiPic.png"))
private var imgYetiPic : Class<Dynamic>;
    private var sprYetiPic : Image = new Image(imgYetiPic);
    
    private var createdPortal : Bool = false;
    
    public function new(_x : Int, _y : Int, _tag : Int = -1, _text : String = "", _talkingSpeed : Int = 10)
    {
        super(_x, _y, sprYeti, _tag, _text, _talkingSpeed);
        sprYeti.add("talk", [0, 1], 5);
        
        myPic = sprYetiPic;
    }
    
    override public function render() : Void
    {
        if (talking)
        {
            sprYeti.play("talk");
        }
        else
        {
            sprYeti.frame = Game.worldFrame(2);
        }
        super.render();
    }
    
    override public function doneTalking() : Void
    {
        super.doneTalking();
        if (!createdPortal)
        {
            createdPortal = true;
            Game.setPersistence(tag, false);
            //In order for this to work, the portal in DeadBoss.oel must have tag "1"
            Game.setPersistence(1, false);
        }
    }
}

