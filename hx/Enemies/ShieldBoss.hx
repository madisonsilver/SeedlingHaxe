package enemies;

import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import openfl.display.BlendMode;
import scenery.Tile;

/**
	 * ...
	 * @author Time
	 */
class ShieldBoss extends Enemy
{
    @:meta(Embed(source="../../assets/graphics/ShieldBoss.png"))
private var imgShieldBoss : Class<Dynamic>;
    private var sprShieldBoss : Spritemap = new Spritemap(imgShieldBoss, 56, 80, endAnim);
    
    private var tag : Int;
    
    private var openShieldFrame(default, never) : Int = 2;
    private var retaliation : Bool = false;
    private var stabbing : Bool = false;
    private var activated : Bool = false;
    
    private var swingForce(default, never) : Float = 6;
    private var swingTimeMax(default, never) : Int = 120;
    private var swingTime : Int = 0;
    
    private var playedSound : Bool = false;
    
    public function new(_x : Int, _y : Int, _tag : Int = -1)
    {
        super(Std.int(_x + Tile.w * 1.5), _y + Tile.h * 2, sprShieldBoss);
        sprShieldBoss.centerOO();
        sprShieldBoss.add("sit", [0]);
        sprShieldBoss.add("stab", [3, 4, 5, 6, 7, 8], 15);
        sprShieldBoss.add("moveShield", [0, 1], 15);
        sprShieldBoss.add("movedShield", [2], 2);
        sprShieldBoss.add("die", [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 15);
        
        sprShieldBoss.play("sit");
        
        tag = _tag;
        layer = Std.int(-(y - sprShieldBoss.originY + sprShieldBoss.height));
        
        type = "ShieldBoss";
        
        setHitbox(48, 48, 24, 24);
        
        hitSoundIndex = 1;  //Big hit sound  
        dieSoundIndex = 1;
    }
    
    override public function check() : Void
    {
        super.check();
        if (tag >= 0 && !Game.checkPersistence(tag))
        {
            FP.world.remove(this);
        }
    }
    
    override public function startDeath(t : String = "") : Void
    {
        Game.setPersistence(tag, false);
        sprShieldBoss.play("die");
    }
    
    override public function update() : Void
    {
        var p : Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch(e:Dynamic) null;
        if (p != null)
        {
            if (FP.distance(x, y, p.x, p.y) <= 96)
            {
                Game.levelMusics[(try cast(FP.world, Game) catch(e:Dynamic) null).level] = Game.bossMusic;
            }
        }
        if (sprShieldBoss.currentAnim != "die")
        {
            super.update();
        }
        else
        {
            death();
        }
    }
    
    override public function death() : Void
    {
        if (destroy)
        {
            Game.levelMusics[(try cast(FP.world, Game) catch(e:Dynamic) null).level] = -1;
            Main.unlockMedal(Main.badges[8]);
        }
        super.death();
    }
    
    override public function knockback(f : Float = 0, p : Point = null) : Void
    {
    }
    
    override public function hitPlayer() : Void
    {
        var p : Player = try cast(FP.world.collideRect("Player", x - originX, y - originY + height, width, Tile.h), Player) catch(e:Dynamic) null;
        if (sprShieldBoss.frame >= 5 && sprShieldBoss.frame <= 8)
        {
            if (p != null && !destroy)
            {
                p.hit(this, swingForce, new Point(x, y));
            }
        }
        if (p != null && sprShieldBoss.currentAnim == "sit")
        {
            swingTime++;
            if (swingTime >= swingTimeMax)
            {
                swingTime = 0;
                startStab(false);
            }
        }
        else
        {
            swingTime = 0;
        }
    }
    
    override public function hit(f : Float = 0, p : Point = null, d : Float = 1, t : String = "") : Void
    {
        if (!activated)
        {
            activated = true;
            return;
        }
        if (sprShieldBoss.currentAnim == "movedShield")
        {
            super.hit(f, p, d, t);
            sit();
        }
        else
        {
            if (!playedSound)
            {
                Music.playSound("Metal Hit");
                playedSound = true;
            }
            startStab(true);
        }
    }
    
    override public function render() : Void
    {
        if (destroy)
        {
            return;
        }
        if (sprShieldBoss.currentAnim == "die")
        {
            sprShieldBoss.blend = BlendMode.HARDLIGHT;
        }
        else
        {
            sprShieldBoss.blend = BlendMode.NORMAL;
        }
        super.render();
    }
    
    public function startStab(_retaliation : Bool = false) : Void
    {
        if (hitsTimer <= 0 && sprShieldBoss.currentAnim == "sit")
        {
            stabbing = true;
            retaliation = _retaliation;
            sprShieldBoss.play("moveShield");
        }
    }
    
    public function sit() : Void
    {
        if (sprShieldBoss.currentAnim != "die")
        {
            sprShieldBoss.play("sit");
            stabbing = false;
            retaliation = false;
        }
    }
    
    public function endAnim() : Void
    {
        playedSound = false;
        if (stabbing)
        {
            var _sw11_ = (sprShieldBoss.currentAnim);            

            switch (_sw11_)
            {
                case "moveShield":
                    if (retaliation)
                    {
                        sprShieldBoss.play("stab");
                    }
                    else
                    {
                        sprShieldBoss.play("movedShield");
                    }
                case "movedShield":
                    sprShieldBoss.play("stab");
                case "stab":
                    sit();
                default:
            }
        }
        if (sprShieldBoss.currentAnim == "die")
        {
            destroy = true;
        }
    }
}

