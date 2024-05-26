package enemies;

import net.flashpunk.Entity;
import openfl.geom.Point;
import net.flashpunk.FP;
import scenery.LightBossTotem;
import scenery.Tile;
import nPCs.NPC;

/**
	 * ...
	 * @author Time
	 */
class LightBossController extends Entity
{
    private static inline var moveDiv : Int = 10;
    private static var flierNumber : Int;
    private static var spinCenter : Point;
    
    private var tag : Int;
    
    private var spin : Float = 0;
    private var spinRate : Float = FP.RAD;
    private var radiusCircle : Int = 100;
    private var radiusCircleMin(default, never) : Int = 48;
    private var radiusCircleMax(default, never) : Int = 64;
    private var radiusCircleFrames(default, never) : Int = 180;
    private var loopsPerCircle(default, never) : Int = 4;
    
    private var states(default, never) : Int = 3;
    private var state : Int = 0;  //just circle the enemies, pulsing in and out  
    private var myFliers : Array<LightBoss> = new Array<LightBoss>();
    
    private var madeFliers : Bool = false;
    private var myTotem : LightBossTotem;
    public var myText : NPC;
    private var text(default, never) : String = "HOW FAR YOU HAVE COME, BEING OF THE LIGHT.~OUR OWN LIGHT WILL SWALLOW YOU. COME, MEET YOUR FATE.";
    
    public function new(_x : Int, _y : Int, _flierNum : Int, _tag : Int = -1)
    {
        super();
        
        tag = _tag;
        x = _x;
        y = _y;
        flierNumber = _flierNum;
    }
    
    override public function check() : Void
    {
        if (Game.checkPersistence(tag))
        {
            spinCenter = new Point(x + Tile.w / 2, y + Tile.h / 2);
            FP.world.add(myText = new NPC(Std.int(x), Std.int(y), null, -1, text, 4, 34));
            myText.align = "CENTER";
            myText.setTemp(this, true, false, true);
            FP.world.add(myTotem = new LightBossTotem(Std.int(x), Std.int(y)));
        }
        else
        {
            endState();
            FP.world.remove(this);
        }
    }
    
    override public function update() : Void
    {
        if (!Game.freezeObjects)
        {
            if (madeFliers && (try cast(FP.world, Game) catch(e:Dynamic) null).totalEnemies() <= 0 && !myTotem.die)
            {
                myTotem.die = true;
                endState();
                Main.unlockMedal(Main.badges[10]);
            }
            if (myText == null && !madeFliers)
            {
                while (myFliers.length < flierNumber)
                {
                    myFliers.push(new LightBoss(Std.int(spinCenter.x), -32, myFliers.length, this));
                    FP.world.add(myFliers[myFliers.length - 1]);
                }
                madeFliers = true;
                Game.levelMusics[(try cast(FP.world, Game) catch(e:Dynamic) null).level] = Game.bossMusic;
            }
            super.update();
            switch (state)
            {
                case 0:
                    flyCircle();
                case 1:
                    flyCircleInvert();
                case 2:
                    flyCircleDouble();
                default:
            }
        }
    }
    
    public function endState() : Void
    {
        FP.world.add(new Teleporter(Std.int(x), Std.int(y), 36, 112, 96, true));
        Game.levelMusics[(try cast(FP.world, Game) catch(e:Dynamic) null).level] = -1;
        Game.setPersistence(tag, false);
    }
    
    public function flyCircle() : Void
    {
        var cFrame : Int = Game.worldFrame(radiusCircleFrames, loopsPerCircle);
        radiusCircle = as3hx.Compat.parseInt(radiusCircleMin + (radiusCircleMax - radiusCircleMin) * (Math.sin(cFrame / radiusCircleFrames * 2 * Math.PI) + 1) / 2);
        for (i in 0...myFliers.length)
        {
            var a : Float = i / myFliers.length * 2 * Math.PI + spin;
            myFliers[i].goto = new Point(spinCenter.x + radiusCircle * Math.cos(a), spinCenter.y + radiusCircle * Math.sin(a));
            if (cFrame == Math.floor(radiusCircleFrames * 3 / 4) ||
                cFrame == Math.floor(radiusCircleFrames / 2) ||
                cFrame == Math.floor(radiusCircleFrames / 4) ||
                cFrame == 0)
            {
                myFliers[i].shoot();
            }
        }
        spin += spinRate * (2 - (radiusCircle - radiusCircleMin) / (radiusCircleMax - radiusCircleMin));
    }
    public function flyCircleInvert() : Void
    {
        var cFrame : Int = Game.worldFrame(radiusCircleFrames, loopsPerCircle);
        radiusCircle = as3hx.Compat.parseInt(radiusCircleMin + (radiusCircleMax - radiusCircleMin) * (Math.sin(cFrame / radiusCircleFrames * 2 * Math.PI) + 1) / 2);
        for (i in 0...myFliers.length)
        {
            var a : Float = i / myFliers.length * 2 * Math.PI + spin;
            if (i % 2 == 0)
            {
                myFliers[i].goto = new Point(spinCenter.x + radiusCircle / 2 * Math.cos(a), spinCenter.y + radiusCircle / 2 * Math.sin(a));
            }
            else
            {
                myFliers[i].goto = new Point(spinCenter.x + radiusCircle * Math.cos(a), spinCenter.y + radiusCircle * Math.sin(a));
            }
            if (cFrame == Math.floor(radiusCircleFrames * 3 / 4) ||
                cFrame == Math.floor(radiusCircleFrames / 2) ||
                cFrame == Math.floor(radiusCircleFrames / 4) ||
                cFrame == 0)
            {
                myFliers[i].shoot();
            }
        }
        spin += spinRate * (2 - (radiusCircle - radiusCircleMin) / (radiusCircleMax - radiusCircleMin));
    }
    
    public function flyCircleDouble() : Void
    {
        var cFrame : Int = Game.worldFrame(radiusCircleFrames, loopsPerCircle);
        radiusCircle = as3hx.Compat.parseInt(radiusCircleMin + (radiusCircleMax - radiusCircleMin) * (Math.sin(cFrame / radiusCircleFrames * 2 * Math.PI) + 1) / 2);
        for (i in 0...myFliers.length)
        {
            var a : Float = i / myFliers.length * 2 * Math.PI + spin;
            if (i % 2 == 0)
            {
                a = i / myFliers.length * 2 * Math.PI + spin * 2;
            }
            myFliers[i].goto = new Point(spinCenter.x + radiusCircle * Math.cos(a), spinCenter.y + radiusCircle * Math.sin(a));
            if (cFrame == Math.floor(radiusCircleFrames * 5 / 6) ||
                cFrame == Math.floor(radiusCircleFrames * 2 / 3) ||
                cFrame == Math.floor(radiusCircleFrames / 2) ||
                cFrame == Math.floor(radiusCircleFrames / 3) ||
                cFrame == Math.floor(radiusCircleFrames / 6) ||
                cFrame == 0)
            {
                myFliers[i].shoot();
            }
        }
        spin += spinRate * (2 - (radiusCircle - radiusCircleMin) / (radiusCircleMax - radiusCircleMin));
    }
    
    public function removeFlier(_id : Int) : Void
    {
        if (_id >= 0 && _id < myFliers.length)
        {
            myFliers.splice(_id, 1);
            for (i in _id...myFliers.length)
            {
                myFliers[i].id--;
            }
            state =Std.int( Math.min(state + 1, states - 1));
        }
    }
}

