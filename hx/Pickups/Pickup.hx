package pickups;
import openfl.utils.Assets;import openfl.display.BitmapData;

import openfl.geom.Point;
import net.flashpunk.Graphic;
import net.flashpunk.FP;
import net.flashpunk.graphics.Image;
import net.flashpunk.Sfx;
import nPCs.NPC;

/**
 * ...
 * @author Time
 */
class Pickup extends Mobile {
	private var attract:Bool;
	private var attractDistance(default, never):Int = 24;
	private var motionDampener(default, never):Int = 20; // The divisor for how much the object will accelerate toward the player
	private var minAttraction(default, never):Float = 0.3;
	private var minSpeedToPlayer(default, never):Int = 2;

	private var specialOffset(default, never):Point = new Point(0, -5);
	private var specialTimerMax(default, never):Int = 150;

	public var playerHit:Player;
	public var special:Bool = false;
	public var specialTimer:Int;

	private var DEF_TEXT_SPEED(default, never):Int = 6;

	public var myText:NPC;
	public var text:String = ""; // Won't display text if the string is ""

	// Won't display text if the pickup isn't special
	private var stopped:Bool = true;

	public var mySound:Sfx = Music.sndOFoundIt;
	public var myVolume:Float = 0.5;

	public function new(_x:Int, _y:Int, _g:Graphic = null, _v:Point = null, _attract:Bool = true) {

		specialTimer = specialTimerMax;
		super(_x, _y, _g);
		if (_v != null) {
			v = _v;
			stopped = false;
		}
		attract = _attract;
	}

	override public function update():Void {
		if (v.length <= 0) {
			stopped = true;
		}

		if (special && specialTimer < specialTimerMax)
			// Timer is going
		{
			{
				pick_up();
			}
		} else {
			var player:Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch (e:Dynamic) null;
			if (player != null && !player.fallFromCeiling) {
				if (attract && stopped) {
					var d:Float = FP.distance(x, y, player.x, player.y);
					if (d <= attractDistance) {
						var attraction:Point = new Point((player.x - x) / motionDampener, (player.y - y) / motionDampener);
						attraction.normalize(Math.max(attraction.length, minAttraction));
						v.x += attraction.x;
						v.y += attraction.y;
						v.normalize(Math.min(v.length, minSpeedToPlayer));
					}
				}
				playerHit = try cast(collide("Player", x, y), Player) catch (e:Dynamic) null;
				if (playerHit != null) {
					Music.abruptThenFade(mySound, myVolume);
					pick_up();
					return;
				}
			}
			super.update();
		}
	}

	public function pick_up():Void {
		var player:Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch (e:Dynamic) null;
		if (special && player != null) {
			Game.freezeObjects = true;
			if (specialTimer > 0) {
				specialTimer--;
				if (specialTimer <= 0 && text != "") {
					FP.world.add(myText = new NPC(Std.int(x), Std.int(y), null, -1, text, DEF_TEXT_SPEED, 32));
					myText.setTemp(this);
					Game.ALIGN = "CENTER";
				}
			} else if (myText == null) {
				Game.freezeObjects = false;
				player.directionFace = -1;
				Game.ALIGN = "LEFT";
				removeSelf();
				return;
			}
			x = player.x + specialOffset.x;
			var offY:Int = Std.int(Math.min(height - originY,
				(try cast(graphic, Image) catch (e:Dynamic) null).height - (try cast(graphic, Image) catch (e:Dynamic) null).originY));
			y = player.y - player.originY - offY + specialOffset.y * Math.min(2 * (1 - specialTimer / specialTimerMax), 1);
			player.directionFace = 3;
			layer = -FP.height;
		} else {
			removeSelf();
		}
	}

	public function removeSelf():Void {
		FP.world.remove(this);
	}
}
