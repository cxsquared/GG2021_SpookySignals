import hxd.Window;
import format.gif.Reader;
import hxd.res.DefaultFont;
import h2d.Text;
import objects.*;

class Main extends hxd.App {

	var tf:Text;
	var updateList:UpdateList;
	var c:Clock;

	override function init() {
		EventController.instance.loadEvents();
		EventController.instance.setSpeed(1);
		EventController.instance.registerEventListener(onGameEvent);
		hxd.Window.getInstance().addEventTarget(onEvent);

		//bg
		var tile = hxd.Res.bg.toTile();
		var bg = new h2d.Bitmap(tile, s2d);

		// my mapona
		var gmap = new GameMap(s2d);

		// rah rah radio
		var r = new Radio(s2d);
		r.onChange(function() {
			trace(r.frequency);
		});


		//test
		updateList = new UpdateList(s2d);

		// clock
		c = new Clock(s2d);
		c.x = Window.getInstance().width - 325;
		c.y = 25;

		tf = new h2d.Text(DefaultFont.get(), s2d);
		tf.text = "Hello World!";
		
	}

	override function update(dt:Float) {
		super.update(dt);

		EventController.instance.update(dt);
		c.setTimeText(EventController.instance.getTimeString());
	}

	function onGameEvent(event:GameEvent):Void {
		//tf.text = event.text;
		updateList.addUpdate(event.text);
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
