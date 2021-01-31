package scenes;

import motion.Actuate;
import h2d.Graphics;
import h2d.Interactive;
import h2d.Bitmap;
import objects.ShaderDanTheShaderMan;
import sfx.ScreenShake;
import objects.Walkie;
import objects.Clock;
import objects.Radio;
import objects.GameMap;
import objects.UpdateList;
import h2d.Text;
import hxd.App;
import h2d.Tile.Tile;

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
	var ndTiles = new Array<Tile>();
	var nightBG:Bitmap;
	var dayEnding = false;

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

		nightBG = new Bitmap(hxd.Res.nightroom.toTile(), this);
		nightBG.visible = false;
		nightBG.alpha = 0;

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

		// next Day
		var ndTile = hxd.Res.endday.toTile();
		ndTiles.push(ndTile.sub(0, 0, 100, 50));
		ndTiles.push(ndTile.sub(0, 50, 100, 50));
		var nd = new Bitmap(ndTiles[0], this); // dialogue
		nd.x = c.x + 115;
		nd.y = c.y - nd.getBounds().height - 10;
		nd.scale(1.25);
		var ndInteractive = new Interactive(100, 50, nd);
		ndInteractive.onClick = triggerNewDay;
		dialogeController = new DialogueController(this);

		dialogeController.onFinish(onDialogueFinish);
	}

	function triggerNewDay(?event:hxd.Event) {
		dayEnding = true;
		var fullscreen = new Graphics(this);
		fullscreen.beginFill(0x000000, 1);
		fullscreen.drawRect(0, 0, 1280, 720);
		fullscreen.endFill();

		fullscreen.alpha = 0;
		Actuate.tween(fullscreen, 2, {alpha: 1}).onComplete(onNewDay, [fullscreen]);

		lastSpeed = EventController.instance.speed;
		EventController.instance.setSpeed(0);
		EventController.instance.canChangeSpeed = false;
		r.canMove = false;
		gmap.canMove = false;
	}

	function onNewDay(fullscreen:Graphics) {
		dayEnding = false;
		nightBG.visible = false;
		nightBG.alpha = 0;
		fullscreen.remove();
		EventController.instance.time = 7 * 60;
		dialogeController.addDialouge(new Dialogue("KATIE", "It's a new day"));
		gmap.resetPlayer();
	}

	override public function update(dt:Float) {
		super.update(dt);

		if (!dayEnding) {
			EventController.instance.update(dt, r.frequency, gmap.getCharLocation());
			dialogeController.update(dt);
			c.setTimeText(EventController.instance.getTimeString());
			ss.update(dt);

			if (EventController.instance.time >= 24 * 60) {
				triggerNewDay();
			}

			if (EventController.instance.time >= 14 * 60 && !nightBG.visible) {
				nightBG.visible = true;
				Actuate.tween(nightBG, 30, {alpha: 1});
			}
		}
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
