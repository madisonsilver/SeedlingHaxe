import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.net.*;

class GetURL {
	private var request:URLRequest;

	public function new(url:String, target:String = "_blank") {
		request = new URLRequest(url);
		flash.Lib.getURL(request, target);
	}
}
