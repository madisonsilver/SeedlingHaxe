import openfl.geom.Point;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import net.flashpunk.graphics.Text;
import net.flashpunk.utils.Input;
import net.flashpunk.utils.Draw;
import nPCs.Help;
import nPCs.NPC;
import enemies.BobBoss;

/**
	 * ...
	 * @author Time
	 */
class Inventory
{
    public var open(get, set) : Bool;
    public var firstUse(get, set) : Bool;
    public var extended(get, set) : Bool;

    //NOT an entity, so render is called explicitly by Game.
    
    @:meta(Embed(source="../assets/graphics/Inventory.png"))
private static var imgInventory : Class<Dynamic>;
    private static var sprInventory : Image = new Image(imgInventory);
    @:meta(Embed(source="../assets/graphics/InventoryItems.png"))
private static var imgInventoryItems : Class<Dynamic>;
    private static var sprInventoryItems : Spritemap = new Spritemap(imgInventoryItems, 17, 17);
    @:meta(Embed(source="../assets/graphics/InventoryItemsSide.png"))
private static var imgInventoryItemsSide : Class<Dynamic>;
    private static var sprInventoryItemsSide : Spritemap = new Spritemap(imgInventoryItemsSide, 8, 8);
    @:meta(Embed(source="../assets/graphics/InventoryItemsTotem.png"))
private static var imgInventoryItemsTotem : Class<Dynamic>;
    private static var sprInventoryItemsTotem : Spritemap = new Spritemap(imgInventoryItemsTotem, 16, 24);
    @:meta(Embed(source="../assets/graphics/tank.png"))
private static var imgTank : Class<Dynamic>;
    private static var sprTank : Image = new Image(imgTank);
    
    public static var width : Int = sprInventory.width;
    public static var height : Int = sprInventory.height;
    public static var help : Bool = true;
    
    private var _open : Bool;
    
    private var movementDivisor(default, never) : Int = 5;
    public static var offsetMin : Point = new Point(-70, FP.screen.height / 2 - sprInventory.height / 2);
    public static var offsetMax : Point = new Point(0, offsetMin.y);
    public static var offset : Point = new Point();
    
    private var itemOffset : Point = new Point(40, 24);
    private var itemOffsetIncrement(default, never) : Point = new Point(0, 32);
    
    private var keyPositions(default, never) : Array<Dynamic> = [new Point(2, 60), new Point(15, 60), new Point(2, 72), new Point(15, 72), new Point(9, 84)];
    private var sidePositions(default, never) : Array<Dynamic> = [new Point(9, 107), new Point(3, 119), new Point(15, 119)];
    private var totemPosition(default, never) : Point = new Point(5, 19);
    
    private var selected : Int = 0;
    private static var items : Array<Int> = [];
    
    private var scaleMin(default, never) : Float = 1;
    private var scaleMax(default, never) : Float = 1.5;
    private var scaleRate(default, never) : Float = 0.1;
    private var scale : Float = scaleMin;
    
    private var textScaleMin(default, never) : Float = 1;
    private var textScaleMax(default, never) : Float = 2;
    private var textScaleRate(default, never) : Float = 0.2;
    private var textScale : Array<Dynamic> = [textScaleMin, textScaleMin];
    
    public static var drawFirstUseHelp : Bool = false;
    public static var drawExtendedHelp : Bool = false;
    private var textIndex : Int = 0;  // The index of the help page that is open  
    private static var FUtexts : Array<Dynamic> = [        "This is your inventory. To open/close it, press <V>.",         "Pick your weapons and the buttons you press to use them",         "Pick a weapon's button by moving up/down, and then press X/C to assign that button."];
    private static var EXtexts : Array<Dynamic> = ["This new tab shows your keys and other items you've obtained."];
    
    public function new()
    {
        offset.x = offsetMin.x;
        offset.y = offsetMin.y;
        
        sprInventoryItems.centerOO();
        
        for (i in 0...FUtexts.length)
        {
            FUtexts[i] = NPC.endlineText(FUtexts[i], 24);
        }
        for (i in 0...EXtexts.length)
        {
            EXtexts[i] = NPC.endlineText(EXtexts[i], 18);
        }
    }
    
    public function check() : Void
    {
        open = false;
    }
    
    public static function clearItems() : Void
    {
        items = [];
    }
    public static function addItem(i : Int, pos : Int = -1) : Void
    {
        if (pos >= 0)
        {
            as3hx.Compat.arraySplice(items, pos, 0, [i]);
        }
        else
        {
            items.push(i);
        }
    }
    public static function removeItem(item : Int) : Void
    {
        for (i in 0...items.length)
        {
            if (getItem(i) == item)
            {
                items.splice(i, 1);
            }
        }
        Main.primary = Main.primary % items.length;
        Main.secondary = Main.secondary % items.length;
    }
    public static function hasItem(item : Int) : Bool
    {
        for (i in 0...items.length)
        {
            if (getItem(i) == item)
            {
                return true;
            }
        }
        return false;
    }
    public static function getItem(i : Int) : Int
    {
        return items[i];
    }
    
    private function set_open(_o : Bool) : Bool
    {
        Game.freezeObjects = _open = _o;
        return _o;
    }
    
    private function get_open() : Bool
    {
        return _open;
    }
    
    public function update() : Void
    {
        if (Game.cheats)
        {
            firstUse = extended = true;
            drawFirstUseHelp = drawExtendedHelp = false;
        }
        else
        {
            if (items.length >= 2 && !firstUse)
            {
                if (help)
                {
                    FP.world.add(new Help(0));
                }
                firstUse = true;
            }
            if (firstUse && !extended && (Player.canSwim || Player.hasFeather || Player.hasTotemPartNumber() > 0))
            {
                extended = true;
            }
        }
        if (drawFirstUseHelp)
        {
            Game.freezeObjects = true;
        }
        
        addItemsFromSave();
        
        var p : Player = try cast(FP.world.nearestToPoint("Player", 0, 0), Player) catch(e:Dynamic) null;
        if (p != null && (!Game.freezeObjects || open))
        {
            if ((Input.released(p.keys[7]) || Input.released(p.keys[8])) && firstUse && !drawFirstUseHelp && !drawExtendedHelp)
            {
                open = !open;
            }
            if (open)
            {
                var tSelected : Int = selected;
                if (Input.released(p.keys[1]))
                
                //Up
{                    
                    {
                        selected = as3hx.Compat.parseInt((selected - 1 + items.length) % items.length);
                    }
                }
                if (Input.released(p.keys[3]))
                
                //Down
{                    
                    {
                        selected = as3hx.Compat.parseInt((selected + 1) % items.length);
                    }
                }
                if (Input.released(p.keys[4]))
                
                //Primary
{                    
                    {
                        Main.primary = selected;
                        textScale[0] = textScaleMax;
                    }
                }
                if (Input.released(p.keys[5]))
                
                //Secondary
{                    
                    {
                        Main.secondary = selected;
                        textScale[1] = textScaleMax;
                    }
                }
                if (Input.pressed(p.keys[7]) || Input.pressed(p.keys[8]))
                
                //Inventory
{                    
                    {
                        if (drawFirstUseHelp || drawExtendedHelp)
                        {
                            textIndex++;
                            if (drawFirstUseHelp)
                            {
                                if (textIndex >= FUtexts.length)
                                {
                                    drawFirstUseHelp = false;
                                    textIndex = 0;
                                }
                            }
                            if (drawExtendedHelp)
                            {
                                if (textIndex >= EXtexts.length)
                                {
                                    drawExtendedHelp = false;
                                    textIndex = 0;
                                }
                            }
                        }
                    }
                }
                
                //Tank checking
                var m : Point = new Point(Input.mouseX, Input.mouseY);
                var pt : Point = ngTankPos();
                if (m.x >= pt.x - sprTank.originX && m.x < pt.x - sprTank.originX + sprTank.width &&
                    m.y >= pt.y - sprTank.originY && m.y < pt.y - sprTank.originY + sprTank.height)
                {
                    sprTank.color = 0x888888;
                    if (Input.mouseReleased)
                    {
                        new GetURL("http://www.newgrounds.com/");
                    }
                }
                else
                {
                    sprTank.color = 0xFFFFFF;
                }
                
                if (selected != tSelected)
                {
                    scale = scaleMax;
                }
            }
        }
        if (open)
        {
            moveToward(offset, offsetMax);
        }
        else
        {
            moveToward(offset, offsetMin);
        }
        if (scale > scaleMin)
        {
            scale -= scaleRate;
            scale = Math.max(scale, scaleMin);
        }
        for (i in 0...textScale.length)
        {
            if (textScale[i] > textScaleMin)
            {
                textScale[i] -= textScaleRate;
            }
            else
            {
                textScale[i] = textScaleMin;
            }
        }
    }
    
    private function addItemsFromSave() : Void
    {
        if (!Player.hasGhostSword)
        {
            if (Player.hasSword && !hasItem(0))
            {
                addItem(0);
            }
        }
        else if (!hasItem(4))
        {
            removeItem(0);
            removeItem(3);
            addItem(4, 0);
        }
        
        if (!Player.hasFireWand)
        {
            if (Player.hasFire && !hasItem(1))
            {
                addItem(1);
            }
            if (Player.hasWand && !hasItem(2))
            {
                addItem(2);
            }
        }
        else if (!hasItem(5))
        {
            removeItem(1);
            removeItem(2);
            addItem(5, 1);
        }
        
        if (!Player.hasGhostSword)
        {
            if (Player.hasSpear && !hasItem(3))
            {
                addItem(3);
            }
        }
    }
    
    public function render() : Void
    {
        offsetMax.x = (extended) ? 0 : -23;
        
        //Background
        sprInventory.render(offset, new Point());
        
        //Item draw
        for (i in 0...items.length)
        {
            sprInventoryItems.frame = items[i];
            if (Main.hasDarkSword && items[i] == 0)
            {
                sprInventoryItems.frame = 6;
            }
            if (selected == i)
            {
                sprInventoryItems.color = 0xFFFF44;
                sprInventoryItems.scale = scale;
            }
            else
            {
                sprInventoryItems.color = 0xFFFFFF;
                sprInventoryItems.scale = 1;
            }
            sprInventoryItems.render(new Point(Math.ceil(offset.x + itemOffset.x + itemOffsetIncrement.x * i), Math.ceil(offset.y + itemOffset.y + itemOffsetIncrement.y * i)), new Point());
        }
        for (i in 0...Player.totemParts)
        {
            if (Player.hasTotemPart(i))
            {
                sprInventoryItemsTotem.frame = i;
                sprInventoryItemsTotem.render(totemPosition.add(offset), new Point());
            }
        }
        for (i in 0...sprInventoryItemsSide.frameCount)
        {
            sprInventoryItemsSide.frame = i;
            var keyFrame : Int = 3;
            switch (i)
            {
                case 0:
                    if (Player.canSwim)
                    {
                        sprInventoryItemsSide.render(sidePositions[0].add(offset), new Point());
                    }
                case 1:
                    if (Player.hasTorch)
                    {
                        sprInventoryItemsSide.render(sidePositions[1].add(offset), new Point());
                    }
                case 2:
                    if (Player.hasFeather)
                    {
                        sprInventoryItemsSide.render(sidePositions[2].add(offset), new Point());
                    }
                default:
                    if (Player.hasKey(i - keyFrame))
                    {
                        sprInventoryItemsSide.render(keyPositions[i - keyFrame].add(offset), new Point());
                    }
            }
        }
        
        sprTank.render(ngTankPos(), new Point());
        
        //Text
        var m : Int = 4;
        Text.static_size = 8;
        var t : Text = new Text("X");
        t.scale = textScale[0];
        t.color = 0x000000;
        t.centerOO();
        t.render(new Point(offset.x + itemOffset.x - sprInventoryItems.width / 2 - t.width / 2, offset.y + itemOffset.y + sprInventoryItems.height / 2 - t.height / 2 + itemOffsetIncrement.y * Main.primary), new Point());
        t = new Text("C");
        t.scale = textScale[1];
        t.color = 0x000000;
        t.centerOO();
        t.render(new Point(offset.x + itemOffset.x + sprInventoryItems.width + 1 - t.width / 2, offset.y + itemOffset.y + sprInventoryItems.height / 2 - t.height / 2 + itemOffsetIncrement.y * Main.secondary), new Point());
        
        var text : Text;
        var helpTextOffset : Point = new Point(offset.x + sprInventory.width, FP.screen.height / 2);  // Left aligned horizontally, but center aligned vertically  
        var margin : Int = 4;
        if (drawFirstUseHelp)
        {
            text = new Text(FUtexts[textIndex]);
        }
        else if (drawExtendedHelp)
        {
            text = new Text(EXtexts[textIndex]);
        }
        if (text != null && FP.world.classCount(Help) <= 0 && open)
        {
            Draw.rect(Std.int(FP.camera.x + helpTextOffset.x), Std.int(FP.camera.y + helpTextOffset.y - text.height / 2 - margin), text.width + margin * 2, text.height + margin * 2, 0x000000, 0.95);
            text.render(new Point(helpTextOffset.x + margin, helpTextOffset.y - text.height / 2), new Point());
        }
        
        Text.static_size = 16;
    }
    
    private function ngTankPos() : Point
    {
        var o : Int = 4;
        return new Point(FP.screen.width + o - (sprTank.width * 3 / 4 + o) * Math.abs((offset.x - offsetMin.x) / (offsetMax.x - offsetMin.x)), FP.screen.height - sprTank.height);
    }
    
    public function moveToward(from : Point, to : Point) : Point
    {
        from.x += (to.x - from.x) / movementDivisor;
        from.y += (to.y - from.y) / movementDivisor;
        if (Math.abs(from.length - to.length) <= 0.1)
        {
            from.x = to.x;
            from.y = to.y;
        }
        return from;
    }
    
    private function get_firstUse() : Bool
    {
        return Main.firstUse;
    }
    private function set_firstUse(_fu : Bool) : Bool
    {
        if (!firstUse && _fu && help)
        
        //we're going from not first use to first use
{            
            drawFirstUseHelp = true;
        }
        Main.firstUse = _fu;
        return _fu;
    }
    private function get_extended() : Bool
    {
        return Main.extended;
    }
    private function set_extended(_e : Bool) : Bool
    {
        if (!extended && _e && help)
        
        //we're going from not extended to extended
{            
            drawExtendedHelp = true;
            open = true;
        }
        Main.extended = _e;
        return _e;
    }
}

