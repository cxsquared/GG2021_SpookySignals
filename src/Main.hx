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
	var dialogeController:DialogueController;
	var lastSpeed = 1;

	var ss:ScreenShake;

	override function init() {
		EventController.instance.loadEvents();
		EventController.instance.setSpeed(1);
		EventController.instance.registerEventListener(onGameEvent);

		// filters
		s2d.filter = new h2d.filter.Bloom(.1, .1);

		// bg
		var tile = hxd.Res.bg.toTile();
		var bg = new h2d.Bitmap(tile, s2d);
		bg.filter = new h2d.filter.Blur(5);
		var bounds = bg.getBounds();

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
		c.x = bounds.width - c.getBounds().width - 25;
		c.y = 25;

		// walkie
		w = new Walkie(s2d);
		w.x = bounds.width - w.getBounds().width - 25;
		w.y = 100;

		ss = new ScreenShake(s2d);
		ss.shake(.5, 1.2);

		// shader stuff
		var umg = new ShaderDanTheShaderMan(s2d);
		umg.y = 400;
		umg.x = 600;

		// dialogue
		dialogeController = new DialogueController(s2d);
		dialogeController.onFinish(onDialogueFinish);
	}

	override function update(dt:Float) {
		super.update(dt);
		EventController.instance.update(dt, r.frequency, gmap.getCharLocation());
		dialogeController.update(dt);
		c.setTimeText(EventController.instance.getTimeString());
		ss.update(dt);
	}

	function onGameEvent(event:GameEvent):Void {
		for (text in event.text) {
			dialogeController.addDialouge(text);
			// updateList.addUpdate(text);
		}
		lastSpeed = EventController.instance.speed;
		EventController.instance.setSpeed(0);
		EventController.instance.canChangeSpeed = false;
		gmap.canMove = false;
	}

	function onDialogueFinish() {
		EventController.instance.canChangeSpeed = true;
		EventController.instance.setSpeed(lastSpeed);
		gmap.canMove = true;
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}
}
