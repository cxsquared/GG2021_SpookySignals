import motion.Actuate;
import sfx.LightningOverlay;
import sfx.ScreenShake;
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

	var ss:ScreenShake;

	override function init() {
		EventController.instance.loadEvents();
		EventController.instance.setSpeed(1);
		EventController.instance.registerEventListener(onGameEvent);
		hxd.Window.getInstance().addEventTarget(onEvent);

		// filters
		var blom = new h2d.filter.Bloom(.2, .1);
		s2d.filter = blom;
		//Can animate filters :D
		//Actuate.tween(blom, 100, { amount: 2 });

		// bg
		var tile = hxd.Res.bg.toTile();
		var bg = new h2d.Bitmap(tile, s2d);
		//bg.filter = new h2d.filter.Blur(5);
		var bounds = bg.getBounds();

		// my mapona
		gmap = new GameMap(s2d);
		gmap.x = 300;
		gmap.y = 40;

		// rah rah radio
		r = new Radio(s2d);
		r.y = 360;
		r.onChange(function() {
			trace(r.frequency);
		});

		// test
		updateList = new UpdateList(s2d);

		// clock
		c = new Clock(s2d);
		c.x = bounds.width - c.getBounds().width - 160;
		c.y = 550;

		// walkie
		w = new Walkie(s2d);
		w.x = bounds.width - w.getBounds().width - 25;
		w.y = 410;

		ss = new ScreenShake(s2d);
		//ss.shake(.5, 1.2);

		//shader stuff
		var umg = new LightningOverlay(s2d);
		umg.strike(2);
	}

	override function update(dt:Float) {
		super.update(dt);
		EventController.instance.update(dt, r.frequency, gmap.getCharLocation());

		c.setTimeText(EventController.instance.getTimeString());

		ss.update(dt);
	}

	function onGameEvent(event:GameEvent):Void {
		for (text in event.text) {
			updateList.addUpdate(text);
		}
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
