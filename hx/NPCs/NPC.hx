package nPCs;

import enemies.LightBossController;
import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Input;
import pickups.BossKey;
import pickups.Pickup;
import scenery.Tile;

/**
	 * ...
	 * @author Time
	 */
class NPC extends Mobile
{
    public var talking(get, set) : Bool;

    @:meta(Embed(source="../../assets/graphics/NPCs/Talk.png"))
private var imgTalk : Class<Dynamic>;
    private var sprTalk : Spritemap = new Spritemap(imgTalk, 10, 14);
    
    public var talked : Bool = false;  //If the player has already talked to him since he came in range  
    private var _talking : Bool = false;
    public var tag : Int;
    
    public var lineLength : Int;
    public var talkRange : Int = 24;
    public var inRange : Bool = false;
    public var myPic : Image;
    public var myText : Dynamic = [];
    public var myCurrentText : Int = 0;
    
    public var facePlayer : Bool = true;
    public var charToTalkMargin : Int = 2;  //The distance from the character image to the prompt  
    
    public var talkingSpeed : Int;  //Matches up with Game.framesPerCharacter; sets the speed of each letter entering the screen.  
    //Measured in frames/character.
    
    public var temporary : Bool = false;
    public var showTalk : Bool = true;
    public var keyNeeded : Bool = true;
    public var parent : Entity;
    
    public var align : String = "LEFT";
    
    public function new(_x : Int, _y : Int, _g : Image, _tag : Int = -1, _text : String = "", _talkingSpeed : Int = 0, _lineLength : Int = 28)
    {
        super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), _g);
        lineLength = _lineLength;
        if (_talkingSpeed < 0)
        {
            _talkingSpeed = Game.framesPerCharacterDefault;
        }
        if (graphic)
        {
            (try cast(graphic, Image) catch(e:Dynamic) null).centerOO();
            setHitbox(_g.width, _g.height, Std.int(_g.width / 2), Std.int(_g.height / 2));
        }
        type = "Solid";
        
        sprTalk.centerOO();
        sprTalk.y = -sprTalk.height;
        sprTalk.originY =Std.int( sprTalk.y);
        
        talkingSpeed = _talkingSpeed;
        tag = _tag;
        
        prepNewText(_text);
    }
    
    override public function removed() : Void
    {
        super.removed();
        if (parent != null)
        {
            if (Std.is(parent, Pickup))
            {
                (try cast(parent, Pickup) catch(e:Dynamic) null).myText = null;
            }
            else if (Std.is(parent, LightBossController))
            {
                (try cast(parent, LightBossController) catch(e:Dynamic) null).myText = null;
            }
        }
    }
    
    //Make sure you have your picture set before using!
    public function prepNewText(_text : String) : Void
    {
        myText = [];
        addText(_text);
        lineWrap();
    }
    
    public function setTemp(_parent : Entity = null, _temp : Bool = true, _talking : Bool = true, _showTalk : Bool = false) : Void
    {
        temporary = _temp;
        showTalk = _showTalk;
        talking = _talking;
        parent = _parent;
        collidable = false;
    }
    
    public function addText(_text : String) : Void
    {
        var _indEnd : Int = _text.indexOf("~", 0);
        if (_indEnd == -1)
        {
            myText.push(_text.substring(0, _text.length));
            return;
        }
        else
        {
            myText.push(_text.substring(0, _indEnd));
            addText(_text.substring(_indEnd + 1, _text.length));
        }
    }
    
    override public function check() : Void
    {
        super.check();
        if (!Game.menu && tag >= 0 && !Game.checkPersistence(tag))
        {
            FP.world.remove(this);
        }
    }
    
    override public function update() : Void
    {
        super.update();
        talk();
    }
    
    override public function render() : Void
    {
        super.render();
        if (inRange && !talked && showTalk && Reflect.field(myText, Std.string(0)).length > 0)
        {
            var talkBobsPerLoop : Float = 1.25;  //The number of times sprTalk bobs up and down per animation loop  
            sprTalk.frame = Game.worldFrame(sprTalk.frameCount, 1 / talkBobsPerLoop);
            sprTalk.render(new Point(x, y - originY - charToTalkMargin), FP.camera);
        }
    }
    
    public function lineWrap() : Void
    {
        for (i in 0...myText.length)
        {
            Reflect.setField(myText, Std.string(i), endlineText(Reflect.field(myText, Std.string(i)), lineLength));
        }
    }
    public static function endlineText(s0 : String, lineL : Int) : String
    {
        var s : String = s0.substr(0, s0.length);  //So that I'm not going by reference  
        
        var pos : Int = as3hx.Compat.parseInt(lineL - 1);
        while (pos < s.length)
        {
            var pchar : String = s.substr(pos, 1);
            while (validChar(pchar))
            {
                pos--;
                if (pos % lineL <= 0)
                {
                    pos += lineL;
                    break;
                }
                pchar = s.substr(pos, 1);
            }
            if (pos < s.length)
            {
                var start : String = s.substring(0, pos);
                var end : String = s.substring(pos + as3hx.Compat.parseInt(pchar == " "), s.length);
                s = start + "\n" + end;
            }
            pos += lineL;
        }
        return s;
    }
    public static function validChar(pchar : String) : Bool
    {
        return pchar != " " && pchar != "-" && pchar != "/";
    }
    
    public function talk() : Void
    {
        var p : Player = try cast(FP.world.nearestToEntity("Player", this), Player) catch(e:Dynamic) null;
        if (p != null && Reflect.field(myText, Std.string(0)).length > 0)
        {
            inRange = FP.distance(x, y, p.x, p.y) <= talkRange;
            var hitKey : Bool = Input.released(p.keys[6]);
            
            if (talking)
            {
                Game.freezeObjects = true;
                if (hitKey)
                {
                    Music.playSound("Text", 1, 0.3);
                    if (Game.currentCharacter >= Reflect.field(myText, Std.string(myCurrentText)).length)
                    {
                        myCurrentText++;
                    }
                    else
                    {
                        Game.currentCharacter =Std.int( Reflect.field(myText, Std.string(myCurrentText)).length - 1);
                    }
                    if (myCurrentText >= myText.length)
                    {
                        talking = false;
                        if (temporary)
                        {
                            FP.world.remove(this);
                        }
                        return;
                    }
                    Game.talkingText = Reflect.field(myText, Std.string(myCurrentText));
                }
            }
            if (inRange)
            {
                if (facePlayer && graphic)
                {
                    (try cast(graphic, Image) catch(e:Dynamic) null).scaleX = as3hx.Compat.parseInt(x < p.x) * 2 - 1;
                }
                if ((hitKey || !keyNeeded) && !Game.talking && !Game.inventory.open)
                {
                    startTalking();
                }
            }
            else
            {
                talked = false;
                if (talking)
                {
                    talking = false;
                }
            }
        }
    }
    
    public function startTalking() : Void
    {
        if (!talked)
        {
            talking = true;
            talked = true;
        }
    }
    
    private function set_talking(_t : Bool) : Bool
    {
        _talking = _t;
        if (!talking)
        {
            Game.freezeObjects = false;
            Game.talking = false;
            Game.talkingText = "";
            Game.talkingPic = null;
            Game.framesPerCharacter = Game.framesPerCharacterDefault;
            Game.ALIGN = "LEFT";
            myCurrentText = 0;
            doneTalking();
        }
        else
        {
            Game.talking = true;
            Game.talkingText = Reflect.field(myText, Std.string(myCurrentText));
            Game.talkingPic = myPic;
            Game.framesPerCharacter = talkingSpeed;
            Game.ALIGN = align;
        }
        talking_extras();
        return _t;
    }
    
    public function doneTalking() : Void
    {
    }
    
    public function talking_extras() : Void
    {
    }
    
    private function get_talking() : Bool
    {
        return _talking;
    }
}

