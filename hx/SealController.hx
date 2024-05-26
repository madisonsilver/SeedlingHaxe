import openfl.display.BitmapData;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.graphics.Text;
import net.flashpunk.utils.Input;
import net.flashpunk.utils.Key;
import net.flashpunk.utils.Draw;
import openfl.display.BlendMode;
import scenery.FinalDoor;

/**
	 * ...
	 * @author Time
	 */
class SealController extends Entity
{
    @:meta(Embed(source="../assets/graphics/Seal.png"))
private static var imgSeal : Class<Dynamic>;
    private static var sprSeal : Spritemap = new Spritemap(imgSeal, 4, 4);
    
    public static inline var SEALS : Int = 16;
    private var scale : Float = 4;
    private var rows(default, never) : Int = 4;
    private var cols(default, never) : Int = 4;
    
    private var waitTime : Int = 60;  //The time that this waits at peak darkness  
    private var alphaSteps(default, never) : Int = 60;  //The time that this takes to reach full darkness  
    private var alphaStep : Int = 0;
    private var alpha : Float = 0;
    
    private var showNewest : Bool;
    private var parent : FinalDoor;
    private var backBmp : BitmapData;
    
    public var text : String;  //Set this to display centered text at the bottom of the screen.  
    private var textO : Text;
    
    private var playedSound : Bool = false;
    
    public function new(_showNewest : Bool = true, _parent : FinalDoor = null, _text : String = "")
    {
        super();
        Game.freezeObjects = true;
        layer = -FP.height * 2;
        sprSeal.centerOO();
        
        showNewest = _showNewest;
        parent = _parent;
        text = _text;
        
        Text.size = 8;
        textO = new Text(text);
        Text.size = 16;
    }
    
    public static function getSealPart(index : Int) : Bool
    {
        var last : Int = -1;
        if (hasAllSealParts())
        {
            return true;
        }
        for (i in 0...SEALS)
        {
            if (Main.hasSealPart(i) == index)
            {
                return false;
            }
            else if (Main.hasSealPart(i) == -1)
            {
                last = i;
                break;
            }
        }
        if (last >= 0 && last < SEALS)
        {
            Main.hasSealPartSet(last, index);
        }
        return true;
    }
    
    public static function hasAllSealParts() : Bool
    {
        return Main.hasSealPart(SEALS - 1) != -1;
    }
    
    override public function update() : Void
    {
        if (alphaStep >= alphaSteps)
        {
            var p : Player = try cast(FP.world.nearestToEntity("Player", this), Player) catch(e:Dynamic) null;
            if (p == null || (p != null && Input.released(p.keys[6])))
            {
                FP.world.remove(this);
            }
        }
        
        if (alphaStep >= alphaSteps && waitTime > 0)
        {
            waitTime--;
        }
        else if (alphaStep < alphaSteps * 2)
        {
            alphaStep++;
        }
        else
        {
            FP.world.remove(this);
        }
        alpha = (-Math.cos(alphaStep / alphaSteps * Math.PI) + 1) / 2;
    }
    
    override public function render() : Void
    //(FP.world as Game).drawCover(0, 0.75);
    {
        
        drawCover(alpha);
        Draw.setTarget((try cast(FP.world, Game) catch(e:Dynamic) null).nightBmp, FP.camera);
        drawCover(alpha);
        Draw.setTarget((try cast(FP.world, Game) catch(e:Dynamic) null).solidBmp, FP.camera);
        drawCover(alpha);
        Draw.resetTarget();
        if (backBmp == null)
        {
            backBmp = new BitmapData(sprSeal.width * cols, sprSeal.height * rows, true, 0x00000000);
            Draw.setTarget(backBmp);
            for (i in 0...SEALS)
            {
                sprSeal.alpha = 1;
                sprSeal.frame = i % sprSeal.frameCount;
                setScale(i, 1);
                sprSeal.render(new Point(sprSeal.originX + sprSeal.width * Math.floor(i / rows), sprSeal.originY + sprSeal.height * (i % rows)), new Point());
            }
            Draw.resetTarget();
            backBmp.threshold(backBmp, backBmp.rect, new Point(), ">", 0, 0xFFFFFFFF);
        }
        else
        {
            var m : Matrix = new Matrix();
            m.scale(scale, scale);
            m.translate(FP.screen.width / 2 - sprSeal.width * scale * cols / 2, FP.screen.height / 2 - sprSeal.height * scale * rows / 2);
            var c : ColorTransform = new ColorTransform(1, 1, 1, 0.25 * alpha);
            FP.buffer.draw(backBmp, m, c);
            (try cast(FP.world, Game) catch(e:Dynamic) null).nightBmp.draw(backBmp, m, new ColorTransform(1, 1, 1, alpha));
            (try cast(FP.world, Game) catch(e:Dynamic) null).solidBmp.draw(backBmp, m, new ColorTransform(1, 1, 1, alpha));
        }
        sprSeal.alpha = alpha;
        for (i in 0...SEALS)
        {
            var j : Int = Main.hasSealPart(i);
            if (j == -1)
            {
                break;
            }
            sprSeal.frame = j % sprSeal.frameCount;
            setScale(j);
            
            if (i + 1 < SEALS && Main.hasSealPart(i + 1) == -1 && alphaStep <= alphaSteps && showNewest)
            {
                sprSeal.scale = (1 - alpha) * 100 + 1;
                sprSeal.alpha /= sprSeal.scale;
                
                if (sprSeal.scale <= 1 && !playedSound)
                {
                    Music.abruptThenFade(Music.sndOSeal);
                    playedSound = true;
                }
            }
            Draw.setTarget((try cast(FP.world, Game) catch(e:Dynamic) null).nightBmp, FP.camera);
            renderSeal(j);
            Draw.setTarget((try cast(FP.world, Game) catch(e:Dynamic) null).solidBmp, FP.camera);
            renderSeal(j);
            Draw.resetTarget();
            renderSeal(j);
            sprSeal.scale = 1;
            sprSeal.alpha = alpha;
        }
        
        if (text != "")
        {
            var margin : Int = 16;  //the margin from the bottom of the screen.  
            textO.alpha = alpha;
            textO.render(new Point(FP.screen.width / 2 - textO.width / 2, FP.screen.height - margin - textO.height), new Point());
        }
    }
    
    private function setScale(j : Int, sc : Float = -1234) : Void
    {
        if (sc == -1234)
        {
            sc = scale;
        }
        sprSeal.scaleX = sc;
        if (j >= sprSeal.frameCount)
        {
            sprSeal.frame = Std.int((j + sprSeal.frameCount / 2) % sprSeal.frameCount);
            sprSeal.scaleX = -sc;
        }
        sprSeal.scaleY = sc;
    }
    
    private function renderSeal(j : Int) : Void
    {
        sprSeal.render(new Point(FP.screen.width / 2 + scale * sprSeal.originX + scale * sprSeal.width * (Math.floor(j / rows) - cols / 2), FP.screen.height / 2 + scale * sprSeal.originY + scale * sprSeal.height * (j % rows - rows / 2)), new Point());
    }
    
    private function drawCover(a : Float) : Void
    {
        Draw.rect(Std.int(FP.camera.x), Std.int(FP.camera.y), FP.screen.width, FP.screen.height, 0, a);
    }
    
    override public function removed() : Void
    {
        Game.freezeObjects = false;
        if (parent != null)
        {
            parent.mySealController = null;
        }
        Music.bkgdVolumeMaxExtern = Music.fadeVolumeMaxExtern = 1;
    }
}

