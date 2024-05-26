package scenery;

import enemies.LightBoss;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import net.flashpunk.utils.Draw;
import net.flashpunk.FP;

/**
	 * ...
	 * @author Time
	 */
class LightBossTotem extends Entity
{
    public var die(get, set) : Bool;

    @:meta(Embed(source="../../assets/graphics/LightBossTotem.png"))
private var imgLightBossTotem : Class<Dynamic>;
    private var sprLightBossTotem : Image = new Image(imgLightBossTotem);
    
    private var _die : Bool = false;
    
    public function new(_x : Int, _y : Int)
    {
        super(_x, _y, sprLightBossTotem);
        setHitbox(16, 16);
        sprLightBossTotem.originY = 8;
        sprLightBossTotem.y = -sprLightBossTotem.originY;
        type = "Solid";
        layer = -(y - originY + height / 2);
    }
    
    override public function render() : Void
    {
        if (die)
        {
            FP.world.add(new Light(x + Tile.w / 2, y + Tile.h / 2, 100, 1, 0xFFFF00, true, 6, 10, y / FP.height));
            (try cast(graphic, Image) catch(e:Dynamic) null).scaleX *= 0.9;
            (try cast(graphic, Image) catch(e:Dynamic) null).scaleY += 0.1;
            (try cast(graphic, Image) catch(e:Dynamic) null).color = FP.colorLerp(0xFFFFFF, 0xFF0000, Math.min(1, (try cast(graphic, Image) catch(e:Dynamic) null).scaleY / 2));
            type = "";
            y -= 10;
        }
        super.render();
        (try cast(graphic, Image) catch(e:Dynamic) null).alpha = 0.5;
        Draw.setTarget((try cast(FP.world, Game) catch(e:Dynamic) null).nightBmp, FP.camera);
        super.render();
        Draw.resetTarget();
        (try cast(graphic, Image) catch(e:Dynamic) null).alpha = 1;
    }
    
    private function set_die(_t : Bool) : Bool
    {
        Music.playSound("Boss Die", 2, 0.3);
        _die = _t;
        return _t;
    }
    private function get_die() : Bool
    {
        return _die;
    }
}

