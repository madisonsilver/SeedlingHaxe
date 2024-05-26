package enemies;

import openfl.geom.Point;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import net.flashpunk.utils.Draw;
import scenery.Tile;
import pickups.Coin;

/**
	 * ...
	 * @author Time
	 */
/*
	 *  The story of how Grace ******* came to michigan.
		The story about grace.  It's like two lines of code if you will.
		Fuck, I forgot how I was going to make fun of her.  I'll stop doing that.
		Can you get Tocata and Fuge on here?
		Eric ******... it was a tuesday, the 17th--friday the 13th was his birthday; OOOOH! Eric was walking the halls of his middle school when his geometry teacher came out--he was taking highschool geometry because he was advanced, but not at Andover, that fabled place.  He was a white person and Eric's parents didn't accept that a white man was teaching him.  Hear that? Racism.  Anyhow, there's this japanese 50 year old guy who looks pretty much like aqualung.  The weather isn't exactly ideal for his nose, and eric is learning geometry from him in a broom closet learning about 3d stuff, like cones and square prisms (as well as cylinders; and domes! HOHOHoooo)  It's going to be about ten years until he discovers porn, and fifteen until he sees a dick that he chooses to see.  Political?  He's going to see plenty of vaginas in his day.  and his girlfriends are going to ask if they are fat--have fat vaginas.  And so the teacher brought models, wooden ones.  But he says "oh I forgot my cylinders and domes!  SO I guess we're going to have to substitute."  So Eric has some trouble, so they try his finger and take measurements.  But Eric says that his finger is too small.  Problem with not using metric units--wrong conversion.  Anyways, so the teacher undid his belt, with that deadly clank (so nice in some situations).  And he pulled it down those hairless legs.  Uh.  To this day, Eric still remembers that it wasn't much bigger than his pinky finger--BUT IT WAS BIGGER!  measurable in inches... 1, 2... 2.25.  But anyways, Eric understood the sensation, as he felt it when he saw the men dancing on the television.  It has affected him to this very day.  Pre-med, anyone?
	*/
class BobSoldier extends Enemy
{
    @:meta(Embed(source="../../assets/graphics/LameSword.png"))
private var imgLameSword : Class<Dynamic>;
    private var sprLameSword : Spritemap = new Spritemap(imgLameSword, 16, 5);
    
    @:meta(Embed(source="../../assets/graphics/BobSoldier.png"))
private var imgBobSoldier : Class<Dynamic>;
    private var sprBobSoldier : Spritemap = new Spritemap(imgBobSoldier, 10, 10, endAnim);
    
    public var moveSpeed : Float = 0.8;
    public var walkAnimSpeed : Int = 10;
    public var walkFrames(default, never) : Array<Dynamic> = [0, 1, 2, 1];
    private var runRange(default, never) : Int = 80;  //Range at which the Bob will run after the character  
    public var attackRange(default, never) : Int = 32;  //Range at which the Bob will attack the character  
    
    public var weapon : Spritemap;
    public var weaponLength : Int = sprLameSword.width;
    
    public var swordSpinning : Bool = false;
    public var swordIndex : Int = 0;
    public var swords : Int = 1;
    public var swordSpinBegin : Array<Dynamic> = [0, 0];
    public var swordSpin : Array<Dynamic> = [Math.PI * 3 / 2, Math.PI / 2, Math.PI, 0];
    public var swordSpinRate : Float = Math.PI / 10;
    public var swordSpinResetTimerMax : Int = 60;
    public var swordSpinResetTimer : Int = 0;
    
    public var hopSoundIndex : Int = 0;
    
    public function new(_x : Int, _y : Int, _g : Spritemap = null)
    {
        if (_g == null)
        {
            _g = sprBobSoldier;
        }
        super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), _g);
        
        (try cast(graphic, Spritemap) catch(e:Dynamic) null).centerOO();
        (try cast(graphic, Spritemap) catch(e:Dynamic) null).add("walk", walkFrames, walkAnimSpeed, true);
        
        weapon = sprLameSword;
        sprLameSword.y = -3;
        sprLameSword.originY =Std.int( -sprLameSword.y);
        
        setHitbox(8, 8, 4, 2);
    }
    
    override public function removed() : Void
    {  //if(!fell) dropCoins();  
        
    }
    
    override public function update() : Void
    {
        super.update();
        if (Game.freezeObjects)
        {
            return;
        }
        var player : Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch(e:Dynamic) null;
        if (player != null)
        {
            playerActions(player);
        }
        swordSpinningStep(player);
        swordHitting();
        
        standingAnimation();
    }
    
    public function playerActions(player : Player) : Void
    {
        var d : Float = FP.distance(x, y, player.x, player.y);
        if (d <= runRange)
        
        // && !FP.world.collideLine("Solid", x, y, player.x, player.y))
{            
            {
                var a : Float = Math.atan2(player.y - y, player.x - x);
                var toV : Point = new Point(moveSpeed * Math.cos(a), moveSpeed * Math.sin(a));
                var pushed : Bool = v.length > moveSpeed;  //If we're already moving faster than we should...  
                v.x += FP.sign(toV.x - v.x) * moveSpeed;
                v.y += FP.sign(toV.y - v.y) * moveSpeed;
                if (!pushed && v.length > moveSpeed)
                {
                    v.normalize(moveSpeed);
                }
                if ((try cast(graphic, Spritemap) catch(e:Dynamic) null).currentAnim != "walk")
                {
                    Music.playSoundDistPlayer(Std.int(x), Std.int(y), "Enemy Hop", hopSoundIndex);
                    (try cast(graphic, Spritemap) catch(e:Dynamic) null).play("walk");
                }
            }
        }
        swordSpinningBeginCheck(Std.int(d));
    }
    
    public function swordSpinningBeginCheck(d : Int = 0) : Void
    {
        if (d <= attackRange)
        {
            if (!swordSpinning)
            {
                if (swordSpinResetTimer > 0)
                {
                    swordSpinResetTimer--;
                }
                else
                {
                    swordSpinningBegin();
                }
            }
        }
    }
    
    public function swordSpinningBegin() : Void
    {
        swordSpinResetTimer = swordSpinResetTimerMax;
        swordSpinning = true;
        swordSpin[swordIndex] = swordSpinBegin[swordIndex] = (swordSpin[swordIndex] + 2 * Math.PI) % (2 * Math.PI);
    }
    
    public function swordSpinningStep(player : Player) : Void
    {
        if (swordSpinning)
        {
            swordSpin[swordIndex] += swordSpinRate;
            
            var ang : Float = (-Math.atan2(player.y - y, player.x - x) + Math.PI * 2) % (Math.PI * 2);
            if (Math.abs(swordSpinBegin[swordIndex] - swordSpin[swordIndex]) >= Math.PI * 2)
            {
                if (Math.abs(FP.angle_difference((swordSpin[swordIndex] + 2 * Math.PI) % (2 * Math.PI), ang)) <= swordSpinRate)
                {
                    swordSpinningStop(ang);
                }
            }
        }
    }
    
    public function swordSpinningStop(ang : Float = 0) : Void
    {
        swordSpin[swordIndex] = ang;
        swordSpinning = false;
        swordIndex = as3hx.Compat.parseInt((swordIndex + 1) % swords);
    }
    
    public function swordHitting() : Void
    {
        for (i in 0...swords)
        {
            var hitPlayer : Player = try cast(FP.world.collideLine("Player", Std.int(x + weaponLength / 2 * Math.cos(-swordSpin[i])), Std.int(y + weaponLength / 2 * Math.sin(-swordSpin[i])), 
                    Std.int(x + weaponLength * Math.cos(-swordSpin[i])), Std.int(y + weaponLength * Math.sin(-swordSpin[i]))
            ), Player) catch(e:Dynamic) null;
            if (hitPlayer != null)
            {
                hitPlayer.hit(this, 3 * damage, new Point(x, y), damage);
            }
        }
    }
    
    public function standingAnimation() : Void
    {
        if ((try cast(graphic, Spritemap) catch(e:Dynamic) null).currentAnim == "")
        {
            (try cast(graphic, Spritemap) catch(e:Dynamic) null).frame = walkFrames[Game.worldFrame(walkFrames.length)];
        }
    }
    
    public function endAnim() : Void
    {
        (try cast(graphic, Spritemap) catch(e:Dynamic) null).play("");
    }
    
    override public function render() : Void
    {
        super.render();
        for (i in 0...swords)
        {
            (try cast(weapon, Image) catch(e:Dynamic) null).alpha = (try cast(graphic, Spritemap) catch(e:Dynamic) null).alpha;
            (try cast(weapon, Spritemap) catch(e:Dynamic) null).angle = swordSpin[i] / Math.PI * 180;
            (try cast(weapon, Spritemap) catch(e:Dynamic) null).render(new Point(x, y), FP.camera);
        }
    }
}

