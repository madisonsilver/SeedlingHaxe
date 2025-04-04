import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class Teleporter extends Entity {
	private var imgPortal:BitmapData;
	private var sprPortal:Spritemap;

	private var to:Int = 0;
	private var playerPos:Point;

	private var playerTouching:Bool = false;
	private var renderLight:Bool = true;

	private var tag:Int = 0; // True = exists, false = doesn't exist
	private var invert:Bool; // If this is true, it inverts the rules for the tag
	private var deactivated:Bool = false; // If true, then doesn't render or do player stuff
	private var sign:Int = 0; // Displays text in the room that this teleporter teleports to (text in Message.as)

	public var sound:String = "Room";
	public var soundIndex:Int = 0;

	private function load_image_assets():Void {
		imgPortal = Assets.getBitmapData("assets/graphics/Portal.png");
	}

	public function new(_x:Int, _y:Int, _to:Int = 0, _px:Int = 0, _py:Int = 0, _show:Bool = false, _tag:Int = -1, _invert:Bool = false, _sign:Int = -1) {
		load_image_assets();
		sprPortal = new Spritemap(imgPortal, 18, 18);
		super(_x, _y, sprPortal);
		to = _to;
		playerPos = new Point(_px, _py);
		setHitbox(16, 16, 0, 0);

		sprPortal.originX = 1;
		sprPortal.originY = 1;
		sprPortal.x = -sprPortal.originX;
		sprPortal.y = -sprPortal.originY;
		sprPortal.add("spin", [0, 1, 2, 3], 15);
		sprPortal.play("spin");

		visible = _show;
		tag = -1; // TODO: Setting a tag to a value of -1 fixes the teleporter in mountain1.oel, but might interfere with telporters elsewhere.  Investigate teleporter logic.
		invert = _invert;
		sign = Std.int(_sign - 1); // takes the value of _sign - 1 because zero should become -1 (to negate all of the levels where it defaults to zero)

		if (visible) {
			soundIndex = 3;
		}

		type = "Teleporter";

		checkDeactivated();
	}

	override public function check():Void {
		super.check();
		if (collide("Player", x, y) != null) {
			playerTouching = true;
		}
	}

	/**
	 * Removes this object by its tag
	 */
	public function removeSelf():Void {
		Game.setPersistence(tag, false);
	}

	public function checkDeactivated():Void {
		deactivated = tag >= 0 && (!Game.checkPersistence(tag) == invert);
	}

	override public function update():Void {
		checkDeactivated();
		if (deactivated) {
			return;
		}
		if (collide("Player", x, y) != null) {
			if (!playerTouching) {
				Music.playSound(sound, soundIndex);
				FP.world = new Game(to, Std.int(playerPos.x), Std.int(playerPos.y));
				Game.sign = sign;
			}
		} else {
			playerTouching = false;
		}
	}

	override public function render():Void {
		if (deactivated) {
			return;
		}
		super.render();
		renderLit();
	}

	public function renderLit():Void {
		if (renderLight) {
			super.render();
			Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
	}
}
