package scenery;

import enemies.FinalBoss;
import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import net.flashpunk.utils.Draw;

/**
 * ...
 * @author Time
 */
class Pod extends Entity {
	public var open(get, set):Bool;

	@:meta(Embed(source = "../../assets/graphics/PodBody.png"))
	private var imgPodBody:Class<Dynamic>;
	private var sprPodBody:Image ;
	@:meta(Embed(source = "../../assets/graphics/Pod.png"))
	private var imgPod:Class<Dynamic>;
	private var sprPod:Spritemap ;

	private var myPodBody:Entity;
	private var hitables(default, never):Dynamic = ["Player"];

	public function new(_x:Int, _y:Int) {
sprPodBody =  new Image(imgPodBody);
sprPod =  new Spritemap(imgPod, 24, 24, animEnd);
		super(_x + Tile.w / 2, _y + Tile.h / 2, sprPod);
		sprPod.centerOO();
		sprPodBody.centerOO();

		sprPod.alpha = 0.5;

		sprPod.add("open", [0, 1, 2, 3, 4, 5, 6], 10);
		sprPod.add("opened", [6], 10);
		sprPod.add("close", [6, 5, 4, 3, 2, 1, 0], 10);
		sprPod.add("closed", [0], 10);
		sprPod.play("open");

		setHitbox(16, 16, 8, 8);
		type = "Pod";

		myPodBody = FP.world.addGraphic(sprPodBody, Std.int(-(y - Tile.h * 3)), Std.int(x), Std.int(y));
	}

	override public function update():Void {
		super.update();

		layer = (sprPod.frame <= 3) ? Std.int(-(y + Tile.h * 3)) : myPodBody.layer - 1;

		var v:Array<Entity> = new Array<Entity>();
		collideTypesInto(hitables, x, y, v);
		for (e in v)
			/*if (e is FinalBoss)
				{
					var fb:FinalBoss = e as FinalBoss;
					if (sprPod.currentAnim == "closed")
					{
						fb.x = x;
						fb.y = y;
						fb.v.x = fb.v.y = 0;
					}
			}*/ {
			if (Std.is(e, Player)) {
				var p:Player = try cast(e, Player) catch (e:Dynamic) null;
				if (sprPod.currentAnim == "closed") {
					p.x = x;
					p.y = y;
					p.v.x = p.v.y = 0;
					p.hit(null, 0, null, 1);
				}
			}
		}

		// type = (sprPod.currentAnim == "closed" && v.length<=0) ? "Solid" : "Pod";

		if (v.length > 0 && sprPod.currentAnim == "opened") {
			sprPod.play("close");
		}
	}

	override public function render():Void {
		super.render();
	}

	private function set_open(_o:Bool):Bool {
		if (_o) {
			sprPod.play("open");
		} else {
			sprPod.play("close");
		}
		return _o;
	}

	private function get_open():Bool {
		return sprPod.currentAnim == "open" || sprPod.currentAnim == "opened";
	}

	public function animEnd():Void {
		var _sw1_ = (sprPod.currentAnim);

		switch (_sw1_) {
			case "open":
				sprPod.play("opened");
			case "close":
				sprPod.play("closed");
			default:
		}
	}
}
