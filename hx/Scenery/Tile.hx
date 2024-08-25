package scenery;

import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.geom.Point;
import net.flashpunk.Entity;
import net.flashpunk.Graphic;
import net.flashpunk.graphics.Emitter;
import net.flashpunk.graphics.Image;
import net.flashpunk.FP;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.graphics.Text;
import net.flashpunk.utils.Draw;
import openfl.display.BlendMode;

/**
 * ...
 * @author Time
 */
class Tile extends Entity {
	public static inline var LAYER:Int = 100;
	public static inline var w:Int = 16;
	public static inline var h:Int = 16;
	private static var types:Array<Dynamic> = [
		"Tile", "Tile", "Solid", "Tile", "Tile", "Tile", "Tile", "Tile", "Tile", "Solid", "Tile", "Solid", "Tile", "Tile", "Solid", "Solid", "Tile", "Tile",
		"Tile", "Solid", "Solid", "Tile", "Tile", "Solid", "Solid", "Tile", "Tile", "Solid", "Tile", "Unused", "Tile", "Tile", "Tile", "Tile", "Solid",
		"Solid", "Solid", "Tile"
	];

	public var img:Int = 0;

	private var bladesOfGrass:Int = 12;

	/*
	 * 0 = Ground
	 * 1 = Water
	 * 2 = Stone
	 * 3 = Brick
	 * 4 = Dirt
	 * 5 = Dungeon Tile
	 * 6 = Pit
	 * 7 = Shield Tile
	 * 8 = Forest
	 * 9 = Cliff
	 * 10= Cliff Stairs
	 * 11= Wood
	 * 12= Walkable Wood
	 * 13= Cave
	 * 14= Wood (natural)
	 * 15= Dark Stone
	 * 16= Igneous Stone
	 * 17= Lava
	 * 18= Blue Tile
	 * 19= Blue Wall
	 * 20= Blue Wall (dark)
	 * 21= Snow
	 * 22= Ice
	 * 23= Ice Wall
	 * 24= Ice Wall (glowing)
	 * 25= Waterfall
	 * 26= Body Floor
	 * 27= Body Wall
	 * 28= Ghost Tile
	 * 29= Bridge
	 * 30= Ghost Tile Step
	 * 31= Igneous-to-Lava
	 * 32= Odd Tile
	 * 33= Fuchsia Tile
	 * 34= Odd Tile (wall)
	 * 35= Rock Wall (dark)
	 * 36= Rock Wall
	 * 37= Rock Wall (floor)
	 */
	public var t:Int = 0; // type of tile

	private var grass:Bool; // Only used if ground
	private var waterfallFrames(default, never):Int = 4;

	private var closedBridge(default, never):Array<Dynamic> = [0, 1];
	private var openingBridge(default, never):Array<Dynamic> = [1, 2, 3, 4, 5, 6];
	private var openBridge(default, never):Array<Dynamic> = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18];

	private static inline var bridgeOpeningTimerMax:Int = 60;

	public var bridgeOpeningTimer:Int = bridgeOpeningTimerMax;

	private static inline var igneousAlpha:Float = 0.25;

	private var igneousFrame:Int = 0;

	private static inline final igneousCounterMax:Int = 8;

	private var igneousCounter:Int = igneousCounterMax;

	public var igneousBreakApart:Bool = false;

	private var _em:Emitter;
	private var _emObj:Entity;

	private static inline var _emOriginX:Int = 4;
	private static inline var _emOriginY:Int = 2; // The origin position of the image stored for the emitter
	private static var bodyFrames:Array<Dynamic> = [0, 1, 2, 3, 2, 1];

	private var continuous:Bool; // Whether a waterfall falls another level
	private var pit:Bool; // Whether the waterfall should end in a pit.
	private var spray:Bool; // Whether or not the particles will form at the bottom
	private var myEdges:BitmapData;

	private var randVal:Float = Math.random(); // Used to get the starting frame for water and lava, and used general-purpose throughout
	private var randVal1:Float = Math.random();
	private var randVal2:Float = Math.random();

	public function new(_x:Int, _y:Int, _t:Int = 0, _grass:Bool = true, _g:Graphic = null, _pit:Bool = false, _continuous:Bool = false, _spray:Bool = true) {
		super(_x + w / 2, _y + h / 2);
		layer = LAYER;

		grass = _grass;
		t = _t;

		setHitbox(w, h, Std.int(w / 2), Std.int(h / 2));
		type = "Tile";

		pit = _pit;
		continuous = _continuous;
		spray = _spray;
	}

	override public function update():Void // Set to the correct type after all of the objects have run their first-frame "check", and then deactivate update loop.
	{
		type = types[t];
		active = false;
	}

	override public function render():Void {
		if (!onScreen((t == 32 ? 1 : 0) * 16)) {
			return;
		}
		var phases:Int = 100;
		var loops:Int = 0;
		var maxAlpha:Float;
		switch (t) {
			case 0:
				Game.sprGround.frame = img;
				Game.sprGround.render(new Point(x, y), FP.camera);
			case 1:
				Game.sprWater.frame = Game.worldFrame(Game.sprWater.frameCount) + Math.floor(randVal * Game.sprWater.frameCount);
				Game.sprWater.render(new Point(x, y), FP.camera);
				drawMyEdges();
			case 2:
				Game.sprStone.frame = img;
				Game.sprStone.render(new Point(x, y), FP.camera);
			case 3:
				Game.sprBrick.render(new Point(x, y), FP.camera);
			case 4:
				Game.sprDirt.frame = img;
				Game.sprDirt.render(new Point(x, y), FP.camera);
			case 5:
				Game.sprDungeonTile.angle = 90 * Math.floor(randVal * 4);
				Game.sprDungeonTile.render(new Point(x, y), FP.camera);
			case 6:
				Game.sprPit.render(new Point(x, y), FP.camera);
			case 7:
				Game.sprShieldTile.frame = img;
				Game.sprShieldTile.render(new Point(x, y), FP.camera);
			case 8:
				Game.sprForest.frame = img;
				Game.sprForest.render(new Point(x, y), FP.camera);
			case 9:
				Game.sprCliff.render(new Point(x, y), FP.camera);
			case 10:
				Game.sprCliffStairs.render(new Point(x, y), FP.camera);
			case 11:
				Game.sprWood.frame = img;
				Game.sprWood.render(new Point(x, y), FP.camera);
			case 12:
				Game.sprWoodWalk.frame = img;
				Game.sprWoodWalk.render(new Point(x, y), FP.camera);
			case 13:
				Game.sprCave.render(new Point(x, y), FP.camera);
			case 14:
				Game.sprWoodTree.frame = img;
				Game.sprWoodTree.render(new Point(x, y), FP.camera);
			case 15:
				Game.sprDarkTile.frame = img;
				Game.sprDarkTile.render(new Point(x, y), FP.camera);

				Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
				loops = 5;
				Game.sprDarkTile.alpha = (Math.sin(Game.worldFrame(phases, loops) / phases * 2 * Math.PI) + 1) / 2;
				Game.sprDarkTile.render(new Point(x, y), FP.camera);
				Game.sprDarkTile.alpha = 1;
				Draw.resetTarget();
			case 16:
				Game.sprIgneousTile.frame = img;
				Game.sprIgneousTile.render(new Point(x, y), FP.camera);

				Game.sprIgneousTile.alpha = igneousAlpha;
				Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
				Game.sprIgneousTile.render(new Point(x, y), FP.camera);
				Draw.resetTarget();
				Game.sprIgneousTile.alpha = 1;
			case 17:
				Game.sprLava.frame = Game.worldFrame(Game.sprLava.frameCount) + Math.floor(randVal * Game.sprLava.frameCount);
				Game.sprLava.render(new Point(x, y), FP.camera);

				// Set the scale, color, and alpha of the lava for drawing to the surface.
				var scale:Float = 1.5;
				if (myEdges == null) {
					myEdges = new BitmapData(Std.int(scale * Game.sprLava.width), Std.int(scale * Game.sprLava.height), true, 0);

					Draw.setTarget(myEdges, new Point());
					Game.sprLava.scale = scale;
					Game.sprLava.color = 0xFFFF00;
					Game.sprLava.alpha = 0.4;
					Game.sprLava.render(new Point(myEdges.width / 2, myEdges.height / 2), new Point());
					Game.sprLava.alpha = 1;
					Game.sprLava.scale = (scale - 1) / 2 + 1;
					Game.sprLava.render(new Point(myEdges.width / 2, myEdges.height / 2), new Point());
					Draw.resetTarget();
				} else {
					var m:Matrix = new Matrix();
					var n:Int = 10;
					loops = 2;
					var addScale:Float = 0.1; // The most variance above and below 1 that it can be scaled
					var sc:Float = Math.sin(Game.worldFrame(n, loops) / n * 2 * Math.PI) * addScale + 1;
					m.scale(sc, sc);
					m.translate(x - myEdges.width * sc / 2 - FP.camera.x, y - myEdges.height * sc / 2 - FP.camera.y);
					(try cast(FP.world, Game) catch (e:Dynamic) null).solidBmp.draw(myEdges, m);
				}

				// Reset Lava values
				Game.sprLava.scale = 1;
				Game.sprLava.alpha = 1;
				Game.sprLava.color = 0xFFFFFF;

				// Draw the lava straight onto the night surface as well.
				Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
				Game.sprLava.render(new Point(x, y), FP.camera);
				Draw.resetTarget();
			case 18:
				Game.sprBlueTile.frame = img;
				if (img == 15) {
					Game.sprBlueTile.frame += Math.floor((Game.sprBlueTile.frameCount - img - 1) * randVal);
				}
				Game.sprBlueTile.render(new Point(x, y), FP.camera);
			case 19:
				Game.sprBlueTileWall.frame = img;
				Game.sprBlueTileWall.render(new Point(x, y), FP.camera);
			case 20:
				Game.sprBlueTileWallDark.frame = img;
				Game.sprBlueTileWallDark.render(new Point(x, y), FP.camera);
			case 21:
				Game.sprSnow.frame = img;
				Game.sprSnow.render(new Point(x, y), FP.camera);
			case 22:
				Game.sprIce.frame = Math.floor(randVal * Game.sprIce.frameCount);
				Game.sprIce.render(new Point(x, y), FP.camera);
			case 23:
				Game.sprIceWall.frame = Game.worldFrame(Game.sprIceWall.frameCount, 2);
				Game.sprIceWall.render(new Point(x, y), FP.camera);
				if (!Game.snowing) {
					Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
					var lightFrames:Int = 60;
					var lightLoops:Int = 5;
					Game.sprIceWall.alpha = (Math.sin(Game.worldFrame(lightFrames, lightLoops) / lightFrames * 2 * Math.PI) + 1) / 2 * 0.3 + 0.1;
					Game.sprIceWall.render(new Point(x, y), FP.camera);
					Game.sprIceWall.alpha = 1;
					Draw.resetTarget();
				}
				drawMyEdges();
			case 24:
				Game.sprIceWallLit.frame = Game.worldFrame(Game.sprIceWallLit.frameCount, 2);
				Game.sprIceWallLit.render(new Point(x, y), FP.camera);
				if (!Game.snowing) {
					Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
					var lightFrames:Int = 60;
					var lightLoops:Int = 5;
					Game.sprIceWallLit.alpha = (Math.sin(Game.worldFrame(lightFrames, lightLoops) / lightFrames * 2 * Math.PI) + 1) / 2 * 0.3 + 0.1;
					Game.sprIceWallLit.render(new Point(x, y), FP.camera);
					Game.sprIceWallLit.alpha = 1;
					Draw.resetTarget();
				}
				drawMyEdges();
			case 25:
				Game.sprWaterfall.frame = (Game.worldFrame(waterfallFrames, 0.8) + Math.floor(randVal * waterfallFrames)) % waterfallFrames
					+ waterfallFrames * (continuous ? 1 : 0);
				Game.sprWaterfall.render(new Point(x, y), FP.camera);
				if (pit) {
					Game.sprPitShadow.render(new Point(x, y), FP.camera);
				}
				if (spray && _em != null) {
					_em.emit("spray", x - originX - _emOriginX + width * Math.random(), y - originY + height - _emOriginY + Math.random());
					_em.update();
				}
			case 26:
				Game.sprBody.flipped = randVal < 0.5;
				Game.sprBody.angle = 180 * (Std.int(2 * randVal) - 1);
				loops = 1;
				Game.sprBody.frame = bodyFrames[(Game.worldFrame(bodyFrames.length, loops) + Std.int(randVal * bodyFrames.length)) % bodyFrames.length];
				Game.sprBody.render(new Point(x, y), FP.camera);
				Game.sprBody.flipped = false;
				drawMyEdges();
			case 27:
				Game.sprBodyWall.flipped = randVal < 0.5;
				Game.sprBodyWall.angle = 180 * (Std.int(2 * randVal) - 1);
				loops = 2;
				Game.sprBodyWall.frame = bodyFrames[(Game.worldFrame(bodyFrames.length, loops) + Std.int(randVal * bodyFrames.length)) % bodyFrames.length];
				Game.sprBodyWall.render(new Point(x, y), FP.camera);
				Game.sprBodyWall.flipped = false;
				drawMyEdges();
			case 28:
				Game.sprGhostTile.frame = img;
				Game.sprGhostTile.render(new Point(x, y), FP.camera);

				Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
				loops = 3;
				maxAlpha = 0.05;
				Game.sprGhostTile.alpha = (Math.sin(Game.worldFrame(phases, loops) / (phases - 1) * 2 * Math.PI) + 1) / 2 * maxAlpha;
				Game.sprGhostTile.render(new Point(x, y), FP.camera);
				Game.sprGhostTile.alpha = 1;
				Draw.resetTarget();
			case 29:
				if (bridgeOpeningTimer >= bridgeOpeningTimerMax) {
					loops = 2;
					Game.sprBridge.frame = closedBridge[Game.worldFrame(closedBridge.length, loops)];
					type = "Solid";
				} else if (bridgeOpeningTimer > 0) {
					bridgeOpeningTimer--;
					Game.sprBridge.frame = openingBridge[Std.int((1 - bridgeOpeningTimer / bridgeOpeningTimerMax) * openingBridge.length)];
					Game.sprBridge.blend = BlendMode.INVERT;
					type = "Solid";
				} else if (bridgeOpeningTimer <= 0) {
					loops = 2;
					Game.sprBridge.frame = openBridge[Game.worldFrame(openBridge.length, loops)];
					type = "Tile";
				}
				Game.sprBridge.render(new Point(x, y), FP.camera);
				Game.sprBridge.blend = BlendMode.NORMAL;

				Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
				loops = 3;
				maxAlpha = 0.1;
				Game.sprBridge.alpha = (Math.sin(Game.worldFrame(phases, loops) / (phases - 1) * 2 * Math.PI) + 1) / 2 * maxAlpha;
				if (bridgeOpeningTimer < bridgeOpeningTimerMax && bridgeOpeningTimer > 0) {
					Game.sprBridge.alpha = 1;
				}

				Game.sprBridge.render(new Point(x, y), FP.camera);
				Game.sprBridge.alpha = 1;
				Draw.resetTarget();
			case 30:
				Game.sprGhostTileStep.render(new Point(x, y), FP.camera);

				Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
				loops = 3;
				maxAlpha = 0.05;
				Game.sprGhostTileStep.alpha = (Math.sin(Game.worldFrame(phases, loops) / (phases - 1) * 2 * Math.PI) + 1) / 2 * maxAlpha;
				Game.sprGhostTileStep.render(new Point(x, y), FP.camera);
				Game.sprGhostTileStep.alpha = 1;
				Draw.resetTarget();
			case 31:
				if (!igneousBreakApart) {
					var p:Player = try cast(FP.world.nearestToPoint("Player", x, y), Player) catch (e:Dynamic) null;
					if (p != null) {
						if (FP.distance(p.x, p.y, x, y) <= Math.sqrt(width * width + height * height) / 2) {
							if (igneousCounter > 0) {
								igneousCounter--;
							} else {
								igneousCounter = igneousCounterMax;
								igneousBreakApart = true;
							}
						}
					}
				} else if (igneousCounter > 0) {
					igneousCounter--;
				} else {
					igneousCounter = igneousCounterMax;
					igneousFrame++;
					if (igneousFrame >= Game.sprIgneousLava.frameCount) {
						t = 17;
					}
				}
				Game.sprIgneousLava.frame = igneousFrame;
				Game.sprIgneousLava.render(new Point(x, y), FP.camera);

				Game.sprIgneousLava.alpha = igneousAlpha;
				Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
				Game.sprIgneousLava.render(new Point(x, y), FP.camera);
				Draw.resetTarget();
				Game.sprIgneousLava.alpha = 1;
			case 32:
				maxAlpha = 1;
				loops = 3;
				var minRadius:Int = 12;
				var maxRadius:Int = 16;
				var minAlpha:Float = 0.5;
				var smoothed:Float = (Math.sin(Game.worldFrame(phases, loops) / phases * 2 * Math.PI + randVal * 2 * Math.PI) + 1) / 2;

				Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).underBmp, FP.camera);
				Draw.circlePlus(Std.int(x), Std.int(y), smoothed * (maxRadius - minRadius) + minRadius, 0xFFFFFF, smoothed);
				Draw.resetTarget();

				Game.sprOddTile.frame = img;
				Game.sprOddTile.render(new Point(x, y), FP.camera);
			case 33:
				Game.sprFuchTile.frame = img;
				Game.sprFuchTile.render(new Point(x, y), FP.camera);

				Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
				loops = 4;
				Game.sprFuchTile.alpha = (Math.sin(Game.worldFrame(phases, loops) / phases * 2 * Math.PI + randVal * 2 * Math.PI) + 1) / 2 * 0.75 + 0.25;
				Game.sprFuchTile.render(new Point(x, y), FP.camera);
				Game.sprFuchTile.alpha = 1;
				Draw.resetTarget();

				drawMyEdges();
			case 34:
				Game.sprOddTileWall.frame = img;
				Game.sprOddTileWall.render(new Point(x, y), FP.camera);
			case 35:
				Game.sprRockTile.frame = Math.round(randVal);
				Game.sprRockTile.angle = 180 * Math.floor(2 * randVal);
				Game.sprRockTile.render(new Point(x, y), FP.camera);
			case 36:
				Game.sprRockTile.frame = Math.round(randVal) + 2;
				Game.sprRockTile.angle = 180 * Math.floor(2 * randVal);
				Game.sprRockTile.render(new Point(x, y), FP.camera);
				drawMyEdges();
			case 37:
				Game.sprRockyTile.frame = Math.round(randVal) * 4;
				Game.sprRockyTile.scaleX = Math.round(randVal1) * 2 - 1;
				Game.sprRockyTile.scaleY = Math.round(randVal2) * 2 - 1;
				Game.sprRockyTile.render(new Point(x, y), FP.camera);
			default:
		}
	}

	override public function check():Void {
		img = 0;
		var c:Tile = try cast(collide("Tile", x + 1, y), Tile) catch (e:Dynamic) null;
		if (c != null && (c.t == t || c.t == 9)) {
			img++;
		}
		c = try cast(collide("Tile", x, y - 1), Tile) catch (e:Dynamic) null;
		if (c != null && (c.t == t || c.t == 9)) {
			img += 2;
		}
		c = try cast(collide("Tile", x - 1, y), Tile) catch (e:Dynamic) null;
		if (c != null && (c.t == t || c.t == 9)) {
			img += 4;
		}
		c = try cast(collide("Tile", x, y + 1), Tile) catch (e:Dynamic) null;
		if (c != null && c.t == t)
			// Ignores the 9 because of the cliff shouldn't clip below.
		{
			{
				img += 8;
			}
		}
		switch (t) {
			case 0:
				if (grass) {
					addGrass();
				}
			case 8:
				if (grass) {
					addGrass();
				}
			case 13: // creates a block for the top of the cave so you can't enter from above.
				var e:Entity;
				e = new Entity(x - originX, y - originY);
				FP.world.add(e);
				e.setHitbox(width, 1);
				e.type = "Solid";
			case 23:
				drawEdges(15 - img, 0x0088FF, 0.25);
			case 24:
				FP.world.add(new Light(Std.int(x), Std.int(y), 60, 1, 0x0088FF, true));
				drawEdges(15 - img, 0x0088FF, 0.5);
			case 25:
				if (spray) {
					_em = new Emitter(Game.imgWaterfallSpray, 8, 5);
					_em.newType("spray", [0, 1, 2, 3]);
					_em.setAlpha("spray", 1, 0);
					_em.setMotion("spray", 90, 6, 0.8, 10, 4, 0.3);
					_emObj = FP.world.addGraphic(_em, Std.int(-(y - originY + height + 3)));
				}
			case 26, 27, 33, 36:
				drawEdges(15 - img, 0x000000, 0.4);
			default:
		}
	}

	public function addGrass():Void {
		for (i in 0...bladesOfGrass) {
			FP.world.add(new Grass(Std.int(x + Tile.w * (Math.random() - 0.5)), Std.int(y + Tile.h * (Math.random() - 0.5))));
		}
	}

	public function drawEdges(_f:Int, _c:Int = 0, _a:Float = 1, _thick:Int = 1):Void {
		_c += 0xFF000000;
		myEdges = new BitmapData(width, height, true, 0x00000000);
		Draw.setTarget(myEdges, new Point());
		if ((_f & 1) != 0) {
			Draw.linePlus(width - 1, 0, width - 1, height, _c, _a, _thick);
		}
		if (Std.int((_f & 2) / 2) != 0) {
			Draw.linePlus(0, 0, width, 0, _c, _a, _thick);
		}
		if (Std.int((_f & 4) / 4) != 0) {
			Draw.linePlus(0, 0, 0, height, _c, _a, _thick);
		}
		if (Std.int((_f & 8) / 8) != 0) {
			Draw.linePlus(0, height - 1, width, height - 1, _c, _a, _thick);
		}
		Draw.resetTarget();
	}

	public function drawMyEdges():Void {
		if (myEdges != null) {
			var m:Matrix = new Matrix(1, 0, 0, 1, x - originX - FP.camera.x, y - originY - FP.camera.y);
			FP.buffer.draw(myEdges, m);
		}
	}
}
