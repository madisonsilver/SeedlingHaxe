package enemies;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.Graphic;
import net.flashpunk.FP;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import pickups.HealthPickup;
import projectiles.Explosion;
import scenery.SlashHit;
import scenery.Tile;
import pickups.Coin;

/**
	 * ...
	 * @author Time
	 */
class Enemy extends Mobile
{
    public var damage : Int = 1;  //The amount of damage this will do when it hits the player  
    public var hits : Float = 0;
    public var hitsMax : Int = 3;
    public var hitsTimer : Int = 0;
    public var hitsTimerMax : Int = 30;
    public var hitsTimerInt(default, never) : Int = 10;
    public var hitsColor : Int = 0xFF0000;
    public var normalColor : Int = 0xFFFFFF;
    public var hitByDarkStuff : Bool = false;
    
    private var coins(default, never) : Int = 4 + Math.random() * 4;  //The number of coins to throw upon death  
    private var healths(default, never) : Int = 1;
    
    public var canFallInPit : Bool = true;
    public var fallInPit : Bool = false;
    public var fallSpinSpeed(default, never) : Int = 8 * FP.choose([-1, 1]);
    public var fallAlphaSpeed(default, never) : Float = 0.05;
    
    public var hitByFire : Bool = false;
    public var dieInWater : Bool = true;
    public var dieInLava : Bool = true;
    public var canHit : Bool = true;
    public var justKnock : Bool = false;  //If the enemy is hit, only bump him, don't hurt him.  
    
    public var fell : Bool = false;
    public var activeOffScreen : Bool = false;
    
    public var onlyHitBy : String = "";
    public var maxForce : Float = -1;
    
    public var hitSound : String = "Enemy Hit";
    public var hitSoundIndex : Int = 0;  //0 = small, 1 = big  
    public var dieSound : String = "Enemy Die";
    public var dieSoundIndex : Int = 0;  //0 = small, 1 = big  
    
    public function new(_x : Int, _y : Int, _g : Graphic = null)
    {
        super(_x, _y, _g);
        type = "Enemy";
    }
    
    override public function update() : Void
    {
        if (!activeOffScreen && !onScreen())
        {
            return;
        }
        var state : Int = getState();
        switch (state)
        {
            case 1:  //Water  
            if (dieInWater)
            {
                destroy = true;
            }
            case 6:
                if (canFallInPit && !fallInPit)
                {
                    Music.playSoundDistPlayer(x, y, "Enemy Fall");
                    fallInPit = true;
                }
            case 17:  //Lava  
            if (dieInLava)
            {
                destroy = true;
            }
            default:
        }
        if (!destroy && fallInPit && canFallInPit)
        {
            x += (Math.floor(x / Tile.w) * Tile.w + Tile.w / 2 - x) / 10;
            y += (Math.floor(y / Tile.h) * Tile.h + Tile.h / 2 - y) / 10;
            (try cast(graphic, Image) catch(e:Dynamic) null).angle += fallSpinSpeed;
            (try cast(graphic, Image) catch(e:Dynamic) null).alpha -= fallAlphaSpeed;
            if ((try cast(graphic, Image) catch(e:Dynamic) null).alpha <= 0)
            {
                destroy = true;
                fell = true;
            }
        }
        else
        {
            super.update();
            if (!destroy)
            {
                hitUpdate();
                hitPlayer();
            }
        }
    }
    
    public function dropCoins() : Void
    {
        var l : Float = 2;
        var astart : Float = Math.random() * Math.PI * 2;
        for (i in 0...coins)
        {
            var a : Float = i / coins * Math.PI * 2 + astart;
            FP.world.add(new Coin(x, y, new Point(l * Math.cos(a), l * Math.sin(a))));
        }
    }
    
    public function getState(_yOffset : Float = 0) : Int
    {
        var tile : Tile = try cast(FP.world.nearestToPoint("Tile", x, y + _yOffset), Tile) catch(e:Dynamic) null;
        if (tile != null)
        {
            return tile.t;
        }
        return 0;
    }
    
    public function hit(f : Float = 0, p : Point = null, d : Float = 1, t : String = "") : Void
    {
        if (maxForce >= 0)
        {
            f = Math.min(f, maxForce);
        }
        if ((hitsTimer <= 0 || hitByDarkStuff) && !Game.freezeObjects && canHit)
        {
            if (onlyHitBy == "" || onlyHitBy == t)
            {
                if (hitByFire || t != "Fire")
                {
                    if (hits < hitsMax)
                    {
                        hits += d;
                        hitsTimer = hitsTimerMax;
                        hitByDarkStuff = (t == "Shield" || t == "Suit");
                        if (hits >= hitsMax)
                        {
                            Music.playSoundDistPlayer(x, y, dieSound, dieSoundIndex);
                            startDeath(t);
                        }
                        else
                        {
                            Music.playSoundDistPlayer(x, y, hitSound, hitSoundIndex);
                            knockback(f, p);
                        }
                    }
                }
                //hitsTimer = hitsTimerMax;
                else
                {
                    
                    knockback(f, p);
                }
            }
            else if (justKnock)
            {
                knockback(f, p);
            }
        }
    }
    
    public function startDeath(t : String = "") : Void
    {
        destroy = true;
        dieEffects(t);
    }
    
    public function dieEffects(t : String, _sc : Float = 0, _xoff : Int = 0, _yoff : Int = 0) : Void
    {
        var g : Spritemap = try cast(graphic, Spritemap) catch(e:Dynamic) null;
        if (g == null)
        {
            return;
        }
        if (_sc == 0)
        {
            _sc = Math.max(g.width, g.height) * Math.max(g.scaleX, g.scaleY) * g.scale;
        }
        switch (t)
        {
            case "Sword", "Spear":
                FP.world.add(new SlashHit(x + _xoff, y + _yoff, _sc));
            case "Wand":
                FP.world.add(new Explosion(x + _xoff, y + _yoff, ["Player", "Enemy"], Math.max(width, height), 1));
            default:
        }
    }
    
    public function hitPlayer() : Void
    {
        if (!destroy && (!(Std.is(graphic, Spritemap)) || (try cast(graphic, Spritemap) catch(e:Dynamic) null).currentAnim != "die") && hitsTimer <= 0)
        {
            var p : Player = try cast(collide("Player", x, y), Player) catch(e:Dynamic) null;
            if (p != null)
            {
                p.hit(this, 3, new Point(x, y), damage);
            }
        }
    }
    
    public function hitUpdate() : Void
    {
        if (hitsTimer > 0)
        {
            if (hitsTimer % hitsTimerInt == 0)
            {
                if ((try cast(graphic, Image) catch(e:Dynamic) null).color == normalColor)
                {
                    (try cast(graphic, Image) catch(e:Dynamic) null).color = hitsColor;
                }
                else
                {
                    (try cast(graphic, Image) catch(e:Dynamic) null).color = normalColor;
                }
            }
            hitsTimer--;
            if (hitsTimer <= 0)
            {
                (try cast(graphic, Image) catch(e:Dynamic) null).color = normalColor;
            }
        }
    }
    
    public function knockback(f : Float = 0, p : Point = null) : Void
    {
        if (p != null && !destroy && (!(Std.is(graphic, Spritemap)) || (try cast(graphic, Spritemap) catch(e:Dynamic) null).currentAnim != "die"))
        {
            var a : Float = Math.atan2(y - p.y, x - p.x);
            v.x += f * Math.cos(a);
            v.y += f * Math.sin(a);
        }
    }
}

