package pickups;

import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class Seed extends Pickup {
	@:meta(Embed(source = "../../assets/graphics/Seed.png"))
	private var imgSeed:Class<Dynamic>;
	private var sprSeed:Spritemap ;
	@:meta(Embed(source = "../../assets/graphics/SeedBloody.png"))
	private var imgSeedBloody:Class<Dynamic>;
	private var sprSeedBloody:Spritemap ;

	@:meta(Embed(source = "../../assets/graphics/TreeGrow.png"))
	private var imgTreeGrow:Class<Dynamic>;

	public var sprTreeGrow:Spritemap ;

	private var sitFrames(default, never):Dynamic = [0, 1, 2, 1];
	private var drawCover:Bool = false;

	private var coverAlpha:Float = 0;
	private var coverAlphaRate(default, never):Float = 0.005;

	private var bloody:Bool;

	public var tree:Bool = false;

	public function new(_x:Int, _y:Int, _bloody:Bool = false, _text:String = "", _tree:Bool = false) {
sprSeed =  new Spritemap(imgSeed, 9, 13);
sprSeedBloody =  new Spritemap(imgSeedBloody, 11, 15);
sprTreeGrow =  new Spritemap(imgTreeGrow, 16, 24, endAnim);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), (_bloody) ? sprSeedBloody : sprSeed, null, false);
		sprSeed.centerOO();
		sprSeedBloody.centerOO();

		bloody = _bloody;

		setHitbox(10, 14, 5, 7);

		special = true;
		text = _text;

		tree = _tree;
		if (tree) {
			graphic = sprTreeGrow;
			sprTreeGrow.add("grow", [0, 0, 0, 0, 1, 0, 1, 2, 2, 1, 2, 3, 4, 4, 5, 6], 3.5);
			sprTreeGrow.add("grown", [6]);
			sprTreeGrow.originX = Std.int(sprTreeGrow.width / 2);
			sprTreeGrow.originY = Std.int(sprTreeGrow.height * 2 / 3);
			sprTreeGrow.x = -sprTreeGrow.originX;
			sprTreeGrow.y = -sprTreeGrow.originY;
			sprTreeGrow.play("grow");
		}
	}

	public function destroySilently():Void {
		FP.world.remove(this);
	}

	override public function update():Void {
		if (drawCover) {
			(try cast(FP.world, Game) catch (e:Dynamic) null).drawCover(0, coverAlpha);
			coverAlpha += coverAlphaRate;
			if (coverAlpha >= 1)
				// GAME WON
			{
				if (bloody) {
					Game.cutscene[1] = true;
					FP.world = new Game(1, 64, 96, false);
				} else if (tree) {
					Game.menu = true;
					Game.cutscene[2] = false;
					Main.unlockMedal(Main.badges[14]);
					FP.world = new Game((try cast(FP.world, Game) catch (e:Dynamic) null).level, Std.int(Game.currentPlayerPosition.x),
						Std.int(Game.currentPlayerPosition.y), false, 2);
				} else {
					Game.cutscene[2] = true;
					FP.world = new Game((try cast(FP.world, Game) catch (e:Dynamic) null).level, Std.int(Game.currentPlayerPosition.x),
						Std.int(Game.currentPlayerPosition.y));
				}
			}
		} else if (!tree) {
			super.update();
		}
	}

	private function endAnim():Void {
		sprTreeGrow.play("grown");
		drawCover = true;
	}

	override public function removeSelf():Void {
		Game.freezeObjects = true;
		drawCover = true;
	}

	override public function render():Void {
		if (!tree) {
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).frame = Reflect.field(sitFrames, Std.string(Game.worldFrame(sitFrames.length)));
		}
		super.render();
	}
}
