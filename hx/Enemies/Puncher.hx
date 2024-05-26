package enemies;

import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;
import pickups.Coin;

/**
	 * ...
	 * @author Time
	 */
class Puncher extends Enemy
{
    @:meta(Embed(source="../../assets/graphics/Puncher.png"))
private var imgPuncher : Class<Dynamic>;
    private var sprPuncher : Spritemap = new Spritemap(imgPuncher, 20, 20, endAnim);
    
    private var direction : Int = 3;  //0 = right, counter-clockwise from there.  
    public var moveSpeed : Float = 1;
    private var standAnimSpeed(default, never) : Int = 2;
    private var walkAnimSpeed(default, never) : Int = 4;
    private var attackAnimSpeed(default, never) : Int = 12;
    private var runRange(default, never) : Int = 80;  //Range at which the Puncher will run after the character  
    private var attackRange(default, never) : Int = 10;  //Range at which the Puncher will attack the character  
    private var punchForce(default, never) : Float = 5;
    
    public function new(_x : Int, _y : Int)
    {
        super(_x + Tile.w / 2, _y + Tile.h / 2, sprPuncher);
        
        sprPuncher.centerOO();
        
        sprPuncher.add("walk-side", [6, 7, 8, 9], walkAnimSpeed);
        sprPuncher.add("walk-up", [16, 17, 18, 19], walkAnimSpeed);
        sprPuncher.add("walk-down", [26, 27, 28, 29], walkAnimSpeed);
        
        sprPuncher.add("attack-side", [2, 3, 4, 5], attackAnimSpeed);
        sprPuncher.add("attack-up", [12, 13, 14, 15], attackAnimSpeed);
        sprPuncher.add("attack-down", [22, 23, 24, 25], attackAnimSpeed);
        
        sprPuncher.add("stand-side", [0, 1], standAnimSpeed);
        sprPuncher.add("stand-up", [10, 11], standAnimSpeed);
        sprPuncher.add("stand-down", [20, 21], standAnimSpeed);
        
        sprPuncher.add("die", [30, 31, 32, 33, 34, 35, 36, 37, 38, 39], 10);
        
        setHitbox(12, 12, 6, 4);
        
        solids.push("Enemy", "Player");
        
        damage = 1;
    }
    
    override public function update() : Void
    {
        super.update();
        if (destroy || (try cast(graphic, Spritemap) catch(e:Dynamic) null).currentAnim == "die")
        {
            return;
        }
        
        var player : Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch(e:Dynamic) null;
        if (player != null && getSprite() != "attack")
        {
            var d : Float = FP.distance(x, y, player.x, player.y);
            if (d <= runRange)
            
            //&& !FP.world.collideLine("Solid", x, y, player.x, player.y) && !FP.world.collideLine("Tree", x, y, player.x, player.y))
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
                    
                    if (direction == 2)
                    {
                        sprPuncher.scaleX = -Math.abs(sprPuncher.scaleX);
                    }
                    else
                    {
                        sprPuncher.scaleX = Math.abs(sprPuncher.scaleX);
                    }
                    if (Math.abs(v.x) > Math.abs(v.y))
                    {
                        if (v.x > 0)
                        {
                            direction = 0;
                        }
                        else if (v.x < 0)
                        {
                            direction = 2;
                        }
                    }
                    else if (v.y >= 0)
                    {
                        direction = 3;
                    }
                    else
                    {
                        direction = 1;
                    }
                    setSprite("walk");
                }
            }
            else
            {
                setSprite("stand");
            }
            if (d <= attackRange)
            
            //ATTTAAAACK
{                
                if ((try cast(graphic, Spritemap) catch(e:Dynamic) null).currentAnim != "attack")
                {
                    Music.playSoundDistPlayer(x, y, "Punch");
                }
                setSprite("attack");
            }
        }
    }
    
    override public function startDeath(t : String = "") : Void
    {
        (try cast(graphic, Spritemap) catch(e:Dynamic) null).play("die");
        dieEffects(t);
    }
    
    public function endAnim() : Void
    {
        if ((try cast(graphic, Spritemap) catch(e:Dynamic) null).currentAnim == "die")
        {
            destroy = true;
            (try cast(graphic, Spritemap) catch(e:Dynamic) null).play("");
            (try cast(graphic, Spritemap) catch(e:Dynamic) null).frame = (try cast(graphic, Spritemap) catch(e:Dynamic) null).frameCount - 1;
        }
        else
        {
            if (getSprite() == "attack")
            {
                attackPlayer();
            }
            setSprite("stand");
        }
    }
    
    public function getSprite() : String
    {
        var s : String = sprPuncher.currentAnim.substring(0, sprPuncher.currentAnim.indexOf("-", 0));
        return s;
    }
    
    public function setSprite(prefix : String) : Void
    {
        switch (direction)
        {
            case 0:
                sprPuncher.play(prefix + "-side");
            case 1:
                sprPuncher.play(prefix + "-up");
            case 2:
                sprPuncher.play(prefix + "-side");
            case 3:
                sprPuncher.play(prefix + "-down");
            default:
        }
    }
    
    override public function knockback(f : Float = 0, p : Point = null) : Void
    {
    }
    
    public function attackPlayer() : Void
    {
        if (hitsTimer > 0)
        {
            return;
        }
        var p : Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch(e:Dynamic) null;
        if (Math.abs(p.x - x) > Math.abs(p.y - y))
        {
            if (p.x - x > 0)
            {
                direction = 0;
            }
            else
            {
                direction = 2;
            }
        }
        else if (p.y - y > 0)
        {
            direction = 3;
        }
        else
        {
            direction = 1;
        }
        var r : Int = 8;  //The width/height of the hitbox that hits the player; the length of the punch.  
        switch (direction)
        {
            case 0:
                p = try cast(FP.world.collideRect("Player", x - originX + width, y - originY, r, height), Player) catch(e:Dynamic) null;
            case 1:
                p = try cast(FP.world.collideRect("Player", x - originX, y - originY - r, width, r), Player) catch(e:Dynamic) null;
            case 2:
                p = try cast(FP.world.collideRect("Player", x - originX - r, y - originY, r, height), Player) catch(e:Dynamic) null;
            case 3:
                p = try cast(FP.world.collideRect("Player", x - originX, y - originY + height, width, r), Player) catch(e:Dynamic) null;
            default:
        }
        if (p != null)
        {
            p.hit(this, punchForce, new Point(x, y), damage);
        }
    }
}

