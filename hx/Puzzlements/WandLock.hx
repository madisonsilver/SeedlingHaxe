package puzzlements;

import net.flashpunk.graphics.Spritemap;

/**
 * ...
 * @author Time
 */
class WandLock extends Lock {
	@:meta(Embed(source = "../../assets/graphics/WandLock.png"))
	private var imgWandLock:Class<Dynamic>;
	private var sprWandLock:Spritemap;

	public function new(_x:Int, _y:Int, _t:Int, _tag:Int = -1) {
		sprWandLock = new Spritemap(imgWandLock, 16, 16);
		super(_x, _y, _t, _tag, sprWandLock);
	}
}
