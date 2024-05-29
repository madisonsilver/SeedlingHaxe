package puzzlements;

import net.flashpunk.graphics.Spritemap;

/**
 * ...
 * @author Time
 */
class GrassLock extends Lock {
	@:meta(Embed(source = "../../assets/graphics/GrassLock.png"))
	private var imgGrassLock:Class<Dynamic>;
	private var sprGrassLock:Spritemap ;

	public function new(_x:Int, _y:Int, _t:Int, _tag:Int = -1) {
sprGrassLock =  new Spritemap(imgGrassLock, 16, 16);
		super(_x, _y, _t, _tag, sprGrassLock);
	}
}
