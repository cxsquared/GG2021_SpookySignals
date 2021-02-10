package scenes;

import sfx.LightningOverlay;
import motion.Actuate;
import h2d.Graphics;
import h2d.Interactive;
import h2d.Bitmap;
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
	var umg:LightningOverlay;
	var music:MusicController;

	var ss:ScreenShake;

	public function new(app:App) {
		super(app);

		music = new MusicController();

		EventController.instance.loadEvents();
		EventController.instance.setSpeed(1);
		EventController.instance.registerEventListener(onGameEvent);

		// filters
		var blom = new h2d.filter.Bloom(.2, .1);
		this.filter = blom;
		// Can animate filters :D
		// Actuate.tween(blom, 100, { amount: 2 });

		umg = new LightningOverlay(this);

		// bg
		var tile = hxd.Res.bg.toTile();
		var bg = new h2d.Bitmap(tile, this);
		// bg.filter = new h2d.filter.Blur(5);
		var bounds = bg.getBounds();

		nightBG = new Bitmap(hxd.Res.nightroom.toTile(), this);
		nightBG.visible = false;
		nightBG.alpha = 0;

		// my mapona
		gmap = new GameMap(this, onGameEvent);
		gmap.x = 300;
		gmap.y = 40;

		// rah rah radio
		r = new Radio(this);
		r.y = 360;
		r.onChange(function() {
			// trace(r.frequency);
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

		dialogeController.addDialouge(new Dialogue("BRANDON", "Have you heard the news this morning? Switch to 100.3 on the radio."));
		lastSpeed = EventController.instance.speed;
		EventController.instance.setSpeed(0);
		EventController.instance.canChangeSpeed = false;
		r.canMove = false;
		gmap.canMove = false;
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
		lastSpeed = 1;
		showNewDayDialogue();
		gmap.resetPlayer();
	}

	function showNewDayDialogue() {
		var triggeredEvents = EventController.instance.triggeredEvents;
		if (triggeredEvents == null) {
			return;
		}

		if (triggeredEvents.exists("012_radio")) {
			dialogeController.addDialouge(new Dialogue("Brandon", "This is all getting so crazy. You wrote down those codes, right?"));
			dialogeController.addDialouge(new Dialogue("Katie", "Yup! The first one was - . -. .--. --"));
			dialogeController.addDialouge(new Dialogue("Katie", "And the second was 1-2-1-14-4-15-14-5-4 and 13-9-14-5"));
			dialogeController.addDialouge(new Dialogue("Brandon", "We're getting so close!"));
		} else if (triggeredEvents.exists("011_radio")) {
			dialogeController.addDialouge(new Dialogue("Brandon", "This is all getting so crazy. You wrote down those codes, right?"));
			dialogeController.addDialouge(new Dialogue("Katie", "Yup! The first one was - . -. .--. --"));
			dialogeController.addDialouge(new Dialogue("Katie", "And we still need the second code from the radio."));
			dialogeController.addDialouge(new Dialogue("Brandon", "We're getting so close!"));
		} else if (triggeredEvents.exists("010_map")) {
			dialogeController.addDialouge(new Dialogue("Katie", "Remind me again what Mr. Jenkinson wanted us to do?"));
			dialogeController.addDialouge(new Dialogue("Brandon", "He said we needed to listen to channel 112.1 at 8:45 am and 2:15 pm."));
			dialogeController.addDialouge(new Dialogue("Katie", "Oh, right!"));
		} else if (triggeredEvents.exists("009_radio")) {
			dialogeController.addDialouge(new Dialogue("Katie",
				"We still need to figure out that crazy guy's secret message. Why does he like Formula 1 so much?"));
			dialogeController.addDialouge(new Dialogue("Brandon", "More importantly, why did he feel the need to tell us?"));
			dialogeController.addDialouge(new Dialogue("Katie", "We'll figure it out eventually. We also have to remember to go 7:30 am as well though"));
		} else if (triggeredEvents.exists("008_map")) {
			dialogeController.addDialouge(new Dialogue("Brandon",
				"I still can't get over the fact this thing left a message in the dirt. I wonder who it's trying to communicate with."));
			dialogeController.addDialouge(new Dialogue("katie", "I know right! I just don't get it."));
			dialogeController.addDialouge(new Dialogue("Brandon", "103.0 - 10.30 has to mean something..."));
		} else if (triggeredEvents.exists("007_radio")) {
			dialogeController.addDialouge(new Dialogue("Katie", "I'm ready to go check out that junkyard whenever you are!"));
			dialogeController.addDialouge(new Dialogue("Brandon", "Do you remember their hours?"));
			dialogeController.addDialouge(new Dialogue("Katie", "Yeah! It was 9 am - 4 pm!"));
		} else if (triggeredEvents.exists("006_map")) {
			dialogeController.addDialouge(new Dialogue("Brandon", "I can't get that number out of my head. What is supposed to mean 4.99?"));
		} else if (triggeredEvents.exists("005_song")) {
			dialogeController.addDialouge(new Dialogue("Katie",
				"Well, we figured out that the grey hour is 9, but where does \"much timber mask the light of day\"?"));
		} else if (triggeredEvents.exists("004_map")) {
			dialogeController.addDialouge(new Dialogue("Brandon", "What was that weird message again?"));
			dialogeController.addDialouge(new Dialogue("Katie", "\"Much timber masks the light of day, be there when the clock strikes grey.\""));
		} else if (triggeredEvents.exists("003_news")) {
			dialogeController.addDialouge(new Dialogue("KATIE", "Can I please go to the fair today! I don't wanna miss out on all the fun!"));
			dialogeController.addDialouge(new Dialogue("Brandon",
				"I know. You can take a break. Just remember to still take your equipment. It starts at noon so that should still be plenty of time for us to do some investigating."));
			dialogeController.addDialouge(new Dialogue("Katie", "Yes! Funnel cake here I come!"));
		} else {
			dialogeController.addDialouge(new Dialogue("Brandon",
				"The start of a new day! We should listen to news at 100.3 on the radio or explore a little."));
			dialogeController.addDialouge(new Dialogue("Katie", "And don't forget we can speed up time with the clock if we need to."));
		}
	}

	override public function update(dt:Float) {
		super.update(dt);

		if (!dayEnding) {
			EventController.instance.update(dt, r.frequency, gmap.getCharLocation());
			music.setFreq(r.frequency);
			dialogeController.update(dt);
			c.setTimeText(EventController.instance.getTimeString());
			ss.update(dt);

			if (EventController.instance.time >= 24 * 60) {
				triggerNewDay();
			}

			if (EventController.instance.time >= 15 * 60) {
				if (!nightBG.visible) {
					nightBG.visible = true;
					Actuate.tween(nightBG, 60, {alpha: 1});
				}

				/*
					if (Rand.create().rand() < .75) {
						umg.strike(2);
					}
				 */
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
		r.stop();
		gmap.stopPlayer();
	}

	function onDialogueFinish() {
		EventController.instance.canChangeSpeed = true;
		EventController.instance.setSpeed(lastSpeed);
		gmap.canMove = true;
		r.canMove = true;

		if (EventController.instance.lastEventId == "013_map") {
			app.setScene(new End(app));
		}
	}
}
