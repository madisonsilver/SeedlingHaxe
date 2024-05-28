package pickups;

import openfl.geom.Point;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import net.flashpunk.utils.Draw;
import scenery.Tile;

/**
 * ...
 * @author Time
 */
class HealthPickup extends Pickup {
	@:meta(Embed(source = "../../assets/graphics/HealthPickup.png"))
	private var imgHealth:Class<Dynamic>;
	private var sprHealth:Spritemap;

	private var angleRate(default, never):Int = 10;
	private var tag:Int;
	private var doActions:Bool = true;

	public function new(_x:Int, _y:Int, _tag:Int = -1) {
		sprHealth = new Spritemap(imgHealth, 8, 8);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprHealth, null, false);
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).centerOO();
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleX = FP.choose([1, -1]);
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).scaleY = FP.choose([1, -1]);
		setHitbox(4, 4, 2, 2);

		tag = _tag;

		special = true;
		text = "You got health!";
	}

	override public function check():Void {
		super.check();
		if (tag >= 0 && !Game.checkPersistence(tag)) {
			doActions = false;
			FP.world.remove(this);
		}
	}

	override public function render():Void {
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).angle += angleRate;
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).frame = Game.worldFrame((try cast(graphic, Spritemap) catch (e:Dynamic) null).frameCount);
		super.render();
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		super.render();
		Draw.resetTarget();
	}

	override public function removed():Void {
		if (doActions) {
			Player.hitsMax++;
			Main.unlockMedal(Main.badges[4]);
		}
		Game.setPersistence(tag, false);
		super.removed();
	}
}
