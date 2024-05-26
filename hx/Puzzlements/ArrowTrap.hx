package puzzlements;

import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;
import scenery.Tile;
import projectiles.Arrow;

/**
	 * ...
	 * @author Time
	 */
class ArrowTrap extends Activators
{
    @:meta(Embed(source="../../assets/graphics/ArrowTrap.png"))
private var imgArrowTrap : Class<Dynamic>;
    private var sprArrowTrap : Spritemap = new Spritemap(imgArrowTrap, 16, 5);
    
    private var shootTimer : Int = 0;
    private var shootTimerMax(default, never) : Int = 10;
    private var shootDefault : Bool;  //Whether it should default to shooting when not activated or vice versa  
    
    public function new(_x : Int, _y : Int, _t : Int = 0, _shoot : Bool = false)
    {
        super(_x + Tile.w / 2, _y + sprArrowTrap.height / 2, sprArrowTrap, _t);
        sprArrowTrap.centerOO();
        layer = -(y - originY + height);
        shootDefault = _shoot;
    }
    
    override public function update() : Void
    {
        if ((activate && !shootDefault) || (!activate && shootDefault))
        {
            shoot();
        }
        else
        {
            shootTimer = 0;
        }
    }
    
    override public function render() : Void
    {
        sprArrowTrap.frame = Game.worldFrame(sprArrowTrap.frameCount);
        super.render();
    }
    
    public function shoot() : Void
    {
        if (shootTimer > 0)
        {
            shootTimer--;
        }
        else
        {
            Music.playSoundDistPlayer(x, y, "Arrow", 0);
            FP.world.add(new Arrow(x - sprArrowTrap.width / 4, y - 2, new Point(0, 5)));
            FP.world.add(new Arrow(x, y - 2, new Point(0, 5)));
            FP.world.add(new Arrow(x + sprArrowTrap.width / 4, y - 2, new Point(0, 5)));
            shootTimer = shootTimerMax;
        }
    }
}

