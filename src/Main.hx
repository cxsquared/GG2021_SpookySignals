import format.gif.Reader;
import hxd.res.DefaultFont;
import h2d.Text;
import objects.*;

class Main extends hxd.App {
	
	override function init() {
		var tf = new h2d.Text(DefaultFont.get(), s2d);
		tf.text = "Hello World!";

		EventController.instance.loadEvents();

		//bg
		var tile = hxd.Res.bg.toTile();
		var bg = new h2d.Bitmap(tile, s2d);

		//my mapona
		var gmap = new GameMap(s2d);

		//rah rah radio
		var r = new Radio(s2d);
		r.onChange( function() {
			trace(r.frequency);
		});

		//test
		var ss = new SampleView();
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
