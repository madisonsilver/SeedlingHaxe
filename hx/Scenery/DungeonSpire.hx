package scenery;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;

/**
 * ...
 * @author Time
 */
class DungeonSpire extends Entity {
	@:meta(Embed(source = "../../assets/graphics/DungeonSpire.png"))
	private var imgDungeonSpire:Class<Dynamic>;
	private var sprDungeonSpire:Image ;

	public function new(_x:Int, _y:Int) {
sprDungeonSpire =  new Image(imgDungeonSpire);
		super(_x, _y, sprDungeonSpire);
		sprDungeonSpire.y = -8;
		sprDungeonSpire.originY = 8;
		setHitbox(16, 16);
		type = "Solid";
		layer = Std.int(-(y - originY + height * 2 / 3));
	}
}
