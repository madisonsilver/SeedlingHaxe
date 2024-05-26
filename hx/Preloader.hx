//import com.newgrounds.components.FlashAd;
import openfl.display.*;
import openfl.geom.Rectangle;
import openfl.text.*;
import openfl.events.*;
import openfl.utils.Assets;
import com.newgrounds.*;
import net.flashpunk.utils.Input;

@:meta(SWF(width="480",height="480"))

class Preloader extends Sprite
{
    public static var sponsorVersion : Bool = false;
    
    
    public static var URL : String;
    // Change these values
    private static var mustClick : Bool = false;
    private static inline var mainClassName : String = "Main";
    
    private static inline var BG_COLOR : Int = 0x000000;
    private static inline var FG_COLOR : Int = 0xFFFFFF;
    
    
    @:meta(Embed(source="../assets/graphics/pixel_logo_large.png"))
public static var imgNG : Class<Dynamic>;
    private static var sprNG : DisplayObject;
    
    @:meta(Embed(source="net/flashpunk/graphics/04B_03__.TTF",fontFamily="default"))

    private static var FONT : Class<Dynamic>;
    
    
    
    // Ignore everything else
    
    public static var LOCAL : Bool = false;
    public static var JAYISGAMES : Bool = false;
    public static var ARMORGAMES : Bool = false;
    public static var CONNORULLMANN : Bool = false;
    public static var KONGREGATE : Bool = false;
    public static var NEWGROUNDS : Bool = false;
    public static var FREEWORLDGROUP : Bool = false;
    public static var ANDKON : Bool = false;
    
    
    private static inline var NGAPPID : String = "26353:sQcLm12P";
    private static inline var NGENCRYPTIONKEY : String = "F1PhADGhzfgTvJe04kYcrbVn8kjUkljt";
    
    
    private var progressBar : Shape;
    private var text : TextField;
    
    private var px : Int;
    private var py : Int;
    private var w : Int;
    private var h : Int;
    private var sw : Int;
    private var sh : Int;
    
    /*
    private var flashAd : FlashAd;
    */
    private var promoRect : Rectangle;
    
    public function new()
    {
        super();
        sprNG = new Bitmap(Assets.getBitmapData ("assets/graphics/pixel_logo_large.png"));
        URL = root.stage.loaderInfo.url;
        
        LOCAL = checkDomain() == 2;
        JAYISGAMES = checkDomain(["jayisgames.com"]) == 1;
        ARMORGAMES = checkDomain(["http://games.armorgames.com", "http://preview.armorgames.com", "http://cache.armorgames.com", "http://cdn.armorgames.com", 
                        "http://gamemedia.armorgames.com", "http://*.armorgames.com", "armorgames.com"
            ]) == 1;
        CONNORULLMANN = checkDomain(["connorullmann.com"]) == 1;
        KONGREGATE = checkDomain(["kongregate.com"]) == 1;
        NEWGROUNDS = checkDomain(["newgrounds.com", "ungrounded.net"]) == 1;
        FREEWORLDGROUP = checkDomain(["freeworldgroup.com"]) == 1;
        ANDKON = checkDomain(["andkon.com"]) == 1;
        
        if (!ARMORGAMES && !KONGREGATE)
        {
            //API.connect(root, NGAPPID, NGENCRYPTIONKEY);
        }
        if (KONGREGATE)
        {
            QuickKong.connectToKong(stage);
        }
        
        sw = stage.stageWidth;
        sh = stage.stageHeight;
        
        if (sponsorVersion && !CONNORULLMANN)
        {
            return;
        }
        
        if (ARMORGAMES || KONGREGATE || CONNORULLMANN || FREEWORLDGROUP || ANDKON)
        {
            addChild(sprNG);
            sprNG.x = (sw - sprNG.width) / 2;
            sprNG.y = (sh - sprNG.height) / 3;
            
            promoRect = new Rectangle(sprNG.x, sprNG.y, sprNG.width, sprNG.height);
        }
        else
        {
            /*
            flashAd = new FlashAd();
            addChild(flashAd);
            flashAd.x = (sw - flashAd.width) / 2;
            flashAd.y = (sh - flashAd.height) / 3;
            flashAd.showPlayButton = false;
            flashAd.playButton.visible = false;
            flashAd.playButton.addEventListener(MouseEvent.MOUSE_UP, onPlayClick);
            
            promoRect = new Rectangle(flashAd.x, flashAd.y, flashAd.width, flashAd.height);*/
        }
        
        
        w = as3hx.Compat.parseInt(stage.stageWidth * 0.8);
        h = 20;
        
        px = as3hx.Compat.parseInt((sw - w) * 0.5);
        py = as3hx.Compat.parseInt((sh + promoRect.y + promoRect.height - h) / 2);
        
        graphics.beginFill(BG_COLOR);
        graphics.drawRect(0, 0, sw, sh);
        graphics.endFill();
        
        graphics.beginFill(FG_COLOR);
        graphics.drawRect(px - 2, py - 2, w + 4, h + 4);
        graphics.endFill();
        
        progressBar = new Shape();
        
        addChild(progressBar);
        
        text = new TextField();
        
        text.textColor = FG_COLOR;
        text.selectable = false;
        text.mouseEnabled = false;
        text.defaultTextFormat = new TextFormat("default", 16);
        text.embedFonts = true;
        text.autoSize = "left";
        text.text = "0%";
        text.x = (sw - text.width) * 0.5;
        text.y = py - text.height - 2;
        
        addChild(text);
        
        stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        
        if (mustClick)
        {
            stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        }
    }
    
    public function onPlayClick(e : MouseEvent) : Void
    {
        // flashAd.playButton.removeEventListener(MouseEvent.MOUSE_UP, onPlayClick);
        load();
    }
    
    public function onEnterFrame(e : Event) : Void
    {
        if (hasLoaded()) { //flashAd.currentFrame >= flashAd.totalFrames
            {
                if (false ) //replaced from flashAd != null
                {
                    /*
                    flashAd.showPlayButton = true;
                    if (flashAd.playButton)
                    {
                        flashAd.playButton.visible = true;
                    }
                    */
                }
                else
                {
                    load();
                }
                if (text.alpha > 0)
                {
                    text.alpha -= 0.005;
                }
            }
        }
        
        var p : Float = (loaderInfo.bytesLoaded / loaderInfo.bytesTotal);
        
        progressBar.graphics.clear();
        progressBar.graphics.beginFill(BG_COLOR);
        progressBar.graphics.drawRect(px, py, p * w, h);
        progressBar.graphics.endFill();
        
        text.text = (hasLoaded()) ? "Done!" : as3hx.Compat.parseInt(p * 100) + "%";
        text.x = (sw - text.width) * 0.5;
    }
    private function load() : Void
    {
        graphics.clear();
        graphics.beginFill(BG_COLOR);
        graphics.drawRect(0, 0, sw, sh);
        graphics.endFill();
        
        if (!mustClick)
        {
            startup();
        }
        else
        {
            text.scaleX = 2.0;
            text.scaleY = 2.0;
            
            text.text = "Click to start";
            text.y = (sh - text.height) * 0.5;
        }
    }
    
    private function onMouseDown(e : MouseEvent) : Void
    {
        if (hasLoaded())
        {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            startup();
        }
    }
    
    private function hasLoaded() : Bool
    {
        return (loaderInfo.bytesLoaded >= loaderInfo.bytesTotal);
    }
    
    private function startup() : Void
    {
        stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        
        var mainObject : DisplayObject = new Main();
        parent.addChild(mainObject);
        
        parent.removeChild(this);
    }
    
    public static function checkDomain(allowed : Dynamic = "") : Int
    {
        return 1;
        /*
        var url : String = Preloader.URL;
        var startCheck : Int = as3hx.Compat.parseInt(url.indexOf("://") + 3);
        if (url.substr(0, startCheck) == "file://")
        {
            return 2;
        }
        var domainLen : Int = as3hx.Compat.parseInt(url.indexOf("/", startCheck) - startCheck);
        var host : String = url.substr(startCheck, domainLen);
        if (Std.is(allowed, String))
        {
            allowed = [allowed];
        }
        for (d in allowed) //AS3HX WARNING could not determine type for var: d exp: EIdent(allowed) type: Dynamic 
        {
            if (host.substr(-d.length, d.length) == d)
            {
                return 1;
            }
        }
        return 0;
        */
    }
}
