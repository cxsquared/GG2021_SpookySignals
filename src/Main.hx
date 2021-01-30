import format.gif.Reader;
import hxd.res.DefaultFont;
import h2d.Text;
import objects.Radio;

class Main extends hxd.App {
	var tf:Text;

	override function init() {
		tf = new h2d.Text(DefaultFont.get(), s2d);
		tf.text = "Hello World!";

		EventController.instance.loadEvents();
		EventController.instance.setSpeed(1);
		EventController.instance.registerEventListener(onGameEvent);
		hxd.Window.getInstance().addEventTarget(onEvent);

		// rah rah radio
		var r = new Radio(s2d);
		r.onChange(function() {
			trace(r.frequency);
		});
	}

	override function update(dt:Float) {
		super.update(dt);

		EventController.instance.update(dt);
	}

	function onGameEvent(event:GameEvent):Void {
		tf.text = event.text;
		EventController.instance.setSpeed(0);
	}

	function onEvent(event:hxd.Event) {
		switch (event.kind) {
			case EPush:
				if (event.button == 0)
					EventController.instance.setSpeed(1);
			case _:
		}
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}
}
