package pickups;

import enemies.BossTotem;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;
import scenery.Tile;
import puzzlements.Activators;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class Wand extends Pickup {
	@:meta(Embed(source = "../../assets/graphics/WandPickup.png"))
	private var imgWandPickup:Class<Dynamic>;
	private var sprWandPickup:Spritemap ;

	private var tag:Int;
	private var doActions:Bool = true;

	private var doBossActions:Bool = true;
	private var alphaRate(default, never):Float = 0.01;
	// When this is picked up, it will activate any tset = 0 object in the room.
	private var tset:Int = 0;

	public function new(_x:Int, _y:Int, _tag:Int = -1) {
sprWandPickup =  new Spritemap(imgWandPickup, 5, 9);
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), sprWandPickup, null, false);
		sprWandPickup.centerOO();
		setHitbox(3, 8, 2, 4);

		tag = _tag;

		if (doBossActions) {
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).alpha = 0;
		}

		special = true;
		text = "You got the Wand!~It shoots weakly, but far.";
	}

	override public function check():Void {
		super.check();
		if (tag >= 0 && !Game.checkPersistence(tag)) {
			doActions = false;
			FP.world.remove(this);
		}
	}

	override public function removed():Void {
		if (doActions) {
			Player.hasWand = true;
			if (doBossActions)
				// Activate falling blocks
			{
				var v:Array<Activators> = new Array<Activators>();
				FP.world.getClass(Activators, v);
				for (n in v) {
					if (n.t == tset) {
						n.activate = true;
					}
				}
			}
			Game.setPersistence(tag, false);
		}
	}

	override public function update():Void {
		var p:Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch (e:Dynamic) null;
		if ((p != null && p.y < y + Tile.h && Player.hasAllTotemParts() && !p.fallFromCeiling) || !doBossActions) {
			if ((try cast(graphic, Spritemap) catch (e:Dynamic) null).alpha < 1) {
				(try cast(graphic, Spritemap) catch (e:Dynamic) null).alpha = Math.min((try cast(graphic, Spritemap) catch (e:Dynamic) null).alpha
					+ alphaRate, 1);
				Game.freezeObjects = (try cast(graphic, Spritemap) catch (e:Dynamic) null).alpha < 1;
			} else {
				super.update();
			}
		}
	}

	override public function render():Void {
		var frameCount:Int = 6;

		sprWandPickup.frame = Game.worldFrame(frameCount);
		sprWandPickup.y = -sprWandPickup.originY + 2 * Math.sin(2 * Math.PI * (Game.time % Game.timePerFrame) / Game.timePerFrame);
		super.render();

		var offsetX:Int = as3hx.Compat.parseInt(sprWandPickup.x + 3);
		var offsetY:Int = as3hx.Compat.parseInt(sprWandPickup.y + 1);
		var radiusMax:Int = 20;
		var radiusMin:Int = 14;
		var color:Int = 0xFFFF00;
		var alpha:Float = (try cast(graphic, Spritemap) catch (e:Dynamic) null).alpha * 0.2;
		var frame:Int = sprWandPickup.frame;
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		Draw.circlePlus(Std.int(x + offsetX), Std.int(y + offsetY), (radiusMax - radiusMin) * frame / (frameCount - 1) + radiusMin, color, alpha);
		Draw.circlePlus(Std.int(x + offsetX), Std.int(y + offsetY), ((radiusMax - radiusMin) * frame / (frameCount - 1) + radiusMin) / 2, color, alpha);
		Draw.resetTarget();
	}
}
