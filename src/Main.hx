import format.gif.Reader;
import hxd.res.DefaultFont;
import h2d.Text;
import objects.Radio;

class Main extends hxd.App {
	
	override function init() {
		var tf = new h2d.Text(DefaultFont.get(), s2d);
		tf.text = "Hello World!";

		EventController.instance.loadEvents();

		//Ah I see no built in update. 
		var r = new Radio(s2d);
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
