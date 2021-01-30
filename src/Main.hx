import hxd.res.DefaultFont;
import h2d.Text;

class Main extends hxd.App {
	override function init() {
		var tf = new h2d.Text(DefaultFont.get(), s2d);
		tf.text = "Hello World!";
	}

	static function main() {
		new Main();
	}
}
