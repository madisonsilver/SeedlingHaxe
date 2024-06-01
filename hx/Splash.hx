import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;
import net.flashpunk.FP;
import net.flashpunk.World;
import net.flashpunk.utils.Input;

/**
 * ...
 * @author Time
 */
class Splash extends World {
	public static var imgNG:BitmapData;
	public static var imgOctoLogo:BitmapData;
	public static var imgRekcahdamLogo:BitmapData;
	public static var imgMusicBy:BitmapData;

	private var spMusicBy:DisplayObject;

	public var sp:Array<DisplayObject> = new Array<DisplayObject>();

	private static inline var WIDTH:Int = 480;
	private static inline var HEIGHT:Int = 480;
	private static var url:Array<String> = [
		"http://www.newgrounds.com/",
		"http://www.connorullmann.com/",
		"http://www.rekcahdam.com/"
	];

	private var frameWidth(default, never):Int = 162;
	private var frameHeight(default, never):Int = 158;
	private var rows:Int;
	private var cols:Int;
	private var frameCount:Int;
	private var frameSpeed(default, never):Float = 0.1;
	private var frame:Float = 0;
	private var extraFadeFrames(default, never):Int = 3;

	public static inline var rek:Int = 2;

	private var t:Int;

	private static inline var timerSplash:Int = 150;

	private var timerAll:Int = timerSplash;

	public var percentageFinished:Float;

	private function load_image_assets():Void {
		imgNG = Assets.getBitmapData("assets/graphics/pixel_logo_large.png");
		imgOctoLogo = Assets.getBitmapData("assets/graphics/OctoLogo.png");
		imgRekcahdamLogo = Assets.getBitmapData("assets/graphics/rackemmap-162Wx158H.png");
		imgMusicBy = Assets.getBitmapData("assets/graphics/musicby.png");
	}

	public function new(_t:Int = 0) {
		load_image_assets();
		percentageFinished = 1 - timerSplash / timerAll;
		super();
		t = _t;

		spMusicBy = new Bitmap(imgMusicBy);

		sp.push(new Bitmap(imgNG));
		sp.push(new Bitmap(imgOctoLogo));
		sp.push(new Bitmap(imgRekcahdamLogo));

		for (i in 0...sp.length) {
			sp[i].visible = false;
		}

		spMusicBy.visible = false;
		rows = as3hx.Compat.parseInt(sp[rek].height / frameHeight);
		cols = as3hx.Compat.parseInt(sp[rek].width / frameWidth);
		frameCount = as3hx.Compat.parseInt(rows * cols);
	}

	override public function begin():Void {
		FP.engine.addChild(sp[t]);
		if (t == rek) {
			FP.engine.addChild(spMusicBy);
		}
	}

	override public function end():Void {
		FP.engine.removeChild(sp[t]);
		if (t == rek) {
			FP.engine.removeChild(spMusicBy);
		}
		Mouse.cursor = MouseCursor.ARROW;
	}

	override public function update():Void {
		super.update();
		alpha();
		checkBegin();
		link();

		if (t == rek) {
			spMusicBy.x = WIDTH / 2 - spMusicBy.width / 2;
			spMusicBy.y = sp[t].y - spMusicBy.height - 10;
			spMusicBy.alpha = sp[t].alpha;
			spMusicBy.visible = true;

			sp[t].visible = true;

			frame += frameSpeed;
			if (frame >= frameCount) {
				sp[t].alpha = 1 - (frame - frameCount) / extraFadeFrames;
			}
			var cframe:Int = Std.int(Math.min(Math.floor(frame), frameCount - 2));
			sp[t].scrollRect = new Rectangle(cframe % cols * frameWidth, Math.floor(cframe / cols) * frameHeight, frameWidth, frameHeight);
			sp[t].x = WIDTH / 2 - frameWidth / 2;
			sp[t].y = HEIGHT / 2 - frameHeight / 2;
		} else {
			sp[t].visible = true;
			sp[t].x = WIDTH / 2 - sp[t].width / 2;
			sp[t].y = HEIGHT / 2 - sp[t].height / 2;
		}
	}

	public function alpha():Void {
		if (t == rek) {
			return;
		}
		percentageFinished = 1 - timerAll / timerSplash;
		if (percentageFinished <= 0.25) {
			sp[t].alpha = percentageFinished * 4;
		} else if (percentageFinished < 0.75) {
			sp[t].alpha = 1;
		} else {
			sp[t].alpha = 1 - (percentageFinished - 0.75) * 4;
		}
	}

	public function checkBegin():Void {
		if ((t != rek && timerAll <= 0) || (t == rek && frame >= frameCount + extraFadeFrames)) {
			startMenu();
			return;
		} else {
			timerAll--;
		}
	}

	public function link():Void {
		if (inBounds()) {
			Mouse.cursor = MouseCursor.BUTTON;
			if (Input.mouseReleased) {
				new GetURL(url[t]);
			}
		} else {
			Mouse.cursor = MouseCursor.ARROW;
		}
	}

	public function startMenu():Void {
		if (t + 1 >= sp.length) {
			Mouse.cursor = MouseCursor.ARROW;
			if (Main.level == -1) {
				FP.world = new Game();
			} else {
				FP.world = new Game(Main.level, Main.playerPositionX, Main.playerPositionY);
			}
		} else {
			FP.world = new Splash(t + 1);
		}
	}

	public function inBounds():Bool {
		return FP.engine.mouseX >= sp[t].x
			&& FP.engine.mouseY >= sp[t].y
			&& FP.engine.mouseX <= sp[t].x + sp[t].width
			&& FP.engine.mouseY <= sp[t].y + sp[t].height;
	}
}
