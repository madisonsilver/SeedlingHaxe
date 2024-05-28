package puzzlements;

import enemies.*;
import net.flashpunk.Entity;
import net.flashpunk.Graphic;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class Cover extends Activators {
	@:meta(Embed(source = "../../assets/graphics/Cover.png"))
	private var imgCover:Class<Dynamic>;

	public var sprCover:Spritemap ;

	private var normType:String = "Solid";

	private var hitables:Dynamic = ["Solid", "Player"];

	public function new(_x:Int, _y:Int, _t:Int, _g:Graphic = null) {
sprCover =  new Spritemap(imgCover, 16, 16);
		if (_g == null) {
			_g = sprCover;
		}
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), _g, _t);
		(try cast(graphic, Image) catch (e:Dynamic) null).centerOO();
		setHitbox(16, 16, 8, 8);
		type = normType;

		layer = Std.int(-(y - originY + height + 1));
	}

	override public function update():Void {
		super.update();
		if (activate) {
			(try cast(graphic, Image) catch (e:Dynamic) null).alpha -= 0.1;
			if ((try cast(graphic, Image) catch (e:Dynamic) null).alpha <= 0) {
				type = "";
				(try cast(graphic, Image) catch (e:Dynamic) null).alpha = 0;
			}
		} else {
			var v:Array<Entity> = new Array<Entity>();
			collideTypesInto(hitables, x, y, v);
			if (v.length > 0) {
				for (c in v) {
					if (Std.is(c, Chest))
						// Anything that can go underneath a cover can go here
					{
						{
							reset();
						}
					}
				}
			} else {
				reset();
			}
		}
	}

	public function reset():Void {
		type = normType;
		(try cast(graphic, Image) catch (e:Dynamic) null).alpha = 1;
	}

	override public function render():Void {
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).frame = Game.worldFrame((try cast(graphic, Spritemap) catch (e:Dynamic) null).frameCount);
		super.render();
	}
}
