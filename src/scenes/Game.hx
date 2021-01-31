package scenes;

import objects.ShaderDanTheShaderMan;
import sfx.ScreenShake;
import objects.Walkie;
import objects.Clock;
import objects.Radio;
import objects.GameMap;
import objects.UpdateList;
import h2d.Text;
import hxd.App;

class Game extends BaseScene {
	var radioText:Text;
	var mapText:Text;
	var updateList:UpdateList;
	var gmap:GameMap;
	var r:Radio;
	var c:Clock;
	var w:Walkie;
	var dialogeController:DialogueController;
	var lastSpeed = 1;
	var intro:Intro;

	var ss:ScreenShake;

	public function new(app:App) {
		super(app);

		EventController.instance.loadEvents();
		EventController.instance.setSpeed(1);
		EventController.instance.registerEventListener(onGameEvent);

		// filters
		var blom = new h2d.filter.Bloom(.2, .1);
		this.filter = blom;
		// Can animate filters :D
		// Actuate.tween(blom, 100, { amount: 2 });

		// bg
		var tile = hxd.Res.bg.toTile();
		var bg = new h2d.Bitmap(tile, this);
		// bg.filter = new h2d.filter.Blur(5);
		var bounds = bg.getBounds();

		// my mapona
		gmap = new GameMap(this);
		gmap.x = 300;
		gmap.y = 40;

		// rah rah radio
		r = new Radio(this);
		r.y = 360;
		r.onChange(function() {
			trace(r.frequency);
		});

		// test
		updateList = new UpdateList(this);

		// clock
		c = new Clock(this);
		c.x = bounds.width - c.getBounds().width - 160;
		c.y = 550;

		// walkie
		w = new Walkie(this);
		w.x = bounds.width - w.getBounds().width - 25;
		w.y = 410;

		ss = new ScreenShake(this);
		// ss.shake(.5, 1.2);

		// shader stuff
		var umg = new ShaderDanTheShaderMan(this);
		umg.strike(2);

		// dialogue
		dialogeController = new DialogueController(this);
		dialogeController.onFinish(onDialogueFinish);
	}

	override public function update(dt:Float) {
		super.update(dt);

		EventController.instance.update(dt, r.frequency, gmap.getCharLocation());
		dialogeController.update(dt);
		c.setTimeText(EventController.instance.getTimeString());
		ss.update(dt);
	}

	function onGameEvent(event:GameEvent):Void {
		for (text in event.text) {
			dialogeController.addDialouge(text);
		}
		lastSpeed = EventController.instance.speed;
		EventController.instance.setSpeed(0);
		EventController.instance.canChangeSpeed = false;
		r.canMove = false;
		gmap.canMove = false;
	}

	function onDialogueFinish() {
		EventController.instance.canChangeSpeed = true;
		EventController.instance.setSpeed(lastSpeed);
		gmap.canMove = true;
		r.canMove = true;
	}
}
