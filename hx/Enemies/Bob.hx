package enemies;

import openfl.geom.Point;
import net.flashpunk.Graphic;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.FP;
import scenery.Tile;
import pickups.Coin;

/**
 * ...
 * @author Time
 */
class Bob extends Enemy {
	@:meta(Embed(source = "../../assets/graphics/Bob.png"))
	private var imgBob:Class<Dynamic>;
	private var sprBob:Spritemap ;

	public var moveSpeed:Float = 0.5;

	private var walkAnimSpeed(default, never):Int = 10;

	public var sitFrames:Array<Dynamic> = [0, 1, 2, 1];
	public var runRange:Int = 80; // Range at which the Bob will run after the character
	public var animateNormally:Bool = true;
	public var sitLoops:Float = 1;
	public var targetOffset:Point = new Point();

	public var hopSoundIndex:Int = 0;

	public function new(_x:Int, _y:Int, _g:Graphic = null) {
sprBob =  new Spritemap(imgBob, 8, 8, endAnim);
		if (_g == null) {
			_g = sprBob;
		}
		super(Std.int(_x + Tile.w / 2), Std.int(_y + Tile.h / 2), _g);
		sprBob.centerOO();
		sprBob.add("walk", sitFrames, walkAnimSpeed, false);
		sprBob.add("die", [3, 4, 5, 6], 5);

		solids.push("Enemy");

		setHitbox(8, 8, 4, 4);
	}

	override public function removed():Void { // if(!fell) dropCoins();
	}

	override public function update():Void {
		super.update();
		if (destroy || (try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "die" || Game.freezeObjects) {
			return;
		}

		var player:Player = try cast(FP.world.nearestToEntity("Player", this), Player) catch (e:Dynamic) null;
		if (player != null) {
			var d:Float = FP.distance(x, y, player.x + targetOffset.x, player.y + targetOffset.y);
			if (d <= runRange)
				// && !FP.world.collideLine("Solid", x, y, player.x, player.y))
			{
				{
					var a:Float = Math.atan2(player.y + targetOffset.y - y, player.x + targetOffset.x - x);
					var toV:Point = new Point(moveSpeed * Math.cos(a), moveSpeed * Math.sin(a));
					var pushed:Bool = v.length > moveSpeed; // If we're already moving faster than we should...
					v.x += FP.sign(toV.x - v.x) * moveSpeed;
					v.y += FP.sign(toV.y - v.y) * moveSpeed;
					if (!pushed && v.length > moveSpeed) {
						v.normalize(moveSpeed);
					}
					if (animateNormally && (try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim != "walk") {
						Music.playSoundDistPlayer(Std.int(x), Std.int(y), "Enemy Hop", hopSoundIndex);
						(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("walk");
					}
				}
			}
		}

		if (!Game.freezeObjects && (try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "") {
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).frame = sitFrames[Game.worldFrame(sitFrames.length, sitLoops)];
		}
	}

	override public function startDeath(t:String = ""):Void {
		(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("die");
		dieEffects(t);
	}

	public function endAnim():Void {
		if ((try cast(graphic, Spritemap) catch (e:Dynamic) null).currentAnim == "die") {
			destroy = true;
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("");
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).frame = (try cast(graphic, Spritemap) catch (e:Dynamic) null).frameCount - 1;
		} else {
			(try cast(graphic, Spritemap) catch (e:Dynamic) null).play("");
		}
	}
}
