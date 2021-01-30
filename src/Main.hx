import format.gif.Reader;
import hxd.res.DefaultFont;
import h2d.Text;
import objects.Radio;

class Main extends hxd.App {
	
	override function init() {
		var tf = new h2d.Text(DefaultFont.get(), s2d);
		tf.text = "Hello World!";

		EventController.instance.loadEvents();

		//rah rah radio
		var r = new Radio(s2d);
		r.onChange( function() {
			trace(r.frequency);
		});
	}

	override function update(dt:Float) {
		super.update(dt);

		EventController.instance.update(dt);
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}
}
