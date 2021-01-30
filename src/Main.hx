import h2d.col.Point;
import hxd.Window;
import h2d.Text;
import objects.*;

class Main extends hxd.App {
	var radioText:Text;
	var mapText:Text;
	var updateList:UpdateList;
	var gmap:GameMap;
	var r:Radio;
	var c:Clock;
	var w:Walkie;

	override function init() {
		EventController.instance.loadEvents();
		EventController.instance.setSpeed(1);
		EventController.instance.registerEventListener(onGameEvent);
		hxd.Window.getInstance().addEventTarget(onEvent);

		// bg
		var tile = hxd.Res.bg.toTile();
		var bg = new h2d.Bitmap(tile, s2d);
		bg.filter = new h2d.filter.Blur(5);


		// my mapona
		gmap = new GameMap(s2d);

		// rah rah radio
		r = new Radio(s2d);
		r.onChange(function() {
			trace(r.frequency);
		});

		// test
		updateList = new UpdateList(s2d);

		// clock
		c = new Clock(s2d);
		c.x = Window.getInstance().width - 325;
		c.y = 25;

		// walkie
		w = new Walkie(s2d);
		w.x = Window.getInstance().width - 300;
		w.y = 100;
	}

	override function update(dt:Float) {
		super.update(dt);

		EventController.instance.update(dt, r.frequency, new Point(0, 0));
		c.setTimeText(EventController.instance.getTimeString());
	}

	function onGameEvent(event:GameEvent):Void {
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
