package nPCs;

import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import net.flashpunk.utils.Input;

/**
	 * ...
	 * @author Time
	 */
class BobBossNPC extends NPC
{
    @:meta(Embed(source="../../assets/graphics/NPCs/BobBoss1Pic.png"))
private var imgBobBoss1Pic : Class<Dynamic>;
    @:meta(Embed(source="../../assets/graphics/NPCs/BobBoss2Pic.png"))
private var imgBobBoss2Pic : Class<Dynamic>;
    @:meta(Embed(source="../../assets/graphics/NPCs/BobBoss3Pic.png"))
private var imgBobBoss3Pic : Class<Dynamic>;
    private var pics(default, never) : Array<Dynamic> = [imgBobBoss1Pic, imgBobBoss2Pic, imgBobBoss3Pic];
    
    public function new(_x : Int, _y : Int, _st : Int = 0, _text : String = "", _talkingSpeed : Int = 10)
    {
        super(_x, _y, null, -1, _text, _talkingSpeed);
        myPic = new Image(pics[_st]);
    }
    
    override public function talk() : Void
    {
        var p : Player = try cast(FP.world.nearestToEntity("Player", this), Player) catch(e:Dynamic) null;
        if (p != null)
        {
            if (talking)
            {
                Game.freezeObjects = true;
            }
            
            var hitKey : Bool = Input.released(p.keys[6]);
            if (talking && hitKey)
            {
                Music.playSound("Text", 1, 0.3);
                if (Game.currentCharacter >= myText[myCurrentText].length)
                {
                    myCurrentText++;
                }
                else
                {
                    Game.currentCharacter =Std.int( myText[myCurrentText].length - 1);
                }
                if (myCurrentText >= myText.length)
                {
                    talking = false;
                    FP.world.remove(this);
                    return;
                }
                Game.talkingText = myText[myCurrentText];
            }
            
            inRange = true;
            if (!Game.talking)
            {
                if (!talked)
                {
                    talking = true;
                    talked = true;
                }
            }
        }
    }
}

