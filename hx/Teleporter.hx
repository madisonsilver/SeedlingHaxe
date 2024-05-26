import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Draw;

/**
	 * ...
	 * @author Time
	 */
class Teleporter extends Entity
{
    @:meta(Embed(source="../assets/graphics/Portal.png"))
private var imgPortal : Class<Dynamic>;
    private var sprPortal : Spritemap = new Spritemap(imgPortal, 18, 18);
    
    private var to : Int;
    private var playerPos : Point;
    
    private var playerTouching : Bool = false;
    private var renderLight : Bool = true;
    
    private var tag : Int;  //True = exists, false = doesn't exist  
    private var invert : Bool;  //If this is true, it inverts the rules for the tag  
    private var deactivated : Bool = false;  //If true, then doesn't render or do player stuff  
    private var sign : Int;  //Displays text in the room that this teleporter teleports to (text in Message.as)  
    
    public var sound : String = "Room";
    public var soundIndex : Int = 0;
    
    public function new(_x : Int, _y : Int, _to : Int = 0, _px : Int = 0, _py : Int = 0, _show : Bool = false, _tag : Int = -1, _invert : Bool = false, _sign : Int = -1)
    {
        super(_x, _y, sprPortal);
        to = _to;
        playerPos = new Point(_px, _py);
        setHitbox(16, 16, 0, 0);
        
        sprPortal.originX = 1;
        sprPortal.originY = 1;
        sprPortal.x = -sprPortal.originX;
        sprPortal.y = -sprPortal.originY;
        sprPortal.add("spin", [0, 1, 2, 3], 15);
        sprPortal.play("spin");
        
        visible = _show;
        tag = _tag;
        invert = _invert;
        sign = as3hx.Compat.parseInt(_sign - 1);  //takes the value of _sign - 1 because zero should become -1 (to negate all of the levels where it defaults to zero)  
        
        if (visible)
        {
            soundIndex = 3;
        }
        
        type = "Teleporter";
        
        checkDeactivated();
    }
    
    override public function check() : Void
    {
        super.check();
        if (collide("Player", x, y))
        {
            playerTouching = true;
        }
    }
    
    /**
		 * Removes this object by its tag
		 */
    public function removeSelf() : Void
    {
        Game.setPersistence(tag, false);
    }
    
    public function checkDeactivated() : Void
    {
        deactivated = tag >= 0 && (!Game.checkPersistence(tag) == invert);
    }
    
    override public function update() : Void
    {
        checkDeactivated();
        if (deactivated)
        {
            return;
        }
        if (collide("Player", x, y))
        {
            if (!playerTouching)
            {
                Music.playSound(sound, soundIndex);
                FP.world = new Game(to, Std.int(playerPos.x), Std.int(playerPos.y));
                Game.sign = sign;
            }
        }
        else
        {
            playerTouching = false;
        }
    }
    
    override public function render() : Void
    {
        if (deactivated)
        {
            return;
        }
        super.render();
        renderLit();
    }
    public function renderLit() : Void
    {
        if (renderLight)
        {
            super.render();
            Draw.setTarget((try cast(FP.world, Game) catch(e:Dynamic) null).nightBmp, FP.camera);
            super.render();
            Draw.resetTarget();
        }
    }
}

