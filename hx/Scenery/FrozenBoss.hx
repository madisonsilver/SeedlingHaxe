package scenery;

import net.flashpunk.Entity;
import net.flashpunk.graphics.Image;
import net.flashpunk.utils.Draw;
import net.flashpunk.FP;

/**
 * ...
 * @author Time
 */
class FrozenBoss extends Entity {
	@:meta(Embed(source = "../../assets/graphics/FrozenBoss.png"))
	private var imgFrozenBoss:Class<Dynamic>;
	private var sprFrozenBoss:Image ;

	public function new(_x:Int, _y:Int) {
sprFrozenBoss =  new Image(imgFrozenBoss);
		super(_x, _y, sprFrozenBoss);
		setHitbox(80, 32, -32, -128);
		type = "Solid";
		layer = Std.int(-(y - originY + height * 2 / 3));
	}

	override public function render():Void {
		super.render();
		Draw.setTarget((try cast(FP.world, Game) catch (e:Dynamic) null).nightBmp, FP.camera);
		super.render();
		Draw.resetTarget();
	}
}
