import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import pickups.SealPiece;
import scenery.Tile;
import pickups.Coin;

/**
 * ...
 * @author Time
 */
class Chest extends Entity {
	@:meta(Embed(source = "../assets/graphics/Chest.png"))
	private var imgChest:Class<Dynamic>;
	private var sprChest:Spritemap;

	private var openTimerMax(default, never):Int = 60;
	private var openTimer:Int = 0;
	private var coins:Int = Math.floor(Math.random() * 4 + 8);
	private var tag:Int;

	public function new(_x:Int, _y:Int, _tag:Int = -1) {
		sprChest = new Spritemap(imgChest, 16, 16);
		super(_x + Tile.w / 2, _y + Tile.h / 2, sprChest);
		sprChest.centerOO();
		type = "Solid";
		setHitbox(16, 16, 8, 8);
		layer = Std.int(-(y - originY));

		tag = _tag;

		checkBySeal();
	}

	override public function check():Void {
		super.check();
		if (tag >= 0 && !Game.checkPersistence(tag)) {
			FP.world.remove(this);
		}
	}

	public function checkBySeal():Void {
		if (SealController.hasAllSealParts()) {
			if (tag >= 0) {
				Game.setPersistence(tag, false);
			}
			FP.world.remove(this);
		}
	}

	override public function update():Void {
		checkBySeal();
		var m:Int = 2; // The distance to check from the edges of the chest
		if (collide("Solid", x, y) == null
			&& FP.world.collideLine("Player", Std.int(x - originX + m), Std.int(y - originY + height + 1), Std.int(x - originX + width - 2 * m),
				Std.int(y - originY + height + 1)) != null) {
			open();
		}
		timerStep();
	}

	public function open():Void {
		if (sprChest.frame == 0) {
			Music.playSound("Chest");
			sprChest.frame = 1;
			openTimer = openTimerMax;
			type = "";
			FP.world.add(new SealPiece(Std.int(x), Std.int(y)));
			/*var m:int = 2; //The margin from each side of the chest to randomly add the object
				for (var i:int = 0; i < coins; i++)
				{
					FP.world.add(new Coin(x - originX + m + Math.random() * (width - m * 2), y - originY + 4 + height/2 * Math.random(), new Point(Math.cos(Math.random()*2*Math.PI), Math.sin(Math.random()*2*Math.PI))));
			}*/
			var index:Int = -1;
			while (index < 0 || !SealController.getSealPart(index)) {
				index = Math.floor(Math.random() * SealController.SEALS);
			}
			Game.setPersistence(tag, false);
		}
	}

	public function timerStep():Void {
		if (openTimer > 0) {
			openTimer--;
			sprChest.alpha = Math.min(openTimer / (openTimerMax / 3), 1);
			if (openTimer <= 0) {
				FP.world.remove(this);
			}
		}
	}
}
